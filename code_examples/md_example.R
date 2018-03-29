# install pandoc from: https://github.com/jgm/pandoc/releases/tag/2.1.3

# install rmarkdown and knitr
library(rmarkdown)
library(knitr)

# Cheat Sheet found at: https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf

# load other libraries
library(dplyr)
library(tidyr)

cars = mtcars

summary(cars)
glimpse(cars)

# Simple Plot

plot(cars$mpg ~ cars$hp, main = "MPG vs Horsepower")
