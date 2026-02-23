-- Stack Overflow SQL Case Study (BigQuery)
-- Query: Distribution of Technologies (Tag Frequency Across All Questions)
-- Source: bigquery-public-data.stackoverflow
-- File: 02_tag_frequency_top20.sql

WITH exploded AS (
  SELECT
    id,
    creation_date,
    tag
  FROM `bigquery-public-data.stackoverflow.posts_questions`,
       UNNEST(SPLIT(tags, '|')) AS tag
)
SELECT
  tag,
  COUNT(*) AS question_count
FROM exploded
GROUP BY tag
ORDER BY question_count DESC
LIMIT 20
