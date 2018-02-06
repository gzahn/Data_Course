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
hist(dat$mpg)
plot(density(dat$mpg))
        

# What is a distribution???
        # Let's say we decided to measure human height. If we measured EVERY human on earth,
        # the distribution of their heights would show the probability of a random person 
        # having a given height.

distributions = c("norm", "lnorm", "pois", "exp", "gamma", "binom", "nbinom", "geom", "beta", "unif", "logis")
# Here's a good web page with all the distributions included in base R:  https://en.wikibooks.org/wiki/R_Programming/Probability_Distributions

# Normal distribution

x<-seq(-4,4,length=2000)
y<-dnorm(x,mean=0, sd=1)
plot(x,y, type="l", lwd=2, main = "Normal Distribution")


  # BUT... there's no way to measure the height of every human. 
  # You can instead take a representative sample of humans and ESTIMATE the distribution of heights.


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

##### Binomial distribution

  # imagine flipping a coin 10 times...at the end, how many heads would you have?
  # This is what a binomial distribution is all about... counts of an outcome of an experiment.
x = seq(0,50,by=1)
y = y <- dbinom(x,50,0.5)
plot(x,y, type = "l", main = "Binomial Dist. - N=50, P=0.5")
  # shows probability of getting a specific number of a certain outcome, given a probability for each result
    # we can see it would be highly unlikely to get fewer than 10 tails in 50 coin flips.


  # What if you flipped it 100000 times?

x = seq(0,10000,by=1)
y = y <- dbinom(x,10000,0.5)
plot(x,y, type = "l", main = "Binomial Dist. - N=10000, P=0.5")


########### A lot of statistical tests are all about determining whether your representative sample
########### could have really come from a given probability distribution!

# Look at the previous plot (P of outcomes from 50 flips)
# If you flipped a coin 50 times and only got 4 heads, how likely is it that it was just random chance,
# vs. how likely is it that the true probability of heads/tails is 50/50 ????

?binom.test()
binom.test(x=4,n=50,p=0.5)  # 4 successes, out of 50 flips, probability of success is 0.5
                                  # Reject the null hypothesis (P-value of 4.462e-10)
binom.test(x=4,n=50,p=0.1)  # 4 successes, out of 50 flips, probability of success is 0.1
                                  # Fail to reject the null Hypothesis (P-value of 0.8151)


# Our coin flip experiment and the Central Limit Theorem
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
  flips = seq(from = 2, to = 500, by=2)

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

# Notice pattern that heavier cars have more cylinders?  This could be a "covariate" .. in other words, wt and cyl are NOT independent
# cyl could also be considered "categorical" since you can't have 4.5 cylinders

dat$cyl = as.factor(dat$cyl)

# categorical predictors of mpg...we can use ANOVA and Tukey's Test
mod3 = aov(mpg ~ factor(cyl)*am, data = dat)

par(mfrow = c(2, 2)) # changes viewing panel into a 2x2 grid
plot(mod3)
par(mfrow = c(1, 1)) # changes viewing panel into a 2x2 grid

summary(mod3)

# So let's say you see some significant interaction between two explanatory variables.
# How do you determine what what the specific effects are? All you see is "significant interaction"
TukeyHSD(mod3)

###### Another Tukey Test example ...

# Let's look at the decomposition rates of some foods sitting in cafeterias at two universities
decomp = data.frame(Food = c(rep("Banana", 40), rep("Apple", 40), rep("Gravy",40)),
                University = c(rep(c("UVU","BYU"),times = 60)),
                Decomposition_Rate = abs(rnorm(120))*c(1,4)*c(rep(1,40),rep(5,40),rep(1,40)))



decomp_model = aov(Decomposition_Rate ~ University:Food, data = decomp)
summary(decomp_model)

# Aaaa HAAA! There is a significant interaction between University and Food

# Let's take a look and see if we can visually find the pattern
ggplot(decomp, mapping = aes(x=Food, y=Decomposition_Rate, fill = University)) +
  geom_boxplot()

# what I see: Food decomposes more rapidly at BYU, but apples, in particular, have a pronounced effect

# a plot is fine, but how about a statistical test...
TukeyHSD(decomp_model)

######



names(dat)
# ANOVA: Find out which terms have significant impact on response
aov(mpg ~ cyl*disp*hp*am*wt, data = dat) %>% summary()
# anova can handle categorical predictors, remember!
    # looks like hp doesn't help our model much...

aov(mpg ~ cyl*disp*am*wt, data = dat) %>% summary()
    # maybe we could even drop am

aov(mpg ~ cyl*disp*wt, data = dat) %>% summary()
mod4 = aov(mpg ~ cyl*disp*wt, data = dat)

mod4_pred = add_predictions(dat, model = mod4) %>% select_("pred")
plot(dat$mpg, mod4_pred[,1])
abline(lm(dat$mpg ~ mod4_pred[,1])) # How do predictions match up?

# is it looking like a good model? 

# What defines a "good" model???




