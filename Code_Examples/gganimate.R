library(tidyverse)
library(gganimate)
library(lubridate)




# gganimate lets you simply add a new 'layer' to your ggplot
# where you tell it how to transition and what variable to use
# cheat sheet is here: https://ugoproto.github.io/ugo_r_doc/pdf/gganimate.pdf





# Simple animation based on categorical states ... transition_states() 
(iris_plot <- iris %>% 
  ggplot(aes(x=Sepal.Length,y=Sepal.Width)) +
  geom_point() +
  labs(title = "Iris {closest_state}") +
  theme_minimal() +  
  theme(plot.title = element_text(face="italic"))
)


iris_plot + 
  geom_smooth(method = "lm") +
  transition_states(Species)
  

# transition_layers reveals each geom layer sequentially
ordered_class <- mpg %>% 
  group_by(class) %>% 
  summarize(med=median(cty)) %>% 
  arrange(med) %>% 
  pull(class)

(mpg_plot <- mpg %>% 
  mutate(ordered_class = factor(class,levels = ordered_class)) %>% 
  ggplot(aes(y=ordered_class,x=cty)) +
  geom_boxplot(alpha=.25) +
  geom_jitter(width = 0,height = 0.25) +
  geom_boxplot(aes(fill=ordered_class),alpha=.25) +
  geom_vline(aes(xintercept=median(mpg$cty)),linetype=2) +
  annotate("text",x=26,y="2seater",label="Median city MPG") +
  geom_segment(aes(x = 22, y = "2seater", xend = 17, yend = "2seater"),
               arrow = arrow(length = unit(0.5, "cm"))) +
  scale_fill_viridis_d() + 
  theme_minimal() +
  theme(legend.position = "none",
        axis.text = element_text(face="bold",size=12),
        axis.title = element_text(face="bold",size=16)) +
  labs(y="Class of car",x="\nCity MPG")
)

# show each layer, one at a time
mpg_plot +
  transition_layers()



# transition_filter() let's you cycle between conditions
mpg %>% 
  ggplot(aes(x=class,y=cty,group=factor(cyl))) +
  geom_boxplot(aes(group=class)) +
  geom_jitter(alpha=.25) +
  transition_filter(transition_length = 2,
                    filter_length = 1,
                    cyl == 4,
                    cyl == 5,
                    cyl == 6,
                    cyl == 8) +
  labs(title = "No. of cylinders: {closest_filter}")


# Time series animation of CO2 data (Keeling curve)
data("co2")

# convert time-series object to useful data frame
co2_df <- co2 %>% 
  as.data.frame() %>% 
  mutate(ppm = x,
         year= floor(time(co2)),
         month = rep(month.abb,39)) %>% 
  mutate(date = mdy(paste0(month,"-01-",year))) %>% 
  select(-x)
co2_df %>% glimpse


# transition_time() takes a "date/time" class variable
co2_df %>% 
  ggplot(aes(x=date,y=ppm)) +
  geom_line() +
  transition_time(date) +
  labs(title = "{frame_time}")

# transition_reveal() works similar to transition_time() but leaves previously shown data
co2_df %>% 
  ggplot(aes(x=date,y=ppm)) +
  geom_line() +
  transition_time(date) +
  labs(title = "Date: {frame_along}")




# make an interactive plot with plotly package
library(plotly)

mpg_plot_2 <- mpg %>% 
  ggplot(aes(y=cty,x=displ,fill=class)) +
  geom_point(size=3) +
  scale_fill_viridis_d() + 
  theme_minimal() +
  labs(y="Class of car",x="\nCity MPG")

ggplotly(mpg_plot_2,tooltip = c("fill","x","y"))

