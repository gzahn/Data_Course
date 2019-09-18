data("iris") # load iris data set


# What I was talking about (looking at how "good" a relationship is between 2+ variables)

mod=lm(data=iris,Sepal.Length~Petal.Length) # linear fit model
plot(x=iris$Petal.Length,y=iris$Sepal.Length) # scatterplot
abline(mod) # add regression line based on linear model from earlier

mod$residuals # amount of variation for each point left unexplained by our model
abs(mod$residuals) # absolute values of the above
mean(abs(mod$residuals)) # mean deviation from model prediction (how close our best-fit line is to all points on average)



# What you were talking about (looking at how spread out 1 variable is in itself)

library(DescTools)
MeanAD(iris$Sepal.Length)


# written out the long way might help cement what the MeanAD function is doing
iris$Sepal.Length
mean.sepal <- mean(iris$Sepal.Length)
mean(abs(iris$Sepal.Length - mean.sepal))


# a plotted example...

library(ggplot2) # load ggplot

# red line is mean Sepal Length, dots are actual values, dotted line shows distance of each actual value to mean value
ggplot(iris, aes(x=1:nrow(iris),y=Sepal.Length)) +
  geom_point() + geom_hline(yintercept = mean(iris$Sepal.Length),color="Red") +
  geom_segment(xend=1:nrow(iris),yend=mean(iris$Sepal.Length),linetype = 2,alpha=.5)



# here it is showing distinction between the 3 iris species:
ggplot(iris, aes(x=1:nrow(iris),y=Sepal.Length,color=Species)) +
  geom_point() + geom_hline(yintercept = mean(iris$Sepal.Length),color="Black") +
  geom_segment(xend=1:nrow(iris),yend=mean(iris$Sepal.Length),linetype = 2,alpha=.5) 



# another version with respective group means instead of overall mean
vi=subset(iris,Species=="virginica")
se=subset(iris,Species=="setosa")
ve=subset(iris,Species=="versicolor")


ggplot(iris,aes(x=1:nrow(iris),y=Sepal.Length,color=Species)) +
  geom_point() + 
  geom_segment(x=1,y=mean(se$Sepal.Length),xend=50,yend=mean(se$Sepal.Length)) +
  geom_segment(x=51,y=mean(ve$Sepal.Length),xend=100,yend=mean(ve$Sepal.Length)) +
  geom_segment(x=101,y=mean(vi$Sepal.Length),xend=150,yend=mean(vi$Sepal.Length))


library(dplyr)  
iris %>%
  group_by(Species) %>%
  summarise(MeanSepLen = mean(Sepal.Length),
            MeanAD = MeanAD(Sepal.Length))

