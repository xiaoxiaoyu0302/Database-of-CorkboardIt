SELECT
    boards.tag_text,
    pushpin_count,
    distinct_boards
FROM
    (SELECT count(*) AS pushpin_count, tag_text FROM "Tag"
    GROUP BY tag_text) pushpins
INNER JOIN
    (SELECT tag_text, count(*) AS distinct_boards FROM
        (SELECT DISTINCT tag_text, corkboard_id FROM "Tag"
    INNER JOIN "Pushpin" P ON "Tag".pushpin_id = P.id) distinct_corkboards
    GROUP BY tag_text) boards
ON boards.tag_text = pushpins.tag_text
ORDER BY pushpin_count desc
LIMIT 5;
