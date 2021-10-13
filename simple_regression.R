
library(tidyverse)
library(factoextra)

df_train  <- read_rds("data/train.rds")

print(df_train)

#pca_res <- prcomp(df_train, scale = TRUE)

#print(pca_res)