-- Our database will be using the Postgres engine.

-- Tables
DROP TABLE IF EXISTS "User";
CREATE TABLE "User" (
  email VARCHAR(255) PRIMARY KEY NOT NULL,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  PIN VARCHAR(4) NOT NULL
);

DROP TABLE IF EXISTS "Corkboard";
CREATE TABLE "Corkboard" (
  id SERIAL PRIMARY KEY NOT NULL,
  title VARCHAR(50) NOT NULL,
  is_private BIT NOT NULL,
  password VARCHAR(255),
  owner VARCHAR(255) NOT NULL,
  category_name VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS "Pushpin";
CREATE TABLE "Pushpin" (
  id SERIAL PRIMARY KEY NOT NULL,
  description VARCHAR(200),
  corkboard_id INTEGER NOT NULL,
  image_link TEXT NOT NULL,
  time_added TIMESTAMP NOT NULL
);

DROP TABLE IF EXISTS "Category";
CREATE TABLE "Category" (
  category_name VARCHAR(50) PRIMARY KEY NOT NULL
);

DROP TABLE IF EXISTS "Comment";
CREATE TABLE "Comment" (
  comment_id SERIAL INTEGER NOT NULL,
  comment_text TEXT NOT NULL,
  time_added TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS "Tag";
CREATE TABLE "Tag" (
  tag_text VARCHAR(20) PRIMARY KEY NOT NULL
);

DROP TABLE IF EXISTS "Liked";
CREATE TABLE "Liked" (
  user_email VARCHAR(255) NOT NULL,
  pushpin_id INTEGER NOT NULL,
  PRIMARY KEY(user_email, pushpin_id)
);

DROP TABLE IF EXISTS "Followed";
CREATE TABLE "Followed" (
  user_email VARCHAR(255) NOT NULL,
  followed_user_email varchar(255) NOT NULL,
  PRIMARY KEY(user_email, followed_user_email)
);

DROP TABLE IF EXISTS "Watched";
CREATE TABLE "Watched" (
  user_email VARCHAR(255) NOT NULL,
  corkboard_id INTEGER NOT NULL,
  PRIMARY KEY(user_email, corkboard_id)
);

DROP TABLE IF EXISTS "Tagged"
CREATE TABLE "Tagged" (
  pushpin_id INTEGER NOT NULL,
  tag_text VARCHAR(20) NOT NULL,
  PRIMARY KEY(pushpin_id, tag)
);

DROP TABLE IF EXISTS "Commented"
CREATE TABLE "Commented" (
  comment_id INTEGER NOT NULL,
  user_email VARCHAR(255) NOT NULL,
  pushpin_id INTEGER NOT NULL,
  PRIMARY KEY(comment_id, user_email, pushpin_id)
);

-- Constraints
ALTER TABLE "Corkboard"
  ADD FOREIGN KEY (owner) REFERENCES "User"(email);
  ADD FOREIGN KEY (category_name) REFERENCES "Category"(category_name);

ALTER TABLE "Pushpin"
  ADD FOREIGN KEY (corkboard_id) REFERENCES "Corkboard"(id);
  
ALTER TABLE "Comment"
  ADD FOREIGN KEY (user_email) REFERENCES "User"(email);
  ADD FOREIGN KEY (pushpin_id) REFERENCES "Pushpin"(id);
 
ALTER TABLE "Liked"
  ADD FOREIGN KEY (pushpin_id) REFERENCES "Pushpin"(id);
  ADD FOREIGN KEY (user_email) REFERENCES "User"(email);
  
ALTER TABLE "Followed"
  ADD FOREIGN KEY (user_email) REFERENCES "User"(email),
  ADD FOREIGN KEY (followed_user_email) REFERENCES "User"(email);
  
ALTER TABLE "Watched"
  ADD FOREIGN KEY (corkboard_id) REFERENCES "Corkboard"(id);
  ADD FOREIGN KEY (user_email) REFERENCES "User"(email);  

ALTER TABLE "Tagged"
  ADD FOREIGN KEY (pushpin_id) REFERENCES "Pushpin"(id);
  ADD FOREIGN KEY (tag_text) REFERENCES "Tag"(tag_text); 

ALTER TABLE "Commented"
  ADD FOREIGN KEY (comment_id) REFERENCES "Comment"(comment_id);
  ADD FOREIGN KEY (user_email) REFERENCES "User"(email);
  ADD FOREIGN KEY (pushpin_id) REFERENCES "Pushpin"(id);