SELECT
    id,
    image_link,
    description,
    time_added
FROM
    "Pushpin"
WHERE
    "Pushpin".corkboard_id = '{corkboard_id}';