
# 📊 Instagram User Analytics - SQL Project

## 🔹 Project Overview

This project analyzes Instagram user data using SQL queries to extract valuable insights. The dataset includes user information, posts, likes, and hashtags. The goal is to assist marketing teams in optimizing campaigns and provide investors with key performance metrics.

## 🔹 Tech Stack

- **Database**: SQL (PostgreSQL/MySQL)
- **Tools**: SQL Queries
- **Data Format**: CSV 

## 🔹 Objectives

### 🏢 Marketing Insights

1. **Rewarding Most Loyal Users** - Identify users who have been active on Instagram the longest.
2. **Reminding Inactive Users** - Find users who have never posted and encourage engagement.
3. **Declaring Contest Winners** - Identify the user with the most-liked photo.
4. **Hashtag Research** - Determine the top 5 most used hashtags.
5. **Optimal Ad Campaign Timing** - Find the day when most users register.

### 💰 Investor Insights

1. **User Engagement** - Analyze posting activity per user.
2. **Detecting Bots & Fake Accounts** - Identify users who have liked every photo, a potential sign of bot activity.

## 🔹 Dataset Description

The dataset consists of multiple tables:

- `users` (id, username, created\_at, email)
- `photos` (id, user\_id, image\_url, created\_at)
- `likes` (id, user\_id, photo\_id, created\_at)
- `tags` (id, tag\_name)
- `photo_tags` (photo\_id, tag\_id)

## 🔹 Queries & Insights

### 📍 1. Find the 5 Oldest Users

```sql
SELECT username, created_at FROM ig_clone.users ORDER BY created_at LIMIT 5;
```

**Insight:** These users can be rewarded for loyalty.

### 📍 2. Identify Inactive Users

```sql
SELECT u.username FROM ig_clone.users u
LEFT JOIN ig_clone.photos p ON u.id = p.user_id
WHERE p.user_id IS NULL ORDER BY u.username;
```

**Insight:** These users can be encouraged to post content.

### 📍 3. Declare Contest Winner

```sql
SELECT username FROM (
  SELECT likes.photo_id, users.username, COUNT(likes.user_id) as like_user
  FROM ig_clone.likes
  INNER JOIN ig_clone.photos ON likes.photo_id = photos.id
  INNER JOIN ig_clone.users ON photos.user_id = users.id
  GROUP BY likes.photo_id, users.username
  ORDER BY like_user DESC LIMIT 1
) base;
```

**Insight:** The user with the most-liked photo wins the contest.

### 📍 4. Find Top 5 Hashtags

```sql
SELECT t.tag_name, COUNT(p.photo_id) AS num_tags
FROM ig_clone.photo_tags p
INNER JOIN ig_clone.tags t ON p.tag_id = t.id
GROUP BY tag_name ORDER BY num_tags DESC LIMIT 5;
```

**Insight:** These hashtags can maximize brand reach.

### 📍 5. Determine Best Day for Ads

```sql
SELECT WEEKDAY(created_at) as weekday, COUNT(username) as num_users
FROM ig_clone.users GROUP BY 1 ORDER BY num_users DESC;
```

**Insight:** Thursdays and Sundays have the highest registrations.

### 📍 6. Analyze User Engagement

```sql
WITH CTE AS (
  SELECT u.id AS userid, COUNT(p.id) AS photoid
  FROM ig_clone.users u LEFT JOIN ig_clone.photos p ON u.id = p.user_id
  GROUP BY u.id
)
SELECT SUM(photoid) AS total_photos, COUNT(userid) AS total_users, SUM(photoid)/COUNT(userid) AS avg_photos_per_user
FROM CTE WHERE photoid > 0;
```

**Insight:** The average user posts 3.47 times.

### 📍 7. Detect Bots

```sql
WITH photo_count AS (
  SELECT user_id, COUNT(photo_id) AS num_likes FROM ig_clone.likes
  GROUP BY user_id ORDER BY num_likes DESC
)
SELECT * FROM photo_count WHERE num_likes = (SELECT COUNT(*) FROM ig_clone.photos);
```

**Insight:** Users who like every photo may be bots.

## 🔹 How to Use This Project

1. Clone the repository:
   ```sh
   git clone https://github.com/your-username/Instagram-User-Analytics.git
   ```
2. Import the dataset (`dataset.sql` or `dataset.csv`).
3. Run the queries in `queries.sql` to extract insights.
4. (Optional) Use `analysis.ipynb` for additional Python-based analytics.


## 🔹 Future Enhancements

- Add machine learning-based sentiment analysis for posts.
- Automate SQL queries into a data pipeline.
- Integrate visualization tools (Power BI/Tableau).

## 🔹 Contact

For any queries, feel free to reach out via **GitHub Issues** or connect with me on **LinkedIn/GitHub**.

⭐ **If you find this project useful, give it a star!** ⭐


