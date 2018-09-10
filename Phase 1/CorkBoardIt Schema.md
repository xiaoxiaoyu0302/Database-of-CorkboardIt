# CorkBoardIt Schema
This document outlines the schema for the CorkBoardIt application.

## Entities
These are the entities and related attributes that must be included in the application.
* User
    * Email (Unique identifier)
    * PIN (Note: hashing is not required.)

* CorkBoard (Weak)
    * Title
    * Category
    1. Public (Sub-type)
    2. Private (Sub-type)
        * Password (Note: hashing is not required.)

* Pushpin (Weak)
    * Image hyperlink
    * Title
    * Description
        * Datatype: VARCHAR(200)
    * Tag
        * Multi-value attribute
        * Datatype: VARCHAR(20)
    * Time added
        * Datatype: TIMESTAMP

* Comment (Weak)   
    * Text
    * Time added
        * Datatype: TIMESTAMP

## Relationships

* Watches (User - CorkBoard)
    * Cardinality: Many to Many
* Follows (User - User)
    * Cardinality: Many to Many
* Owns (User - CorkBoard)
    * Cardinality: 1 to Many
* IsOn (Pushpin - CorkBoard)
    * Cardinality: Many to 1
* Likes (User - Pushpin)
    * Cardinality: Many to Many
* Commented (User - Pushpin)
    * Cardinality: Many to Many