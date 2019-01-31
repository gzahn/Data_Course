# Find out what's wrong

# Below, you will see several tasks denoted by comments describing them
# Each task has been completed in several different ways, but only one of them works
# Find the one that works for each task and then repair the others so they work as well

library(readxl)


# 1. Import a data set
dat <- read.csv("./Data/Utah_Religions_by_County.csv")
dat = as.data.frame(read_xlsx("./Data/Utah_Religions_by_County.xlsx"))
dat = read.delim("./Data/Utah_Religions_by_County.xlsx")
dat <- read.csv("./Data/Utah_Religions_by_County.csv")

?read.csv

# 2. Find and plot population values by county
plot(y=dat$Pop_2010, x=dat[,1])
plot(dat$Pop_2010 ~ factor(dat$County))
plot(dat[,1],dat[,2])

# 3. Find proportion of population who are religious in each county and take its mean across all counties
rel = mean(cbind(dat[1,],dat$Religious)[,2])
rel = mean(data.frame(County=dat[,1],Perc.Rel = rowSums(dat[,-c(1:4)]))[,2])
rel = mean(as.numeric(unlist(strsplit(paste0(dat[,1],dat$Religious),"County"))[seq(from=2,to=(length(dat[,1])*2),by=2)]))

mean(dat$Religious)


library(dplyr)
dat2 = dat %>%
  filter(Pop_2010 > 100000) %>%
  group_by(County) %>%
  summarise(N=n(),Mean=mean(Buddhism.Mahayana))


levels(dat$County)

hist(dat$Pop_2010,breaks=10)

hist(dat$Non.Religious)
hist(dat$Religious)
hist(dat$Buddhism.Mahayana)
hist(dat$Greek.Orthodox)
hist(dat$LDS)

jpeg(filename = "asflhasfkj.jpeg")
hist(dat$Pop_2010)
 dev.off()


mod1 = lm(Orthodox ~ Buddhism.Mahayana, data = dat)
summary(mod1)

plot(dat$Orthodox ~ dat$Buddhism.Mahayana)
abline(mod1)


dat[,c("Religious","Non.Religious")]
?list.files()



# 4. Regress (linear model) religiousity against population and print model summary
summary(lm(dat$Religious ~ dat$Pop_2010))
summary(lm(Religious ~ Pop_2010, data = ghk))

mod1 <- lm(dat$Religious ~ dat$Pop_2010) 
summary(mod1)





