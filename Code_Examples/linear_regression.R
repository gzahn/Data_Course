#Packages
library(tidyverse)
library(fitdistrplus)


# Data
data("mtcars")
df <- mtcars

# quick peek
glimpse(df)

#plot mpg vs disp

p = ggplot(df, aes(x=disp,y=mpg)) +
  geom_point() 
p

p + geom_smooth(method = "lm", se=FALSE)

# Make linear model of relationship between disp and mpg
mod1 = lm(mpg ~ disp, data = df)

# gather info from model
df$predicted <- predict(mod1)
df$residuals <- residuals(mod1)
p

# plot from above but with model precited values
p2 = p + geom_smooth(method="lm", se=FALSE, alpha=.05, color="lightgrey") +
  geom_point(aes(y=df$predicted),color="Red")
p2

# Show residuals
p2 + geom_segment(aes(xend=disp,yend=df$predicted),linetype=2) +
  theme_bw() 




