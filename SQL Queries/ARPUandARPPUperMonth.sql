SELECT
    a.Month,
    a.ActivePlayers,
    COALESCE(r.PayingPlayers, 0) AS PayingPlayers,
    ROUND(COALESCE(r.Revenue, 0) / a.ActivePlayers, 2) AS ARPU,
    ROUND(r.Revenue / r.PayingPlayers, 2) AS ARPPU
FROM (
    SELECT DATE_FORMAT(StartTime, '%Y-%m') AS Month, COUNT(DISTINCT PlayerID) AS ActivePlayers
    FROM Sessions
    GROUP BY Month
) AS a
LEFT JOIN (
    SELECT DATE_FORMAT(p.PurchaseDate, '%Y-%m') AS Month,
           SUM(i.Price) AS Revenue,
           COUNT(DISTINCT s.PlayerID) AS PayingPlayers
    FROM Purchases p
    JOIN Items i    ON p.ItemID = i.ItemID
    JOIN Sessions s ON p.SessionID = s.SessionID
    GROUP BY Month
) AS r ON r.Month = a.Month
ORDER BY a.Month;
