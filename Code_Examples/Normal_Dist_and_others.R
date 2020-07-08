library(ggplot2)
library(tidyr)

# Make vectors
x = rnorm(10,0,1)
y = rnorm(100,0,1)
z = rnorm(1000,0,1)
n = rnorm(10000,0,1)
u = rnorm(100000,0,1)
v = rnorm(1000000,0,1)


# Combine into data frame
df = data.frame(ten=x,hundred=y,thousand=z,tenthousand=n,hund.thousand=u,million=v)

# Need to convert to "long" tidy format
df_long = gather(df, key = Variable, value = Value)
  # This "long" tidy format makes plotting much more intuitive

# Plotting in panels using df_long
ggplot(df_long, aes(x=Value)) +
  geom_histogram(bins = 500) +
  facet_wrap(~Variable)

ggplot(df_long, aes(x=Value, fill=Variable)) +
  geom_density(alpha=0.5) 


#### how to use the normal distribution ####

# Assume that the test scores of a college entrance exam fits a normal distribution. 
# Furthermore, the mean test score is 72, and the standard deviation is 6.2
# What is the percentage of students scoring 84 or more in the exam? 

# for 10000 exam scores
set.seed(3001)
scores = rnorm(10000, 72, 6.2)
hist(scores, breaks=100)

# theoretical percentage of students getting >= 84 on exam
# AKA Cumulative Distribution Function
pnorm(84, mean=72, sd=6.2, lower.tail=FALSE)
pnorm(84, mean=72, sd=6.2) # cumulative probability of getting 84 or less

# Cumulative Probability in plot form
# Create a sequence of numbers between 0 and 100 incrementing by 1.
x <- seq(0,100,by = 1)
y <- pnorm(x, mean=72, sd=6.2)
plot(x,y)



# theoretical density at exactly 84
dnorm(84,mean=72,sd=6.2)
# This function gives height of the probability distribution at each point 
# for a given mean and standard deviation.
# i.e., what percent got 84 exactly?


#### Other distributions ####

?Distributions


#### What distribution do my data follow? ####


library(fitdistrplus)

plotdist(z, histo = TRUE, demp = TRUE)

plot(fitdist(z, "norm"))
plot(fitdist(z, "unif"))

?fitdist


b = rbinom(10000,10,.5)
plotdist(b, histo = TRUE, demp = TRUE)
plot(fitdist(b, "norm"))
plot(fitdist(b, "binom", fix.arg = list(size=10),start = list(prob=0.5)))


# Read More!
http://www.di.fc.ul.pt/~jpn/r/distributions/fitting.html


