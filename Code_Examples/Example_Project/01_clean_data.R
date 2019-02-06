##################################################
#   This script loads and cleans the raw data    #
#   and saves the clean data set.                #
#                                                #
#   Author: Geoffrey Zahn - Feb 5, 2019          #
#                                                #
##################################################

# Load packages ####
library(tidyverse)

# Load data ####
dat = read.csv("./data/raw/BioLog_Plate_Data.csv")

# Inspect data set ####
glimpse(dat)
levels(dat$Sample.ID)
names(dat)

# Data is in "wide" format - convert to long ####
dat_long = gather(dat, key = Hour, value = Absorbance, c("Hr_24","Hr_48","Hr_144"))

# Inspect "long" data
glimpse(dat_long)
unique(dat_long$Hour)

# Convert "Hr_24" to 24, etc ####
hours = plyr::mapvalues(dat_long$Hour, from = unique(dat_long$Hour), to = c(24,48,144))
hours = as.numeric(hours)
dat_long$Hour = hours

# Add soil/water variable
table(dat_long$Sample.ID) # 864 reps of each sample ID
type = rep(c("Water","Soil","Soil","Water"), each = table(dat_long$Sample.ID)[1])
dat_long$SampleType = type

# Save cleaned data ####
write.csv(dat_long, "./data/cleaned_BioLog_plate_data.csv", quote = FALSE, row.names = FALSE)
