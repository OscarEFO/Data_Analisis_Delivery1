SELECT
    pl.PlayerID,
    pl.Country,
    pl.Age,
    CASE WHEN pl.Gender < 0.5 THEN 'M' ELSE 'F' END AS Gender,
    DATE(pl.CreateDate) AS InstallDate,
    (SELECT COUNT(*) FROM Sessions s WHERE s.PlayerID = pl.PlayerID) AS Sessions,
    (SELECT AVG(s.SessionLengthSeconds) FROM Sessions s WHERE s.PlayerID = pl.PlayerID) AS AvgSessionSeconds,
    (SELECT COALESCE(SUM(i.Price), 0)
       FROM Sessions s
       JOIN Purchases p ON p.SessionID = s.SessionID
       JOIN Items i     ON i.ItemID = p.ItemID
      WHERE s.PlayerID = pl.PlayerID) AS Revenue,
    EXISTS (SELECT 1 FROM Sessions s WHERE s.PlayerID = pl.PlayerID
            AND DATE(s.StartTime) = DATE(pl.CreateDate) + INTERVAL 1 DAY) AS D1,
    EXISTS (SELECT 1 FROM Sessions s WHERE s.PlayerID = pl.PlayerID
            AND DATE(s.StartTime) = DATE(pl.CreateDate) + INTERVAL 3 DAY) AS D3,
    EXISTS (SELECT 1 FROM Sessions s WHERE s.PlayerID = pl.PlayerID
            AND DATE(s.StartTime) = DATE(pl.CreateDate) + INTERVAL 7 DAY) AS D7
FROM Players pl
ORDER BY pl.PlayerID;
