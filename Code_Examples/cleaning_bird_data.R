library(carData)
library(tidyverse)
# library(dplyr)
# library(tidyr)


crappy <- read.csv("./Data/Bird_Measurements.csv")
names(crappy)
colnames(crappy)

# Get rid of "N" columns
crappy2 <- crappy %>%
  select(-ends_with("_N"))

# create new subsets for each gender
Male <- crappy2 %>%
  select(c("Family","Species_number","Species_name","English_name",
           "Clutch_size","Egg_mass","Mating_System"),starts_with("M_"))

Female <- crappy2 %>%
  select(c("Family","Species_number","Species_name","English_name",
           "Clutch_size","Egg_mass","Mating_System"),starts_with("F_"))

Unsexed <- crappy2 %>%
  select(c("Family","Species_number","Species_name","English_name",
           "Clutch_size","Egg_mass","Mating_System"),contains("nsexed_")) 

# create new gender column and fill with appropriate values
Male$Gender <- "Male"
Female$Gender <- "Female"
Unsexed$Gender <- "Unsexed"

names(Male)
names(Female)

# rename all column
names(Male) <- str_replace(names(Male),"M_","")
names(Female) <- str_replace(names(Female),"F_","")
names(Unsexed) <- str_replace(names(Unsexed),"unsexed","Unsexed")
names(Unsexed) <- str_replace(names(Unsexed),"Unsexed_","")

#re-join them 
full <- rbind(Male,Female,Unsexed)

# write cleaned data
write.csv(full, "./Data/cleaned_bird_data.csv",quote = FALSE,row.names = FALSE)
