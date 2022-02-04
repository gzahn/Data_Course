# Site map ####
library(ggmap)
library(maps)
library(tidyverse)
library(readxl)


# Google Map with custom API ####
counties <- map_data("county")
utah_counties <- counties %>% 
  filter(region == "utah") %>% 
  filter(subregion == "utah")

# get secret google api key from system variable
key <- system("cat ~/.bashrc | tail -1 | cut -d '=' -f 2", intern = TRUE) %>% 
  str_remove_all('\"')

# build map of sample locations ####
ggmap::register_google(key = key) # Key kept private

# custom labeling 
mapstyle1 = 'feature:all|element:labels|visibility:off&style=feature:water|element:labels|visibility:on&style=feature:administrative.locality|element:labels|visibility:on&style=feature:road.local|element:geometry.fill|visibility:on'

# build basic map
UtahMap <- get_googlemap(center = c(lon = -111.6952, lat = 40.1542),
                         zoom = 9, scale = 2,
                         style = mapstyle1,
                         maptype = "roadmap")

# add Utah County boundary
UtahCoMap <- ggmap(UtahMap) +
  geom_polygon(data=utah_counties,
               aes (x=long,y=lat,group=group), 
               fill= NA, 
               color = "Black") +
  coord_cartesian(xlim = c(-112.25,-110.85),
                  ylim = c(39.75,40.6)) +
  labs(title = "Utah County")

UtahCoMap

# add locations ####

# import location data
# data frame with: Longitude, Latitude, SalePrice, etc 
# meta <- read_csv()
# example with random points
set.seed(12345678)
meta <- data.frame(Longitude = runif(500,-112.1,-111.2),
           Latitude = runif(500,39.9,40.4),
           SalePrice = runif(500,100,500))

UtahCoMap +
  geom_point(aes(x = Longitude, y = Latitude, colour = SalePrice), data = meta, size = .1) +
  scale_color_viridis_c(option = "magma")



# basic usmap map ####
library(usmap)
UT_Co_fips <- fips(state = "UT",county="utah")

usmap::plot_usmap(regions="county",include=UT_Co_fips)


# interactive map ####
library(sf)
library(leaflet)
# devtools::install_github("ropensci/USAboundaries")
# devtools::install_github("ropensci/USAboundariesData")
library(USAboundaries)

us_counties()
m <- leaflet() %>% 
  setView(lng = -111.6952, lat = 40.1542,zoom = 8) %>% 
  addTiles()
m  

# extract polygon info for Utah County border
ut_counties <- us_counties(states = "Utah",resolution = "high") 

#clean extra column
ut_counties <- ut_counties[,-9]
ut_counties %>% 
  filter(name == "Utah")


utah_co <- ut_counties %>% 
  filter(name == "Utah")

ut_co_poly <- utah_co$geometry
latlon <- ut_co_poly %>% unlist()
long <- latlon[1:(length(latlon)/2)]
lat <- latlon[(length(long)+1):length(latlon)]

# add boundary shape to leaflet map
m %>% 
  addPolygons(lng = long,lat = lat,color = "Black",fillOpacity = .1)

# add city circles, sized by 2010 population
cities <- us_cities() %>% 
  filter(state_abbr == "UT" & county_name == "Utah")
cities$geometry[[15]]
city_long <- cities$geometry %>% map_dbl(1)
city_lat <- cities$geometry %>% map_dbl(2)


m %>% 
  addPolygons(lng = long,
              lat = lat,
              color = "Black",
              fillOpacity = .1) %>% 
  addCircles(lng = city_long,
             lat=city_lat,
             radius = sqrt(cities$population)*15,
             label = paste0(cities$city,": 2010 Pop. = ",
                            cities$population),
             fillColor = "Gray",
             color = "Gray")


  