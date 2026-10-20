library(ggplot2)

players <- read.csv("PlayerSummary.csv")
dau     <- read.csv("DAU.csv")

players$InstallDate <- as.Date(players$InstallDate)
dir.create("plots", showWarnings = FALSE)

last_day <- as.Date("2022-12-31")

retention_ci <- function(x) {
  eligible <- players[players$InstallDate <= last_day - x, ]
  returned <- sum(eligible[[paste0("D", x)]])
  test <- prop.test(returned, nrow(eligible))
  data.frame(KPI = paste0("D", x, " retention"), value = returned / nrow(eligible),
             low = test$conf.int[1], high = test$conf.int[2])
}

payers <- players[players$Revenue > 0, ]
conv   <- prop.test(nrow(payers), nrow(players))

mean_ci <- function(name, x) {
  test <- t.test(x)
  data.frame(KPI = name, value = mean(x), low = test$conf.int[1], high = test$conf.int[2])
}

kpis <- rbind(
  retention_ci(1), retention_ci(3), retention_ci(7),
  data.frame(KPI = "Conversion", value = nrow(payers) / nrow(players),
             low = conv$conf.int[1], high = conv$conf.int[2]),
  mean_ci("ARPU",                        players$Revenue),
  mean_ci("ARPPU",                       payers$Revenue),
  mean_ci("Sessions per player",         players$Sessions),
  mean_ci("Session length (min)",        players$AvgSessionSeconds / 60)
)
print(kpis, digits = 3)

eligible_d1 <- players[players$InstallDate <= last_day - 1, ]
eligible_d1$Half <- ifelse(format(eligible_d1$InstallDate, "%m") < "06", "Jan-May", "Jun-Dec")
d1_by_half <- table(eligible_d1$Half, eligible_d1$D1)
print(d1_by_half)
print(prop.test(d1_by_half[, "1"], rowSums(d1_by_half)))

players$Half <- ifelse(format(players$InstallDate, "%m") < "06", "Jan-May", "Jun-Dec")
print(t.test(Sessions ~ Half, data = players))

print(t.test(Revenue ~ Gender, data = players))
print(t.test(Sessions ~ Gender, data = players))
print(cor.test(players$Age, players$Sessions))
print(cor.test(players$Age, players$Revenue))
print(kruskal.test(Sessions ~ Country, data = players))

dau$date <- as.Date(dau$date)

all_days <- data.frame(date = seq(min(dau$date), max(dau$date), by = "day"))
dau <- merge(all_days, dau, all.x = TRUE)
dau$DAU[is.na(dau$DAU)] <- 0
dau$day <- as.numeric(dau$date - min(dau$date))

model <- lm(DAU ~ day, data = dau)
print(summary(model))

future <- data.frame(day = max(dau$day) + 1:30)
future$date <- min(dau$date) + future$day
pred <- predict(model, future, interval = "prediction", level = 0.95)
future <- cbind(future, pred)

ggsave("plots/kpis_ci.png", width = 8, height = 5,
  ggplot(kpis[1:4, ], aes(x = KPI, y = value * 100)) +
    geom_col(fill = "#2a9d8f") +
    geom_errorbar(aes(ymin = low * 100, ymax = high * 100), width = 0.2) +
    labs(title = "Retention and conversion (95% CI)", x = NULL, y = "%") +
    theme_minimal())

ggsave("plots/dau_prediction.png", width = 9, height = 5,
  ggplot() +
    geom_line(data = dau, aes(date, DAU), color = "grey40") +
    geom_smooth(data = dau, aes(date, DAU), method = "lm", color = "#2a9d8f") +
    geom_ribbon(data = future, aes(date, ymin = lwr, ymax = upr), fill = "#e76f51", alpha = 0.3) +
    geom_line(data = future, aes(date, fit), color = "#e76f51", linewidth = 1) +
    labs(title = "DAU with trend and 30-day prediction (95% interval)", x = NULL, y = "DAU") +
    theme_minimal())

ggsave("plots/d1_by_half.png", width = 6, height = 5,
  ggplot(aggregate(D1 ~ Half, eligible_d1, mean), aes(Half, D1 * 100)) +
    geom_col(fill = "#2a9d8f") +
    labs(title = "D1 retention by install period", x = NULL, y = "D1 retention (%)") +
    theme_minimal())

ggsave("plots/revenue_by_gender.png", width = 6, height = 5,
  ggplot(players, aes(Gender, Revenue)) +
    geom_boxplot(fill = "#2a9d8f", alpha = 0.6) +
    labs(title = "Revenue per player by gender", x = NULL, y = "Revenue") +
    theme_minimal())
