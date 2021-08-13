# Typical modeling workflow: ####

# Packages and example data
library(tidyverse)
library(modelr)
library(GGally)
library(lindia)
library(skimr)
library(patchwork)
library(caret)

# Data
data("mtcars")
data("iris")


# Get to know your data ####
mtcars %>% ggpairs()
iris %>% filter(Species == "setosa") %>% ggpairs()
iris %>% ggpairs(mapping = c("Species","Sepal.Length"))


# Build possible models ####

# lm() is linear model. There are LOTS of other model types
mod1 <- lm(data=iris, formula = Sepal.Length ~ Sepal.Width)
mod2 <- lm(data=iris, formula = Sepal.Length ~ Sepal.Width + Species)
mod3 <- lm(data=iris, formula = Sepal.Length ~ Sepal.Width * Species)



# Look at model summaries ####
summary(mod1)
summary(mod2)
summary(mod3)

# how to interpret results?
# Coefficients, P-values, Adjusted R-squared


# Look at model diagnostics ####
gg_diagnose(mod1)
gg_diagnose(mod2)
gg_diagnose(mod3)


# Compare models ####
anova(mod1, mod2) # different?
anova(mod1, mod3)
anova(mod2, mod3)

# which has better fit ?
mod1mse <- mean(residuals(mod1)^2)
mod2mse <- mean(residuals(mod2)^2)
mod3mse <- mean(residuals(mod3)^2)

mod1mse ; mod2mse ; mod3mse

# Evaluate predictions ####
df_mod1 <- add_predictions(iris,mod1) # adds model prediction column using a single model
df_mod1

df <- gather_predictions(iris, mod1,mod2,mod3) # add many models' predictions at once (tidy-style)
df
skim(df)
names(df)

# compare predictions to reality
p1 <- ggplot(df_mod1,aes(x=Sepal.Width,color=Species)) +
  geom_point(aes(y=Sepal.Length),alpha=.5,size=2) +
  geom_point(aes(y=pred),color="Black") + theme_bw()
p1

p1 + geom_segment(aes(y=Sepal.Length,xend=Sepal.Width,yend=pred),
                  linetype=2,color="Black",alpha=.5)

# look at plot of predictions for each model
# we can do this after using gather_predictions() with more than 1 model
ggplot(df,aes(x=Sepal.Width,color=Species)) +
  geom_point(aes(y=Sepal.Length),alpha=.25) +
  geom_point(aes(y=pred),color="Black") +
  facet_wrap(~model) +
  theme_bw()

# which model is best?


# Using mtcars #
skim(mtcars)
carsmod1 <- lm(data=mtcars, formula = mpg ~ wt + factor(cyl))
carsmod2 <- lm(data=mtcars, formula = mpg ~ wt * factor(cyl))

p1 <- add_predictions(mtcars,carsmod1) %>%
  ggplot(aes(x=wt,color=factor(cyl))) +
  geom_point(aes(y=mpg)) +
  geom_smooth(method = "lm",aes(y=pred)) +
  labs(title = "wt + cyl")

p2 <- add_predictions(mtcars,carsmod2) %>%
  ggplot(aes(x=wt,color=factor(cyl))) +
  geom_point(aes(y=mpg)) +
  geom_smooth(method = "lm",aes(y=pred)) +
  labs(title = "wt * cyl")

p1 / p2

# Cross-validation ####

# if we train our model on the full data set, it can become "over-trained"
# In other words, we want to make sure our model works for the SYSTEM, not just the data set

set.seed(123) # set reproducible random number seed
set <- caret::createDataPartition(iris$Sepal.Length, p=.5) # pick random subset of data 
set <- set$Resample1 # it saved as a dataframe for some good reason, I'm sure. convert to vector

train <- iris[set,] # subset iris using the random row numbers we made
test <- iris[-set,] # The other half of the iris dataset

# build our best iris model (mod3, from above)
formula(mod3)
mod3_cv <- lm(data=train, formula = formula(mod3))


# Test trained model on unused other half of data set
iristest <- add_predictions(test,mod3_cv)

# plot it
ggplot(iristest,aes(x=Sepal.Width,color=Species)) +
  geom_point(aes(y=Sepal.Length),alpha=.25) +
  geom_point(aes(y=pred),shape=5)


# compare MSE from our over-fitted model to the cross-validated one
testedresiduals <- (iristest$pred - iristest$Sepal.Length)

mod3mse # our original MSE
mean(testedresiduals^2) # our cross-validated model

# Plot comparison of original and validated model 

# gather model predictions
df <- gather_predictions(iris, mod3,mod3_cv)

# plot - distinguish model predictions using "linetype"
ggplot(df, aes(x=Sepal.Width,color=Species)) +
  geom_point(aes(y=Sepal.Length),alpha=.2) +
  geom_smooth(method = "lm",aes(linetype=model,y=pred)) + theme_bw()

# If it still looks good, you can use the full model for future predictions ####


################################## Your turn ... ########################################

# Now, use this workflow to model miles per gallon in the mtcars dataset!

    # Things to consider:
      # What variables are explanatory? 
      # What interaction terms are useful?
      # What's the simplest model that has good explanatory power?



