-- Stack Overflow SQL Case Study (BigQuery)
-- Query: Tag Count vs Average Answer Time
-- Source: bigquery-public-data.stackoverflow
-- File: 11_answer_speed_by_tag_count.sql

WITH data AS (
  -- same dataset as above reduced to key columns
  SELECT
    ARRAY_LENGTH(SPLIT(tags, '|')) AS tag_count,
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
  tag_count,
  AVG(answer_time_hours) AS avg_answer_time
FROM data
GROUP BY tag_count
ORDER BY tag_count
