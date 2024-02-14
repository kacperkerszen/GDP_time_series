# Time series analysis of Poland's GDP using R

Time-series analysis for understanding and forecasting the behavior of GDP and its components over time, aiding in economic analysis and decision-making.

## Overal Project Description

- The code covers a comprehensive workflow for time series analysis and modeling, including data preprocessing, exploratory analysis, stationarity testing, ARIMA modeling, and model diagnostics.
- It utilizes various R packages such as timeSeries, tseries, forecast, zoo, xts, Quandl, quantmod, and urca for different tasks.
- Techniques such as ACF, PACF, differencing, logarithmic transformation, and statistical tests are employed to analyze and model the time series data.

### Data Preprocessing

- Libraries necessary for data handling, visualization, and modeling are installed and loaded.
- Data is read from an Excel file (R1.xlsx) using the read_excel function from the readxl package.
- The data is viewed and extracted into relevant variables, such as quarterly GDP (Y) and consumption (C).
- Quarterly increments of GDP and consumption are calculated.

### Exploratory Data Analysis

- Simple time series plots are generated to visualize the GDP level and its growth rate.
- Autocorrelation Function (ACF) and Partial Autocorrelation Function (PACF) plots are created to analyze the autocorrelation structure of the time series.

### Stationarity Analysis

- The concept of stationarity is introduced with theoretical examples of white noise and random walk processes.
- The logarithm of GDP (logY) and its increments (dlogY) are analyzed and plotted.
- Stationarity tests including Augmented Dickey-Fuller (ADF), Phillips-Perron (PP), and Kwiatkowski-Phillips-Schmidt-Shin (KPSS) tests are performed on both the original and differenced series.

### ARIMA Modelling

- Automatic ARIMA model selection is performed on both logY and dlogY series using the auto.arima function.
- Manual ARIMA model fitting is demonstrated with the arima function.
- Diagnostic checks on the ARIMA models are conducted, including plotting the residuals, autocorrelation of residuals, and normality tests.
- Model-based forecasting is carried out for future time periods using the forecast function.

### Alternative ARIMA Model Estimation

- Different ARIMA model estimation methods (CSS-ML, CSS, ML) are demonstrated.
- Coefficients of the ARIMA models are summarized.
