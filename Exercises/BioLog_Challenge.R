library(tidyverse)
df = read.csv("./Data/BioLog_Plate_Data.csv")

glimpse(df)
?plyr::mapvalues()

# write a command the subsets the BioLog data to Clear_Creek samples, with dilution of 0.01, and only "Glycogen"


# Now plot those three replicates over time


# Make a plot of Tween 80 utilization over time for ALL the samples, colored by Sample.ID


# Now, same plot, but combine both soils and both waters into soil and water groups and color by soil vs water


# Make a table of summary statistics: for each combination of Sample.ID and Substrate, give:
# -- Number of observations
# -- Mean absorbance value

# Example output ....

# Sample.ID     Substrate                       N Mean
# <fct>         <fct>                       <int> <dbl>
# 1 Clear_Creek 2-Hydroxy Benzoic Acid         27 0.0562
# 2 Clear_Creek 4-Hydroxy Benzoic Acid         27 0.247 
# 3 Clear_Creek D-Cellobiose                   27 0.403 
# 4 Clear_Creek D-Galactonic Acid γ-Lactone    27 0.314 
# 5 Clear_Creek D-Galacturonic Acid            27 0.385 
# 6 Clear_Creek D-Glucosaminic Acid            27 0.154 
# 7 Clear_Creek D.L -α-Glycerol Phosphate      27 0.0335
# 8 Clear_Creek D-Mallic Acid                  27 0.170 
# 9 Clear_Creek D-Mannitol                     27 0.346 
# 10 Clear_Creek D-Xylose                       27 0.0323
# 

