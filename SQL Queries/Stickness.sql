SELECT
    DATE(s.StartTime) AS date,
    COUNT(DISTINCT s.PlayerID) AS DAU,
    (
    SELECT COUNT(DISTINCT s2.PlayerID)
    FROM Sessions s2
    WHERE s2.StartTime BETWEEN DATE_SUB(s1.StartTime, INTERVAL 30 DAY) AND s1.StartTime
    ) AS MAU,
    ROUND(
    COUNT(DISTINCT s1.PlayerID) /
    (
    SELECT COUNT(DISTINCT s2.PlayerID)
    FROM Sessions s2
    WHERE s2.StartTime BETWEEN DATE_SUB(s1.StartTime, INTERVAL 30 DAY) AND s1.StartTime
    ) * 100,2) AS stickiness_percent
    FROM Sessions s1
GROUP BY DATE(s1.StartTime)
ORDER BY date;