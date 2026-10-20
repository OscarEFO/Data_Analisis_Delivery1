SELECT
    d.month,
    ROUND(AVG(d.DAU), 2) AS AvgDAU,
    m.MAU,
    ROUND(AVG(d.DAU) / m.MAU * 100, 2) AS Stickiness_percent
FROM (
    SELECT DATE_FORMAT(StartTime, '%Y-%m') AS month, DATE(StartTime) AS day, COUNT(DISTINCT PlayerID) AS DAU
    FROM Sessions
    GROUP BY day
) AS d
JOIN (
    SELECT DATE_FORMAT(StartTime, '%Y-%m') AS month, COUNT(DISTINCT PlayerID) AS MAU
    FROM Sessions
    GROUP BY month
) AS m ON m.month = d.month
GROUP BY d.month, m.MAU
ORDER BY d.month;
