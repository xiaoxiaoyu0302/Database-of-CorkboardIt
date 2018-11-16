SELECT
    EXISTS(SELECT * FROM "Followed" WHERE
    user_email = '{user_email}'
    AND
    followed_user_email = '{followed_user_email}') AS is_followed
;