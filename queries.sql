-- Instagram User Analytics SQL Queries

-- 1. Find the 5 oldest users of Instagram
WITH base AS (
    SELECT username, created_at
    FROM ig_clone.users
    ORDER BY created_at
    LIMIT 5
)
SELECT * FROM base;

-- 2. Find users who have never posted a single photo
SELECT u.username 
FROM ig_clone.users u
LEFT JOIN ig_clone.photos p ON u.id = p.user_id
WHERE p.user_id IS NULL
ORDER BY u.username;

-- 3. Identify the winner of the contest (user with the most likes on a single photo)
SELECT username FROM (
    SELECT likes.photo_id, users.username, COUNT(likes.user_id) AS like_user 
    FROM ig_clone.likes likes
    INNER JOIN ig_clone.photos photos ON likes.photo_id = photos.id
    INNER JOIN ig_clone.users users ON photos.user_id = users.id
    GROUP BY likes.photo_id, users.username
    ORDER BY like_user DESC
    LIMIT 1
) base;

-- 4. Identify the top 5 most commonly used hashtags
SELECT t.tag_name, COUNT(p.photo_id) AS num_tags 
FROM ig_clone.photo_tags p
INNER JOIN ig_clone.tags t ON p.tag_id = t.id
GROUP BY tag_name
ORDER BY num_tags DESC
LIMIT 5;

-- 5. Find the best day to launch ad campaigns (day with most registrations)
SELECT WEEKDAY(created_at) AS weekday, COUNT(username) AS num_users
FROM ig_clone.users
GROUP BY 1
ORDER BY num_users DESC;

-- 6. Find the average number of posts per user
WITH CTE AS (
    SELECT u.id AS userid, COUNT(p.id) AS photoid
    FROM ig_clone.users u
    LEFT JOIN ig_clone.photos p ON u.id = p.user_id
    GROUP BY u.id
)
SELECT SUM(photoid) AS total_photos, COUNT(userid) AS total_users, SUM(photoid)/COUNT(userid) AS photo_per_user
FROM CTE
WHERE photoid > 0;

-- 7. Identify bot accounts (users who have liked every single photo on the site)
WITH photo_count AS (
    SELECT user_id, COUNT(photo_id) AS num_like 
    FROM ig_clone.likes
    GROUP BY user_id
    ORDER BY num_like DESC
)
SELECT * FROM photo_count 
WHERE num_like = (SELECT COUNT(*) FROM ig_clone.photos);
