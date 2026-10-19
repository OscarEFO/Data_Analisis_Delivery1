SELECT 
    DATE(StartTime) AS Date,
    ROUND(AVG(SessionLengthSeconds) / 3600, 2) AS AvgSessionLength_Hours
FROM Sessions
GROUP BY DATE(StartTime)
ORDER BY Date;