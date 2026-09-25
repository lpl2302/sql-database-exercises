-- ============================================================
-- 03 — Subqueries
-- ============================================================
--
-- Examples of nested and correlated queries.
-- ============================================================


-- ------------------------------------------------------------
-- Find non-painting artworks that have not appeared in
-- exhibitions held in Finland.
-- ------------------------------------------------------------

SELECT
    a.title,
    a.year,
    a.type
FROM Artwork AS a
WHERE a.type <> 'painting'
AND a.artworkId NOT IN (
    SELECT
        oe.artworkId
    FROM On_Exhibition AS oe
    JOIN Exhibition AS e
        ON oe.exhibitionId = e.exhibitionId
    JOIN Location AS l
        ON e.locationId = l.locationId
    WHERE l.country = 'Finland'
)
ORDER BY a.artworkId ASC;


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
-- Find the most-liked artwork in each exhibition.
--
-- The subquery is correlated with the outer exhibition.
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
