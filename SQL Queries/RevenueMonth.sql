SELECT 
    DATE_FORMAT(p.PurchaseDate, '%Y-%m') AS Month,
    SUM(i.Price) AS TotalRevenue
FROM Purchases AS p
JOIN Items AS i ON p.ItemID = i.ItemID
GROUP BY DATE_FORMAT(p.PurchaseDate, '%Y-%m')
ORDER BY Month;