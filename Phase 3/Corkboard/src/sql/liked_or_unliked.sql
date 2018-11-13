SELECT
  user_email,
       pushpin_id
FROM
     "Liked"
WHERE 
    pushpin_id = {pushpin_id} AND 
    user_email = '{email}';