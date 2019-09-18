# Tuesday #

# Git pull all student repos to grade

# Go over assignment 3 (keep it brief)

# practice *exploring* data using ./Data/landdata-states

  # summaries
  # histograms
  # boxplots
  # scatterplots
  # coloring by category
  # subsetting

df = read.csv("~/Desktop/GIT_REPOSITORIES/Data_Course/Data/landdata-states.csv")
str(df)
skimr::skim(df)

plot(x=df$Year,y=df$Home.Value,col=df$region)

# summary
summary(df$Home.Value)

# histogram of home value
hist(df$Home.Value,breaks = 50)

# histogram of state
hist(df$State)

# histogram of land value
hist(df$Land.Value,breaks=50)

# boxplot
plot(x=df$region,df$Home.Value,col="Red")

# boxplot ("quarter" needs to be a factor to get a boxplot)
plot(as.factor(df$Qrtr),df$Home.Value)

# just look at homes in the "West"
west <- df[df$region == "West",]
plot(west$Year,west$Home.Value,col=west$State)

# Which state is that up at the top!

# We might need some more powerful tools. Do ./Code_Examples/ggplot_intro.R before proceeding below...


library(ggplot2)

ggplot(west, aes(x=Year,y=Home.Value,color=State)) +
  geom_point()

ggplot(df,aes(x=Year,y=Home.Value,color=region)) +
  geom_smooth()

# what states have "region" of NA?
df[is.na(df$region),"State"]
