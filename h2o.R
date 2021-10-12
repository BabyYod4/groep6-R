
install.packages("h2o")
library(h2o)

# Start the H2O cluster (locally)
h2o.init()

# Import a sample binary outcome train/test set into H2O
train <- h2o.importFile("https://s3.amazonaws.com/erin-data/higgs/higgs_train_10k.csv")
test <- h2o.importFile("https://s3.amazonaws.com/erin-data/higgs/higgs_test_5k.csv")

# Identify predictors and response
y <- "response"
x <- setdiff(names(train), y)

# For binary classification, response should be a factor
train[, y] <- as.factor(train[, y])
test[, y] <- as.factor(test[, y])

# Run AutoML for 20 base models
aml <- h2o.automl(x = x, y = y,
                  training_frame = train,
                  max_models = 20,
                  seed = 1)

# View the AutoML Leaderboard
lb <- aml@leaderboard
print(lb, n = nrow(lb))

###################################################################
library(tidyverse)
library(h2o)

# Start the H2O cluster (locally)
h2o.init()

# Allow it to import data tables
options("h2o.use.data.table"=FALSE)

train <- read_rds("data/train.rds")
test <- read_rds("data/test.rds")

write.csv(train, "data/train.csv")
write.csv(test, "data/test.csv")

df_train <- h2o.uploadFile(path = "data/train.csv")
df_test  <- h2o.uploadFile(path = "data/test.csv")

y <- "score"
x <- setdiff(names(df_train), y)

aml <- h2o.automl(x = x, y = y,
                  training_frame = df_train,
                  max_models = 20,
                  seed = 123)

# View the AutoML Leaderboard
lb <- h2o.get_leaderboard(object = aml, extra_columns = "ALL")
print(lb, n = nrow(lb))
view(lb)


