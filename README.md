# Hrvatski Kviz Savez
Players and scores of quizzing competitions

## 1. Motivation behind
In the last ten years, the Croatian Quizzing Association has organized hundreds of quizzes, the results of which are scattered in many XLSX tables. The tables contain the names of the players, the locations where they played, and the points achieved, i.e. the number of correct answers. The main goal is to build a relational database from the scratch, first ever in Croatian Quizzing Association. After that, using analytical and/or visual tools:
   
- to analyze the success of the players
- to measure the difficulty level of the quizzes
- to analyze attendance by city, especially churn (the number of players who participated in only one quiz)
- to detect correlations of correct answers between categories, e.g. sports-history

## 2. Data Model

The tech used is SQL Server Management Studio. The model is designed as a star schema to optimize analytical queries.

Dimension tables:
```text
Categories – categoryID (PK), name - 14 rows
Players – playerID (PK), name - 904 rows
Quizes – quizID (PK), name, date, maxpoints, author - 93 rows
Venues – venueID (PK), city, country, latitude, longitude - 38 rows
```
Fact tables:
```text
Scores – scoreID (PK), quizID (FK), playerID (FK), venueID (FK), rank, points - 7836 rows
CategoryScores – scoreID (PK), categoryID (FK), points - 56875 rows
```

## 3. ETL Process

1. Create CSV from XLSX files
2. Import CSV file into SQL Server
3. Validate data types
4. Clean up NULL values, rename column names to be consistent
5. Add new quiz to Quizes:
   
```sql
INSERT INTO Quizes (QuizID, Name, Date, MaxPoints, Author)
VALUES (
    92,
    'S7K2',
    '2026-01',
    84,
    'Josip Rončević'
);
```
6. Add new players to Players:
   
```sql
INSERT INTO Players (Name)
SELECT DISTINCT
    k.ime_i_prezime
FROM S7K2 k
WHERE k.ime_i_prezime IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM Players p
      WHERE p.Name = k.ime_i_prezime
      );
```
7. Add new venues to Venues:
   
```sql
INSERT INTO Venues (City)
SELECT DISTINCT
    k.grad
FROM S7K2 k
WHERE k.grad IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM Venues v
      WHERE v.City = k.grad
  );
```
8.  Load scores to Scores:

```sql
INSERT INTO Scores (
    ScoreID,
    QuizID,
    PlayerID,
    VenueID,
    Rank,
    Points
)
SELECT
    NEXT VALUE FOR score_seq AS ScoreID,
    92 AS QuizID,
    p.PlayerID,
    v.VenueID,
    Mjesto,
    Ukupno
FROM S7K2
JOIN Players p ON p.Name = S7K2.ime_i_prezime
JOIN Venues  v ON v.City = S7K2.grad;
```
9. Load score of each category to CategoryScores:

```sql
INSERT INTO CategoryScores (ScoreID, CategoryID, Points)
SELECT
    s.ScoreID,
    c.CategoryID,
    ca.Points
FROM S7K2 src
JOIN Players p
    ON p.Name = src.ime_i_prezime
JOIN Scores s
    ON s.PlayerID = p.PlayerID
   AND s.QuizID = 92
   AND s.Points = src.ukupno
CROSS APPLY (
    VALUES
        ('History',       src.Povijest),
        ('PopArts',       src.Pop_kultura),
        ('Nature',        src.Priroda),
        ('SportGames',    src.Sport_i_igre),
        ('Society',       src.Društvo),
        ('Lifestyle',     src.Lifestyle),
        ('FineArts',      src.Visoka_kultura)
) ca(CategoryName, Points)
JOIN Categories c
    ON c.Name = ca.CategoryName;
```

## 4. Analytical queries

```sql
/* number of players in all HR-12x7 quizzes */
SELECT
COUNT(DISTINCT s.PlayerID) AS BrojIgrača
FROM Scores s
JOIN Quizes q
    ON q.QuizID = s.QuizID
WHERE q.MaxPoints = 84;

/* number of different authors of HR-12x7 quizzes */
SELECT
COUNT(DISTINCT q.Author) AS BrojAutora
FROM Quizes q
WHERE q.MaxPoints = 84;

/* number of different locations of HR-12x7 quizzes */
SELECT
COUNT(DISTINCT s.VenueID) AS BrojLokacija
FROM Scores s
JOIN Quizes q ON q.QuizID = s.QuizID
JOIN Venues v ON v.VenueID = s.VenueID
WHERE q.MaxPoints = 84;

/* average number of players and percentage of correct answers on HR-12x7 quizzes */
SELECT 
    AVG(CAST(BrojIgraca AS DECIMAL)) AS ProsjekBrojaIgraca,
    AVG(CAST(ProsjekBodova AS DECIMAL))/84*100 AS PostotakTocnihOdgovora
FROM (
    SELECT 
        s.QuizID,
        COUNT(DISTINCT s.PlayerID) AS BrojIgraca,
        AVG(s.Points) AS ProsjekBodova
    FROM Scores s
    JOIN Quizes q ON q.QuizID = s.QuizID
    WHERE q.MaxPoints = 84
    GROUP BY s.QuizID
) x;

/* number of perfect 12s on HR-12x7 quizzes */
SELECT
    p.Name AS Natjecatelj,
    COUNT(cs.ScoreID) AS Broj12ica,
    COUNT(DISTINCT s_all.QuizID) AS OdigranihKvizova,
    STRING_AGG(c.Name, ', ') AS Kategorije
FROM Players p
JOIN Scores s_all
    ON s_all.PlayerID = p.PlayerID
JOIN Quizes q
    ON q.QuizID = s_all.QuizID
LEFT JOIN CategoryScores cs
    ON cs.ScoreID = s_all.ScoreID
   AND cs.Points = 12
LEFT JOIN Categories c
    ON c.CategoryID = cs.CategoryID
WHERE q.MaxPoints = 84
GROUP BY p.Name
ORDER BY Broj12ica DESC;
```

## 5. Visuals

The technology used is Microsoft Power BI. Six report pages were generated: https://tinyurl.com/HR-12x7

```text
Page 1: HR-12x7 table view of all quizzes played, sorted by percentage of correct answers

Page 2: HR-12x7 number of players and percentage of correct answers for each quiz chronologically; players with the most appearances

Page 3: HR-12x7 top 10 players with more than 10 quizzes played

Page 4: HR-12x7 top 5 players in each category with more than 10 quizzes played

Page 5: HR-12x7 number of different players in each city

Page 6: HR-12x7 ratio of each category (use slicer) to total points for players with more than 5 quizzes played
```
