rm(list = ls())

library(dplyr)
library(tidyr)
library(ggplot2)
library(broom)
library(fitdistrplus)
library(MASS)
library(lme4)
library(modelr)

df = CO2



##########

glimpse(df)
plot(fitdist(df$uptake, distr = "norm"))
plot(fitdist(df$uptake, distr = "lnorm"))
plot(fitdist(df$uptake, distr = "logis"))
plot(fitdist(df$uptake, distr = "gamma"))


plot(fitdist(log10(df$uptake), distr = "norm")) # this looks best
plot(fitdist(sqrt(df$uptake), distr = "norm"))

denscomp(fitdist(df$log10_uptake, distr = "norm"))


# # try box-cox transformation
# Box = boxcox(uptake ~ conc, data = df, lambda = seq(-6,6,0.1))
# Cox = data.frame(Box$x, Box$y)
# Cox2 = Cox[with(Cox, order(-Cox$Box.y)),]
# Cox2[1,]
# lambda = Cox2[1, "Box.x"]
# df$Turbidity_box = (df$uptake ^ lambda - 1)/lambda  
# 
# plot(fitdist(df$Turbidity_box, distr = "norm"))
# 
# #####
# log10 transformation looked like best strategy

df$log10_uptake = log10(df$uptake)

# exploratory plots

boxplot(df$uptake ~ df$Treatment*df$Type, col = c("Lightgrey","White"))

p1 = ggplot(df, aes(x=conc, y=log10_uptake, col=Treatment)) +
  geom_point() +
  stat_smooth() + ggtitle("CO2 Uptake")
p1

p2 = ggplot(df, aes(x=conc, y=log10_uptake, col=Type)) +
  geom_point() +
  stat_smooth() + ggtitle("CO2 Uptake")
p2

p3 = ggplot(df, aes(x=conc, y=log10_uptake, col=Treatment)) +
  geom_point() +
  stat_smooth() + ggtitle("CO2 Uptake") +
  facet_grid(facets = ~ Type)
p3

# ANOVA model

mod1 = aov(log10_uptake ~ conc*Treatment*Type, data = df)
summary(mod1)
plot(mod1)
tidy(mod1)

# check model predictions
df = add_predictions(df,model = mod1)

plot(df$log10_uptake, df$pred)
abline(lm(df$pred ~ df$log10_uptake))

mean(sum((df$log10_uptake - df$pred)^2))

p3

TukeyHSD(mod1)

# Make some specific predictions
df2 = data.frame(conc = c(1200,1000,750,500), Type = factor(c("Quebec","Quebec","Mississippi","Mississippi")),
                 Treatment = factor(c("nonchilled","chilled","nonchilled","chilled")))
df2

mod2 = aov(log10_uptake ~ conc, data = df)

predictions = predict(mod1, newdata = df2)
predictions2 = predict(mod2, newdata = df2)

# plot predictions along with data
plot(df$log10_uptake ~ df$conc, xlim = c(0,1200), ylim = c(0,2))
points(df2$conc, predictions, col = "Red", pch = 19)
points(df2$conc, predictions2, col = "Blue", pch = 19)

ggplot() +
  geom_point(aes(x=df$conc,y=df$log10_uptake,col=df$Type)) +
  geom_point(aes(x=df2$conc,y=predictions,col=df2$Type), cex = 5, pch = 15) +
  geom_point(aes(x=df2$conc,y=predictions2,col=df2$Type),cex = 5, pch = 0) +
  geom_smooth(aes(x=df$conc,y=df$log10_uptake,col=df$Type)) +
  labs(title="CO2 uptake vs CO2 concentration", subtitle = "Boxes indicate model predictions for arbitrary values",
       x = "Log10 CO2 Uptake", y = "CO2 concentration")





######## Cross-Validation

# Any model trained on a data set will be baised toward good predictions for that data set!!!

c(1,4,4,4,2,3,4,5) %in% c(4,5,6,7,8)


'%ni%' = Negate('%in%')

df$Cross = rnorm(length(df$Plant))
df.sample = sample(df$Cross, 48)
df.train = df[which(df$Cross %in% df.sample),]
df.cross = df[which(df$Cross %ni% df.sample),]

mod3 = aov(log10_uptake ~ conc*Treatment*Type, data = df.train)
plot(mod3)
mod3
summary(aov(mod3))


(anova(mod1,mod2))


cross.predictions = add_predictions(model = mod3, data = df.cross)

mean((cross.predictions$pred - cross.predictions$log10_uptake)^2)

