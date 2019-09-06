library(tidyverse)

# find file
file = list.files(pattern="1620_YC_Points.csv",recursive = TRUE)

# load file
df = read.csv(file)

# find columns that match the pattern
cols = grep(names(df), pattern = "YOUR.CHOICE....")

# convert NA to 0
df[is.na(df)] <- 0

# remove first row which is "example student"
df=df[-1,]

# subset to desired columns
df = df[,cols]

# look at row sums
rowSums(df)

# arrange by decreasing point total
df = arrange(df,desc(rowSums(df)))

# look again ... sanity check
rowSums(df)

# plot it
ggplot(df, aes(x=1:nrow(df),y=rowSums(df))) +
  geom_bar(stat="identity",color="Black") + labs(x="Student",y="Current Your-choice Points") +
  theme_bw() + geom_hline(yintercept = 50,linetype=2) +
  labs(title = "Seriously!? This doesn't bode well for almost all of you!")

# save it as a file to show to wayward students
ggsave("~/Desktop/Current_1620_YC_Points.png")
