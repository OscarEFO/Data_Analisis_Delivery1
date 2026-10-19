SELECT 
    DATE(StartTime) AS date,
    AVG(TIMESTAMPDIFF(MINUTE, StartTime, EndTime)) AS avg_session_minutes,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, StartTime, EndTime)) / 60, 2) AS avg_session_hours
FROM Sessions
WHERE StartTime IS NOT NULL 
    AND EndTime IS NOT NULL 
    AND EndTime > StartTime
    AND TIMESTAMPDIFF(MINUTE, StartTime, EndTime) <= 1440
GROUP BY DATE(StartTime)
ORDER BY date;