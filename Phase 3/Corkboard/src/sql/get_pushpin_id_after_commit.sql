SELECT
    id
FROM
    "Pushpin"
WHERE
    "Pushpin".corkboard_id = '{corkboard_id}'
AND
    "Pushpin".time_added = '{time_added}';