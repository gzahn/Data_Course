# Building and looking at models ####

# Necessary packages ####
library(GGally)
library(tidyverse)
library(lindia)


# Data ####
data("mtcars")
data("iris")


# Overview of data all at once ####
mtcars %>% ggpairs()
iris %>% filter(Species == "setosa") %>% ggpairs()


# Build linear regression models ####
mod <- lm(data=iris, formula = Sepal.Length ~ Sepal.Width * Species)
mod2 <- lm(data=iris, formula = Sepal.Length ~ Sepal.Width)

# Look at model summaries ####
summary(mod)
summary(mod2)

# how to interpret results?

# Diagnose model assumptions ####
gg_diagnose(mod,boxcox = TRUE)
gg_diagnose(mod2,boxcox = TRUE)


# Compare models ####
anova(mod, mod2) # different?

# which has better fit ?
sum(residuals(mod)^2)
sum(residuals(mod2)^2)


# Add predictions ####


# Cross-validation ####


