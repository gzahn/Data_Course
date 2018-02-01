###################################################
######## Intro to modeling and testing ############
###################################################


####  Load packages ####
library(modelr)
library(broom)
library(dplyr)
library(fitdistrplus)
library(ggplot2)
########################

#### Load built-in mtcars data into data frame ####
dat = mtcars
###################################################

#### Check out data, summaries, visualizations ####

# Look at column descriptions of the built-in data
?mtcars

# Quick look at column classes and first rows
glimpse(dat)


# change "am" column from 1s and 0s to "Manual" and "Automatic"
dat$am[dat$am == 1] <- "Manual"
dat$am[dat$am == 0] <- "Automatic"

# Change "am" column to factor from numeric
dat$am = as.factor(dat$am)

# double-check
glimpse(dat)

# quick summary stats for every column
summary(dat)

# quick plot
plot(dat) # whoa!

# quick plot of mpg as function of other variables, one at a time...

for(i in names(dat)){
  plot(dat[,"mpg"] ~ dat[,i], xlab = i, ylab = "MPG", main = i)
}

# look at distribution of mpg

        # What is a distribution???

distributions = c("norm", "lnorm", "pois", "exp", "gamma", "binom", "nbinom", "geom", "beta", "unif", "logis")
# Here's a good web page with all the distributions included in base R:  https://en.wikibooks.org/wiki/R_Programming/Probability_Distributions

# Normal distribution
plot(density(dnorm(c(10000,10000))), main = "Normal Distribution")

  # Plot random samples from a truly normal distribution:
  points(density(rnorm(5)), col = "Red") # for 5 random samples
  points(density(rnorm(10)), col = "Green") # for 10 random samples
  points(density(rnorm(1000)), col = "Blue") # for 1000 random samples
  points(density(rnorm(100000)), col = "Orange") # for 100000 random samples
  points(density(rnorm(999999)), col = "Purple") # for 999999 random samples

  # ^^^ This is why sample size is important... as you randomly sample from an unknown distribution,
  # your sample distribution begins to approach the true distribution as sample size increases!
    

# Think of probability distributions like a histogram...
  # if you sampled 100% of some variable from a population of values, the histogram would BE the distribution
  
hist(dat$mpg)

# The fitdist() function from fitdistrplus package let's us compare a vector of data to a given distribution
?fitdist
fitdist(dat$mpg, "norm")

# we can look at the fit of our data to the theoretical values given by a chosen distribution
plot(fitdist(dat$mpg, "norm"))
plot(fitdist(dat$mpg, "gamma"))
plot(fitdist(dat$mpg, "logis"))

# try it on a different vector of data
plot(fitdist(dat$cyl, "norm")) # whoa now!

# Binomial distribution

  # imagine flipping a coin 10 times...at the end, how many heads would you have?
  # What if you flipped it 100000 times?

  # Our coin flip experiment
  sample(c("Heads","Tails"), size = 10, replace = TRUE) %>%
    table()

  # again, but with 1000 flips
  sample(c("Heads","Tails"), size = 1000, replace = TRUE) %>%
    table()
  
  # Let's plot it:
  
  # set counter, variable placeholders, and sequence of larger and larger coin flip experiments
  x=1
  heads = 0
  num.heads = c()
  flips = seq(from = 2, to = 5000, by=2)

for(i in flips){
  heads = table(sample(c("Heads","Tails"), size = i, replace = TRUE))[1]
  num.heads[x] = heads
  x=x+1
}  
  
# plot!
  plot(x=flips, y=num.heads/flips, ylim = c(0,1)) # Explain what this plot is showing!
  
  
# Which variables predict MPG?

########################################
#######         Models           #######
########################################

# A statistical model is a simple (hopefully) equation that *explains* trends in your data
# "In what way does variable Y (The response) depend on other variables (X1 .... Xn) in the study?
# The model attempts to approximate this relationship


