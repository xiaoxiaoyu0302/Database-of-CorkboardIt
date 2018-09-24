-- Our database will be using the Postgres engine.

-- Tables
DROP TABLE IF EXISTS "User";
CREATE TABLE "User" (
  email VARCHAR(255) PRIMARY KEY NOT NULL,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  PIN VARCHAR(4) NOT NULL
);

DROP TABLE IF EXISTS "Pushpin";
CREATE TABLE "Pushpin" (
  id SERIAL PRIMARY KEY NOT NULL,
  description TEXT,
  image_link TEXT NOT NULL,
  time_added TIMESTAMP NOT NULL
);

DROP TABLE IF EXISTS "Corkboard";
CREATE TABLE "Corkboard" (
  id SERIAL PRIMARY KEY NOT NULL,
  title VARCHAR(255) NOT NULL,
  category VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS "Comment";
CREATE TABLE "Comment" (
  id SERIAL PRIMARY KEY NOT NULL,
  pushpin_id INTEGER,
  text TEXT NOT NULL,
  time_added TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS "Tag";
CREATE TABLE "Tag" (
  text TEXT NOT NULL,
  pushpin_id INTEGER NOT NULL,
  PRIMARY KEY(text, pushpin_id)
);

DROP TABLE IF EXISTS "Like";
CREATE TABLE "Like" (
  user_email VARCHAR(255) NOT NULL,
  pushpin_id INTEGER NOT NULL,
  PRIMARY KEY(user_email, pushpin_id)
);

DROP TABLE IF EXISTS "Follow";
CREATE TABLE "Follow" (
  user_email VARCHAR(255) NOT NULL,
  followed_user_email varchar(255) NOT NULL,
  PRIMARY KEY(user_email, followed_user_email)
);

DROP TABLE IF EXISTS "Watch";
CREATE TABLE "Watch" (
  user_email VARCHAR(255) NOT NULL,
  corkboard_id INTEGER NOT NULL,
  PRIMARY KEY(user_email, corkboard_id)
);

-- Constraints
