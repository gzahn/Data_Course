library(dplyr)

setwd("~/Desktop/GIT_REPOSITORIES/Data_Course/Exam_1/")
list.files()

###### Import file into "df"

df = read.csv("DNA_Conc_by_Extraction_Date.csv.gz")
names(df)

###### Make histograms for each lab student

hist(df$DNA_Concentration_Katy, xlab = "DNA Concentration", main = "Katy's Extractions")
hist(df$DNA_Concentration_Ben, xlab = "DNA Concentration", main = "Ben's Extractions")

# Convert "Year" from numeric to factor
df$Year_Collected = as.factor(df$Year_Collected)

###### Make boxplot for each lab student and save them as jpeg images

jpeg("Zahn_Plot1.jpeg")
plot(x=df$Year_Collected, y=df$DNA_Concentration_Katy, xlab = "YEAR", ylab = "DNA Concentration",
     main = "Katy's Extractions")
dev.off()

jpeg("Zahn_Plot2.jpeg")
plot(x=df$Year_Collected, y=df$DNA_Concentration_Ben, xlab = "YEAR", ylab = "DNA Concentration",
     main = "Ben's Extractions")
dev.off

###### Compare Ben and Katy
boxplot(df$DNA_Concentration_Ben, df$DNA_Concentration_Katy, main = "Ben and Katy Boxplots")

ben.summary = summary(df$DNA_Concentration_Ben)
katy.summary = summary(df$DNA_Concentration_Katy)

ben.summary - katy.summary # Ben is consistently higher than Katy

###### In which year was Ben's performance lowest, relative to Katy's

# Make new column of difference between Ben and Katy
df$Relative = df$DNA_Concentration_Ben - df$DNA_Concentration_Katy

# Find minimum difference
minimum = min(df$Relative)
min_row = which(df$Relative == minimum)

# Return df, Year_Collected column for row where Relative is its minimum
Worst_Year_For_Ben = df[min_row,"Year_Collected"]

Worst_Year_For_Ben # year 2000


########### Note: you could also look at yearly averages to find this.... ############

yearly_mean_diff = df %>% 
  mutate(Relative = DNA_Concentration_Ben - DNA_Concentration_Katy) %>%
  group_by(Year_Collected) %>%
  summarise(MEAN = mean(Relative)) 

yearly_mean_diff[which(yearly_mean_diff$MEAN == min(yearly_mean_diff$MEAN)),]

######################################################################################

###### Make new summary data frame of Ben's averages by year

Ben_Yearly = df %>%
  group_by(Year_Collected) %>%
  summarise(MEAN = mean(DNA_Concentration_Ben))

# Get maximum mean DNA Conc. for Ben
maximum = max(Ben_Yearly$MEAN)
max_row = which(Ben_Yearly$MEAN == maximum)

# return the row and max value
Ben_Yearly[max_row,]

###### Write summary of Ben's values by year to new csv file
write.csv(Ben_Yearly, file = "Ben_Average_by_Year.csv")
