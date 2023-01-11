#### Machine learning (random forest) model to predict survival of titanic passengers

# install.packages(c("DALEX","ranger","vip","ALEPlot"))
library(ALEPlot)


data(titanic_imputed, package = "DALEX")

head(titanic_imputed)
library(ALEPlot)

ranger_model <- ranger::ranger(survived~., data = titanic_imputed, classification = TRUE, probability = TRUE,importance = 'permutation')
vip::vip(ranger_model) # find most important factors for success (survival)


pred <- predict(ranger_model,titanic_imputed[68,]) # look at passenger 68, young 1st class female who survived
pred$predictions # predicted probs of failure, success (survival)

X <- titanic_imputed[which(names(titanic_imputed) != "survived")] # remove response column

pred_fun <- function(X.model, newdata) {    # define function to pull predictions vector
  predict(X.model, newdata)$predictions[,2] # pull vector of success predictions
}

ALEPlot_1 <- ALEPlot(X = X, X.model = ranger_model, J = c(3), pred.fun = pred_fun) # look at local effect of 3rd predictor (class)
ALEPlot_2 <- ALEPlot(X = X, X.model = ranger_model, J = c(2), pred.fun = pred_fun) # look at local effect of 2nd predictor (age)
ALEPlot_1 <- ALEPlot(X = X, X.model = ranger_model, J = c(3,2), pred.fun = pred_fun) # look at local effects of age and class
