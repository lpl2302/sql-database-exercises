-- ============================================================
-- 02 — JOIN Operations
-- ============================================================
--
-- Examples of combining related relational tables using
-- JOIN operations, including a self join.
-- ============================================================


-- ------------------------------------------------------------
-- Match derivative/reproduction artworks with their
-- corresponding original artwork.
--
-- This is a self join because Artwork is joined with itself.
-- ------------------------------------------------------------

SELECT
    r.title,
    r.year,
    r.type,
    r.material,
    o.title,
    o.year,
    o.type,
    o.material
FROM Artwork AS r
JOIN Artwork AS o
    ON r.original_artworkId = o.artworkId
WHERE r.original_artworkId IS NOT NULL;


-- ------------------------------------------------------------
-- Find exhibitions that contain artworks from only one artist.
--
-- This query joins:
-- Exhibition -> On_Exhibition -> Artwork -> Artist
-- ------------------------------------------------------------

SELECT
    e.title,
    MIN(ar.name) AS artistName,
    e.numberOfVisitors
FROM Exhibition AS e
JOIN On_Exhibition AS oe
    ON e.exhibitionId = oe.exhibitionId
JOIN Artwork AS a
    ON oe.artworkId = a.artworkId
JOIN Artist AS ar
    ON a.artistId = ar.artistId
GROUP BY
    e.exhibitionId,
    e.title,
    e.numberOfVisitors
HAVING COUNT(DISTINCT a.artistId) = 1
ORDER BY e.title ASC;


-- ------------------------------------------------------------
-- Find artists whose artwork was exhibited in a city that
-- matches the artist's birthplace.
--
-- This demonstrates a five-table join.
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
    