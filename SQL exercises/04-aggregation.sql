-- ============================================================
-- 04 — Aggregation
-- ============================================================
--
-- Examples using:
-- COUNT, SUM, AVG, MIN, GROUP BY, HAVING,
-- DISTINCT, and conditional aggregation.
-- ============================================================


-- ------------------------------------------------------------
-- Calculate total exhibition visitors for each museum.
-- ------------------------------------------------------------

SELECT
    l.name,
    SUM(e.numberOfVisitors) AS totalVisitors
FROM Location AS l
JOIN Exhibition AS e
    ON l.locationId = e.locationId
WHERE l.locationType = 'museum'
GROUP BY
    l.locationId,
    l.name
ORDER BY l.name ASC;


-- ------------------------------------------------------------
-- Calculate the number and combined value of artworks
-- belonging to each collection.
-- ------------------------------------------------------------

SELECT
    c.name,
    COUNT(a.artworkId) AS numberOfArtworks,
    SUM(a.price) AS totalValue
FROM Collection AS c
JOIN Artwork AS a
    ON c.collectionId = a.collectionId
GROUP BY
    c.collectionId,
    c.name
HAVING SUM(a.price) IS NOT NULL
ORDER BY c.name ASC;


-- ------------------------------------------------------------
-- Calculate the average number of likes received by artworks
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
-- Find artists whose artworks received at least one like in
-- every exhibition in which the artist participated.
--
-- Conditional aggregation is used inside HAVING.
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
