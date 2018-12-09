getwd()
library(ggplot2)
library(dplyr)
library(tidyr)
library(vegan)
library(gridExtra)


# load the data set
biolog = read.csv("./data/BioLog_Plate_Data.csv")

# can't be analyzed in this "wide" form
tidy = gather(biolog,Time,Abs,c("Hr_24","Hr_48","Hr_144"))

# convert factors to numeric
numbers = plyr::mapvalues(tidy$Time,from=c("Hr_24","Hr_48","Hr_144"), to=c(24,48,144))
tidy$Time = as.numeric(numbers)

# plot "average" absorbance over time, colored by Site
ggplot(tidy, aes(x=Time,y=Abs, col = Sample.ID)) +
  geom_smooth() +
  theme_bw() + ggtitle("Average absorbance over time")

# break up by dilution

  # make function for ggplot
abs.plot = function(x,y){
  ggplot(x, aes(x=Time,y=Abs, col = Sample.ID)) +
    geom_smooth() + scale_y_continuous(limits=c(0,2)) +
    theme_bw() + ggtitle(paste("Average absorbance over time - dilution = ",y))
}

dilutions = unique(tidy$Dilution)
length(dilutions)
  

  # run plots on subsets
plot.1 = abs.plot(tidy[tidy$Dilution == dilutions[1],],dilutions[1])
plot.2 = abs.plot(tidy[tidy$Dilution == dilutions[2],],dilutions[2])
plot.3 = abs.plot(tidy[tidy$Dilution == dilutions[3],],dilutions[3])

  # combine plots
grid.arrange(plot.1,plot.2,plot.3)

# re-spread data for vegan
wide = spread(tidy,key = Sample.ID,value = Abs)

# subset single dilution and day for each replicate
last.day1 = wide[wide$Time == 144 & wide$Dilution == 0.100 & wide$Rep == 1,]
last.day1 = select(last.day1, -c(Well, Dilution, Time))
last.day2 = wide[wide$Time == 144 & wide$Dilution == 0.100 & wide$Rep == 2,]
last.day2 = select(last.day2, -c(Well, Dilution, Time))
last.day3 = wide[wide$Time == 144 & wide$Dilution == 0.100 & wide$Rep == 3,]
last.day3 = select(last.day3, -c(Well, Dilution, Time))



# Shannon diversity for last day, each replicate
shannon1 = diversity(t(last.day1[,3:6]))
shannon2 = diversity(t(last.day2[,3:6]))
shannon3 = diversity(t(last.day3[,3:6]))

#create data frame of shannon values for each replicate of last day
shannon.div = data.frame(Rep1 = shannon1, Rep2 = shannon2, Rep3 = shannon3)

# Find functional diversity between sites


