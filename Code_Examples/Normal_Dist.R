library(ggplot2)
library(tidyr)

# Make vectors
x = rnorm(10,0,1)
y = rnorm(100,0,1)
z = rnorm(1000,0,1)
n = rnorm(10000,0,1)
p = rnorm(1000000,0,1)

# Combine into data frame
df = data.frame(ten=x,hundred=y,thousand=z,tenthousand=n, million=p)

# Need to convert to "long" tidy format
df_long = gather(df, key = Variable, value = Value)
  # This "long" tidy format makes plotting much more intuitive

# Plotting in panels using df_long
ggplot(df_long, aes(x=Value)) +
  geom_histogram(bins = 100) +
  facet_wrap(~Variable)

ggplot(df_long, aes(x=Value, fill=Variable)) +
  geom_density(alpha=0.5) 


