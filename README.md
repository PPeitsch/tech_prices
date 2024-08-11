# Big Tech Stock Price Analysis

## Summary

This repository contains a data analysis of daily stock prices for the 14 most important technology companies in the United States. The dataset was obtained from Yahoo Finance via Kaggle, proposed by Evan Gower. The objective of this analysis is to demonstrate technical skills in R, addressing relevant information about stock price trends of major technology companies.

## Data

- **Tidy Tuesday dataset:** [Big Tech Stock Prices](https://github.com/rfordatascience/tidytuesday/blob/master/data/2023/2023-02-07/readme.md)
- **Original Dataset:** [Big Tech Stock Prices](https://www.kaggle.com/datasets/evangower/big-tech-stock-prices)
- **Additional Information:** This dataset includes daily information on stock prices and volumes of companies such as Apple (AAPL), Amazon (AMZN), Alphabet (GOOGL), Meta Platforms (META), and more.

## Context

The stocks of major tech companies show an apparent trend of significant decline during the period of the data. The choice of this dataset is related to companies operating in financial services, and this analysis is expected to provide relevant information about trends in the technology market.

## Analysis Objectives

1. **Obtain relevant information**
   - Identify patterns or events that could have contributed to significant price drops.
   - Analyze the correlation between stocks of different technology companies.
2. **Dataset choice:**
   - Relevance of technology stocks for target companies.
   - The variability or volatility in prices can offer investment and risk perspectives.

## Tools

- R will be used to perform the analysis, leveraging the capabilities of RMarkdown and Quarto for creating a presentation.
- SQL queries will be employed through the DBI library to simulate operations in a database.

## Repository Structure

- **ppt:** 
- **doc:** The analysis is presented in a technical document format using Quarto with Reveal.js. A PDF version is included and can be found [here](doc/technical_en.pdf).
- **data:** Directory where original data and generated tables are stored.
- **core:** Directory where the code used for the analysis is located.
- **img:** A directory is reserved for images in case they are needed.

## Requirements

Make sure you have R and the necessary libraries installed. Refer to the `renv.lock` file for more details.

## Pending

The following code blocks ("chunks") are pending improvement: chunk 6 and 7

---

**Note:** It is recommended to clone this repository and run the code in your own environment to replicate the results.
