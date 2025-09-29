options(warn=1)

source("utils.R")

library(dplyr)
library(xgboost)

#library(fable)
#library(tsibble)
#library(lubridate)

train_chap <- function(csv_fn, model_fn) {
  dataframe_list <- get_df_per_location(csv_fn)
  
  models <- list()
  for (location in names(dataframe_list)){
    model <- train_single_region(dataframe_list[[location]], location)
    models[[location]] <- model
  }
  saveRDS(models, file=model_fn)
}

train_single_region <- function(df, location){
  predictors <- c("rainfall", "mean_temperature") # adjust to your variables
  response <- "disease_cases"
  
  df <- df[!is.na(df$disease_cases), ] #removes rows where disease_cases are NA
  
  train_matrix <- as.matrix(df[, predictors])
  label <- df[, response]
  xgb_model <- xgboost(data = train_matrix, label = label,
                       nrounds = 100, objective = "reg:squarederror", verbose = 0)
  return(xgb_model)
}

args <- commandArgs(trailingOnly = TRUE)

if (length(args) >= 2) {
  csv_fn <- args[1]
  model_fn <- args[2]
  
  train_chap(csv_fn, model_fn)
}






