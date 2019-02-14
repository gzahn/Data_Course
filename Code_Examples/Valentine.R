library(tidyverse)

data_frame(t=seq(-pi, 0, .001),
           x1=16*(sin(t))^2,
           x2=-x1,
           y=13*cos(t) -5 * cos(2*t) -2*cos(3*t) - cos(4*t)) %>%
  gather(side, x, x1, x2) %>%
  ggplot(aes(x,y)) +
  geom_polygon(fill="red") +
  coord_fixed() +
  theme_minimal() +
  annotate("text",x=0,y=0,label="Happy Valentine's Day")
