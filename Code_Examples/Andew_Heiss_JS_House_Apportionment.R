library(tidyverse)      # For ggplot, dplyr, and friends
library(historydata)    # Historical population data
library(USAboundaries)  # Historical geographic data
# remotes::install_github("ropensci/USAboundariesData")  # Actual data
library(rvest)          # Scrape websites
library(sf)             # Plot geographic data
library(tigris)         # Shift AK, HI, and PR around with shift_geometry()
library(patchwork)      # For combining plots
# devtools::install_github("ropensci/USAboundariesData")

# Figure out House apportionment ------------------------------------------

# Historical apportionment data is locked in this US Census PDF :(
# https://www2.census.gov/programs-surveys/decennial/1990/data/apportionment/cph-2-1-1-table-3.pdf
#
# Wikipedia has a big table of historical apportionment data here though:
# https://en.wikipedia.org/wiki/United_States_congressional_apportionment#Past_apportionments
#
# So I use rvest::read_html() and the xpath of that table to scrape it and clean it up

raw_apportionment <- read_html(
  paste0("https://web.archive.org/web/20210930182255/", 
         "https://en.wikipedia.org/wiki/United_States_congressional_apportionment")
) %>%
  html_nodes(xpath = '/html/body/div[3]/div[3]/div[5]/div[1]/table[4]') %>%  
  html_table() %>% 
  bind_rows()
raw_apportionment

apportionment_meta <- raw_apportionment %>% 
  slice(1:4)

# Clean up wide messy table
apportionment_tidy <- raw_apportionment %>% 
  slice(5:n()) %>% 
  select(-Statehoodorder, state = Census, everything()) %>% 
  mutate(across(!state, ~as.integer(.))) %>% 
  pivot_longer(cols = !state, names_to = "census", values_to = "seats") %>% 
  filter(!is.na(seats)) %>% 
  mutate(state_name = state.name[match(state, state.abb)])

# Only look at the results from the 6th (1840) and 23rd (2010) censuses
congress_actual <- apportionment_tidy %>% 
  filter(census %in% c("6th", "23rd")) %>% 
  mutate(year = recode(census, `6th` = 1840, `23rd` = 2010))

# Seats per apportionment
congress_actual %>% 
  group_by(year) %>% 
  summarize(total_seats = sum(seats))




# Figure out Joseph Smith's proposed count --------------------------------

# As part of his presidential platform, Joseph Smith proposed radically
# shrinking the House of Representatives so that states would get 1
# representative per 1 million residents:

# > Reduce Congress at least one half. Two Senators from a state and two members
# > to a million of population, will do more business than the army that now
# > occupy the halls of the National Legislature.

# *General Smith’s Views of the Powers and Policy of the Government of the United States*, pp. 8-9
# https://www.josephsmithpapers.org/paper-summary/general-smiths-views-of-the-powers-and-policy-of-the-government-of-the-united-states-circa-26-january-7-february-1844/8

# Here I'm assuming the "Webster Method" for apportionment, used in 1840 (see
# https://www.census.gov/prod/3/98pubs/CPH-2-US.PDF), where a state with 3.51
# would get 4 representatives and one with 3.49 would get 3, with a minimum of 1

# Historical state populations
state_pop <- us_state_populations %>% 
  filter(year %in% c(1840, 2010))

# Extract just the states that have congressional delegations (i.e. no territories)
states_in_congress <- congress_actual %>% 
  filter(year == 1840) %>% pull(state)

# Calculate apportionment with Joseph Smith's proposed rule
js_proposal <- state_pop %>% 
  mutate(n_million = population / 1000000,
         rounded_quotient = round(n_million),
         seats = case_when(
           rounded_quotient == 0 ~ 1,
           rounded_quotient >= 1 ~ rounded_quotient * 2
         )) %>% 
  mutate(state_name = str_remove(state, " Territory"),
         state = state.abb[match(state_name, state.name)],
         state = case_when(
           state_name == "District Of Columbia" ~ "DC",
           state_name == "Puerto Rico" ~ "PR",
           TRUE ~ state)) %>%
  filter(year == 1840 & state %in% states_in_congress | year == 2010)

js_proposal %>% 
  group_by(year) %>% 
  summarize(total_seats = sum(seats))



# Make some maps ----------------------------------------------------------
states_1844 <- us_states("1844-01-01")

states_2010 <- us_states("2000-12-31")

# Add seat counts to maps
congress_actual_1844 <- congress_actual %>% 
  filter(year == 1840) %>% 
  select(state, seats_actual = seats)

js_proposal_1844 <- js_proposal %>% 
  filter(year == 1840) %>% 
  select(state, seats_js = seats)

data_1844 <- states_1844 %>% 
  left_join(js_proposal_1844, by = c("state_abbr" = "state")) %>% 
  left_join(congress_actual_1844, by = c("state_abbr" = "state")) %>% 
  filter(terr_type == "State") %>% 
  mutate(state_power = seats_actual / sum(seats_actual, na.rm = TRUE),
         js_state_power = seats_js / sum(seats_js, na.rm = TRUE)) %>% 
  mutate(pct_change_power = (js_state_power - state_power) / js_state_power)


