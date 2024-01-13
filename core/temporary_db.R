library(DBI)
#library(RPostgreSQL)
library(RSQLite)

# Source cleaning_data.R
source(file.path("core", "cleaning_data.R"))

# Connect to SQLite in-memory database
con <- DBI::dbConnect(RSQLite::SQLite(), dbname = ":memory:")

# Connect to PostgreSQL in-memory database
#con <- DBI::dbConnect(RPostgreSQL::PostgreSQL(), dbname = ":memory:", user = "postgres", password = "", host = "localhost", port = 5432)

big_tech_stock_prices <- getBigTechStockPrices()
# Table creation about the stock prices of the big tech companies
DBI::dbWriteTable(con, "big_tech_stock_prices", big_tech_stock_prices, overwrite = TRUE)

big_tech_companies <- getBigTechCompanies()
# Table creation about information of the big tech companies
DBI::dbWriteTable(con, "big_tech_companies", big_tech_companies, overwrite = TRUE)

# Convert date to DATE type
query_date <- "
  UPDATE big_tech_stock_prices
  SET Date = CAST(Date AS DATE);
"
DBI::dbExecute(con, query_date)

# Convert numeric columns to appropriate numeric types
query_numeric <- "
  UPDATE big_tech_stock_prices
  SET Open = CAST(Open AS DOUBLE PRECISION),
      High = CAST(High AS DOUBLE PRECISION),
      Low = CAST(Low AS DOUBLE PRECISION),
      Close = CAST(Close AS DOUBLE PRECISION),
      Adj_Close = CAST(Adj_Close AS DOUBLE PRECISION),
      Volume = CAST(Volume AS INTEGER);
"
DBI::dbExecute(con, query_numeric)

# Query for daily price volatility
query_volatility <- "
  SELECT
    s.stock_symbol,
    sp.Date,
    (sp.High - sp.Low) / sp.Low * 100 AS daily_volatility
  FROM
    big_tech_stock_prices sp
    JOIN big_tech_companies s ON sp.stock_symbol = s.stock_symbol
"
volatility_result <- DBI::dbGetQuery(con, query_volatility)
saveRDS(volatility_result, here::here("data", "volatility_result.RDS"))

# Query for percentage price changes
query_price_changes <- "
  SELECT
    s.stock_symbol,
    sp.Date,
    (sp.Close - sp.Open) / sp.Open * 100 AS price_change_percentage
  FROM
    big_tech_stock_prices sp
    JOIN big_tech_companies s ON sp.stock_symbol = s.stock_symbol
"
price_changes_result <- DBI::dbGetQuery(con, query_price_changes)
saveRDS(price_changes_result, here::here("data", "price_changes_result.RDS"))

# Query for trading volume
query_volume <- "
  SELECT
    s.stock_symbol,
    sp.Date,
    sp.Volume
  FROM
    big_tech_stock_prices sp
    JOIN big_tech_companies s ON sp.stock_symbol = s.stock_symbol
"
volume_result <- DBI::dbGetQuery(con, query_volume)
saveRDS(volume_result, here::here("data", "volume_result.RDS"))

# Calculate market capitalization in SQL
query_market_cap <- "
  CREATE TEMPORARY TABLE market_cap_temp AS
  SELECT
      stock_symbol,
      date,
      AVG(close) * SUM(volume) / 1000000000 AS market_cap
  FROM
      big_tech_stock_prices
  GROUP BY
      stock_symbol, date
  ORDER BY
      market_cap;
"

DBI::dbExecute(con, query_market_cap)

# Select the results from the temporary table
market_cap_df <- DBI::dbGetQuery(con, "SELECT * FROM market_cap_temp")

# Save market_cap_df as an RDS file
saveRDS(market_cap_df, here::here("data", "market_cap_df.RDS"))

# Close the database connection
DBI::dbDisconnect(con)
