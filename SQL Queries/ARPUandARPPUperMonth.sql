SELECT 
    DATE_FORMAT(p.PurchaseDate, '%Y-%m') AS Month,
    SUM(i.Price) / (SELECT COUNT(*) FROM Players) AS ARPU,
    SUM(i.Price) / COUNT(DISTINCT s.PlayerID) AS ARPPU
FROM Purchases AS p
JOIN Items AS i ON p.ItemID = i.ItemID
JOIN Sessions AS s ON p.SessionID = s.SessionID
GROUP BY DATE_FORMAT(p.PurchaseDate, '%Y-%m')
ORDER BY Month;
