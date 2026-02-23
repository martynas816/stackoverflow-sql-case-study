-- Stack Overflow SQL Case Study (BigQuery)
-- Query: Technologies Used Disproportionately by Beginners
-- Source: bigquery-public-data.stackoverflow
-- File: 09_overindexed_by_beginners.sql

WITH exploded AS (
  SELECT
    q.id,
    u.reputation,
    tag
  FROM `bigquery-public-data.stackoverflow.posts_questions` AS q
  JOIN `bigquery-public-data.stackoverflow.users` AS u
    ON q.owner_user_id = u.id
  CROSS JOIN UNNEST(SPLIT(q.tags, '|')) AS tag
  WHERE u.reputation IS NOT NULL
),

-- Beginner users: reputation < 1000
beginner AS (
  SELECT
    tag,
    COUNT(*) AS beginner_count
  FROM exploded
  WHERE reputation < 1000
  GROUP BY tag
),

-- Expert users: reputation >= 10000
expert AS (
  SELECT
    tag,
    COUNT(*) AS expert_count
  FROM exploded
  WHERE reputation >= 10000
  GROUP BY tag
),

combined AS (
  SELECT
    COALESCE(b.tag, e.tag) AS tag,
    beginner_count,
    expert_count
  FROM beginner b
  FULL OUTER JOIN expert e
    ON b.tag = e.tag
)

SELECT
  tag,
  beginner_count,
  expert_count,
  SAFE_DIVIDE(beginner_count, expert_count) AS beginner_ratio
FROM combined
WHERE beginner_count > 50000      -- remove rare/noisy tags
  AND expert_count > 50
ORDER BY beginner_ratio DESC
LIMIT 20
