-- Stack Overflow SQL Case Study (BigQuery)
-- Query: Question Volume Over Time (2008–2022)
-- Source: bigquery-public-data.stackoverflow
-- File: 03_question_volume_by_year.sql

SELECT
  EXTRACT(YEAR FROM creation_date) AS year,
  COUNT(*) AS questions_count
FROM `bigquery-public-data.stackoverflow.posts_questions`
GROUP BY year
ORDER BY year
