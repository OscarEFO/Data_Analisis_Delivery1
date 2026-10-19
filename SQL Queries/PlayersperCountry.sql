SELECT 
    Country,
    COUNT(*) AS TotalPlayers
FROM Players
GROUP BY Country
ORDER BY TotalPlayers DESC;
