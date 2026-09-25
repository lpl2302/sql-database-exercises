-- ============================================================
-- 06 — Advanced SQL Queries
-- ============================================================
--
-- Queries combining multiple SQL concepts such as:
-- UNION, date functions, CAST, correlated subqueries,
-- multi-table joins, and conditional aggregation.
-- ============================================================


-- ------------------------------------------------------------
-- Calculate artist ages.
--
-- For deceased artists, age is calculated using yearDied.
-- For living artists, the current year is obtained using
-- SQLite's strftime() function.
-- ------------------------------------------------------------

SELECT
    name,
    CAST(yearDied AS INTEGER)
        - CAST(yearBorn AS INTEGER) AS age
FROM Artist
WHERE yearDied IS NOT NULL

UNION

SELECT
    name,
    CAST(strftime('%Y', 'now') AS INTEGER)
        - CAST(yearBorn AS INTEGER) AS age
FROM Artist
WHERE yearDied IS NULL

ORDER BY
    age ASC,
    name ASC;


-- ------------------------------------------------------------
-- Find the oldest artwork or artworks in the database.
-- ------------------------------------------------------------

SELECT
    title,
    year
FROM Artwork
WHERE year = (
    SELECT MIN(year)
    FROM Artwork
);


-- ------------------------------------------------------------
-- Calculate the average number of likes for artworks
-- in each exhibition.
-- ------------------------------------------------------------

SELECT
    e.title,
    ROUND(AVG(oe.numberOfLikes), 2) AS avg_likes
FROM Exhibition AS e
JOIN On_Exhibition AS oe
    ON e.exhibitionId = oe.exhibitionId
GROUP BY
    e.exhibitionId,
    e.title
ORDER BY avg_likes DESC;


-- ------------------------------------------------------------
-- Find the most-liked artwork in every exhibition.
--
-- A correlated subquery determines the maximum number
-- of likes separately for each exhibition.
-- ------------------------------------------------------------

SELECT
    e.title,
    a.title,
    oe.numberOfLikes
FROM Exhibition AS e
JOIN On_Exhibition AS oe
    ON e.exhibitionId = oe.exhibitionId
JOIN Artwork AS a
    ON oe.artworkId = a.artworkId
WHERE oe.numberOfLikes = (
    SELECT MAX(oe2.numberOfLikes)
    FROM On_Exhibition AS oe2
    WHERE oe2.exhibitionId = e.exhibitionId
)
ORDER BY e.title ASC;


-- ------------------------------------------------------------
-- Find artists whose artwork was displayed in an exhibition
-- located in the same city as the artist's birthplace.
-- ------------------------------------------------------------

SELECT DISTINCT
    ar.name,
    e.title,
    l.city
FROM Artist AS ar
JOIN Artwork AS a
    ON ar.artistId = a.artistId
JOIN On_Exhibition AS oe
    ON a.artworkId = oe.artworkId
JOIN Exhibition AS e
    ON oe.exhibitionId = e.exhibitionId
JOIN Location AS l
    ON e.locationId = l.locationId
WHERE ar.birthplace = l.city
ORDER BY
    ar.name ASC,
    e.title ASC;


-- ------------------------------------------------------------
-- Find artists whose artworks received at least one like
-- in every exhibition in which they participated.
-- ------------------------------------------------------------

SELECT
    ar.name
FROM Artist AS ar
JOIN Artwork AS a
    ON ar.artistId = a.artistId
JOIN On_Exhibition AS oe
    ON a.artworkId = oe.artworkId
GROUP BY
    ar.artistId,
    ar.name
HAVING COUNT(DISTINCT oe.exhibitionId) =
       COUNT(
           DISTINCT CASE
               WHEN oe.numberOfLikes > 0
               THEN oe.exhibitionId
           END
       )
ORDER BY ar.name ASC;
