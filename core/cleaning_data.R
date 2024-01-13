library(fs)
library(tidyverse)
library(here)
library(janitor)

# Load functions to get data
source(file.path("core", "getting_data.R"))

# Get data from tables using DBI
big_tech_stock_prices <- getBigTechStockPrices()
big_tech_companies <- getBigTechCompanies()

# Clean and correct data types
big_tech_stock_prices <- big_tech_stock_prices %>%
  drop_na() %>%
  janitor::clean_names()

# Create a lookup table for symbols
symbols_lookup <- tibble::tibble(
  stock_symbol = c(
    "AAPL", "ADBE", "AMZN", "CRM", "CSCO", "GOOGL", "IBM", "INTC",
    "META", "MSFT", "NFLX", "NVDA", "ORCL", "TSLA"
  ),
  company = c(
    "Apple Inc.", "Adobe Inc.", "Amazon.com, Inc.", "Salesforce, Inc.",
    "Cisco Systems, Inc.", "Alphabet Inc.", "International Business Machines Corporation",
    "Intel Corporation", "Meta Platforms, Inc.", "Microsoft Corporation",
    "Netflix, Inc.", "NVIDIA Corporation", "Oracle Corporation", "Tesla, Inc."
  )
)

# Merge company names to the data
big_tech_stock_prices <- big_tech_stock_prices %>%
  left_join(symbols_lookup, by = "stock_symbol")

# Save to CSV files for precaution, even though it's not necessary
readr::write_csv(
  big_tech_stock_prices,
  here::here("data", "big_tech_stock_prices_cleaned.csv")
)
saveRDS(big_tech_stock_prices, here::here("data", "big_tech_stock_prices_cleaned.RDS"))

# Create a lookup table for symbols
symbols_lookup |> 
  readr::write_csv(
    here::here("data", "big_tech_companies.csv")
  )
saveRDS(big_tech_stock_prices, here::here("data", "big_tech_companies.RDS"))

# Clean and correct data types for volatility result
volatility_result %>%
  drop_na() %>%
  janitor::clean_names()
saveRDS(volatility_result, here::here("data", "volatility_result.RDS"))

# Clean and correct data types for price changes result
price_changes_result %>%
  drop_na() %>%
  janitor::clean_names()
saveRDS(price_changes_result, here::here("data", "price_changes_result.RDS"))

# Clean and correct data types for volume result
volume_result %>%
  drop_na() %>%
  janitor::clean_names()
saveRDS(volume_result, here::here("data", "volume_result.RDS"))
