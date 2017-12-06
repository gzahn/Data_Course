#Repeat the Excel analysis in R

#Load package(s)
library(readr)

#look at working directory
getwd()

# Import dataset
wingspan_vs_mass <- read_csv("./data/wingspan_vs_mass.csv", col_types = cols(X1 = col_skip()))

# Sort by mass (decreasing)
wingspan_vs_mass = wingspan_vs_mass[order(wingspan_vs_mass$mass, decreasing = TRUE),]

# Summarize wingspan and mass values to get min, mean, max
summary(wingspan_vs_mass$wingspan)[c(1,3,6)]
summary(wingspan_vs_mass$mass)[c(1,3,6)]

# Plot wingspan vs mass
plot(wingspan_vs_mass$wingspan ~ wingspan_vs_mass$mass)

# Print a file that contains the measured mass values, ordered from highest to lowest (one value per line)
sink("./code_examples/mass_ordered.txt")
cat(wingspan_vs_mass$mass, sep = "\n")
sink(NULL)
