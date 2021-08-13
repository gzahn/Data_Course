
################################
#                              #
# Practice playing with models #
#                              #
################################

# Packages
library(tidyverse)
library(modelr)
library(GGally)
library(MASS)

# We will use some built-in data sets
data("heights")


# make plots use "normal" numbers
options(scipen = 999)

# Do taller people earn more money? ####
?heights
glimpse(heights)
#ggpairs(heights)

# Quick model of income (throw in lots of predictors)
height_fullmodel <- glm(data=heights, income ~ height * weight * age * marital * sex * education)
summary(height_fullmodel)
ggcoef(height_fullmodel,exclude_intercept = TRUE)

# Let's look at some specific predictors
ggplot(heights, aes(x=height,y=income,color=sex,fill=sex)) + 
  geom_point() + facet_wrap(~marital)


# what are those weird high values that all appear the same?
max(heights$income)
which(heights$income==max(heights$income))

# I don't trust those. Is it believeable that ~150 random people all make exactly $343,830 a year!?  Let's remove them
heights <- heights %>% filter(income < 340000)

# try that plot again with those suspect values removed
ggplot(heights, aes(x=height,y=income,color=sex,fill=sex)) + 
  geom_point(alpha=.25,size=.25) + geom_smooth(method="lm") + facet_wrap(~marital) + theme_minimal()

# Looks like a difference based on sex
ggplot(heights, aes(x=income,fill=sex)) + geom_density(alpha=.5) + facet_wrap(~marital) + theme_minimal() 

# Let's run an ANOVA to explore sex and marital status interactions (are these categories significantly different in income?)
heights_aov1 <- aov(data=heights, income ~ sex * marital) #ANOVA with interaction term
summary(heights_aov1) # All significant
tuktest <- TukeyHSD(heights_aov1) # Tukey Test let's us see groupwise pairings
plot(tuktest) # hard to read...plus any with error bars crossing zero are likely not significant (no difference between those category pairs)
tuktest <- as.data.frame(tuktest$`sex:marital`) # just looking at the interaction term, make a data frame
tuktest$pairing <- row.names(tuktest) # add column from row names


ggplot(tuktest %>% filter(`p adj` < 0.005),
       aes(x=diff,y=pairing,xmin=lwr,xmax=upr)) +
  geom_errorbarh() + geom_point() +
  geom_vline(xintercept=0,linetype=2) # neat! married females are expected to earn significantly less than married males (size of difference is ~$25,000)


# back to our full model!

# Can it be simplified?
summary(height_fullmodel)
stepAIC(height_fullmodel) # warning: this searches through a LOT of potential models. It can take a loooong time to run on some machines

# short answer (if you don't want to run the stepAIC) is that we can probably get rid of interaction terms and still get good fits
height_model <- glm(data=heights, income ~ height + marital + sex + education)
summary(height_model)

# compare reality with predictions of model
preds <- add_predictions(data = heights,model = height_model)

# plot it:
ggplot(preds,aes(x=height)) + 
  geom_point(aes(y=income),color="Black",alpha=.2) +
  geom_point(aes(y=pred,color=sex),alpha=.2) + facet_wrap(~marital)


# Compare to the "full model"
height_fullmodel <- glm(data=heights, income ~ height * weight * age * marital * sex * education)

preds <- gather_predictions(heights, height_fullmodel,height_model)

# plot it:
ggplot(preds,aes(x=height)) + 
  geom_point(aes(y=income),color="Black") + geom_point(aes(y=pred,color=sex),alpha=.2) +
  facet_wrap(~model)

# maybe the full model does a slightly better job of predicting values
rmse(height_model,data = heights)
rmse(height_fullmodel,data = heights) # not better enough to justify such a complex model!

# using education as the x-axis
ggplot(preds,aes(x=education)) + 
  geom_point(aes(y=income),color="Black") + geom_point(aes(y=pred,color=sex),alpha=.2) +
  facet_wrap(~model)


# So, what do you think about taller people earning more?

justheight <- glm(data=heights, income ~ height)
summary(justheight) # according to this model, each extra cm of height = $1741.70 of extra income

summary(height_model) # according to this model, height is barely significant and +1 cm = $363.30 of extra income

# What's the difference?  
# The second model accounts for more factors. e.g., a tall person with low education probably won't make more than a short person with a degree




############# Second data set ####################

# clear out all those previous objects
rm(list = ls())

# Do police treat people differently for small amounts of cannabis posession based on demographics? ####
data("Arrests")
?Arrests
glimpse(Arrests)



# Dependent variable of interest is 'released' which is whether someone was arrested

# let's convert it to T/F to be explicit
Arrests$released <- as.character(Arrests$released)
Arrests$released[Arrests$released=="Yes"] <- TRUE
Arrests$released[Arrests$released=="No"] <- FALSE
Arrests$released <- as.logical(Arrests$released)


# Full glm model (logistic regression, since binary DV)
arrest_fullmod <- glm(data=Arrests, released ~ colour + age + sex + employed + citizen + checks,family = "binomial")
summary(arrest_fullmod) # age and sex don't seem that important. Let's plot it

ggpairs(Arrests)

ggplot(Arrests,aes(x=colour,fill=released)) + geom_bar(position = "dodge") + theme_minimal() # this doesn't look great for police racial bias

# What about percentages
ggplot(Arrests, aes(x=colour,fill=colour)) + geom_bar()

arrestcounts <- Arrests %>% group_by(released,colour) %>%
  summarize(N=n()) 

arrestcounts %>% mutate(proportion = N/sum(arrestcounts$N))

# are those counts significantly different?
?chisq.test()

tab <- with(Arrests, table(colour,released))
Xsq <- chisq.test(tab)
Xsq # There IS a significant difference
Xsq$expected


# Let's go back to our logistic model and use it to make predictions
arrest_mod <- glm(data=Arrests, released ~ colour+checks+age+sex,family = "binomial")

preds <- add_predictions(data = Arrests, model = arrest_mod,type = "response") 

ggplot(preds, aes(x=checks,y=pred,color=colour)) + geom_point() + facet_wrap(~sex) +
  labs(subtitle = "Predicted probability of release as a function of Sex, Race, and Police Record",
       y="Probability of Release (Predicted)",x="Number of Previous Police Checks in Record",
       color="Race") + theme_bw() + lims(y=c(0,1))

# That race gap in police treatment is statistically significant. Here, we see our model preditions (probability) based on previous stop records.




##############  One more data set ######################
rm(list = ls())

data("birthwt")

?birthwt
glimpse(birthwt)

# Does mother's age, race, weight, or smoking status affect child birth weight?

ggplot(birthwt, aes(x=lwt,y=bwt,color=factor(smoke))) + geom_point() + geom_smooth(method = "lm",se=FALSE) + facet_wrap(~factor(race))

# work your magic!
