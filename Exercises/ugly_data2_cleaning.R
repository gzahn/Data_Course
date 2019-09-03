library(tidyverse)
df = read.csv("Exercises/ugly_data2.csv", stringsAsFactors = FALSE)
df1 = df[1:9,]
df2 = df[20:28,]
df1$Gender = "Male"
df2$Gender = "Female"
df = full_join(df1,df2)
df = gather(df,AgeGroup,Count,2:5)
df$AgeGroup = str_remove(df$AgeGroup,"m")
df$AgeGroup = str_replace(df$AgeGroup,"014","0014")
age1 = str_sub(df$AgeGroup,1,2)
age2 = str_sub(df$AgeGroup,3,4)
df$AgeGroup = paste0(age1,"-",age2)
write.csv(df, "Exercises/ugly_data2_cleaned.csv", row.names = FALSE,quote = FALSE)
