DELETE
FROM
    "Followed"
WHERE
    user_email = '{user}'
    AND
    followed_user_email = '{followed_user}';