-- Stack Overflow SQL Case Study (BigQuery)
-- Query: Country Growth
-- Source: bigquery-public-data.stackoverflow
-- File: 06_country_growth_2010_2022.sql

WITH user_raw AS (
  SELECT
    location,
    EXTRACT(YEAR FROM creation_date) AS year
  FROM `bigquery-public-data.stackoverflow.users`
  WHERE location IS NOT NULL
    AND location != ''
    AND EXTRACT(YEAR FROM creation_date) BETWEEN 2010 AND 2022
),

-- Extract and standardize country from free-text location
country_cleaned AS (
  SELECT
    year,
    CASE
      WHEN TRIM(SPLIT(location, ',')[OFFSET(array_length(SPLIT(location, ',')) - 1)])
           IN ('US', 'USA', 'United States', 'United States of America') THEN 'United States'
      WHEN TRIM(SPLIT(location, ',')[OFFSET(array_length(SPLIT(location, ',')) - 1)])
           IN ('UK', 'United Kingdom', 'Great Britain', 'England') THEN 'United Kingdom'
      ELSE TRIM(SPLIT(location, ',')[OFFSET(array_length(SPLIT(location, ',')) - 1)])
    END AS country
  FROM user_raw
)

SELECT
  country,
  year,
  COUNT(*) AS new_users
FROM country_cleaned
WHERE country IS NOT NULL AND country != ''
GROUP BY country, year
ORDER BY new_users DESC
LIMIT 20
