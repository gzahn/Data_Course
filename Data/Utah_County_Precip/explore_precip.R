# SETUP ####

library(tidyverse)
library(measurements)
library(prophet)
options(scipen = 999)
theme_set(theme_minimal())


# READ DATA ####

# read in older data
old <- read_csv("./Data/Utah_County_Precip/provo_hourly_precip_1980-2014.csv") %>% 
  select(DATE,HourlyPrecipitation=HPCP)

# clean up old "999.99" values to NA
old$HourlyPrecipitation[old$HourlyPrecipitation == 999.99] <- NA


# read in newer data
new <- read_csv("./Data/Utah_County_Precip/provo_hourly_precip_2014-2021.csv") %>% 
  select("DATE","HourlyPrecipitation")

is.na(old$HourlyPrecipitation) %>% sum
is.na(new$HourlyPrecipitation) %>% sum



  
# MERGE OLD AND RECENT DATA ####

# sanity check that units are in inches
old$HourlyPrecipitation %>% plot # that's weird!!
new$HourlyPrecipitation %>% plot

new %>% 
  mutate(DAY=format(DATE, "%d"),
         MONTH=format(DATE, "%m"),
         YEAR=format(DATE, "%Y")) %>% 
  group_by(YEAR) %>% 
  summarize(TotalPrecip = sum(HourlyPrecipitation,na.rm = TRUE))

new$HourlyPrecipitation <- new$HourlyPrecipitation %>% as.numeric()
old$HourlyPrecipitation %>% summary
new$DATE %>% summary
old$DATE %>% summary

# merge the data sets
full <- full_join(old,new)

# DAILY PRECIP ####

# convert to daily totals

daily <- full %>% 
  mutate(DAY=format(DATE, "%d"),
         MONTH=format(DATE, "%m"),
         YEAR=format(DATE, "%Y")) %>% 
  group_by(YEAR,MONTH,DAY) %>% 
  summarize(DAY=unique(DAY),MONTH=unique(MONTH),YEAR=unique(YEAR),
            DAILY_PRECIP=sum(HourlyPrecipitation,na.rm = TRUE)) %>% 
  mutate(DATE=as.POSIXct(paste(YEAR,MONTH,DAY,sep="-")))

daily$DAILY_PRECIP %>% plot
# do we need to round?
daily$DAILY_PRECIP %>% round(1) %>% plot

daily <- daily %>% 
  mutate(DAILY_PRECIP_ROUNDED=DAILY_PRECIP %>% round(1))


daily %>% 
  ggplot(aes(x=DATE,y=DAILY_PRECIP_ROUNDED)) +
  geom_point() +
  labs(y="Daily total precipitation (inches)")


# monthly totals over time
monthly <- full %>% 
  mutate(DAY=format(DATE, "%d"),
         MONTH=format(DATE, "%m"),
         YEAR=format(DATE, "%Y")) %>% 
  group_by(YEAR,MONTH) %>% 
  summarize(total=sum(HourlyPrecipitation,na.rm = TRUE)) %>% 
  mutate(DATE = paste(YEAR,MONTH,"01",sep="-") %>% as.POSIXct(format='%Y-%m-%d'))

monthly %>% 
  ggplot(aes(x=DATE,y=total)) +
  geom_point() +
  geom_smooth(aes(color=MONTH),se=FALSE) +
  scale_color_viridis_d()


# FORECASTING w/ MACHINE LEARNING (RECENT DATA ONLY) ####  

# prophet forecasting for next year (to compare to reality later)
dat <- data.frame(ds=daily$DATE,
                  y=daily$DAILY_PRECIP_ROUNDED)


m <- prophet(dat)
future <- prophet::make_future_dataframe(m,365)
pred <- predict(m,future)
prophet_plot_components(m,pred)
future %>% head
p <- plot(m,pred,xlabel = "Date",ylabel = "Inches of precip (daily total)")
p

# modify ggplot object that was created by a black box function!
q <- ggplot_build(p) # disassemble
q$data[[2]]$alpha <- 0.1 # modify point alpha values
p2 <- ggplot_gtable(q) # rebuild

plot(p2)


