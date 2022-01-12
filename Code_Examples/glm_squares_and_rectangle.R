library(tidyverse)
library(patchwork)
theme_set(theme_minimal())

# statistical model ... the simplest one ever!

# make a simple data frame for different sized squares
squares <- data.frame(length=1:20,width=1:20)
# add a column for area
squares <- squares %>% 
  mutate(area=length * width)

squares %>% 
  ggplot(aes(x=length,y=width)) +
  geom_point()

# if you know the length of a square, you automatically know the width
# can a statistical test show that?

mod <- glm(data=squares,
           formula = width ~ length)

mod %>% summary()
# the (Intercept) is effectively zero
# the estimate for how length impacts width is 1
# so, our model is telling us that for each increase of 1 unit of length,
# it predicts that the width will go up by 1 as well.

# shocking!


# What about area? Let's see what that looks like...

squares %>% 
  ggplot(aes(x=length,y=area)) +
  geom_point()
# oh, right... that's an exponential, not a linear relationship!

# let's model it anyway...
mod2 <- glm(data=squares,
            formula = area ~ length)

mod2 %>% summary()
# What the hell!? the intercept is -77 !?
# And the estimated effect for length (slope of regression line) is 21 !?

# Let's plot it to see why that would make sense for our model,
# even though it doesn't make sense in reality...

squares %>% 
  ggplot(aes(x=length,y=area)) +
  geom_point() +
  geom_smooth(method="lm",se=FALSE,linetype=2)

# The points are the real observations, the blue line is the model.
# Do you see what it did? It was constrained to be a straight line and did its best
# under that unfortunate constraint. 
# It really believes that a square with zero length will have an area of -77

# so, what can we do about this?

# option 1: transform the data
squares <- squares %>% 
  mutate(area_sqrt = sqrt(area))

mod3 <- glm(data=squares,
            formula = area_sqrt ~ length)
summary(mod3) # ahh, that's better

# option 2: let our glm model use a different line formula
mod4 <- glm(data=squares,
            formula = area ~ I(length^2)) # the I() means to stop and evaluate as-is
mod4 %>% summary()


# Let's try to plot the second option:
squares %>% 
  ggplot(aes(x=length,y=area)) +
  geom_point() +
  geom_smooth(method="lm",formula = y ~ I(x^2)) # tell it the formula, just like above


# Okay, that's all fine and dandy, and our model claims to have near-perfect
# predictive powers. Let's try a messier data set...

set.seed(123) # same lengths as square, but random widths
rectangles <- data.frame(length = 1:20, width = round(runif(20,1,20),0))

# add area column
rectangles <- rectangles %>% 
  mutate(area=length * width)

# here are our rectangles
rectangles %>% 
  ggplot(aes(x=length,y=width)) +
  geom_point() +
  geom_segment(aes(xend=0,yend=width)) +
  geom_segment(aes(xend=length,yend=0))

# Can we predict width based on length? 
rectangles %>% 
  ggplot(aes(x=length,y=width)) +
  geom_point() + 
  geom_smooth(se=FALSE,method="lm")
# Looks like a lot of scatter. I don't trust that line... what do the stats say?

mod5 <- glm(data=rectangles,
            formula = width ~ length)
summary(mod5)
# no statistical support for length predicting width (p=0.578683)
# good, since those are random widths we made!

# But maybe we can use both length and width to predict area!
mod6 <- glm(data=rectangles,
            formula = area ~ length * width)
summary(mod6)
# okay, those estimates are telling us:
# it thinks a rectangle with length and width of zero has an almost zero area (good enough)
# both length and width are correlated with area, but with small effect sizes
# however, if you have BOTH length and width considered together (length:width),
# then it's pretty sure that it can tell you the area

# let's visualize the disparate effects of length and width on area:
p1 <- ggplot(rectangles,aes(x=length,y=area)) +
  geom_point() + geom_smooth(se=FALSE,method = "lm")

p2 <- ggplot(rectangles,aes(x=width,y=area)) +
  geom_point() + geom_smooth(se=FALSE,method = "lm")
p1 + p2

# fine. it makes sense that the greater the length of a rectangle, the more likely
# that it will have a larger area.  Same for width. But of course, there's room
# for variation. 


# Let's see how a model of just length predicting area does...
library(modelr)

# this is a deliberately bad model
mod7 <- glm(data=rectangles,
            formula = area ~ length)

add_predictions(rectangles, mod7) %>% 
  ggplot(aes(x=length,y=area)) +
  geom_point() + 
  geom_smooth(method="lm",se=FALSE,linetype=2,alpha=.25) +
  geom_point(aes(y=pred),color="red") +
  labs(subtitle = "black = observed reality; blue line = model; red dots = predictions")

# the "fit" of a model can be measured by how far each real point is from the model predictions
add_predictions(rectangles, mod7) %>% 
  ggplot(aes(x=length,y=area)) +
  geom_point() + 
  geom_smooth(method="lm",se=FALSE,alpha=.25) +
  geom_segment(aes(xend=length,yend=pred))

