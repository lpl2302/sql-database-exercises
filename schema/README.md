# Database Schema

The original database used for these exercises was provided as part of University of Oulu course material and is therefore not redistributed in this repository.

The SQL examples work with a relational database containing entities such as:

`Artist`

Stores information about artists, including names, birth years, death years, nationalities, and birthplaces.

`Artwork`

Stores individual artworks and their properties, including title, year, type, material, price, artist, and collection.

`Exhibition`

Stores information about exhibitions, including dates, visitor statistics, online status, and location.

`Location`

Stores museums, galleries, and other exhibition locations.

`Collection`

Stores artwork collections.

`On_Exhibition`

Represents the many-to-many relationship between artworks and exhibitions and contains additional information such as artwork likes.

## Relationships

The queries demonstrate relationships such as:

```text
Artist
  │
  └──< Artwork
          │
          ├──> Collection
          │
          └──< On_Exhibition >── Exhibition
                                    │
                                    └──> Location
```

`On_Exhibition` acts as an associative table between `Artwork` and `Exhibition`.

The complete original database schema and course database are not included because they are course materials.
