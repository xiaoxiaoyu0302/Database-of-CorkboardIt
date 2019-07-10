SELECT
    email,
    first_name,
    last_name
FROM
    "User"
WHERE
    email = '{email}' AND
    pin = '{pin}';