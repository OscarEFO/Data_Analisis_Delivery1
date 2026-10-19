CREATE TABLE active_hour_distribution AS
SELECT
HOUR(s.StartTime) AS hour_of_day,
    COUNT(DISTINCT s.PlayerID) AS active_users,
    ROUND(COUNT(DISTINCT s.PlayerID) / (SELECT COUNT(DISTINCT PlayerID) FROM Sessions) * 100, 2) AS percent_of_total
    FROM Sessions s
GROUP BY hour_of_day
ORDER BY hour_of_day;