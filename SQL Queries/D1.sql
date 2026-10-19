SELECT
DATE(p.CreatTime) AS creat_date,
ROUND(
COUNT(DISTINCT s.PlayerID)
/ COUNT(DISTINCT p.PlayerID) * 100, 2  
) AS D1_Retention_percent
FROM Players p
LEFT JOIN Sessions s
ON p.PlayerID = s.PlayerID
AND DATE(s.StartTime) = DATE(p.CreatTime + INTERVAL 1 DAY)
GROUP BY DATE(p.CreatTime)
ORDER BY creat_date;