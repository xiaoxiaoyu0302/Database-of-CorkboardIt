-- Login User
SELECT email FROM "User"
WHERE email='$email' AND pin='$pin';

-- Get User Details
SELECT first_name, last_name FROM "User"
WHERE email='$email';

-- Get Owned Corkboards
SELECT id, title, owner, is_private, category FROM "Corkboard"
where owner = '$email';

-- Get Watched Corkboards
SELECT "Corkboard".id, "Corkboard".title, "Corkboard".owner, "Corkboard".is_private, "Corkboard".category FROM "Corkboard"
INNER JOIN "Watched"
ON "Corkboard".id = "Watched".corkboard_id
WHERE "Watched".user_email = '$email';

-- Get Corkboards of Followed Users
SELECT "Corkboard".id, "Corkboard".title, "Corkboard".owner, "Corkboard".category, "Corkboard".is_private FROM
(SELECT followed_user_email FROM "Followed" WHERE "Followed".user_email = '$email') followed_emails
INNER JOIN "Corkboard"
ON "Corkboard".owner = followed_emails.followed_user_email;

-- Sort Corkboards
SELECT
  MAX(time_added) as most_recent_update,
  "Corkboard".id,
  "Corkboard".title,
  "Corkboard".owner,
  "Corkboard".category,
  "Corkboard".is_private
FROM
  "Pushpin"
INNER JOIN
  "Corkboard"
ON "Corkboard".id = "Pushpin".corkboard_id
WHERE "Pushpin".corkboard_id IN ($'corkboard_IDs')
GROUP BY "Pushpin".corkboard_id
ORDER BY most_recent_update DESC
LIMIT 4;
