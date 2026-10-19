SELECT 
    CASE 
        WHEN p.Age < 18 THEN 'Under 18'
        WHEN p.Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN p.Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN p.Age BETWEEN 36 AND 50 THEN '36-50'
        WHEN p.Age > 50 THEN 'Over 50'
    END AS age_group,
    COUNT(s.SessionID) AS total_sessions,
    COUNT(DISTINCT p.PlayerID) AS unique_players,
    ROUND(COUNT(s.SessionID) * 1.0 / COUNT(DISTINCT p.PlayerID), 2) AS avg_sessions_per_player,
    COUNT(DISTINCT DATE(s.StartTime)) AS active_days
FROM Players p
LEFT JOIN Sessions s ON p.PlayerID = s.PlayerID
WHERE s.StartTime IS NOT NULL
GROUP BY age_group
ORDER BY MIN(p.Age);