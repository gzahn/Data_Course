library(tidyverse)
library(modelr)

data("sim3") # included in modelr package

# Interactions ####

ggplot(sim3, aes(x1, y)) + 
  geom_point(aes(colour = x2))

# two possible models
mod1 <- lm(y ~ x1 + x2, data = sim3) # no interaction
mod2 <- lm(y ~ x1 * x2, data = sim3) # with interaction term

sim3 %>% gather_predictions(mod1,mod2) %>%
  ggplot(aes(x=x1,y=y,color=x2)) + geom_point() +
  geom_line(aes(x=x1,y=pred,group=x2)) +
  facet_wrap(~model)

# build grid and add predictions (building grid first is important for drawing lines)

grid <- sim3 %>% 
  data_grid(x1, x2)

View(grid)

grid <- sim3 %>% 
  data_grid(x1, x2) %>% 
  gather_predictions(mod1, mod2)
grid


# visualize
ggplot(sim3, aes(x=x1, y=y, color = x2)) + 
  geom_point() + 
  geom_line(data = grid, aes(y = pred)) + # use data grid of all combos so line isn't overplotted
  facet_wrap(~ model)

# plot residuals (very handy!)
gather_residuals(sim3,mod1,mod2) %>%
  ggplot(aes(x=x1,y=resid,color=x2)) + geom_point() + geom_ref_line(h=0,size = .5,colour = "Black") +
  facet_grid(model~x2)

