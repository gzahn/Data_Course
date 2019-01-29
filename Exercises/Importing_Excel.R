library(readxl)
df1 = read_xlsx("./Data/Student_Survey_Fall_2017.xlsx", sheet = 1)
df2 = read_xlsx("./Data/Student_Survey_Fall_2017.xlsx", sheet = 2)
df3 = read_xlsx("./Data/Student_Survey_Fall_2017.xlsx", sheet = 3)

df1$Sheet <- "COS"
df2$Sheet <- "BUS"
df3$Sheet <- "ENG"

df = rbind(df1,df2,df3)

rm(df1,df2,df3)

# What have I done here?


# Subset this full data frame to include only rows where the answer to the question:
# `Do you anticipate using the lab next semester?` is "No"


# What is different between these "No" students and the "Yes" students?