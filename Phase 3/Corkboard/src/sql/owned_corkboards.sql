SELECT
    "Corkboard".id,
     title,
     is_private,
     password,
     owner,
     category,
     COALESCE(count, 0) as pushpin_count
FROM
     "Corkboard"
     LEFT OUTER JOIN
         ( SELECT
                  count(*),
                  corkboard_id as id
           FROM "Pushpin"
           WHERE corkboard_id IN (SELECT id FROM "Corkboard" WHERE owner = '{email}')
           GROUP BY corkboard_id) corkboard_count
     ON corkboard_count.id = "Corkboard".id
WHERE owner = '{email}'
ORDER BY title asc;
