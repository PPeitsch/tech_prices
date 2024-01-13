# Getting the Data from TidyTuesday
tuesdata <- tidytuesdayR::tt_load('2023-02-07')
tuesdata <- tidytuesdayR::tt_load(2023, week = 6)

# Function to retrieve Big Tech Stock Prices
getBigTechStockPrices <- function() {
  big_tech_stock_prices <- tuesdata$big_tech_stock_prices
  return(big_tech_stock_prices)
}

# Function to retrieve Big Tech Companies
getBigTechCompanies <- function() {
  big_tech_companies <- tuesdata$big_tech_companies
  return(big_tech_companies)
}

# Alternatively, read it manually
# big_tech_stock_prices <- readr::read_csv('tables_on_data_folder.csv')
