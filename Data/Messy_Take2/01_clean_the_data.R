library(stringr)
library(tidyr)
library(dplyr)
library(ggplot2)
# git pull .... new directory Data/Messy_Take2/


# 1 data set spread over 7 files (a:g)
# Import them and Tidy it ####

# import with for-loop
fs <- list.files("Data/Messy_Take2",full.names = TRUE)

for(i in fs){
  assign(x = str_replace(basename(i),pattern = "_df.csv",replacement = ""),read.csv(i),envir = .GlobalEnv)   
}

# bind them together
full <- rbind(a,b,c,d,e,f,g)


# make a new names vector 

names(full)

newnames <- c("DOB_Male","DaysAlive_Male","IQ_Male","Pass_Male",
  "DOB_Female","DaysAlive_Female","IQ_Female","Pass_Female")   

names(full) <- newnames

# Tidy it   ... what's the problem?


# male vs female subsets
male <- full %>%
  select(ends_with("_Male"))

female <- full %>%
  select(ends_with("_Female"))


female <- female %>% mutate(Gender = "Female")
male <- male %>% mutate(Gender = "Male")

female$Gender <-"Female"


# rename columns
names(male) <- str_replace(names(male),"_Male","")
names(female) <- str_replace(names(female),"_Female","")

# bind
clean <- rbind(male,female)


# save clean data set to a file...
write.csv(clean,"./Data/Messy_Take2/cleaned_data.csv",row.names = FALSE,quote = FALSE)

# save R objects!
saveRDS(object = clean,file = "./Data/Messy_Take2/cleaned_data.RDS")


reread <- readRDS("./Data/Messy_Take2/cleaned_data.RDS")

# Intro to modeling












