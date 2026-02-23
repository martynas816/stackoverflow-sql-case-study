-- Stack Overflow SQL Case Study (BigQuery)
-- Query: Question Features & Answer Speed
-- Source: bigquery-public-data.stackoverflow
-- File: 10_answer_speed_base_dataset_2020.sql

WITH answers AS (
  -- Get each answer with its parent question
  SELECT
    a.parent_id AS question_id,
    a.creation_date AS answer_date
  FROM `bigquery-public-data.stackoverflow.posts_answers` AS a
),

first_answer AS (
  -- For each question, find the earliest answer timestamp
  SELECT
    question_id,
    MIN(answer_date) AS first_answer_date
  FROM answers
  GROUP BY question_id
),

questions AS (
  SELECT
    q.id AS question_id,
    q.title,
    q.body,
    q.tags,
    q.creation_date AS question_date,
    q.score,
    q.view_count
  FROM `bigquery-public-data.stackoverflow.posts_questions` AS q
  WHERE q.creation_date BETWEEN '2020-01-01' AND '2020-12-31'   -- limit to one year
)

SELECT
  q.question_id,
  q.score,
  q.view_count,
  LENGTH(q.title) AS title_length,
  LENGTH(q.body) AS body_length,
  ARRAY_LENGTH(SPLIT(q.tags, '|')) AS tag_count,
  TIMESTAMP_DIFF(f.first_answer_date, q.question_date, HOUR) AS answer_time_hours
FROM questions q
JOIN first_answer f
  ON q.question_id = f.question_id
