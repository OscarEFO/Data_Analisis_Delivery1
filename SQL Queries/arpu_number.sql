SELECT 
    SUM(i.Price) / COUNT(DISTINCT pl.PlayerID) AS ARPU
FROM Players AS pl
LEFT JOIN Sessions AS s ON pl.PlayerID = s.PlayerID
LEFT JOIN Purchases AS p ON s.SessionID = p.SessionID
LEFT JOIN Items AS i ON p.ItemID = i.ItemID;