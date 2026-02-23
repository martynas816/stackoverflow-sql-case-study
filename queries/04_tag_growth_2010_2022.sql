-- Stack Overflow SQL Case Study (BigQuery)
-- Query: Tag Growth from 2010 to 2022
-- Source: bigquery-public-data.stackoverflow
-- File: 04_tag_growth_2010_2022.sql

WITH exploded AS (
  SELECT
    EXTRACT(YEAR FROM creation_date) AS year,
    tag
  FROM `bigquery-public-data.stackoverflow.posts_questions`,
       UNNEST(SPLIT(tags, '|')) AS tag
  WHERE EXTRACT(YEAR FROM creation_date) BETWEEN 2010 AND 2022
),

tag_year_counts AS (
  SELECT
    tag,
    year,
    COUNT(*) AS question_count
  FROM exploded
  GROUP BY tag, year
),

tag_growth AS (
  SELECT
    tag,
    MIN(CASE WHEN year = 2010 THEN question_count END) AS count_2010,
    MAX(CASE WHEN year = 2022 THEN question_count END) AS count_2022
  FROM tag_year_counts
  GROUP BY tag
),

filtered AS (
  -- Remove tags that had almost no activity in either year
  SELECT *
  FROM tag_growth
  WHERE count_2010 >= 100 AND count_2022 >= 100
),

growth_calc AS (
  SELECT
    tag,
    count_2010,
    count_2022,
    (count_2022 - count_2010) AS absolute_change,
    ROUND(((count_2022 - count_2010) / count_2010) * 100, 1) AS percent_change
  FROM filtered
)

SELECT *
FROM growth_calc
ORDER BY percent_change DESC
LIMIT 20
