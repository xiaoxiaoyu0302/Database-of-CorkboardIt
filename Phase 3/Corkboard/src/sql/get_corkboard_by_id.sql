SELECT
	"Corkboard".title,
	"Corkboard".category,
	CONCAT( "User".first_name, ' ' , "User".last_name) AS owner_name,
	(
		SELECT
			"Pushpin".time_added
		FROM
			"Pushpin"
		WHERE
			"Pushpin".corkboard_id = '{corkboard_id}'
		GROUP BY
			"Pushpin".time_added
		ORDER BY
			"Pushpin".time_added DESC
		LIMIT 1
	) AS last_update,
	(
		SELECT
			COUNT (*)
		FROM
			"Watched"
		WHERE
			"Watched".corkboard_id = '{corkboard_id}'
	) AS watcher_count
FROM
	"Corkboard"
INNER JOIN
	"User"
ON
	"User".email = "Corkboard".owner
WHERE
    "Corkboard".id = '{corkboard_id}';