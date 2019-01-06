#Repeat the Excel analysis in R

#Load package(s)
library(readr)
library(tidyverse)

#look at working directory
getwd()
setwd("~/Desktop/GIT_REPOSITORIES/Data_Course/Code_Examples/")
# Import dataset
wingspan_vs_mass <- read_csv("../Data/wingspan_vs_mass.csv", col_types = cols(X1 = col_skip()))

# Sort by mass (decreasing)
wingspan_vs_mass = wingspan_vs_mass[order(wingspan_vs_mass$mass, decreasing = TRUE),]

fit = lm(wingspan_vs_mass$wingspan ~ wingspan_vs_mass$mass)
# Get slope (coefficient of mass)


# Summarize wingspan and mass values to get min, mean, max
sink("./Example_day1/summary_and_slope.txt")
print("Wingspan")
summary(wingspan_vs_mass$wingspan)[c(1,3,6)]
print("Mass")
summary(wingspan_vs_mass$mass)[c(1,3,6)]
print("Slope")
fit$coefficients[2]
sink(NULL)


mod1 = summary(lm(wingspan~mass, data = wingspan_vs_mass))

# Plot wingspan vs mass and save to file
ggplot(wingspan_vs_mass, aes(x=mass,y=wingspan)) +
  geom_point(alpha=.5,aes(color=variety)) +
  stat_smooth() +
  annotate("text",x=40,y=35, label = paste0("R-sq= ",signif(mod1$r.squared,4))) +
  theme_bw()
ggsave("./Example_day1/scatterplot_example.jpg")

# Print a file that contains the measured mass values, ordered from highest to lowest (one value per line)
sink("./Example_day1/mass_ordered.txt")
cat(wingspan_vs_mass$mass, sep = "\n")
sink(NULL)





