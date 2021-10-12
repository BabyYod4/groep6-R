library(tidyverse)
library(gbm)


train <- read_rds("data/train.rds")
df_test <- read_rds("data/test.rds")

smp_size <- floor(0.75 * nrow(df_train))
set.seed(123)
train_ind <- sample(seq_len(nrow(df_train)), size = smp_size)
train <- df_train[train_ind, ]
valid <- df_train[-train_ind, ]

train$Medu <- factor(train$Medu)
train$Fedu <- factor(train$Fedu)
train$traveltime <- factor(train$studytime)
train$famrel <- factor(train$famrel)
train$freetime <- factor(train$freetime)
train$goout <- factor(train$goout)
train$Dalc <- factor(train$Dalc)
train$Walc <- factor(train$Walc)
train$health <- factor(train$health)

valid$Medu <- factor(valid$Medu)
valid$Fedu <- factor(valid$Fedu)
valid$traveltime <- factor(valid$studytime)
valid$famrel <- factor(valid$famrel)
valid$freetime <- factor(valid$freetime)
valid$goout <- factor(valid$goout)
valid$Dalc <- factor(valid$Dalc)
valid$Walc <- factor(valid$Walc)
valid$health <- factor(valid$health)


hyper_grid <- expand.grid(
  shrinkage = c(.1, .3, .5),
  interaction.depth = c(5, 7, 10),
  n.minobsinnode = c(12, 15, 18),
  bag.fraction = c(0.8, 0.9, 1), 
  optimal_trees = 0,               # a place to dump results
  min_RMSE = 0                     # a place to dump results
)


# grid search 
for(i in 1:nrow(hyper_grid)) {
  
  # reproducibility
  set.seed(123)
  
  # train model
  gbm.tune <- gbm(
    formula = score ~ .,
    distribution = "gaussian",
    data = train,
    n.trees = 5000,
    interaction.depth = hyper_grid$interaction.depth[i],
    shrinkage = hyper_grid$shrinkage[i],
    n.minobsinnode = hyper_grid$n.minobsinnode[i],
    bag.fraction = hyper_grid$bag.fraction[i],
    train.fraction = .75,
    n.cores = NULL, # will use all cores by default
    verbose = FALSE
  )
  
  # add min training error and trees to grid
  hyper_grid$optimal_trees[i] <- which.min(gbm.tune$valid.error)
  hyper_grid$min_MSE[i] <- min(gbm.tune$valid.error)
}

hyper_grid %>% 
  dplyr::arrange(min_MSE) %>%
  head(10)




summary(boost)

# get MSE
min(boost$cv.error)
## [1] 0.7825207

# plot loss function as a result of n trees added to the ensemble
gbm.perf(boost, method = "cv")
