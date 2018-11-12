DELETE
FROM
    "Watched"
WHERE
    user_email = '{user_email}'
    AND
    corkboard_id = '{corkboard_id}'