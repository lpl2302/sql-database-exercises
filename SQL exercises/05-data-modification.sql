-- ============================================================
-- 05 — Data Modification
-- ============================================================
--
-- Examples using INSERT, UPDATE, and DELETE.
--
-- NOTE:
-- These statements originally came from separate database
-- exercises. They are included here as examples of SQL data
-- modification and are not intended to be run as one migration.
-- ============================================================


-- ------------------------------------------------------------
-- INSERT
-- Add a new exhibition.
-- ------------------------------------------------------------

INSERT INTO Exhibition (
    title,
    startDate,
    endDate,
    isOnlineExhibition,
    locationId
)
VALUES (
    'Navigating North',
    '2022-10-07',
    '2023-04-02',
    1,
    2
);


-- ------------------------------------------------------------
-- UPDATE
-- Add visitor statistics to an existing exhibition.
-- ------------------------------------------------------------

UPDATE Exhibition
SET
    numberOfVisitors = 14000,
    numberOfOnlineVisitors = 50000
WHERE title = 'Navigating North'
AND startDate = '2022-10-07'
AND endDate = '2023-04-02'
AND isOnlineExhibition = 1
AND locationId = (
    SELECT locationId
    FROM Location
    WHERE name = 'Museum of Contemporary Art Kiasma'
);


-- ------------------------------------------------------------
-- UPDATE
-- Move an artwork into the Oulu Museum of Art collection.
-- ------------------------------------------------------------

UPDATE Artwork
SET collectionId = (
    SELECT collectionId
    FROM Collection
    WHERE name = 'Collection of the Oulu Museum of Art'
)
WHERE title = 'La Merenda'
AND year = '1904'
AND type = 'painting'
AND material = 'oil on canvas'
AND artistId = (
    SELECT artistId
    FROM Artist
    WHERE name = 'Elin Danielson-Gambogi'
);


-- ------------------------------------------------------------
-- INSERT
-- Add a new gallery location.
-- ------------------------------------------------------------

INSERT INTO Location (
    name,
    city,
    country,
    locationType
)
VALUES (
    'Cultural Center Valve Gallery',
    'Oulu',
    'Finland',
    'art gallery'
);


-- ------------------------------------------------------------
-- INSERT
-- Add an exhibition using the new gallery as its location.
-- ------------------------------------------------------------

INSERT INTO Exhibition (
    title,
    startDate,
    endDate,
    isOnlineExhibition,
    locationId
)
VALUES (
    'New North - New Perspectives',
    '2022-09-10',
    '2022-10-16',
    1,
    (
        SELECT locationId
        FROM Location
        WHERE name = 'Cultural Center Valve Gallery'
        AND city = 'Oulu'
        AND country = 'Finland'
        AND locationType = 'art gallery'
    )
);


-- ------------------------------------------------------------
-- INSERT
-- Add a new artwork by Juuso Noronkoski.
-- ------------------------------------------------------------

INSERT INTO Artwork (
    title,
    year,
    type,
    artistId
)
VALUES (
    'All That Is Solid Melts into Air',
    '2019',
    'photography',
    (
        SELECT artistId
        FROM Artist
        WHERE name = 'Juuso Noronkoski'
    )
);


-- ------------------------------------------------------------
-- INSERT
-- Connect the artwork to an exhibition and initialize
-- its like statistics.
-- ------------------------------------------------------------

INSERT INTO On_Exhibition (
    artworkId,
    exhibitionId,
    numberOfLikes,
    numberOfOnlineLikes
)
VALUES (
    (
        SELECT artworkId
        FROM Artwork
        WHERE title = 'All That Is Solid Melts into Air'
        AND year = '2019'
        AND type = 'photography'
        AND artistId = (
            SELECT artistId
            FROM Artist
            WHERE name = 'Juuso Noronkoski'
        )
    ),
    (
        SELECT exhibitionId
        FROM Exhibition
        WHERE title = 'New North - New Perspectives'
        AND startDate = '2022-09-10'
        AND endDate = '2022-10-16'
    ),
    0,
    0
);


-- ------------------------------------------------------------
-- DELETE
-- Remove dependent artwork/exhibition relationships before
-- deleting the exhibition itself.
-- ------------------------------------------------------------

DELETE FROM On_Exhibition
WHERE exhibitionId = (
    SELECT e.exhibitionId
    FROM Exhibition AS e
    WHERE e.title = 'New North - New Perspectives'
    AND e.startDate = '2022-09-10'
    AND e.endDate = '2022-10-16'
    AND e.locationId = (
        SELECT l.locationId
        FROM Location AS l
        WHERE l.name = 'Cultural Center Valve Gallery'
        AND l.city = 'Oulu'
        AND l.country = 'Finland'
    )
);


-- ------------------------------------------------------------
-- DELETE
-- Delete the exhibition after its dependent rows have
-- been removed.
-- ------------------------------------------------------------

DELETE FROM Exhibition
WHERE title = 'New North - New Perspectives'
AND startDate = '2022-09-10'
AND endDate = '2022-10-16'
AND locationId = (
    SELECT l.locationId
    FROM Location AS l
    WHERE l.name = 'Cultural Center Valve Gallery'
    AND l.city = 'Oulu'
    AND l.country = 'Finland'
);
