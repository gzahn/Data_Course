library(tidyverse)
library(MASS)
library(modelr)

df = read.csv("Data/1620_scores.csv")


df %>% mutate(MeanExam = sum(Exam.1..4245260.,Exam.2..4245261.)/2)

df$SumExams = df$Exam.1..4245260. + df$Exam.2..4245261.
names(df)

mod1 = lm(SumExams ~ Actual.PreTest.Score...not.what.your.grade.is...4122452., data = df)
summary(mod1)

ggplot(df, aes(x=Actual.PreTest.Score...not.what.your.grade.is...4122452.,
               y=SumExams)) +
  geom_point() + geom_smooth(method="lm")



mod2 = lm(SumExams ~ Actual.PreTest.Score...not.what.your.grade.is...4122452. +
            YOUR.CHOICE....Midterm..4122464., data = df)
summary(mod2)

ggplot(df, aes(x=Actual.PreTest.Score...not.what.your.grade.is...4122452.,
               y=SumExams, color= YOUR.CHOICE....Midterm..4122464.)) +
  geom_point() + geom_smooth(method="lm")

names(df)
df$MeanQuiz = rowSums(df[,17:23])/7


mod3 = lm(SumExams ~ Actual.PreTest.Score...not.what.your.grade.is...4122452. +
            YOUR.CHOICE....Midterm..4122464. + MeanQuiz, data = df)

summary(mod3)

stepAIC(mod3)

aov()
anova(mod1,mod2)
anova(mod2,mod3)
anova(mod1,mod3)


df = add_predictions(df, mod3, var = "mod3")
df = add_predictions(df, mod2, var = "mod2")
df = add_predictions(df, mod1, var = "mod1")
plot(df$Exam.1..4245260.~df$Exam.2..4245261.)

ggplot(df, mapping = aes(x=row.names(df))) +
  geom_point(aes(y=SumExams),color="Black") +
  geom_point(aes(y=mod1),color="Red") +
  geom_point(aes(y=mod3),color="Blue")


ggplot(df, aes(x=MeanQuiz,y=SumExams)) +
  geom_point() + geom_smooth(color="Black",method = "lm") +
  geom_smooth(aes(y=mod3),color="Red", method="lm") +
  geom_smooth(aes(y=mod1),color="Blue", method="lm")



sum(residuals(mod1)^2)
sum(residuals(mod3)^2)


mod3

newdf = data.frame(Actual.PreTest.Score...not.what.your.grade.is...4122452. = c(0,30,40),
           YOUR.CHOICE....Midterm..4122464. = c(0,50,50),
           MeanQuiz = c(0,3,8))

predict(mod3, newdata = newdf)





#### Cleaning example
library(tidyverse)



# read data
bird = read.csv("Data/Bird_Measurements.csv")

names(bird)
# find columns with mass (except egg mass)
masscols = c(5,7,9)

# find cols to keep in every subset
impt.cols = c(1:4)

#subset to mass only
bird.mass = bird[,c(impt.cols,masscols)]

# turn to long format (mass only)
mass.long = gather(bird.mass,Sex,Mass,5:7)
# clean up sex values
mass.long$Sex = str_remove(mass.long$Sex,"_mass")

unique(mass.long$Sex)








