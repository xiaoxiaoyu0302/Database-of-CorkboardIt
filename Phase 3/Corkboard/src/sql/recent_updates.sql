SELECT
   id,
   title,
   is_private,
   password,
   owner,
   category,
   max as most_recent_update,
   CONCAT(first_name, ' ', last_name) AS name
FROM
     "Corkboard"
INNER JOIN "User" ON "Corkboard".owner = "User".email
INNER JOIN
      (select corkboard_id, max(time_added) from "Pushpin"
        WHERE corkboard_id in
      (SELECT id FROM "Corkboard"
          WHERE owner = '{email}'
          OR owner IN (SELECT
                 followed_user_email
          FROM
               "Followed"
          WHERE
              user_email = '{email}')
          OR id IN (SELECT
                           corkboard_id
                    FROM
                         "Watched"
                    WHERE
                   user_email = '{email}'))
group by corkboard_id) recent_updates
    ON recent_updates.corkboard_id = "Corkboard".id
WHERE owner = '{email}'
OR owner IN (SELECT
       followed_user_email
FROM
     "Followed"
WHERE
    user_email = '{email}')
OR id IN (SELECT
                 corkboard_id
          FROM
               "Watched"
          WHERE
         user_email = '{email}')
ORDER BY most_recent_update desc
LIMIT 4;