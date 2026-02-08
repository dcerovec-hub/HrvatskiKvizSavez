WITH Pivoted AS (
    SELECT
        s.ScoreID,
        MAX(CASE WHEN c.Name = 'FineArts'   THEN cs.Points END) AS FineArts,
        MAX(CASE WHEN c.Name = 'PopArts'    THEN cs.Points END) AS PopArts,
        MAX(CASE WHEN c.Name = 'Lifestyle'  THEN cs.Points END) AS Lifestyle,
        MAX(CASE WHEN c.Name = 'SportGames' THEN cs.Points END) AS SportGames,
        MAX(CASE WHEN c.Name = 'Society'    THEN cs.Points END) AS Society,
        MAX(CASE WHEN c.Name = 'Nature'     THEN cs.Points END) AS Nature,
        MAX(CASE WHEN c.Name = 'History'    THEN cs.Points END) AS History
    FROM Scores s
    JOIN CategoryScores cs ON cs.ScoreID = s.ScoreID
    JOIN Categories c      ON c.CategoryID = cs.CategoryID
    GROUP BY s.ScoreID
),
Corr AS (
    SELECT 'FineArts' AS CategoryA, 'PopArts' AS CategoryB,
        (AVG(FineArts * PopArts) - AVG(FineArts) * AVG(PopArts))
        / NULLIF(SQRT(
            (AVG(FineArts*FineArts) - POWER(AVG(FineArts),2)) *
            (AVG(PopArts*PopArts)   - POWER(AVG(PopArts),2))
        ),0) AS Correlation
    FROM Pivoted

    UNION ALL
    SELECT 'FineArts','Lifestyle',
        (AVG(FineArts * Lifestyle) - AVG(FineArts) * AVG(Lifestyle))
        / NULLIF(SQRT(
            (AVG(FineArts*FineArts) - POWER(AVG(FineArts),2)) *
            (AVG(Lifestyle*Lifestyle) - POWER(AVG(Lifestyle),2))
        ),0)
    FROM Pivoted

    UNION ALL
    SELECT 'FineArts','SportGames',
        (AVG(FineArts * SportGames) - AVG(FineArts) * AVG(SportGames))
        / NULLIF(SQRT(
            (AVG(FineArts*FineArts) - POWER(AVG(FineArts),2)) *
            (AVG(SportGames*SportGames) - POWER(AVG(SportGames),2))
        ),0)
    FROM Pivoted

    UNION ALL
    SELECT 'FineArts','Society',
        (AVG(FineArts * Society) - AVG(FineArts) * AVG(Society))
        / NULLIF(SQRT(
            (AVG(FineArts*FineArts) - POWER(AVG(FineArts),2)) *
            (AVG(Society*Society) - POWER(AVG(Society),2))
        ),0)
    FROM Pivoted

    UNION ALL
    SELECT 'FineArts','Nature',
        (AVG(FineArts * Nature) - AVG(FineArts) * AVG(Nature))
        / NULLIF(SQRT(
            (AVG(FineArts*FineArts) - POWER(AVG(FineArts),2)) *
            (AVG(Nature*Nature) - POWER(AVG(Nature),2))
        ),0)
    FROM Pivoted

    UNION ALL
    SELECT 'FineArts','History',
        (AVG(FineArts * History) - AVG(FineArts) * AVG(History))
        / NULLIF(SQRT(
            (AVG(FineArts*FineArts) - POWER(AVG(FineArts),2)) *
            (AVG(History*History) - POWER(AVG(History),2))
        ),0)
    FROM Pivoted

    UNION ALL
    SELECT 'PopArts','Lifestyle',
        (AVG(PopArts * Lifestyle) - AVG(PopArts) * AVG(Lifestyle))
        / NULLIF(SQRT(
            (AVG(PopArts*PopArts) - POWER(AVG(PopArts),2)) *
            (AVG(Lifestyle*Lifestyle) - POWER(AVG(Lifestyle),2))
        ),0)
    FROM Pivoted

    UNION ALL
    SELECT 'PopArts','SportGames',
        (AVG(PopArts * SportGames) - AVG(PopArts) * AVG(SportGames))
        / NULLIF(SQRT(
            (AVG(PopArts*PopArts) - POWER(AVG(PopArts),2)) *
            (AVG(SportGames*SportGames) - POWER(AVG(SportGames),2))
        ),0)
    FROM Pivoted

    UNION ALL
    SELECT 'PopArts','Society',
        (AVG(PopArts * Society) - AVG(PopArts) * AVG(Society))
        / NULLIF(SQRT(
            (AVG(PopArts*PopArts) - POWER(AVG(PopArts),2)) *
            (AVG(Society*Society) - POWER(AVG(Society),2))
        ),0)
    FROM Pivoted

    UNION ALL
    SELECT 'PopArts','Nature',
        (AVG(PopArts * Nature) - AVG(PopArts) * AVG(Nature))
        / NULLIF(SQRT(
            (AVG(PopArts*PopArts) - POWER(AVG(PopArts),2)) *
            (AVG(Nature*Nature) - POWER(AVG(Nature),2))
        ),0)
    FROM Pivoted

    UNION ALL
    SELECT 'PopArts','History',
        (AVG(PopArts * History) - AVG(PopArts) * AVG(History))
        / NULLIF(SQRT(
            (AVG(PopArts*PopArts) - POWER(AVG(PopArts),2)) *
            (AVG(History*History) - POWER(AVG(History),2))
        ),0)
    FROM Pivoted

    UNION ALL
    SELECT 'Lifestyle','SportGames',
        (AVG(Lifestyle * SportGames) - AVG(Lifestyle) * AVG(SportGames))
        / NULLIF(SQRT(
            (AVG(Lifestyle*Lifestyle) - POWER(AVG(Lifestyle),2)) *
            (AVG(SportGames*SportGames) - POWER(AVG(SportGames),2))
        ),0)
    FROM Pivoted

    UNION ALL
    SELECT 'Lifestyle','Society',
        (AVG(Lifestyle * Society) - AVG(Lifestyle) * AVG(Society))
        / NULLIF(SQRT(
            (AVG(Lifestyle*Lifestyle) - POWER(AVG(Lifestyle),2)) *
            (AVG(Society*Society) - POWER(AVG(Society),2))
        ),0)
    FROM Pivoted

    UNION ALL
    SELECT 'Lifestyle','Nature',
        (AVG(Lifestyle * Nature) - AVG(Lifestyle) * AVG(Nature))
        / NULLIF(SQRT(
            (AVG(Lifestyle*Lifestyle) - POWER(AVG(Lifestyle),2)) *
            (AVG(Nature*Nature) - POWER(AVG(Nature),2))
        ),0)
    FROM Pivoted

    UNION ALL
    SELECT 'Lifestyle','History',
        (AVG(Lifestyle * History) - AVG(Lifestyle) * AVG(History))
        / NULLIF(SQRT(
            (AVG(Lifestyle*Lifestyle) - POWER(AVG(Lifestyle),2)) *
            (AVG(History*History) - POWER(AVG(History),2))
        ),0)
    FROM Pivoted

    UNION ALL
    SELECT 'SportGames','Society',
        (AVG(SportGames * Society) - AVG(SportGames) * AVG(Society))
        / NULLIF(SQRT(
            (AVG(SportGames*SportGames) - POWER(AVG(SportGames),2)) *
            (AVG(Society*Society) - POWER(AVG(Society),2))
        ),0)
    FROM Pivoted

    UNION ALL
    SELECT 'SportGames','Nature',
        (AVG(SportGames * Nature) - AVG(SportGames) * AVG(Nature))
        / NULLIF(SQRT(
            (AVG(SportGames*SportGames) - POWER(AVG(SportGames),2)) *
            (AVG(Nature*Nature) - POWER(AVG(Nature),2))
        ),0)
    FROM Pivoted

    UNION ALL
    SELECT 'SportGames','History',
        (AVG(SportGames * History) - AVG(SportGames) * AVG(History))
        / NULLIF(SQRT(
            (AVG(SportGames*SportGames) - POWER(AVG(SportGames),2)) *
            (AVG(History*History) - POWER(AVG(History),2))
        ),0)
    FROM Pivoted

    UNION ALL
    SELECT 'Society','Nature',
        (AVG(Society * Nature) - AVG(Society) * AVG(Nature))
        / NULLIF(SQRT(
            (AVG(Society*Society) - POWER(AVG(Society),2)) *
            (AVG(Nature*Nature) - POWER(AVG(Nature),2))
        ),0)
    FROM Pivoted

    UNION ALL
    SELECT 'Society','History',
        (AVG(Society * History) - AVG(Society) * AVG(History))
        / NULLIF(SQRT(
            (AVG(Society*Society) - POWER(AVG(Society),2)) *
            (AVG(History*History) - POWER(AVG(History),2))
        ),0)
    FROM Pivoted

    UNION ALL
    SELECT 'Nature','History',
        (AVG(Nature * History) - AVG(Nature) * AVG(History))
        / NULLIF(SQRT(
            (AVG(Nature*Nature) - POWER(AVG(Nature),2)) *
            (AVG(History*History) - POWER(AVG(History),2))
        ),0)
    FROM Pivoted
)
SELECT
    CategoryA,
    CategoryB,
    Correlation
FROM Corr
WHERE Correlation IS NOT NULL
ORDER BY Correlation DESC