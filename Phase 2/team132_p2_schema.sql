-- Tables
CREATE TABLE User (
  email VARCHAR(255) NOT NULL,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  PIN VARCHAR(4) NOT NULL,
  PRIMARY KEY (email)
);

CREATE TABLE Corkboard (

);

CREATE TABLE Pushpin (
  id INT(11) NOT NULL AUTO_INCREMENT,
  description TEXT,
  image_link TEXT NOT NULL,
  time_added TIMESTAMP NOT NULL
  PRIMARY KEY (id)
);

CREATE TABLE Comment (
  id INT(11) NOT NULL AUTO_INCREMENT,
  text TEXT NOT NULL,
  time_added TIMESTAMP NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE Tag (

);

CREATE TABLE Like (

);

CREATE TABLE Follow (

);

CREATE TABLE Watch (

);

-- Constraints
