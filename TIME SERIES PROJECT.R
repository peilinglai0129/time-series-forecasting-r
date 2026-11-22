library(fpp3)
library(ggplot2)
library(forecast)

#data<-read.csv(file.choose(),header=TRUE)
data <- tsibbledata::aus_livestock
data
data
calves_q <- data %>% filter(Animal == "Calves",
                            State == "Queensland") %>%
            mutate(YearMonth = yearmonth(Month)) %>%
            filter(YearMonth >= yearmonth("1976 Jul")) %>%
            as_tsibble(index = YearMonth)
calves_q

cattle_sa <- data %>% filter(Animal == "Cattle (excl. calves)", 
                             State == "South Australia") %>% 
             mutate(YearMonth = yearmonth(Month)) %>%
             filter(YearMonth >= yearmonth("July 1976")) %>%
             as_tsibble(index=YearMonth)
cattle_sa

#1.time series plots
calves_q %>% autoplot(Count) + xlab("Year Month") + 
             ylab("Count of Calves") +
             ggtitle("Number of monthly slaughters of Calves in Queensland")

cattle_sa %>% autoplot(Count) + xlab("Year Month") + 
  ylab("Count of Cattle (excl. calves)") +
  ggtitle("Number of monthly slaughters of Cattle (excl. calves) in South Australia")

#22222.a.	time series regression model, 
#b.	exponential smoothing method
#c.	ARIMA or SARIMA model
fit_calves <- calves_q %>% model (linear = TSLM(Count ~ trend() + season(period=12)),
                                  exponential = TSLM(log(Count) ~ trend() + season(period=12)),
                                  squareroot = TSLM(sqrt(Count) ~ trend() + season(period=12)),
                                  quarticroot = TSLM(Count^(1/4) ~ trend() + season(period=12)))
report(select(fit_calves, linear))
report(select(fit_calves, exponential))
report(select(fit_calves, squareroot))
report(select(fit_calves, quarticroot))

fit1 <- calves_q %>% model(MHW = ETS(Count ~ error("M") + trend("A") + season("M")),
                                 DMHW = ETS(Count ~ error("M") + trend("Ad") + season("M")))
report(select(fit1, MHW))
report(select(fit1, DMHW))

fit2 <- calves_q %>% model(sarima = ARIMA(Count ~ PDQ(period=12),
                                   stepwise=FALSE, approximation=FALSE))

report(fit2)

#cattleeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
fit_cattle <- cattle_sa %>% model (linear = TSLM(Count ~ trend() + season(period=12)),
                                  exponential = TSLM(log(Count) ~ trend() + season(period=12)),
                                  squareroot = TSLM(sqrt(Count) ~ trend() + season(period=12)),
                                  quarticroot = TSLM(Count^(1/4) ~ trend() + season(period=12)))
report(select(fit_cattle, linear))
report(select(fit_cattle, exponential))
report(select(fit_cattle, squareroot))
report(select(fit_cattle, quarticroot))

fit1 <- cattle_sa %>% model(MHW = ETS(Count ~ error("M") + trend("A") + season("M")),
                           DMHW = ETS(Count ~ error("M") + trend("Ad") + season("M")),
                           AHW = ETS(Count ~ error("A") + trend("A") + season("A")),
                           DAHW = ETS(Count ~ error("A") + trend("Ad") + season("A")))
report(select(fit1, MHW))
report(select(fit1, DMHW))
report(select(fit1, AHW))
report(select(fit1, DAHW))

fit2 <- cattle_sa %>% model(sarima = ARIMA(Count ~ PDQ(period=12),
                                          stepwise=FALSE, approximation=FALSE))
report(select(fit2, sarima))
report(select(fit2, arima))
#3 show the report

report(select(fit_calves, linear))
report(select(fit_calves, es))
report(select(fit_calves, sarima))

report(select(fit_cattle, linear))
report(select(fit_cattle, es))
report(select(fit_cattle, sarima))

#6 diagnose the residuals
fit_calves %>% select(exponential) %>% augment() %>% gg_tsdisplay(.resid, plot_type = "hist")
fit_calves %>% select(exponential) %>% augment() %>% 
  features(.resid, ljung_box, lag=24, dof=13)

fit1 %>% select(DMHW) %>% augment() %>% gg_tsdisplay(.resid, plot_type = "hist")
fit1 %>% select(DMHW) %>% augment() %>% 
  features(.resid, ljung_box, lag=24, dof=18)

augment(fit2) %>% gg_tsdisplay(.resid, plot_type = "hist")
ljung_box(augment(fit2)$.resid, lag=24)

#cattleeeeeeeeeeeeeeeee
fit_cattle %>% select(linear) %>% augment() %>% gg_tsdisplay(.resid, plot_type = "hist")
fit_cattle %>% select(linear) %>% augment() %>% 
  features(.resid, ljung_box, lag=24, dof=13)

fit1 %>% select(DAHW) %>% augment() %>% gg_tsdisplay(.resid, plot_type = "hist")
fit1 %>% select(DAHW) %>% augment() %>% 
  features(.resid, ljung_box, lag=24)

augment(fit2) %>% gg_tsdisplay(.resid, plot_type = "hist")
ljung_box(augment(fit2)$.resid, lag=24)



#PI
# For ETS: Get the very last Level, Trend, and Seasonal state
fit1 %>% components() %>% tail(1) %>% print(digits=10)
fit1 %>% components() %>% view()
fit1 %>% forecast(h=3) %>% autoplot(calves_q)

# For ARIMA: Get the last few residuals to multiply by the MA coefficients
fit2 %>% augment() %>% tail(4)
fit2 %>% augment() %>% view()

# 1. Get the Design Matrix X for your specific data
X <- model.matrix(fit_calves)

# 2. Calculate the (X'X) inverse matrix
# This is the "tedious" part that R handles in a millisecond
XTX_inv <- solve(t(X) %*% X)

# 3. View the results to copy into your report
print(XTX_inv)
