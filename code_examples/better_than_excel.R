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

# Get linear model fit
fit = lm(wingspan_vs_mass$wingspan ~ wingspan_vs_mass$mass)
# Get slope (coefficient of mass)
fit$coefficients[2]

# Print a file that contains the measured mass values, ordered from highest to lowest (one value per line)
sink("./output/mass_ordered.txt")
cat(wingspan_vs_mass$mass, sep = "\n")
sink(NULL)

# Print a file that has the slope of our linear model fit (cofficient of mass for linear model) 
# along with summary stats for each variable
sink("./output/summary_and_slope.txt")
print("Wingspan",quote = FALSE)
summary(wingspan_vs_mass$wingspan)[c(1,3,6)]
print("Mass",quote = FALSE)
summary(wingspan_vs_mass$mass)[c(1,3,6)]
print("Slope of linear model fit",quote = FALSE)
fit$coefficients[2]
sink(NULL)

