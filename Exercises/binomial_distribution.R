library(tidyverse)


a = rnorm(100, mean = 10, sd = 1)
b = rnorm(100, mean = 10.5, sd = 4)
c = rnorm(100, mean = 14, sd = 1)
df = data.frame(a=a,b=b,c=c)
df = gather(df, Var, Value, 1:3)


ggplot(df, aes(x=Value, fill = Var)) +
  geom_density(alpha = .5) 


t.test(a,b)
mod1 = (aov(Value ~ Var, data = df))
summary(mod1)
tuk1 = TukeyHSD(mod1)
plot(tuk1)


binom.test()
