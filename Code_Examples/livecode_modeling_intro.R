library(tidyverse)
library(modelr)
library(MASS)

data(mtcars)

df = mtcars

glimpse(df)
df$am = factor(df$am)
df$vs = factor(df$vs)
# df$cyl = factor(df$cyl)
# df$carb = factor(df$carb)
# df$gear = factor(df$gear)

ggplot(df, aes(x=cyl,y=mpg)) +
  geom_point() +
  geom_smooth(method="lm")

mod1 = lm(mpg ~ cyl, data=df)
summary(mod1)

df2 = add_predictions(df,mod1)

ggplot(df2, (aes(x=cyl))) +
  geom_jitter(aes(y=pred),color="Red") +
  geom_point(aes(y=mpg)) +
  labs(x="askjhgafliu",y="12345678")

df2 = mutate(df2, DIFF = abs(pred-mpg))
mean(df2$DIFF)

ggplot(df, aes(x=cyl,y=mpg,color=(am))) +
  geom_point() + geom_smooth(method="lm")

mod2 = lm(mpg ~ cyl*am, data = df)
summary(mod2)

df2 = add_predictions(df2, mod2, var = "pred2")
df2 = mutate(df2, DIFF2 = abs(pred2 - mpg))

ggplot(df2, aes(x=cyl)) +
  geom_point(aes(y=mpg), alpha =.5) +
  geom_jitter(aes(y=pred), color="Red") +
  geom_jitter(aes(y=pred2),color="Blue")

mean(df2$DIFF)
mean(df2$DIFF2)


mod.full = glm(mpg ~ cyl*disp*hp*wt*qsec*vs*am*gear*carb, data = df)
summary(mod.full)
mean(abs(residuals(mod.full)))

df.mod = sample_n(df,nrow(df)/2)
df.cross = anti_join(df,df.mod)

mod.full.cross = glm(mpg ~ cyl+disp+hp+drat*vs+am+carb, data = df)
df3 = add_predictions(df.cross, mod.full.cross)

mean(abs(df3$pred - df3$mpg))

aic.output = stepAIC(mod.full.cross)


ggplot(df, aes(x=disp, y=mpg,color=factor(carb))) +
  geom_point() + geom_smooth(method = "lm", se=FALSE) +
  facet_wrap(~am)

mod.test = glm(mpg ~ carb+disp+am, data = df)
summary(mod.test)

