-- ============================================================
-- 01 — SELECT, Filtering, and Sorting
-- ============================================================
--
-- Basic SQL queries demonstrating:
-- SELECT, WHERE, ORDER BY, DISTINCT, NULL checks,
-- boolean conditions, and simple joins.
-- ============================================================


-- ------------------------------------------------------------
-- Retrieve Finnish artists and sort them alphabetically.
-- ------------------------------------------------------------

SELECT
    name,
    yearBorn,
    birthplace
FROM Artist
WHERE nationality = 'Finland'
ORDER BY name ASC;


-- ------------------------------------------------------------
-- Find paintings valued above 1,000,000.
-- ------------------------------------------------------------

SELECT
    title,
    price
FROM Artwork
WHERE type = 'painting'
AND price > 1000000
ORDER BY price DESC;


-- ------------------------------------------------------------
-- Find museums located in Oulu or Helsinki.
-- ------------------------------------------------------------

SELECT
    name,
    city
FROM Location
WHERE locationType = 'museum'
AND (city = 'Oulu' OR city = 'Helsinki');


-- ------------------------------------------------------------
-- Find paintings or sculptures valued above 50,000.
-- ------------------------------------------------------------

SELECT
    title,
    price,
    type
FROM Artwork
WHERE price > 50000
AND (type = 'painting' OR type = 'sculpture');


-- ------------------------------------------------------------
-- List exhibitions that have visitor information available,
-- together with information about their locations.
-- ------------------------------------------------------------

SELECT
    e.title,
    e.startDate,
    e.endDate,
    e.numberOfVisitors,
    l.name,
    l.city,
    l.country
FROM Exhibition AS e
JOIN Location AS l
    ON e.locationId = l.locationId
WHERE e.numberOfVisitors IS NOT NULL
ORDER BY e.numberOfVisitors DESC;


-- ------------------------------------------------------------
-- Find cities containing museum exhibitions with
-- more than 5,000 visitors.
-- ------------------------------------------------------------

SELECT DISTINCT
    l.city
FROM Exhibition AS e
JOIN Location AS l
    ON e.locationId = l.locationId
WHERE l.locationType = 'museum'
AND e.numberOfVisitors > 5000
ORDER BY e.numberOfVisitors DESC;
