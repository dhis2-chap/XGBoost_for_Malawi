options(warn=1)

source("utils.R")

library(dplyr)
library(xgboost)

#library(fable)
#library(tsibble)
#library(lubridate)
#library(distributional) #to extract info from dist objects 

predict_chap <- function(model_fn, historic_data_fn, future_climatedata_fn, predictions_fn) {
  future_per_location <- get_df_per_location(future_climatedata_fn)
  historic_per_location <- get_df_per_location(historic_data_fn)
  models <- readRDS(model_fn)  # Assumes the model was saved using saveRDS
  first_location <- TRUE
  
  predictors <- c("rainfall", "mean_temperature") # adjust to your variables
  
  for (location in names(future_per_location)){
    df <- future_per_location[[location]]
    historic_df <- historic_per_location[[location]]
    model <- models[[location]]
    
    test_matrix  <- as.matrix(df[, predictors])
    
    xgb_preds <- predict(model, test_matrix)
    
    sample_df <- df
    
    sample_df["sample_0"] <- xgb_preds
    
    if (first_location){
      full_df <- sample_df
      first_location <- FALSE
    }
    else {
      full_df <- rbind(full_df, sample_df)
    }
    #print(paste("Forecasted values:", paste(df[, "sample_0", drop=TRUE], collapse = ", ")))
  }
  full_df["time_period"] <- df["time_period"]
  write.csv(full_df, predictions_fn, row.names = FALSE)
}

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 4) {
  model_fn <- args[1]
  historic_data_fn <- args[2]
  future_climatedata_fn <- args[3]
  predictions_fn <- args[4]
  
  predict_chap(model_fn, historic_data_fn, future_climatedata_fn, predictions_fn)
}






