# Time Series Analysis and Forecasting in R

**Time Series Analysis | Academic Project**

## Project Overview

This project explores monthly livestock slaughter data in Australia using time series analysis and forecasting techniques in R.

The analysis focuses on two time series:
- Calves slaughtered in Queensland
- Cattle (excluding calves) slaughtered in South Australia

Different statistical approaches are applied to examine trends, seasonality, and forecasting models.

## Objectives

1. Visualize and explore monthly time series patterns.
2. Apply time series regression models with different transformations.
3. Fit exponential smoothing and seasonal ARIMA models.
4. Examine model residuals using diagnostic plots and statistical tests.
5. Explore forecasting and model components.

## Dataset

**Dataset:** Australian Livestock Slaughter (`aus_livestock`)

**Source:** Australian Bureau of Statistics (ABS), available through the `tsibbledata` R package.

The dataset contains monthly livestock slaughter counts across Australian states.

The analysis focuses on observations from July 1976 onward.

The dataset can be loaded directly in R without downloading a separate CSV file.

```r
data <- tsibbledata::aus_livestock
```

## Methodology

### 1. Time Series Visualization

Visualize monthly slaughter counts to explore long-term patterns and seasonality.

### 2. Time Series Regression

Fit regression models using:
- Linear transformation
- Logarithmic transformation
- Square-root transformation
- Fourth-root transformation

The models include trend and seasonal components.

### 3. Exponential Smoothing

Explore Holt-Winters exponential smoothing models using the ETS framework, including additive and damped trends with additive or multiplicative seasonal components.

### 4. Seasonal ARIMA

Apply seasonal ARIMA models to capture temporal dependence and seasonal patterns.

### 5. Model Diagnostics

Examine model residuals using:
- Residual diagnostic plots
- Histograms
- Ljung-Box tests

### 6. Forecasting

Explore forecast generation and selected model components.

## Tools and Technologies

- R
- fpp3
- ggplot2
- forecast
- tsibbledata

## Project Files

- `assignment_2_aus_livestock.R` — R script containing time series visualization, model fitting, diagnostics, and forecasting-related analysis.

## Data Attribution

The Australian livestock slaughter dataset is sourced from the Australian Bureau of Statistics and distributed through the `tsibbledata` R package.

Dataset documentation: https://tsibbledata.tidyverts.org/reference/aus_livestock.html

## Acknowledgment

This project was developed as part of an academic Time Series Analysis assignment.
