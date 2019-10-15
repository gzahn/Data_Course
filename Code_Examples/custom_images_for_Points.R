library(tidyverse)
library(png)
library(gridGraphics)
library(ggimage)

mush = readPNG("~/Desktop/mush.png")

g1 <- rasterGrob(mush, interpolate=FALSE)

data("mtcars")

mtcars$image <- "~/Desktop/mush.png"

ggplot(mtcars, aes(disp,mpg)) +
  geom_image(aes(image=image),size=.1) +
  theme_minimal()
    
    