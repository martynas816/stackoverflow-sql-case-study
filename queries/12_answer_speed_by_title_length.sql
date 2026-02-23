-- Stack Overflow SQL Case Study (BigQuery)
-- Query: Title Length vs Average Answer Time
-- Source: bigquery-public-data.stackoverflow
-- File: 12_answer_speed_by_title_length.sql

WITH data AS (
  SELECT
    LENGTH(title) AS title_length,
    TIMESTAMP_DIFF(f.first_answer_date, q.creation_date, HOUR) AS answer_time_hours
  FROM `bigquery-public-data.stackoverflow.posts_questions` q
  JOIN (
    SELECT parent_id AS id, MIN(creation_date) AS first_answer_date
    FROM `bigquery-public-data.stackoverflow.posts_answers`
    GROUP BY parent_id
  ) f
  ON q.id = f.id
  WHERE q.creation_date BETWEEN '2020-01-01' AND '2020-12-31'
)
SELECT
  CASE
    WHEN title_length < 30 THEN "<30 chars"
    WHEN title_length < 70 THEN "30-70 chars"
    ELSE ">70 chars"
  END AS title_bucket,
  AVG(answer_time_hours) AS avg_answer_time
FROM data
GROUP BY title_bucket
ORDER BY avg_answer_time
