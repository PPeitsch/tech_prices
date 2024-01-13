library(tidyr)
library(dplyr)
library(corrplot)
library(kableExtra)
library(ggplot2)

# Source temporary database functions
source(here::here("core", "temporary_db.R"))

# Read ticker prices data
big_tech_stock_prices_cleaned <- readRDS(here::here("data", "big_tech_stock_prices_cleaned.RDS"))

## Prices tendencies
# Calculate market capitalization
market_cap <- big_tech_stock_prices_cleaned %>%
  group_by(stock_symbol) %>%
  summarise(market_cap = mean(close) * sum(volume))

# Select the top 5 companies by market capitalization
top_5_market_cap <- market_cap %>%
  arrange(desc(market_cap)) %>%
  slice_head(n = 5)

# Filter data only for the selected 5 companies
selected_tickers <- top_5_market_cap$stock_symbol
selected_data <- big_tech_stock_prices_cleaned %>%
  filter(stock_symbol %in% selected_tickers)

# Prepare destination and file name
png(here::here("img", "prices_5tickers.png"),
    width = 1200,
    height = 800)

# Create a price trends plot
prices_plot <- ggplot(selected_data, aes(x = date, y = close, color = stock_symbol)) +
  geom_line() +
  labs(title = "Price Trends of Companies with Highest Market Capitalization",
       x = "Date",
       y = "Closing Price") +
  theme_minimal()
prices_plot
dev.off()

## Correlation Analysis
# Select relevant columns and remove rows with NA
correlation_data <- big_tech_stock_prices_cleaned %>%
  select(stock_symbol, date, close) %>%
  drop_na()

# Group by date and calculate summary statistics to handle duplicates
correlation_data <- correlation_data %>%
  group_by(date, stock_symbol) %>%
  ungroup()

# Create a wide data frame
correlation_matrix <- correlation_data %>%
  pivot_wider(names_from = stock_symbol,
              values_from = close) %>%
  drop_na()

correlation_matrix <- correlation_matrix[, -1]

# Calculate the correlation matrix
correlation_m <- cor(correlation_matrix)

# Prepare destination and file name
png(here::here("img", "correlation_plot.png"),
    width = 800,
    height = 800)

# Create a correlation plot
correlation_plot <- corrplot(correlation_m,
                             method = "circle",
                             type = "upper",
                             tl.col = "black",
                             tl.srt = 45)
correlation_plot
dev.off()

# Create a table object with correlation statistics
correlation_stats <- data.frame(
  Mean = apply(correlation_matrix, 2, mean, na.rm = TRUE),
  SD = apply(correlation_matrix, 2, sd, na.rm = TRUE),
  Min = apply(correlation_matrix, 2, min, na.rm = TRUE),
  Max = apply(correlation_matrix, 2, max, na.rm = TRUE)
)

# Display the table in the document
correlation_table <- kable(correlation_stats, "html") %>% 
  kable_styling(full_width = FALSE, bootstrap_options = "striped", font_size = 10)
