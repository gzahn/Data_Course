library(broom)
library(modelr)
library(tidyverse)

hotdogs <- data.frame(item=c("plain","cheese dog","chili dog","chili-cheese dog"),
           price=c(2,2.35,2.35,2.7),
           cheese=c(FALSE,TRUE,FALSE,TRUE),
           chili=c(FALSE,FALSE,TRUE,TRUE))

hotdogs

model_hotdogs <- 
  lm(price ~ cheese + chili + cheese*chili,data=hotdogs)

summary(model_hotdogs)


