select
"Pushpin".id,
"Corkboard".id as corkboard_id,
  description,
       "Corkboard".title,
       CONCAT(first_name, ' ', last_name) as name
from "Pushpin" INNER JOIN (SELECT id FROM "Pushpin"
WHERE
description ilike '%{query}%'
UNION DISTINCT
select pushpin_id from "Tag"
WHERE tag_text ilike '%{query}%'
UNION DISTINCT
select id from "Pushpin" where corkboard_id in
    (select id from "Corkboard"
    WHERE category ilike '%{query}%')) search_ids
ON search_ids.id = "Pushpin".id
INNER JOIN "Corkboard" ON "Pushpin".corkboard_id = "Corkboard".id
INNER JOIN "User" ON "User".email = "Corkboard".owner
WHERE "Corkboard".is_private <> '1'
ORDER BY description asc;