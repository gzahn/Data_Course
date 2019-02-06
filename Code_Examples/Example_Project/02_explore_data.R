##################################################
#   This script explores the cleaned data set    #
#                                                #
#   Author: Geoffrey Zahn - Feb 5, 2019          #
#                                                #
##################################################

# Load packages ####
library(tidyverse)

# Load custom R function(s) ####
source("./R/01_functions.R") 

# Load cleaned data ####
dat = read.csv("./data/cleaned_BioLog_plate_data.csv")

# Explore data ####

# Glimpse data 
glimpse(dat)

# Summary stats of absorbance by sample
Site.Summary = dat %>%
  group_by(Sample.ID) %>%
  summarise(N=n(), Min.Abs = min(Absorbance), Mean.Abs = mean(Absorbance), Max.Abs = max(Absorbance))

Site.Summary

# Quick plot of absorbance values across all substrates
ggplot(dat, aes(x=Absorbance)) +
  geom_histogram() +
  facet_grid(~Sample.ID) +
  ggtitle("Distribution of Absorbance for All Substrates")

# Which carbon substrates had highest absorbance in each sample type?
maxwater = getmax.byType("Water")
maxsoil = getmax.byType("Soil")

dat[maxwater,"Substrate"] # water
dat[maxsoil,"Substrate"] # soil
