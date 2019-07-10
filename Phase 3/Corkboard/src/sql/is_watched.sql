SELECT
    EXISTS(SELECT * FROM "Watched" WHERE
    user_email = '{user_email}'
    AND
    corkboard_id = '{corkboard_id}') AS is_watched;