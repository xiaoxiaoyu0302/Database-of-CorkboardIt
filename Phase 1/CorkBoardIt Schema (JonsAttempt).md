# CorkBoardIt Schema (Jon's attempt)
This document outlines the schema for the CorkBoardIt application.

## Entities
These are the entities and related attributes that must be included in the application.
* User
	* Id (Unique Identifier)
		* Having an Id instead of email will make the relationships easier
		* Datatype: int (autoinc)
    * E-mail
        * Username for User.
        * Datatype: VARCHAR(255)
    * PIN
        * Users are required to use a 4-digit PIN for login. Hashing is not required for this PIN.
        * Datatype: VARCHAR(4)
    * First Name
        * User's first name.
        * Datatype: VARCHAR(255)
    * Last Name
        * User's last name.
        * Datatype: VARCHAR(255)

* CorkBoard
	* Id (Unique Identifier)
		* Having an Id instead of using title will make the relationships easier
		* Datatype: int (autoinc)
    * Title
        * Title of the corkboard. Each Corkboard for a given user must have a different title. The title must also be short enough to be displayed on the application. Titles are not unique across all Corkboards.
        * Datatype: VARCHAR(50)
    * IsPrivate
        * if == 1, Password authentication is required to view private Corkboards (even if the owner is attempting to view).
		* if == 0, Anyone can view the Corkboard.
		* Datatype: Short
	* Password
		* Password protecting the private Corkboard. Hashing is not required for the password.
		* Datatype: VARCHAR(50)

* Pushpin
	* Id (Unique Identifier)
		* Having an Id instead of using title will make the relationships easier
		* Datatype: int (autoinc)
    * Image hyperlink
        * Image location.
        * Datatype: VARCHAR(255)
    * Title
        * Title of the image used in the Pushpin.
        * Datatype: VARCHAR(50)
    * Description
        * Datatype: VARCHAR(200)
    * Time added
        * Most recent pushpin addition determines the update timestamp of the Corkboard.
        * Datatype: TIMESTAMP

* Category
	* Id (Unique Identifier)
		* Datatype: int (autoinc)
	* Name
		* Datatype: VARCHAR(255)

* Tag
	* Id (Unique Identifier)
		* Datatype: int (autoinc)
	* Name
		* Datatype: VARCHAR(20)

* Comment
	* Id (Unique Identifier)
		* Datatype: int (autoinc)
    * Text
        * Datatype: TEXT
    * Time added
        * Datatype: TIMESTAMP

## Relationships

* Watches (User -> CorkBoard)
	* A user can watch any number of CorkBoards
	* Each User has a list of CorkBoards that they watch
    * Cardinality: 1 to Many
* Owns (User -> CorkBoard)
    * A user can own any number of Corkboards, but each Corkboard can only be owned by one user. A corkboard cannot exist without ownership.
    * Cardinality: 1 to Many
* Follows (User -> User)
    * A user can follow any number of other users.
	* Each user has a list of users they follow.
    * Cardinality: 1 to Many
* IsOn (CorkBoard -> Pushpin)
    * Many Pushpins are owned by a single CorkBoard, which is owned by a single user.
    * Cardinality: 1 to Many
* HasCategory (Category -> CorkBoard)
	* A CorkBoard has a Category
	* A CorkBoard can only have one Category
	* A Category can have many CorkBoards
	* Cardinality: 1 to Many
* IsTagged (Pushpin <-> Tag)
	* A pushpin can have many tags
	* A tag can appear on many pushpins
	* Cardinality: Many to Many
* Likes (User <-> Pushpin)
    * Any number of users are able to like any number of Pushpins. They are also able to rescind these likes.
    * Cardinality: Many to Many
* Commented (User <-> Pushpin)
    * Any number of users can comment on any number of Pushpins. Comments cannot be deleted.
    * Cardinality: Many to Many