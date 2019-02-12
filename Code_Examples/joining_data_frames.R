library(tidyverse)

# here are two data frames
df1 = data.frame(CustomerId = c(1:6), Product = c(rep("Toaster", 3), rep("Radio", 3)))
df2 = data.frame(CustomerId = c(2, 4, 6), State = c(rep("Alabama", 2), rep("Ohio", 1)))

df1
df2

# join them together
full_join(df1,df2, by="CustomerId")
left_join(df1,df2, by="CustomerId")
right_join(df1,df2, by="CustomerId")
inner_join(df1,df2, by="CustomerId")
semi_join(df1,df2, by="CustomerId")
anti_join(df1,df2, by="CustomerId")

