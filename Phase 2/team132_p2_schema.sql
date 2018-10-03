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
  fk_Corkboard_owner_User_email VARCHAR(255) NOT NULL,
  fk_Corkboard_category_Category_category_name VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS "Pushpin";
CREATE TABLE "Pushpin" (
  id SERIAL PRIMARY KEY NOT NULL,
  description VARCHAR(200),
  image_link TEXT NOT NULL,
  time_added TIMESTAMP NOT NULL,
  fk_Pushpin_corkboard_Corkboard_id INTEGER NOT NULL
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
  fk_Liked_user_User_email VARCHAR(255) NOT NULL,
  fk_Liked_pushpin_User_id INTEGER NOT NULL,
  PRIMARY KEY(fk_Liked_user_User_email, fk_Liked_pushpin_User_id)
);

DROP TABLE IF EXISTS "Followed";
CREATE TABLE "Followed" (
  fk_Followed_user_User_email VARCHAR(255) NOT NULL,
  fk_Followed_followed_user_User_email varchar(255) NOT NULL,
  PRIMARY KEY(fk_Followed_user_User_email, fk_Followed_followed_user_User_email)
);

DROP TABLE IF EXISTS "Watched";
CREATE TABLE "Watched" (
  fk_Watched_user_User_email VARCHAR(255) NOT NULL,
  fk_Pushpin_corkboard_Corkboard_id INTEGER NOT NULL,
  PRIMARY KEY(fk_Watched_user_User_email, fk_Pushpin_corkboard_Corkboard_id)
);

DROP TABLE IF EXISTS "Tagged";
CREATE TABLE "Tagged" (
  fk_Tagged_pushpin_Pushpin_id INTEGER NOT NULL,
  fk_Tagged_tag_Tag_tag_text VARCHAR(20) NOT NULL,
  PRIMARY KEY(fk_Tagged_pushpin_Pushpin_id, fk_Tagged_tag_Tag_tag_text)
);

DROP TABLE IF EXISTS "Commented";
CREATE TABLE "Commented" (
  fk_Commented_comment_Comment_id INTEGER NOT NULL,
  fk_Commented_user_User_email VARCHAR(255) NOT NULL,
  fk_Commented_pushpin_Pushpin_id INTEGER NOT NULL,
  PRIMARY KEY(fk_Commented_comment_Comment_id, fk_Commented_user_User_email, fk_Commented_pushpin_Pushpin_id)
);

-- Constraints
ALTER TABLE "Corkboard"
  ADD FOREIGN KEY (fk_Corkboard_owner_User_email) REFERENCES "User"(email);
ALTER TABLE "Corkboard"
  ADD FOREIGN KEY (fk_Corkboard_category_Category_category_name) REFERENCES "Category"(category_name);

ALTER TABLE "Pushpin"
  ADD FOREIGN KEY (fk_Pushpin_corkboard_Corkboard_id) REFERENCES "Corkboard"(id);
  
ALTER TABLE "Liked"
  ADD FOREIGN KEY (fk_Liked_user_User_email) REFERENCES "User"(email);
ALTER TABLE "Liked"
  ADD FOREIGN KEY (fk_Liked_pushpin_User_id) REFERENCES "Pushpin"(id);
  
ALTER TABLE "Followed"
  ADD FOREIGN KEY (fk_Followed_user_User_email) REFERENCES "User"(email);
ALTER TABLE "Followed"
  ADD FOREIGN KEY (fk_Followed_followed_user_User_email) REFERENCES "User"(email);
  
ALTER TABLE "Watched"
  ADD FOREIGN KEY (fk_Watched_user_User_email) REFERENCES "User"(email);  
ALTER TABLE "Watched"
  ADD FOREIGN KEY (fk_Pushpin_corkboard_Corkboard_id) REFERENCES "Corkboard"(id);  

ALTER TABLE "Tagged"
  ADD FOREIGN KEY (fk_Tagged_pushpin_Pushpin_id) REFERENCES "Pushpin"(id);
ALTER TABLE "Tagged"
  ADD FOREIGN KEY (fk_Tagged_tag_Tag_tag_text) REFERENCES "Tag"(tag_text); 

ALTER TABLE "Commented"
  ADD FOREIGN KEY (fk_Commented_comment_Comment_id) REFERENCES "Comment"(id);
ALTER TABLE "Commented"
  ADD FOREIGN KEY (fk_Commented_user_User_email) REFERENCES "User"(email);
ALTER TABLE "Commented"
  ADD FOREIGN KEY (fk_Commented_pushpin_Pushpin_id) REFERENCES "Pushpin"(id);