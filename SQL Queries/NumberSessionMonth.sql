SELECT 
    DATE_FORMAT(StartTime, '%Y-%m') AS Month,
    COUNT(*) AS TotalSessions
FROM Sessions
GROUP BY DATE_FORMAT(StartTime, '%Y-%m')
ORDER BY Month;
