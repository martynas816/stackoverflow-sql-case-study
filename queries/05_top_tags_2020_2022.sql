-- Stack Overflow SQL Case Study (BigQuery)
-- Query: Which technologies dominate recent years (2020–2022)?
-- Source: bigquery-public-data.stackoverflow
-- File: 05_top_tags_2020_2022.sql

WITH exploded AS (
  SELECT
    EXTRACT(YEAR FROM creation_date) AS year,
    tag
  FROM `bigquery-public-data.stackoverflow.posts_questions`,
       UNNEST(SPLIT(tags, '|')) AS tag
  WHERE EXTRACT(YEAR FROM creation_date) BETWEEN 2020 AND 2022
)
SELECT
  tag,
  COUNT(*) AS question_count
FROM exploded
GROUP BY tag
ORDER BY question_count DESC
LIMIT 20
