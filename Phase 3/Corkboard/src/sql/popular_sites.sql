SELECT
    SUBSTRING
        (
            "Pushpin".image_link
            FROM
            '(?:.*://)?([^/]*)'
        ) AS site_name,
    COUNT
        (*) AS site_count
FROM
    "Pushpin"
GROUP BY
    1
ORDER BY
    site_count DESC;