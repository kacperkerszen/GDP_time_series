
install.packages("timeSeries")
install.packages("tseries")
install.packages("readxl")
install.packages("forecast")
install.packages("zoo")
install.packages("xts")
install.packages("Quandl")
install.packages("quantmod")
install.packages("urca")


# Cleaning the environment (workspace, plots and console)
rm(list = ls())
if(!is.null(dev.list())) dev.off()
cat("\014")



# fetching data from a directory
library(readxl)
R1 <- read_excel("...R1.xlsx")
View(R1)


# 1. ACF PACF time series and functions #


# Defining variable Y - quarterly GDP
Y <- R1[,"Y"]
Y <- ts(Y, start=c(1995,1), freq = 4)

C <- R1[,"C"]
C <- ts(C, start=c(1995,1), freq = 4)


# Defining quarterly increments
dY <- 100*(Y/lag(Y,k=-4)-1)
dC <- 100*(C/lag(C,k=-4)-1)

# Charts from the forecast package
library(forecast)
library(zoo)
library(xts)
library(Quandl)
library(quantmod)

# The simplest time series graph

plot.ts(Y)

windows()

# Defining parameters for charts
par(mfrow=c(3,2), cex=0.5, pin=c(2,1), bty="l")

# Graphs of variables and incremental graphs
plot(Y/1000, main="GDP level", ylab = "mld PLN", xlab = "", type = "l")
plot(dY, main="Annual growth rate", xlab = "", type = "l")

# Graphs of ACF and PACF functions
Acf(Y, main="ACF", xlab="", ylab="")
Acf(dY, main="ACF", xlab="", ylab="")
Pacf(Y, main="PACF", xlab="", ylab="")
Pacf(dY, main="PACF", xlab="", ylab="")


# 2. Stationarity 


# The process of white noise and random wandering - a theoretical example

set.seed(7)
x <- rnorm(1000)
y <- cumsum(x)

library(forecast)
windows()
par(mfrow=c(3,2), cex = 0.7, bty="l", pin=c(2,1))
plot(x, type="l", main="white noice", sub="", xlab="", ylab="")
plot(y, type="l", main="random walk", sub="", xlab="", ylab="")
Acf(x, main="ACF for white noice", sub="", xlab="", ylab="", ylim=c(-1,1))
Acf(y, main="ACF for white walk", sub="", xlab="", ylab="", ylim=c(-1,1))

# GDP logarithm analysis

logY <-log(Y)
dlogY <- 100*(logY/lag(logY,k=-4)-1)

windows()
par(mfrow=c(3,2), cex=0.5, pin=c(2,1), bty="l")
plot(logY/1000, main="GDP logarithm", ylab = "mld PLN", xlab = "", type = "l")
plot(dlogY, main="Annual growth rate", xlab = "", type = "l")



# Testing for stationarity 


library(tseries)

adf.test(logY)
adf.test(dlogY)

pp.test(logY)
pp.test(dlogY)

kpss.test(logY)
kpss.test(dlogY)

library(urca)

summary(ur.df(logY, type="trend", lags=8))
summary(ur.df(dlogY, type="drift", lags=10))

summary(ur.pp(logY, type = "Z-tau", model="trend"))
summary(ur.pp(dlogY, type = "Z-tau", model = "constant"))

summary(ur.kpss(logY, type = "tau"))
summary(ur.kpss(dlogY, type = "mu"))



# 3. ARIMA estimation      


auto.arima(logY)

auto.arima(dlogY)


model_logY=arima(logY,order=c(1,1,0),seasonal=list(order=c(0,0,1),period=4))
summary(model_logY)

#or
model_dlogY=arima(dlogY,order=c(1,0,3),seasonal=list(order=c(0,0,1),period=4))
summary(model_dlogY)


# Model diagnostics                


et=residuals(model_logY)
plot.ts(et)

# Random component autocorrelation test
acf(et)
pacf(et)
Box.test(et, lag=10, type=c("Ljung-Box"), fitdf=2)

# Test of normality of the random component
gghistogram(et)
JB <- jarque.bera.test(et)
options(digits=4)
JB



# Model-based forecasting 


progn_model_logY=forecast(model_logY,h=10)
plot(progn_model_logY)
plot(progn_model_logY, include=60, shaded=T, shadecols=c('grey','GhostWhite'), main="Increments in log GDP", ylab="", xlab="")




# different ARIMA model


options(digits=3)
summary(arima(logY, order = c(3,0,3)))

arma.CSS_ML <- arima(logY, order = c(3,0,3), method="CSS-ML")
arma.CSS    <- arima(logY, order = c(3, 0, 3), method = "CSS")
arma.ML     <- arima(logY, order = c(3, 0, 3), method = "ML")

ARMA.coef <- matrix(NA,3,7)
ARMA.coef[1,] <- arma.CSS_ML[["coef"]]
ARMA.coef[2,] <- arma.CSS[["coef"]]
ARMA.coef[3,] <- arma.ML[["coef"]]
rownames(ARMA.coef) <- c("CSS-ML","CSS","ML")
colnames(ARMA.coef) <- c("ar1", "ar2", "ar3", "ma1", "ma2", "ma3", "cons.")
ARMA.coef


