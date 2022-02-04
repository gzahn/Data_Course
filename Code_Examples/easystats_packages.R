# load packages ####
library(easystats)
library(modelr)
library(tidyverse)
library(lme4)

# get data (built-in)
data(mpg)
glimpse(mpg)

# build models ####
mod1 <- mpg %>% 
  glm(data = .,
      formula = cty ~ displ * year * cyl)

mod2 <- mpg %>%
  glm(data = .,
      formula = cty ~ displ + drv + cyl)

mod3 <- mpg %>% 
  lmer(data = .,
       formula = cty ~ displ + year + (1 | model))

# Quick look at confusing model output ####
summary(mod1)
summary(mod2)
summary(mod3)


# use performance package to investigate models ####
check_model(mod1)
check_model(mod2)
check_model(mod3)

compare_performance(mod1,mod2,mod3)
compare_performance(mod1,mod2,mod3, rank = TRUE)
compare_performance(mod1,mod2,mod3, rank = TRUE) %>% plot()


# use parameters package to investigate further ####
parameters(mod1) %>% plot()
parameters(mod2) %>% plot()
parameters(mod3) %>% plot()


# use report package to help interpret model output ####
report(mod1)
report(mod2)
report(mod3)
