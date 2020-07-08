library(tidyverse)
library(modelr)


# R for Data Science: Models


# Visualizing what a model does
ggplot(sim1, aes(x, y)) + 
  geom_point()

models <- tibble(
  a1 = runif(250, -20, 40),
  a2 = runif(250, -5, 5)
)

ggplot(sim1, aes(x, y)) + 
  geom_abline(aes(intercept = a1, slope = a2), data = models, alpha = 1/4) +
  geom_point() 


# Visualizing model error - residuals
dist1 <- sim1 %>% 
  mutate(
    dodge = rep(c(-1, 0, 1) / 20, 10),
    x1 = x + dodge,
    pred = 7 + x1 * 1.5
  )

ggplot(dist1, aes(x1, y)) + 
  geom_abline(intercept = 7, slope = 1.5, colour = "grey40") +
  geom_point(colour = "grey40") +
  geom_linerange(aes(ymin = y, ymax = pred), colour = "#3366FF")

# Measuring residuals
model1 <- function(a, data) {
  a[1] + data$x * a[2]
}
model1(c(7, 1.5), sim1)

measure_distance <- function(mod, data) {
  diff <- data$y - model1(mod, data)
  sqrt(mean(diff ^ 2))
}
measure_distance(c(7, 1.5), sim1)

# Use purrr to compute distance for all models defined above
sim1_dist <- function(a1, a2) {
  measure_distance(c(a1, a2), sim1)
}
models <- models %>% 
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))
models

# lm() finds optimum linear model automatically
mod.lm = lm(y~x,sim1)
lm.coef <- mod.lm$coefficients

ggplot(sim1) + geom_point(aes(x=x,y=y)) +
  geom_abline(intercept = lm.coef[1],slope = lm.coef[2],color="Blue")


# Practice on this simulated dataset
sim1a <- tibble(
  x = rep(1:10, each = 3),
  y = x * 1.5 + 6 + rt(length(x), df = 2)
)

mod.lm.sim1a <- lm(y~x,data = sim1a)
ggplot(sim1a) + geom_point(aes(x=x,y=y)) +
  geom_abline(intercept = coef(mod.lm.sim1a)[1],slope = coef(mod.lm.sim1a)[2])


# Making predictions ####
# predictions tell you pattern your model has captured...
grid <- sim1 %>% 
  data_grid(x) 
grid

grid <- grid %>% 
  add_predictions(model=mod.lm) 
grid

# visualize, using predictions from model to make line
ggplot(sim1, aes(x)) +
  geom_point(aes(y = y)) +
  geom_line(aes(y = pred), data = grid, colour = "red", size = 1)

# compare to geom_smooth()
ggplot(sim1, aes(x=x,y=y)) +
  geom_point() + geom_smooth(method = "lm", se=FALSE) +
  geom_line(aes(y = pred), data = grid, colour = "red", size = 1)
# totally identical

# Residuals tells you patterns your model has missed

# add residuals
sim1 <- sim1 %>% 
  add_residuals(mod.lm)
sim1
  
# visualize them
ggplot(sim1, aes(resid)) + 
  geom_freqpoly(binwidth = 0.5)

# looking for good, random scatter...
ggplot(sim1, aes(x=x, y=resid)) + 
  geom_ref_line(h = 0) +
  geom_point() 

# Bonus...gather and spread predictions (look at more than one model at same time) ####
df <- tibble::data_frame(
  x = sort(runif(100)),
  y = 5 * x + 0.5 * x ^ 2 + 3 + rnorm(length(x))
)
plot(df)

m1 <- lm(y ~ x, data = df)
grid <- data.frame(x = seq(0, 1, length = 10))
grid %>% add_predictions(m1)

m2 <- lm(y ~ poly(x, 2), data = df)
grid %>% spread_predictions(m1, m2)
grid %>% gather_predictions(m1, m2)

# plotting from gather_predictions()
grid %>% gather_predictions(m1, m2) %>%
  ggplot(aes(x=x,y=pred,color=model)) +
  geom_line()


# Model matrix (what's going on with that model formula?)
df <- tribble(
  ~y, ~x1, ~x2,
  4, 2, 5,
  5, 1, 6
)

model.matrix(y~x1+x2,df)
model.matrix(y~x1*x2,df)

# Categorical variables
df <- tribble(
  ~ sex, ~ response,
  "male", 1,
  "female", 2,
  "male", 1
)
model.matrix(response~sex,df)

# simulated categorical data
ggplot(sim2) + 
  geom_point(aes(x, y))

mod2 <- lm(y ~ x, data = sim2)

# same predicted value for each category (naturally)
add_predictions(sim2,mod2)

# since predictions for categorical predictors will equal mean, can do in grid form
grid <- sim2 %>% 
  data_grid(x) %>% # generates evenly spaced grid of points from data
  add_predictions(mod2)
grid

# visualize (mean minimized mean sq distance)
ggplot(sim2, aes(x)) + 
  geom_point(aes(y = y)) +
  geom_point(data = grid, aes(y = pred), colour = "red", size = 4)


# Interactions ####

ggplot(sim3, aes(x1, y)) + 
  geom_point(aes(colour = x2))

# two possible models
mod1 <- lm(y ~ x1 + x2, data = sim3) # no interaction
mod2 <- lm(y ~ x1 * x2, data = sim3) # with interaction term

sim3 %>% gather_predictions(mod1,mod2) %>%
  ggplot(aes(x=x1,y=y,color=x2)) + geom_point() +
  geom_line(aes(x=x1,y=pred,color=model,group=x2)) +
  facet_wrap(~model)

# build grid and add predictions (building grid first is important for drawing lines)
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


# Interactions with 2 CONTINUOUS PREDICTOR variables ####

# overview of simulated data
sim4 %>% ggplot(aes(x=x1,y=y,group=x2,color=x2)) + 
  geom_point() + geom_smooth(method = "lm", se=FALSE)

mod1 <- lm(y ~ x1 + x2, data = sim4) # no interaction (slope stays same)
mod2 <- lm(y ~ x1 * x2, data = sim4) # with interaction (slope can change by group!)



grid <- sim4 %>% 
  data_grid(
    x1 = seq_range(x1, 5), # not using EVERY possible combo
    x2 = seq_range(x2, 5)  # just a regularly spaced range of values
  ) %>% 
  gather_predictions(mod1, mod2)
grid # make that grid or visualization will be tricky!

ggplot(grid, aes(x=x1,y=pred,group=x2,color=x2)) + # used GROUP aesthetic to make lines happy
  geom_line() + facet_grid(~model)


# Non-linear data ####

sim5 <- tibble(
  x = seq(0, 3.5 * pi, length = 50),
  y = 4 * sin(x) + rnorm(length(x))
)

ggplot(sim5, aes(x, y)) +
  geom_point() + geom_smooth(method = "lm", se=FALSE)



# Try natural spline variations... ns() instead of straight linear models
library(splines)
mod1 <- lm(y ~ ns(x, 1), data = sim5)
mod2 <- lm(y ~ ns(x, 2), data = sim5)
mod3 <- lm(y ~ ns(x, 3), data = sim5)
mod4 <- lm(y ~ ns(x, 4), data = sim5)
mod5 <- lm(y ~ ns(x, 5), data = sim5)

# make that grid
grid <- sim5 %>% 
  data_grid(x = x) %>% 
  gather_predictions(mod1, mod2, mod3, mod4, mod5)

ggplot(sim5, aes(x, y)) + 
  geom_point() +
  geom_line(data = grid, colour = "red",aes(y=pred)) +
  facet_wrap(~ model)
