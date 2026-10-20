SELECT 
    pl.Country,
    COALESCE(SUM(i.Price), 0) AS TotalRevenue,
    COUNT(DISTINCT CASE WHEN p.PurchaseID IS NOT NULL THEN s.PlayerID END) AS PayingUsers,
    ROUND(COALESCE(SUM(i.Price), 0) / NULLIF(COUNT(DISTINCT CASE WHEN p.PurchaseID IS NOT NULL THEN s.PlayerID END), 0), 2) AS ARPPU
FROM Players AS pl
LEFT JOIN Sessions AS s ON pl.PlayerID = s.PlayerID
LEFT JOIN Purchases AS p ON s.SessionID = p.SessionID
LEFT JOIN Items AS i ON p.ItemID = i.ItemID
GROUP BY pl.Country
ORDER BY TotalRevenue DESC;