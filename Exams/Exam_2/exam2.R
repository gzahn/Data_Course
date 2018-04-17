rm(list = ls())

# Load the libraries that you use here:





############# Part 1 - Preparing wide data ################## ---------------- (30 points possible)

# read in salaries.csv
# This is faculty salary information from 1995 - Split up by university, state, faculty rank, and university tier




# convert to usable format so we can look at salaries as a dependent variable (10 points)




# create boxplot of salary by University Tier, colored by Faculty Rank (10 points)
# x-axis = Tier
# y-axis = Salary
# Boxplot fill color = Rank
# Title = "Faculty Salaries - 1995"




# export this boxplot to a file in your personal repository named "LASTNAME_exam2_plot1.jpeg" (10 points)





################# PART 2 ################### ------------ (70 points possible)

# read in atmosphere.csv
# this data frame has microbial diversity values over time found in atmospheric observation station air filters
# sampling date and two environmental variables [CO2] and [Aerosols] are reported for each measurement
# "Diversity" is the dependent variable



# First, check whether your response variable is normally distributed (5 points)



# Next, convert "Year" to a factor...just because (5 points)



# Create a simple ANOVA model with "Year" as the only explanatory variable (5 points)



# Now, create an ANOVA model that incorporates "Year", "Aerosol_Density", and their interaction (5 points)



# Compare the two models mean-squared difference method to see which is better at making predictions 
# (20 points)




# Export the summary ANOVA table of the better model to a text file in your repository named:
# "LASTNAME_exam2_table1.txt" (10 points)


# use this model to predict what diversity should be for the following hypothetical conditions:
# note: only include the conditions that are part of your chosen model! (10 points)

# Year = 2007
# Quarter = "Q4"
# Month = August
# Mday = 10
# BarcodeSequence = "CTCTCTATCAGTGAGT"
# Aerosol_Density = 1000,
# CO2_Concentration = 384



# Now, make a pretty plot to the following specifications:
# x-axis = Day
# y-axis = Aerosol_Density
# point transparency based on values of "Diversity"
# Title: "Decadal Aerosol Density"
# Subtitle: "More aerosols contribute to greater microbial diversity in the atmosphere"



# Save this plot in your repository as "LASTNAME_exam2_plot2.jpeg" (10 points)


#### When you are all finished, push the files, including this R script, onto your GitHub repo
#### I will look at your script and look for the three properly named files that you generated


