# packages
library(tidyverse)
library(janitor)
library(modelr)
library(patchwork)

# plot theme
theme_set(theme_minimal() +
            theme(axis.text.x = element_text(angle=90,hjust=1)))

# load data
df <- read_csv("./Data/Utah_Religions_by_County.csv")


# tidy data
df %>% glimpse()
names(df) <- make_clean_names(names(df))
df %>% glimpse()

df <- df %>% 
  pivot_longer(-c(county,pop_2010,religious),names_to = "religion",values_to = "proportion") %>% 
  arrange(desc(proportion)) %>% 
  mutate(religion = factor(religion,levels = unique(religion)))


# visualize
df %>% 
  ggplot(aes(x=religion,y=proportion)) +
  geom_boxplot(alpha = .25) +
  geom_jitter(width = .1,alpha=.25)


# just looking at LDS vs religiosity
lds <- df %>% 
  filter(religion == "lds")

# linear model - proportion of LDS folks as a function of religiosity
mod <- lm(data=lds,formula = proportion ~ religious)

# more plots
p1 <- lds %>% 
  ggplot(aes(x=religious,y=proportion)) +
  geom_point() +
  geom_smooth(method="lm") +
  facet_wrap(~religion,scales = "free") + 
  geom_hline(yintercept = mean(lds$proportion),linetype=2) +
  geom_segment(aes(xend=religious,yend=mean(lds$proportion)),linetype=3) +
  labs(title = "Distances from reality to the mean...")


p2 <- lds %>% 
  add_predictions(mod) %>% 
  ggplot(aes(x=religious,y=proportion)) +
  geom_point() +
  geom_smooth(method="lm") +
  facet_wrap(~religion,scales = "free") + 
  geom_hline(yintercept = mean(lds$proportion),linetype=2) +
  geom_segment(aes(xend=religious,yend=pred),linetype=3) +
  labs(title = "Distances from reality to the linear model...")

p1 + p2

lds %>% 
  ggplot(aes(x=religious,y=proportion)) +
  geom_point() +
  geom_smooth(method="lm") +
  facet_wrap(~religion,scales = "free") + 
  geom_hline(yintercept = mean(lds$proportion),linetype=2) +
  annotate("text",x=.6,y=mean(lds$proportion) + .025,label="Mean LDS Porportion") +
  annotate("text",x=0.6,y=0.4,label = paste0("R-sq = ",round(summary(mod)$r.squared,3))) +
  labs(caption = paste0("An R-sq of ",round(summary(mod)$r.squared,3)," means that religiosity does a 76% better job\nof explaining the proportion of LDS people than the mean alone does.")) +
  labs(title = "R-sq value measures how much better a model does at\npredicting reality than the mean by itself")

