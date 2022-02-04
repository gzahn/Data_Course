library(tidyverse)
library(xkcd)
library(extrafont)


# install the xkcd font
download.file("http://simonsoftware.se/other/xkcd.ttf",
              dest="xkcd.ttf", mode="wb")
system("mkdir ~/.fonts")
system("cp xkcd.ttf ~/.fonts")
font_import(pattern = "Humor Sans", prompt=FALSE)
fonts()
fonttable()
if(.Platform$OS.type != "unix") {
  ## Register fonts for Windows bitmap output
  loadfonts(device="win")
} else {
  loadfonts()
}


#############


iris %>% 
  ggplot(aes(x=Petal.Length,y=Petal.Width)) +
  geom_point() +
  theme_xkcd() +
  xkcdaxis(range(iris$Petal.Length),range(iris$Petal.Width))
