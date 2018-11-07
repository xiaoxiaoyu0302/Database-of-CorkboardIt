SELECT
	"Corkboard".title,
	CONCAT( "User".first_name, ' ' , "User".last_name) AS owner_name,
	(
		SELECT
			"Pushpin".time_added
		FROM
			"Pushpin"
		WHERE
			"Pushpin".corkboard_id = %s
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
			"Watched".corkboard_id = %s
	) AS watcher_count
FROM
	"Corkboard"
INNER JOIN
	"User"
ON
	"User".email = "Corkboard".user_email
WHERE
    "Corkboard".id = %s;