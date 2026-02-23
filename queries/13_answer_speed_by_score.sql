-- Stack Overflow SQL Case Study (BigQuery)
-- Query: Score and Answer Speed
-- Source: bigquery-public-data.stackoverflow
-- File: 13_answer_speed_by_score.sql

WITH first_answer AS (
  SELECT
    parent_id AS question_id,
    MIN(creation_date) AS first_answer_date
  FROM `bigquery-public-data.stackoverflow.posts_answers`
  GROUP BY parent_id
),
q AS (
  SELECT
    q.id AS question_id,
    q.score,
    TIMESTAMP_DIFF(f.first_answer_date, q.creation_date, HOUR) AS answer_time_hours
  FROM `bigquery-public-data.stackoverflow.posts_questions` q
  JOIN first_answer f
    ON q.id = f.question_id
  WHERE q.creation_date BETWEEN '2018-01-01' AND '2020-12-31'
)

SELECT
  CASE
    WHEN score < 0 THEN 'negative'
    WHEN score = 0 THEN '0'
    WHEN score BETWEEN 1 AND 5 THEN '1–5'
    ELSE '6+'
  END AS score_bucket,
  AVG(answer_time_hours) AS avg_answer_time
FROM q
GROUP BY score_bucket
ORDER BY avg_answer_time;
