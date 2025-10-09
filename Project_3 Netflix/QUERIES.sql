DROP TABLE IF EXISTS NETFLIX;

CREATE TABLE NETFLIX (
show_id VARCHAR(10) PRiMARY KEY,
type VARCHAR(10),
title VARCHAR(110),
director VARCHAR(210) ,
casts VARCHAR(800),
country VARCHAR(130),
date_added VARCHAR(50) ,
release_year INT ,
rating VARCHAR(10),
duration VARCHAR(10),
listed_in VARCHAR(80) ,
description VARCHAR(260)
);

SELECT *  FROM netflix;

-- TASK 1.  Count the Number of Movies vs TV Shows

SELECT type , COUNT(*) FROM netflix GROUP BY 1; 

-- Task 2. Find the Most Common Rating for Movies and TV Shows

SELECT type,rating from(
SELECT
type ,
rating ,
count(*) ,
RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC ) AS ranking
from netflix
group by 1, 2
) as t1 where ranking =1;

-- Task 3. List All Movies Released in a Specific Year (e.g., 2020)

SELECT * from netflix where release_year = 2020;

-- TASK 4. Find the Top 5 Countries with the Most Content on Netflix 

select 
UNNEST(STRING_TO_ARRAY(country , ',')) as new_country , 
COUNT(*) from netflix 
GROUP BY 1 ORDER BY 2 DESC LIMIT 5; 

-- TASK 5. Identify the Longest Movie
SELECT * from netflix WHERE type = 'Movie' ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;;


-- Task 6. Find Content Added in the Last 5 Years
SELECT * FROM netflix WHERE to_date(DATE_ADDED , 'MONTH DD , YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

Select * from (
SELECT * , UNNEST(STRING_TO_ARRAY(director,',')) as director_name from netflix
) as drct where director_name = 'Rajiv Chilaka';

-- for the count

SELECT COUNT(*)
FROM netflix 
WHERE 'Rajiv Chilaka' = ANY(STRING_TO_ARRAY(director, ','));

-- Task 8. List All TV Shows with More Than 5 Seasons

SELECT * FROM netflix  where type = 'TV Show' AND SPLIT_PART(duration , ' ' , 1)::numeric > 5;

-- Task 9. Count the Number of Content Items in Each Genre

SELECT UNNEST(STRING_TO_ARRAY(listed_in ,',')) , COUNT(*)  FROM netflix GROUP BY 1 ORDER BY 2 DESC;

-- Task 10. Find each year and the average numbers of content release in India on netflix.

SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;


-- Task 11. List All Movies that are Documentaries

SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';

-- Task 12. Find All Content Without a Director

SELECT * 
FROM netflix;
WHERE director IS NULL;

-- Task 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT * FROM (
SELECT * , UNNEST(STRING_TO_ARRAY(casts,',')) as cst  from netflix 
) AS t1 where cst = 'Salman Khan' and release_year>= EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-- ALSO

SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-- Task 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

SELECT UNNEST(STRING_TO_ARRAY(casts , ',')) as actors , count(*) from netflix WHERE country = 'India' GROUP BY 1 ORDER BY 2 DESC LIMIT 10;
 
-- TASK 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;








