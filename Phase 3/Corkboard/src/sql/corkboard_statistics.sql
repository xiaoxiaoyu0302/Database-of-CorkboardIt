SELECT
    U.email,
    CONCAT(U.first_name, ' ', U.last_name) AS user_name,
    (SELECT
        SUM
            (CASE
                WHEN
                    is_private = '0'
                THEN
                    1
                ELSE
                    0
                END)
    FROM
        "Corkboard"
    WHERE
        owner = U.email) AS public_corkboard_count,
    (SELECT
        SUM
            (CASE
                WHEN
                    is_private = '1'
                THEN
                    1
                ELSE
                    0
                END)
    FROM
        "Corkboard"
    WHERE
        owner = U.email) AS private_corkboard_count,
    (SELECT
        SUM(CASE
            WHEN
                is_private = '0'
            THEN
                1
            ELSE
                0
            END)
    FROM
        "Corkboard"
    INNER JOIN
        "Pushpin"
    ON
        corkboard_id = "Corkboard".id
    WHERE
        owner = U.email) AS public_pushpin_count,
    (SELECT
        SUM((CASE
            WHEN
                is_private = '1'
            THEN
                1
            ELSE
                0
            END))
    FROM
        "Corkboard"
    INNER JOIN
        "Pushpin"
    ON
        corkboard_id = "Corkboard".id
    WHERE
        owner = U.email) AS private_pushpin_count
FROM
    "User" U
ORDER BY
    public_corkboard_count DESC NULLS LAST, private_corkboard_count DESC NULLS LAST
;