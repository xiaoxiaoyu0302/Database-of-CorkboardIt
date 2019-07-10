SELECT 
    CONCAT(first_name, ' ', last_name) as name 
FROM 
    "Liked",
    "User"
WHERE pushpin_id = {pushpin_id} AND 
user_email = "User".email;