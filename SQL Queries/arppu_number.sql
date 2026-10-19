SELECT 
    SUM(i.Price) / COUNT(DISTINCT s.PlayerID) AS ARPPU
FROM Purchases AS p
JOIN Sessions AS s ON p.SessionID = s.SessionID
JOIN Items AS i ON p.ItemID = i.ItemID;