congress_actual_2010 <- congress_actual %>% 
  filter(year == 2010) %>% 
  select(state, seats_actual = seats)

js_proposal_2010 <- js_proposal %>% 
  filter(year == 2010) %>% 
  select(state, seats_js = seats)

data_2010 <- states_2010 %>% 
  left_join(js_proposal_2010, by = c("state_abbr" = "state")) %>% 
  left_join(congress_actual_2010, by = c("state_abbr" = "state")) %>% 
  filter(terr_type == "State") %>% 
  mutate(state_power = seats_actual / sum(seats_actual, na.rm = TRUE),
         js_state_power = seats_js / sum(seats_js, na.rm = TRUE)) %>% 
  mutate(pct_change_power = (js_state_power - state_power) / js_state_power)

map_theme <- function() {
  theme_void(base_family = "Assistant") +
    theme(legend.position = "bottom",
          plot.title = element_text(face = "bold", hjust = 0.5, size = rel(1.4)),
          plot.subtitle = element_text(hjust = 0.5, size = rel(1.2)),
          legend.title = element_text(face = "bold", hjust = 0.5))
}

# 1844 maps
plot_actual <- ggplot(data_1844) +
  geom_sf(aes(fill = seats_actual), size = 0.5) +
  scale_fill_viridis_b(option = "inferno", na.value = "grey90", 
                       n.breaks = 10, show.limits = TRUE,
                       guide = guide_colorsteps(barwidth = 12, title.position = "top")) +
  coord_sf() +  # Albers
  labs(title = "Actual apportionment\nof the 1844 House",
       subtitle = paste0(sum(congress_actual_1844$seats_actual), 
                         " representatives in the 28th Congress"),
       fill = "House seats") +
  map_theme()

plot_js <- ggplot(data_1844) +
  geom_sf(aes(fill = seats_js), size = 0.5) +
  scale_fill_viridis_b(option = "viridis", na.value = "grey90", 
                       breaks = c(1, 2, 4),
                       limits = c(0, 4), show.limits = TRUE,
                       guide = guide_colorsteps(barwidth = 12, title.position = "top")) +
  coord_sf() +  # Albers
  labs(title = "Joseph Smith’s proposed apportionment\napplied to the 1844 House",
       subtitle = paste0(sum(js_proposal_1844$seats_js), 
                         " proposed representatives"),
       fill = "House seats") +
  map_theme()

plot_change <- ggplot(data_1844) +
  geom_sf(aes(fill = pct_change_power), size = 0.5) +
  scale_fill_distiller(palette = "RdYlBu", direction = -1, na.value = "grey95",
                       guide = guide_colourbar(barwidth = 12, title.position = "top"),
                       labels = scales::percent_format(),
                       limits = c(-0.8, 0.8)) +
  coord_sf() +  # Albers
  labs(title = "Change in relative state House power\nif Joseph Smith’s proposal had worked",
       subtitle = "House power calculated by dividing\neach state's total number of representatives\nby the overall number of representatives",
       fill = "Percent change in relative power") +
  map_theme()

plot_actual | plot_js | plot_change


# 2010 maps
plot_actual_2010 <- ggplot(data_2010) +
  geom_sf(aes(fill = seats_actual), size = 0.5) +
  scale_fill_viridis_b(option = "inferno", na.value = "grey90", 
                       n.breaks = 10, show.limits = TRUE,
                       guide = guide_colorsteps(barwidth = 12, title.position = "top")) +
  coord_sf() +  # Albers
  labs(title = "Actual apportionment\nof the 2010 House",
       subtitle = paste0(sum(congress_actual_2010$seats_actual), 
                         " representatives in the 111th Congress"),
       fill = "House seats") +
  map_theme()

plot_js_2010 <- ggplot(data_2010) +
  geom_sf(aes(fill = seats_js), size = 0.5) +
  scale_fill_viridis_b(option = "viridis", na.value = "grey90", 
                       n.breaks = 10, show.limits = TRUE,
                       guide = guide_colorsteps(barwidth = 12, title.position = "top")) +
  coord_sf() +  # Albers
  labs(title = "Joseph Smith’s proposed apportionment\napplied to the 2010 House",
       subtitle = paste0(sum(js_proposal_2010$seats_js), 
                         " proposed representatives"),
       fill = "House seats") +
  map_theme()

plot_change_2010 <- ggplot(data_2010) +
  geom_sf(aes(fill = pct_change_power), size = 0.5) +
  scale_fill_distiller(palette = "RdYlBu", direction = -1, na.value = "grey95",
                       guide = guide_colourbar(barwidth = 12, title.position = "top"),
                       labels = scales::percent_format(),
                       limits = c(-0.45, 0.45)) +
  coord_sf() +  # Albers
  labs(title = "Change in relative state House power\nif Joseph Smith’s proposal had worked",
       subtitle = "House power calculated by dividing\neach state's total number of representatives\nby the overall number of representatives",
       fill = "Percent change in relative power") +
  map_theme()

plot_actual_2010 | plot_js_2010 | plot_change_2010
