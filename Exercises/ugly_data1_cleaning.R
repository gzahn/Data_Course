library(tidyverse)

df = read.csv("Exercises/ugly_data1.csv")
names(df)

long = gather(df,Group,Value,2:9)

malerows = grep("^m",long$Group)
femalerows = grep("^f",long$Group)

long$Gender[malerows] <- "Male"
long$Gender[femalerows] <- "Female"

long$Group = str_remove(long$Group,"^m")
long$Group = str_remove(long$Group, "^f")


ages = str_replace(long$Group,"014","0014")


ages1 = substr(ages,start = 1,stop = 2)
ages2 = substr(ages,start = 3,stop = 4)
cbind(ages1,ages2)

ages = paste0(ages1,"-",ages2)
long$Group = ages
names(long)[names(long) == "Group"] <- "AgeRange"


write.csv(long, "Exercises/ugly_data1_cleaned.csv",quote = FALSE, row.names = FALSE)


