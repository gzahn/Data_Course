##################################################
#   This script makes publication figs from      #
#   the cleaned data set                         #
#                                                #
#   Author: Geoffrey Zahn - Feb 5, 2019          #
#                                                #
##################################################

# Load packages
library(tidyverse)

# Load cleaned data
dat = read.csv("./data/cleaned_BioLog_plate_data.csv")

# Figure 1 - Water vs Soil, all substrates over time
ggplot(dat, aes(x=Hour,y=Absorbance,color=Substrate)) +
  geom_jitter(alpha = .5) +
  geom_smooth(se=FALSE) +
  facet_grid(~SampleType) +
  theme_bw()
ggsave("./figs/Fig1_water_vs_soil_absorbance.png", dpi = 300, width = 12, height = 8)

# Figure 2 - Facet for each substrate, colored by sampleType
ggplot(dat, aes(x=Hour,y=Absorbance, color=SampleType)) +
  geom_smooth(se=FALSE) +
  facet_wrap(~Substrate) +
  theme_bw()
ggsave("./figs/Fig2_Absorbance_Over_Time_Each_Substrate.png", dpi = 300, width = 12, height = 8)
