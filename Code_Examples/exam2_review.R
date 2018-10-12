library(tidyr)


?rnorm
x = rnorm(10, mean = 10)
y = rnorm(10, mean = 10.5)
z = rnorm(10)
obs = 1:10

df = data.frame(obs = obs, x=x, y=y, z=z)

df.l = gather(df, key = "Stock", value = "PriceChange", c(x,y,z))







spread(df.l, Stock, PriceChange)

aov1 = aov(PriceChange ~ Stock*obs, data = df.l)
summary(aov1)
x
y
z

TukeyHSD(aov1)







library(dplyr)

df %>% mutate(total = x+y+z, min = apply(df[,2:4],1, min))
min = apply(df[,2:4],1, min)


mutate()
select(df, c(x,y))
df %>% select(c(x,y))
?filter
  
df %>% filter(x>9.5&x<10.5)  

# select picks columns
# filter picks rows

?group_by()

df$group = c(rep("A",6),rep("B",4))

df %>% group_by(group) %>%
  summarise(meanx = mean(x), N = n())

df.l %>% group_by(Stock) %>%
  summarise(mean = mean(PriceChange), 
            sum = sum(PriceChange), 
            min = min(PriceChange), 
            Nonsense = n(),
            StDev = sd(PriceChange))



df2 = read.csv("../iris.csv")

plot(df2)

mod1 = aov(Petal.Length ~ Petal.Width*Species, data = df2)
mod2 = aov(Petal.Length ~ Petal.Width+Species, data = df2)


summary(mod1)
summary(mod2)

anova(mod1,mod2)

library(modelr)
df2 = add_predictions(df2,mod1,var = "mod1")
df2 = add_predictions(df2,mod2,var = "mod2")


library(ggplot2)

ggplot(df2) +
  geom_point(aes(x=Petal.Width,y=Petal.Length,color=Species)) +
  geom_smooth(aes(x=Petal.Width, y=mod1,col=Species),method = "lm") +
  geom_smooth(aes(x=Petal.Width, y=mod2,color=Species),method = "lm",linetype=5) 


sqrt(mean((df2$mod1 - df2$Petal.Length)^2))
sqrt(mean((df2$mod2 - df2$Petal.Length)^2)

     
     
     p1 = ggplot(df2) +
       geom_point(aes(x=Petal.Width,y=Petal.Length,color=Species)) +
       geom_smooth(aes(x=Petal.Width, y=mod1,col=Species),method = "lm") +
       geom_smooth(aes(x=Petal.Width, y=mod2,color=Species),method = "lm",linetype=5)

     
p1 + ylim(c(0,5))            


library(outliers)
?outlier()

# subset based on values ... get rid of outliers?
df2[(df2$Petal.Length < mean(df2$Petal.Length)),]


# violin plot
ggplot(df2, aes(x=Species,y=Petal.Length,fill=Species)) +
  geom_violin()




# ellipses
p1 +
  stat_ellipse(aes(x=Petal.Width,y=Petal.Length,color=Species))
