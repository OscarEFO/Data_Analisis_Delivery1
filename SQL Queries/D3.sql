SELECT
DATE(p.CreateDate) AS creat_date,
ROUND(
COUNT(DISTINCT s.PlayerID)
/ COUNT(DISTINCT p.PlayerID) * 100, 2  
) AS D3_Retention_percent
FROM Players p
LEFT JOIN Sessions s
ON p.PlayerID = s.PlayerID
AND DATE(s.StartTime) = DATE(p.CreateDate + INTERVAL 3 DAY)
GROUP BY DATE(p.CreateDate)
ORDER BY creat_date;