### Decisions, decisions... ###

    # Which variable is your response?

    # Which variables are explanatory?

    # Are the explanatory variables continuous, categorical, or both?

        # All continuous: Regression
        # All categorial: ANOVA
        # Mix:            ANCoVA

    # Is the response variable continuous, a count, a proportion, a category????

        # Continuous:     Regression, ANOVA, ANCoVA
        # Proportion:     Logistic regression
        # Count:          Log-Linear model
        # Binary:         Binary logistic

#######################################################################

### What models look like in R ###

# Y ~ X                     This means "Y, is modeled as a function of X"
# Y ~ X1 + X2               This means "Y, is modeled as a function of X1 AND X2" (two explanatory variables)
# Y ~ X1:X2                 This means "Y, is modeled as a function of THE INTERACTION BETWEEN X1 AND X2 (only the interaction term)
# Y ~ X1*X2                 This means "Y, is modeled as a function of X1 AND X2 AND THE INTERACTION BETWEEN X1 AND X2

# Real quick...what's an interaction?
  
  ggplot(dat, mapping = aes(x=hp, y=mpg, col = am)) +
    geom_point() +
    geom_smooth(method = "aov", se = FALSE) +
    ggtitle("No interaction between Transmission type and Horsepower") +
    labs(subtitle = "...with respect to its effect on MPG")
  
  
  
  ggplot(dat, mapping = aes(x=disp, y=mpg, col = am)) +
    geom_point() +
    geom_smooth(method = "aov", se = FALSE) +
    ggtitle("Clear interaction between Transmission type and Horsepower") +
    labs(subtitle = "...with respect to its effect on MPG")
  
  
  
# You also need to tell R which model to use

?lm # linear model....common (for better or worse) when everything is continuous
?glm # Kind of the same as lm() but more flexible ... you can use it for non-normally distributed data
?aov # basically a glm for each level of categorical variables

# define a model: mpg, as explained by number of cylinders AND Displacement AND Weight
mod1 = glm(mpg ~ cyl + disp + wt, data = dat) 

# look at how well each term in the model explains mpg
summary(mod1)
tidy(mod1)

# we can look at the model fit diagnostics visually as well
par(mfrow = c(2, 2)) # changes viewing panel into a 2x2 grid
plot(mod1) # show model fit plots for diagnostics
par(mfrow = c(1, 1)) # changes viewing panel back to single plot space


# We can use the modelr package to easily add predictions (made by our model)
dat %>% add_predictions(model = mod1)
# This new column shows what our model predicts SHOULD be the mpg, based on cyl, disp, and wt

# Save this as a new data frame
dat.mod1 = dat %>% add_predictions(model = mod1)

# Calculate the mean squared difference between actual and predicted values of mpg
mean((dat.mod1$mpg - dat.mod1$pred)^2)


####### Try a different model! #########

mod2 = glm(mpg ~ cyl*wt, data = dat)
tidy(mod2)
dat.mod2 = dat %>% add_predictions(model = mod2)
mean((dat.mod2$mpg - dat.mod2$pred)^2)
        # this model seems to do a better job...it's mean square error is smaller

# Visually compare the two models against the real data

plot(dat$mpg ~ dat$wt)
abline(mod1, col = "Red")
abline(mod2, col = "Blue")
abline(lm(mpg ~ wt, data = dat)) # linear model of mpg explained only by wt
points(dat$mpg ~ dat$wt, col = dat$cyl) # color over points, using No. of Cylinders as color values


# ggplot way
ggplot(data = dat) +
  geom_point(aes(x=wt, y=mpg, col = factor(cyl))) +
  geom_smooth(aes(x=wt, y=mpg), method = "glm", col = "Black")
?geom_smooth
# Notice pattern that heavier cars have more cylinders?  This could be a "covariate" .. in other words, wt and cyl are NOT independent
# cyl could also be considered "categorical" since you can't have 4.5 cylinders

# categorical predictors of mpg...we can use ANOVA and Tukey's Test
mod3 = aov(mpg ~ factor(cyl)*am, data = dat)

par(mfrow = c(2, 2)) # changes viewing panel into a 2x2 grid
plot(mod3)
par(mfrow = c(1, 1)) # changes viewing panel into a 2x2 grid

summary(mod3)
TukeyHSD(mod3)





