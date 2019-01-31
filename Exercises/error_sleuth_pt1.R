# Find out what's wrong

# Below, you will see several tasks denoted by comments describing them
# Each task has been completed in several different ways, but only one of them works
# Find the one that works for each task and then repair the others so they work as well



# 1. Import a data set
dat -> read.csv("./Data/Utah_Religions_by_County.csv")
dat = as.data.frame(read_xlsx("./Data/Utah_Religions_by_County.xlsx"))
dat = read.delim("./Data/Utah_Religions_by_County.xlsx")
dat <- read.csv2("./Data/Utah_Religions_by_County.csv")

# 2. Find and plot population values by county
plot(x=dat$Pop_2010, y=dat[,1])
plot(dat$Pop_2010 ~ factor(dat$County))
plot(dat[,1],dat[,2])

# 3. Find proportion of population who are religious in each county and take its mean across all counties
rel = mean(cbind(dat[1,],dat$Religious)[,2])
rel = mean(data.frame(County=dat[,1],Perc.Rel = rowSums(dat[,-c(1:4)]))[,2])
rel = mean(unlist(strsplit(paste0(dat[,1],dat$Religious),"County"))[seq(from=2,to=(length(dat[,1])*2),by=2)])

print(rel)

# 4. Regress (linear model) religiousity against population and print model summary
lm(dat$Religious ~ dat$Pop_2010)
summary(lm(Religious ~ Pop_2010, data = dat))
mod1 <- lm(dat$Religious - dat$Pop_2010) ; summary(mod1)
