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

query_market_cap_result <- DBI::dbGetQuery(con, query_market_cap)
saveRDS(query_market_cap_result, here::here("data", "query_market_cap_result.RDS"))

# Filter data for the top 5 companies in SQL and calculate market_cap
query_selected_data <- "
  SELECT
    *
  FROM (
    SELECT
      *,
      AVG(close) * SUM(volume) AS market_cap
    FROM
      big_tech_stock_prices
    WHERE
      stock_symbol IN (
        SELECT
          stock_symbol
        FROM
          big_tech_stock_prices
        GROUP BY
          stock_symbol
        ORDER BY
          AVG(close) * SUM(volume) DESC
        LIMIT 5
      )
    GROUP BY
      stock_symbol, Date, Open, High, Low, Close, Adj_Close, Volume
  )
  ORDER BY
    market_cap DESC;
"

selected_data <- DBI::dbGetQuery(con, query_selected_data)
saveRDS(selected_data, here::here("data", "selected_data.RDS"))

# Calculate drawdowns for selected companies in SQL
query_drawdowns <- "
  SELECT
    stock_symbol,
    date,
    close,
    1 - close / LAG(close) OVER (PARTITION BY stock_symbol ORDER BY date) AS drawdown
  FROM
    big_tech_stock_prices
  WHERE
    stock_symbol IN (
      SELECT
        stock_symbol
      FROM
        big_tech_stock_prices
      GROUP BY
        stock_symbol
      ORDER BY
        AVG(close) * SUM(volume) DESC
      LIMIT 5
    );
"

drawdowns_result <- DBI::dbGetQuery(con, query_drawdowns)
saveRDS(drawdowns_result, here::here("data", "drawdowns_result.RDS"))


# Close the database connection
DBI::dbDisconnect(con)
