# Hypothesis testing

library(ggplot2)
library(tidyr)
library(dplyr)

# T-Test ####

# make 3 fake variables with random values from normal distributions
x=rnorm(100)
y=rnorm(100)
z=rnorm(100,5,.5)

# build a plottable data frame
df = data.frame(x,y,z)
df = gather(df,key = Var,value = Value,1:3)

# plot density (shape of distribution)
ggplot(df,aes(x=Value,fill=Var)) +
  geom_density(alpha=.5)

# t-tests to determine whether the samples likely came from the same distributions
t.test(x,y)
t.test(x,z)



# correlation between 2 variables ####

count = c(9,25,15,2,14,25,24,47)
speed = c(2,3,5,9,14,24,29,34)

ggplot(mapping = aes(x=count,y=speed)) +
  geom_point() +
  geom_smooth(method = "lm",se=FALSE)

# correlation coefficients
cor(count, speed)
cor(count, speed, method = 'spearman')

# test for significance
cor.test(count,speed)




# ANOVA ####

data("iris")

# 1-way anova
mod.aov = aov(data=iris, Sepal.Length ~ Species)
summary(mod.aov)

#ANCOVA
mod.acv = aov(data = iris, Sepal.Length ~ Species + Petal.Length)
summary(mod.acv)


# compare two models
anova(mod.aov,mod.acv)


# Multiple comparisons ####

TukeyHSD(mod.aov)
plot(TukeyHSD(mod.aov))

