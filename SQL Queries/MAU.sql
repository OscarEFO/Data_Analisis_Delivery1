SELECT
DATE_FORMAT(StartTime, '%Y-%m') AS month,
COUNT(DISTINCT PlayerID) AS MAU
FROM Sessions
GROUP BY month
ORDER BY month;