library(tidyverse)
library(modelr)


# Some simulated data
sim1
ggplot(sim1,aes(x,y)) + geom_point() # x is numeric

sim2
ggplot(sim2,aes(x,y)) + geom_point() # x is categorical

sim3
ggplot(sim3,aes(x1,y,color=x2)) + geom_point() # categorical AND numeric predictors



# Fit a linear model for each
mod1 <- lm(data = sim1,y~x)
mod2 <- lm(data = sim2,y~x)
mod3a <- lm(data = sim3,y~x1+x2)
mod3b <- lm(data = sim3,y~x1*x2)

# Visualize the models
ggplot(sim1,aes(x,y)) + geom_point() + geom_smooth(method = "lm",se=FALSE) # easy, automatic


ggplot(sim2,aes(x,y)) + geom_point() + geom_point(aes(x=x,y=add_predictions(sim2,mod2)$pred),color="Red",size=4) # have to make predictions first


# bit harder.... need all unique values of x1 and x2 and then predict based on those 
grid <- sim3 %>%
  data_grid(x1,x2)
grid

pred = gather_predictions(grid,mod3a,mod3b)
pred

ggplot(sim3,aes(x1,y,color=x2)) +
  geom_point() +
  geom_line(data = pred, aes(y=pred)) +
  facet_wrap(~model)

# which model is a better fit for these data?
sqrt(mean(residuals(mod3a)^2))
sqrt(mean(residuals(mod3b)^2))

sim3 %>%
  gather_residuals(mod3a,mod3b)
