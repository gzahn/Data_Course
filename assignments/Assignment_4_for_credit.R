
df = read.csv("~/Desktop/mush_growth.csv")
base = abs(rbinom(n = 216,size = 20,prob = .3))
mult = round(base*abs(rnorm(216)), digits = 2)

clust = kmeans(df$Light, centers = 3)
add = clust$cluster * mult
light = add + c(2,12,28)
nitrogen = light + c(rep(2,3),rep(6,3),rep(10,3),rep(30,3),rep(40,3),rep(11,3),rep(12,3),rep(5,3),rep(1,3),
                     rep(2,3),rep(6,3),rep(10,3),rep(20,3),rep(22,3),rep(11,3),rep(12,3),rep(5,3),rep(1,3))
humidity = nitrogen * c(rep(1,27),rep(1.5,27))
temp = humidity * c(rep(2.2,54), rep(1.8,54))
spp = temp + (c(rep(1,108),abs(rnorm(108))))

df$GrowthRate = spp

boxplot(df$GrowthRate ~ df$Temperature*df$Nitrogen)

aov
?anova


ggplot(df, aes(x=Nitrogen,y=GrowthRate,col=Species)) +
  geom_point() + geom_smooth() + 
  facet_grid(facets = ~ Humidity)

write.csv(df, file = "../data/mushroom_growth.csv", row.names = FALSE)
df3 = read.csv("../data/mushroom_growth.csv")
