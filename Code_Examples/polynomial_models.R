library(modelr)
library(ggplot2)

data("mtcars")

df = mtcars
names(df)


ggplot(df, aes(x=disp,y=mpg)) +
  geom_point() + geom_smooth(method = "lm")

mod1 <- lm(data=df,mpg~disp)
summary(mod1)


ggplot(df, aes(x=disp,y=mpg)) +
  geom_point() + geom_smooth(method = "lm",formula = y ~ poly(x,2))
?poly
# "over-fitting is when your model is picking up the noise instead of the signal"

mod2 = lm(data=df,mpg~poly(disp,2))
mod3 = lm(data=df,mpg~poly(disp,3))

summary(mod1)
summary(mod2)
summary(mod3)

# mean squared error function
mse <- function(mod){mean(residuals(mod)^2)}

# use it to calculate how well the data fit each of our models
mse(mod1)
mse(mod2)
mse(mod3)


# use the "best" model to generate predictions
df2 <- add_predictions(data = df,model = mod3)

ggplot(df2,aes(x=disp,y=mpg)) +
  geom_point() +
  geom_point(aes(y=pred),color="Red")


# predict mpg based on new arbitrary disp values
new_disp <- data.frame(disp = c(10,20,30,40,50))

predict(mod3,newdata = new_disp)
new_disp$mpg <- predict(mod3,newdata = new_disp)
# newdata must have columns with same names as used in your model!

# add these predictions to the main data frame
df3 <- df2 %>% 
  select(mpg,disp) %>%
  rbind(new_disp) %>%
  mutate(Source = c(rep("Observed",32),rep("Predicted",5)))

ggplot(df3,aes(x=disp,y=mpg)) + geom_point()

ggplot(df3,aes(x=disp,y=mpg)) + 
  geom_smooth(method = "lm",se=FALSE,formula = y~poly(x,3)) +
  geom_point(aes(color=Source),size=3) +
  scale_color_manual(values = c("Black","Red")) +
  labs(title = mod3$call)
  
mod3$call
mod3$coefficients
summary(mod3)


summary(mod3)





# how to train a model properly ####

# divide your data into random subsets:
# train your model on one subset, test your model on the other!

library(caret)
trainingsamples <- createDataPartition(mtcars$mpg,p=0.5,list=FALSE)
train <- mtcars[trainingsamples,]
test <- mtcars[-trainingsamples,]

mod5 <- lm(data = train,mpg ~ poly(disp,3))
add_predictions(test,mod5)
