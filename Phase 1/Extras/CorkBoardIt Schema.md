# CorkBoardIt Schema
This document outlines the schema for the CorkBoardIt application.

## Entities
These are the entities and related attributes that must be included in the application.
* User
    * E-mail (Unique Identifier)
        * Users are uniquely identified by their e-mail address.
        * Datatype: VARCHAR(255)
    * PIN
        * Users are required to use a 4-digit PIN for login. Hashing is not required for this PIN.
        * Datatype: VARCHAR(4)
    * Name
        * User's full name.
        * Datatype: VARCHAR(100)

* CorkBoard (Weak)
    * Title (Partial Identifier)
        * Title of the corkboard. Each Corkboard for a given user must have a different title. The title must also be short enough to be displayed on the application.
        * Datatype: VARCHAR(50)
    * Category
        * Pre-defined list of categories that must be alphabetically sorted on the application.
        * Datatype: ENUM
    1. Public (Sub-type)
        * Anyone can view the Corkboard.
    2. Private (Sub-type)
        * Password authentication is required to view private Corkboards (even if the owner is attempting to view).
        * Password
            * Password protecting the private Corkboard. Hashing is not required for the password.
            * Datatype: VARCHAR(50)

* Pushpin (Weak)
    * Image hyperlink
        * Image location.
        * Datatype: VARCHAR(255)
    * Title (Partial Identifier)
        * Title of the image used in the Pushpin.
        * Datatype: VARCHAR(50)
    * Description
        * Datatype: VARCHAR(200)
    * Tag
        * Multi-value attribute. These tags must be stored individually after parsing on the UI.
        * Datatype: VARCHAR(20)
    * Time added
        * Most recent pushpin addition determines the update timestamp of the Corkboard.
        * Datatype: TIMESTAMP

* Comment (Weak)   
    * Text
        * Datatype: TEXT
    * Time added
        * Datatype: TIMESTAMP

## Relationships

* Watches (User - CorkBoard)
    * Cardinality: Many to Many
* Follows (User - User)
    * An arbitrary number of users are able to follow each other.
    * Cardinality: Many to Many
* Owns (User - CorkBoard)
    * A user can own any number of Corkboards, but each Corkboard can only be owned by one user. A corkboard cannot exist without ownership.
    * Cardinality: 1 to Many
* IsOn (Pushpin - CorkBoard)
    * Many Pushpins are owned by a single CorkBoard, which is owned by a single user.
    * Cardinality: Many to 1
* Likes (User - Pushpin)
    * Any number of users are able to like any number of Pushpins. They are also able to rescind these likes.
    * Cardinality: Many to Many
* Commented (User - Pushpin)
    * Any number of users can comment on any number of Pushpins. Comments cannot be deleted.
    * Cardinality: Many to Many