DELETE FROM
  "Liked"
WHERE
  user_email = '{email}' AND
  pushpin_id = {pushpin_id};