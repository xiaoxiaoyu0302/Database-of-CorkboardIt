SELECT
    id,
    image_link,
    description,
    time_added
FROM
    "Pushpin"
WHERE
    "Pushpin".id = '{pushpin_id}';