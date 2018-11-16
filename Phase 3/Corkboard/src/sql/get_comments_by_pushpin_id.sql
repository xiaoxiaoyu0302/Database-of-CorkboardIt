SELECT
    comment_text,
    CONCAT(first_name, ' ', last_name) AS user_name
FROM
    "Comment"
INNER JOIN
	"User"
ON
	"User".email = "Comment".user_email
WHERE
    "Comment".pushpin_id = '{pushpin_id}';