-- Stack Overflow SQL Case Study (BigQuery)
-- Query: Methods & Filters
-- Source: bigquery-public-data.stackoverflow
-- File: 01_data_overview_sample_questions.sql

SELECT
  id,
  title,
  creation_date,
  score,
  view_count,
  tags
FROM `bigquery-public-data.stackoverflow.posts_questions`
ORDER BY creation_date
LIMIT 10
