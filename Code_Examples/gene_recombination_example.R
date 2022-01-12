# Simulate genetic recombination

library(caret)
library(tidyverse)

# make 2 decks of "cards" - one full of red cards, the other full of blue
Red <- rep("Red",30000)
Blue <- rep("Blue",30000)


# combine red and blue cards
combined <- c(Red,Blue) 

counts <- list()
full_counts <- data.frame(V1 = 1:20)

for(j in 1:10){

for(i in 1:20){

# shuffle and keep only half
shuffled <- sample(combined)
new_deck <- sample(shuffled,15000)

# count remaining red cards
reds <- new_deck == "Red"
num_reds <- sum(reds)
counts[i] <- num_reds
# combine new deck with another blue deck
combined <- c(new_deck,Blue)

}

full_counts[,j] <- counts %>% unlist()
combined <- c(Red,Blue) 

}

full_counts %>% 
  mutate(Trial=1:20) %>% 
  pivot_longer(starts_with("V")) %>%
  mutate(name = str_replace(name,"V","Trial_")) %>% 
  ggplot(aes(x=Trial,y=value)) +
  geom_point() +
  geom_smooth() +
  labs(x="Generation",y="Remaining genes") +
  theme_minimal()

