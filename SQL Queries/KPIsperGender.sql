SELECT
    CASE WHEN pl.Gender < 0.5 THEN 'M' ELSE 'F' END AS Gender,
    COUNT(DISTINCT pl.PlayerID) AS Players,
    COUNT(DISTINCT s.SessionID) AS Sessions,
    ROUND(COUNT(DISTINCT s.SessionID) / COUNT(DISTINCT pl.PlayerID), 2) AS SessionsPerPlayer,
    COALESCE(SUM(i.Price), 0) AS TotalRevenue,
    ROUND(COALESCE(SUM(i.Price), 0) / COUNT(DISTINCT pl.PlayerID), 2) AS ARPU
FROM Players pl
LEFT JOIN Sessions s  ON s.PlayerID = pl.PlayerID
LEFT JOIN Purchases p ON p.SessionID = s.SessionID
LEFT JOIN Items i     ON i.ItemID = p.ItemID
GROUP BY Gender;
