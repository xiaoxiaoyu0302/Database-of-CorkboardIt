-- Our database will be using the Postgres engine.

-- Tables
DROP TABLE IF EXISTS "User";
CREATE TABLE "User" (
  email VARCHAR(255) PRIMARY KEY NOT NULL,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  pin VARCHAR(4) NOT NULL
);

DROP TABLE IF EXISTS "Corkboard";
CREATE TABLE "Corkboard" (
  id SERIAL PRIMARY KEY NOT NULL,
  title VARCHAR(50) NOT NULL,
  is_private BIT NOT NULL,
  password VARCHAR(255),
  owner VARCHAR(255) NOT NULL,
  category VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS "Pushpin";
CREATE TABLE "Pushpin" (
  id SERIAL PRIMARY KEY NOT NULL,
  description VARCHAR(200),
  image_link TEXT NOT NULL,
  time_added TIMESTAMP NOT NULL,
  corkboard_id INTEGER NOT NULL
);

DROP TABLE IF EXISTS "Category";
CREATE TABLE "Category" (
  category_name VARCHAR(50) PRIMARY KEY NOT NULL
);

DROP TABLE IF EXISTS "Comment";
CREATE TABLE "Comment" (
  id SERIAL PRIMARY KEY NOT NULL,
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

DROP TABLE IF EXISTS "Tagged";
CREATE TABLE "Tagged" (
  pushpin_id INTEGER NOT NULL,
  tag_text VARCHAR(20) NOT NULL,
  PRIMARY KEY(pushpin_id, tag_text)
);

DROP TABLE IF EXISTS "Commented";
CREATE TABLE "Commented" (
  comment_id INTEGER NOT NULL,
  user_email VARCHAR(255) NOT NULL,
  pushpin_id INTEGER NOT NULL,
  PRIMARY KEY(comment_id, user_email, pushpin_id)
);

-- Constraints
ALTER TABLE "Corkboard"
  ADD CONSTRAINT fk_Corkboard_owner_User_email
  FOREIGN KEY (owner) REFERENCES "User"(email);
ALTER TABLE "Corkboard"
  ADD CONSTRAINT fk_Corkboard_category_Category_category_name
  FOREIGN KEY (category) REFERENCES "Category"(category_name);

ALTER TABLE "Pushpin"
  ADD CONSTRAINT fk_Pushpin_corkboard_id_Corkboard_id
  FOREIGN KEY (corkboard_id) REFERENCES "Corkboard"(id);

ALTER TABLE "Liked"
  ADD CONSTRAINT fk_Liked_user_email_User_email
  FOREIGN KEY (user_email) REFERENCES "User"(email);
ALTER TABLE "Liked"
  ADD CONSTRAINT fk_LIKED_pushpin_id_Pushpin_id
  FOREIGN KEY (pushpin_id) REFERENCES "Pushpin"(id);

ALTER TABLE "Followed"
  ADD CONSTRAINT fk_Followed_user_email_User_email
  FOREIGN KEY (user_email) REFERENCES "User"(email);
ALTER TABLE "Followed"
  ADD CONSTRAINT fk_Followed_followed_user_email_User_email
  FOREIGN KEY (followed_user_email) REFERENCES "User"(email);

ALTER TABLE "Watched"
  ADD CONSTRAINT fk_Watched_user_email_User_email
  FOREIGN KEY (user_email) REFERENCES "User"(email);
ALTER TABLE "Watched"
  ADD CONSTRAINT fk_Watched_corkboard_id_Corkboard_id
  FOREIGN KEY (corkboard_id) REFERENCES "Corkboard"(id);

ALTER TABLE "Tagged"
  ADD CONSTRAINT fk_Tagged_pushpin_id_Pushpin_id
  FOREIGN KEY (pushpin_id) REFERENCES "Pushpin"(id);
ALTER TABLE "Tagged"
  ADD CONSTRAINT fk_Tagged_tag_text_Tag_tag_text
  FOREIGN KEY (tag_text) REFERENCES "Tag"(tag_text);

ALTER TABLE "Commented"
  ADD CONSTRAINT fk_Commented_comment_id_Comment_id
  FOREIGN KEY (comment_id) REFERENCES "Comment"(id);
ALTER TABLE "Commented"
  ADD CONSTRAINT fk_Commented_user_email_User_email
  FOREIGN KEY (user_email) REFERENCES "User"(email);
ALTER TABLE "Commented"
  ADD CONSTRAINT fk_Commented_pushpin_id_Pushpin_id
  FOREIGN KEY (pushpin_id) REFERENCES "Pushpin"(id);
