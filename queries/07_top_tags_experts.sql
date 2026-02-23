-- Stack Overflow SQL Case Study (BigQuery)
-- Query: Top Technologies Used by Experts
-- Source: bigquery-public-data.stackoverflow
-- File: 07_top_tags_experts.sql

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
    AND u.reputation >= 10000          -- high-reputation users
),

tag_counts AS (
  SELECT
    tag,
    COUNT(*) AS question_count
  FROM exploded
  GROUP BY tag
)

SELECT
  tag,
  question_count
FROM tag_counts
ORDER BY question_count DESC
LIMIT 20
