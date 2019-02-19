# Intro to linear and binomial regressions with single categorical predictor variables

#Packages
library(tidyverse)
library(fitdistrplus)
library(modelr)
library(gridExtra)


# Data
data("mtcars")
df <- mtcars

# quick peek
glimpse(df)

#plot mpg vs disp

p = ggplot(df, aes(x=disp,y=mpg)) +
  geom_point() 
p

p + geom_smooth(method = "lm", se=FALSE)

# Make linear model of relationship between disp and mpg
mod1 = lm(mpg ~ disp, data = df)

# gather info from model
df$predicted <- predict(mod1)
df$residuals <- residuals(mod1)
p

# plot from above but with model precited values
p2 = p + geom_smooth(method="lm", se=FALSE, alpha=.05, color="lightgrey") +
  geom_point(aes(y=df$predicted),color="Red")
p2

# Show residuals
p3 = p2 + geom_segment(aes(xend=disp,yend=df$predicted),linetype=2) +
  theme_bw() + 
  geom_text(x=300,y=30,mapping = aes(label=paste0("Sum of Squares = ",signif(sum(residuals(mod1)^2),4)))) +
  geom_text(x=300,y=27.5,mapping = aes(label=paste0("Mean Sq. Deviance = ",signif(mean(residuals(mod1)^2),4))))
p3

# regression for PREDICTION ####

# Make dataframe of new values (must have same column names as in model you want to predict from)
newdata = data.frame(disp = c(50,100,150,200,250,300,350,400,450,500,550,600))

# use new disp values to get predictions from mod1
newpreds = add_predictions(newdata, model = mod1)
p3 + geom_point(newpreds, mapping=aes(x=newpreds$disp,y=newpreds$pred),color="Blue", size=3)


# Cross-validate your model predictions based on your own data ####

# Pick a random half of your data
modrows = sample(nrow(df), replace = FALSE,nrow(df)/2)

# use those random rows: half to build model, other half to test it against real data
mod.df = df[modrows,]
cross.df = df[-modrows,]

# model based on half of data
mod.cross = lm(mpg ~ disp, data = mod.df)

cross.df = add_predictions(cross.df, model = mod.cross, var = "cross.predictions")
mean(abs(cross.df$mpg - cross.df$cross.predictions)) # mean absolute difference btwn predictions and real data
mean(abs(df$mpg - df$predicted)) # for model built on whole data set


p.cross1 = ggplot(cross.df, aes(x=disp,y=mpg)) +
  geom_point() + geom_segment(aes(xend=disp,yend=cross.predictions)) + 
  geom_point(aes(y=cross.predictions),color="Red") + ggtitle("lm: disp")
p.cross1
p.cross1 = p.cross1 + geom_smooth(method = "lm", se=FALSE)
  
# Add another predictor variable
mod.aov = aov(mpg ~ disp + wt, data = cross.df)
summary(mod.aov)

cross.df = add_predictions(cross.df, model = mod.aov, var = "aov.cross.predictions")
mean(abs(cross.df$mpg - cross.df$aov.cross.predictions)) # mean absolute difference btwn predictions and real data
mean(abs(df$mpg - df$predicted)) # for model built on whole data set

p.cross2 = ggplot(cross.df, aes(x=disp,y=mpg)) +
  geom_point() + geom_segment(aes(xend=disp,yend=aov.cross.predictions)) + 
  geom_point(aes(y=aov.cross.predictions),color="Red") + ggtitle("aov: disp + wt")

p.cross2 = p.cross2 + geom_smooth(method = "lm", se=FALSE)


grid.arrange(p.cross1,p.cross2)


################################################################


# Logistic regression

# Binary dependent variable
# vs	is variable in mtcars dataframe: "V" engine or "Straight" engine (o=V, 1=Straight)

# Can we predict whether a car is automatic or manual based on other data?

ggplot(df, aes(x=hp,y=vs)) + geom_point()

ggplot(df, aes(x=hp,y=vs)) + geom_point() + geom_smooth(method="lm",se=FALSE) +
  geom_text(x=250,y=.5,mapping=aes(label="WTF ?!\nLinear model no good for binary response."))

# Try "logistic" regression
mod2 = glm(vs ~ hp, data = df, family = "binomial")
df$binom.pred <- predict(mod2, type = "response")
df$binom.resid <- residuals(mod2, type = "response")

summary(mod2)
exp(coefficients(mod2)) # This gives log-odds: for every 1-unit increase in hp, log-odds of being V-engine drop 0.0685


ggplot(df, aes(x=hp,y=vs)) +
  geom_segment(aes(xend=hp,yend=binom.pred), alpha=.5) +
  geom_point() +
  geom_point(aes(y=binom.pred), shape=22, color="Blue") +
  geom_point(data = df %>% filter(vs != round(binom.pred)),
             color = "red", size = 2)

