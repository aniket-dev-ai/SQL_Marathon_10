#  Netflix Content Analysis: Advanced SQL Queries

![Language](https://img.shields.io/badge/Language-SQL-red.svg)
![Tasks Solved](https://img.shields.io/badge/Tasks_Solved-15-brightgreen.svg)
![Concepts](https://img.shields.io/badge/Concepts-Window_Functions,_String_Manipulation,_Advanced_Aggregation-blue)

![Netflix logo](https://upload.wikimedia.org/wikipedia/commons/0/08/Netflix_2015_logo.svg)


### Overview

This repository presents a deep-dive analysis of a Netflix dataset using a series of advanced SQL queries. The project showcases the ability to handle complex data cleaning, transformation, and analysis tasks entirely within SQL. The queries address **15 distinct business questions**, ranging from simple aggregations to complex string manipulations and window functions, demonstrating a robust command of modern SQL techniques for data analysis.

---

### Tasks Completed & Queries Solved

1.  **Count** the total number of Movies vs. TV Shows.
2.  **Find** the most common content rating (e.g., TV-MA, PG-13) for both Movies and TV Shows.
3.  **List** all content released in a specific year (2020).
4.  **Identify** the top 5 countries with the most content available on Netflix.
5.  **Find** the movie with the longest duration.
6.  **Retrieve** all content added to Netflix within the last 5 years.
7.  **Find** all content directed by a specific director ('Rajiv Chilaka').
8.  **List** all TV shows that have more than 5 seasons.
9.  **Count** the number of content items available in each genre.
10. **Analyze** the average number of content releases per year for a specific country (India).
11. **List** all movies that fall under the 'Documentaries' genre.
12. **Find** all content that does not have a director listed.
13. **Count** the number of movies featuring 'Salman Khan' released in the last 10 years.
14. **Identify** the top 10 actors with the most appearances in content produced in India.
15. **Categorize** content based on the presence of keywords like 'Kill' or 'Violence' in their descriptions.

---

###  Detailed Explanations & Solutions

Here is a comprehensive breakdown of each task, the corresponding SQL query, and a deep-dive explanation of the techniques used.

#### 1. 📊 Count Movies vs. TV Shows
* **Objective:** To get a simple count of how many titles are Movies and how many are TV Shows.
* **Solution:**
    ```sql
    SELECT type, COUNT(*) AS content_count
    FROM netflix
    GROUP BY type;
    ```
* **In-Depth Explanation:** This is a fundamental aggregation query. The `GROUP BY type` clause segregates all rows into two buckets: 'Movie' and 'TV Show'. The `COUNT(*)` function then counts the number of rows within each of these buckets, providing a clear summary of the content distribution.

#### 2. 🏆 Find the Most Common Rating
* **Objective:** To identify the single most frequent rating for Movies and TV Shows separately.
* **Solution:**
    ```sql
    SELECT type, rating
    FROM (
        SELECT
            type,
            rating,
            RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
        FROM netflix
        GROUP BY type, rating
    ) AS t1
    WHERE ranking = 1;
    ```
* **In-Depth Explanation:** This query showcases the power of **window functions**.
    * **Inner Query:** First, it groups the data by both `type` and `rating` to get a count for each combination (e.g., 'Movie' + 'PG-13').
    * **Window Function (`RANK()`):** The `RANK()` function is applied to this aggregated data. `PARTITION BY type` tells the function to restart the ranking for each content type (i.e., it ranks movie ratings and TV show ratings independently). `ORDER BY COUNT(*) DESC` sorts the ratings within each partition by their frequency in descending order.
    * **Outer Query:** The final query simply filters these results to pull only the rows where `ranking` is 1, which represents the top-ranked (most common) rating for each content type.

#### 3. 🗓️ List Content from a Specific Year
* **Objective:** To retrieve all titles released in the year 2020.
* **Solution:**
    ```sql
    SELECT * FROM netflix WHERE release_year = 2020;
    ```
* **In-Depth Explanation:** A straightforward `SELECT` query that uses a `WHERE` clause to filter the entire table and return only those rows where the `release_year` column has a value of 2020.

#### 4. 🌍 Top 5 Countries by Content Volume
* **Objective:** To identify the top 5 countries that have produced the most content on Netflix.
* **Solution:**
    ```sql
    SELECT
        UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
        COUNT(*) AS content_count
    FROM netflix
    GROUP BY new_country
    ORDER BY content_count DESC
    LIMIT 5;
    ```
* **In-Depth Explanation:** This query demonstrates advanced **string manipulation**.
    * `STRING_TO_ARRAY(country, ',')`: This function takes the `country` string (e.g., "United States, India") and splits it into an array of strings (`{'United States', 'India'}`).
    * `UNNEST(...)`: This powerful function takes that array and expands it into individual rows. So, one row with two countries becomes two separate rows, each with one country. This is crucial for accurately counting content from multi-country productions.
    * The rest of the query groups by this new, cleaned country name, counts the occurrences, orders them, and limits the result to the top 5.

#### 5. ⏳ Identify the Longest Movie
* **Objective:** To find the movie with the longest runtime.
* **Solution:**
    ```sql
    SELECT *
    FROM netflix
    WHERE type = 'Movie'
    ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC
    LIMIT 1;
    ```
* **In-Depth Explanation:**
    * `SPLIT_PART(duration, ' ', 1)`: This function splits the `duration` string (e.g., "150 min") by the space character and returns the first part ("150").
    * `::INT`: This is a PostgreSQL-specific cast to convert the extracted text ("150") into an integer (150).
    * `ORDER BY ... DESC`: The query then sorts all movies by this integer duration in descending order.
    * `LIMIT 1`: This retrieves only the first row from the sorted list, which is the movie with the longest duration.
    * **Note:** The user's original query was missing `LIMIT 1`, which is added here to strictly answer the question.

#### 6. 📅 Find Content Added in the Last 5 Years
* **Objective:** To list all content that was added to Netflix on or after the date exactly five years ago from today.
* **Solution:**
    ```sql
    SELECT *
    FROM netflix
    WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
    ```
* **In-Depth Explanation:**
    * `TO_DATE(date_added, 'Month DD, YYYY')`: The `date_added` column is stored as a string (e.g., "September 25, 2021"). This function converts that string into a proper date data type by specifying its format.
    * `CURRENT_DATE - INTERVAL '5 years'`: This expression dynamically calculates the date five years prior to the current date when the query is run. The `WHERE` clause then filters for all content added on or after this calculated date.

#### 7. 🎬 Find Content by a Specific Director
* **Objective:** To retrieve all titles directed by 'Rajiv Chilaka'.
* **Solution:**
    ```sql
    SELECT *
    FROM netflix
    WHERE 'Rajiv Chilaka' = ANY(STRING_TO_ARRAY(director, ','));
    ```
* **In-Depth Explanation:** This is an efficient way to search within a comma-separated list.
    * `STRING_TO_ARRAY(director, ',')`: This splits the `director` string into an array of director names.
    * `'Rajiv Chilaka' = ANY(...)`: The `ANY` operator checks if the value 'Rajiv Chilaka' exists anywhere within the generated array. This is more robust and often more performant than using `LIKE` for this purpose.

#### 8. 📺 List TV Shows with More Than 5 Seasons
* **Objective:** To identify TV shows that have a high number of seasons.
* **Solution:**
    ```sql
    SELECT *
    FROM netflix
    WHERE type = 'TV Show' AND SPLIT_PART(duration, ' ', 1)::NUMERIC > 5;
    ```
* **In-Depth Explanation:** Similar to finding the longest movie, this query first filters for `TV Show`. It then uses `SPLIT_PART` to extract the number from the `duration` string (e.g., "7 Seasons" -> "7") and casts it to a `NUMERIC` type to perform a mathematical comparison, returning only shows with more than 5 seasons.

#### 9. 🎭 Count Content Items in Each Genre
* **Objective:** To get a count of how many titles belong to each genre.
* **Solution:**
    ```sql
    SELECT
        UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
        COUNT(*) AS content_count
    FROM netflix
    GROUP BY genre
    ORDER BY content_count DESC;
    ```
* **In-Depth Explanation:** This uses the same `UNNEST(STRING_TO_ARRAY(...))` technique as the country analysis. It unpacks the comma-separated `listed_in` string into individual genre rows, then groups by these genres to provide an accurate count for each one.

#### 10. 🇮🇳 Analyze Average Content Releases in India
* **Objective:** To find the top 5 years with the highest percentage of content releases for India.
* **Solution:**
    ```sql
    SELECT 
        release_year,
        COUNT(show_id) AS total_release,
        ROUND(
            COUNT(show_id)::NUMERIC /
            (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::NUMERIC * 100, 2
        ) AS percentage_of_total
    FROM netflix
    WHERE country = 'India'
    GROUP BY release_year
    ORDER BY total_release DESC
    LIMIT 5;
    ```
* **In-Depth Explanation:**
    * **Subquery:** A subquery `(SELECT COUNT(show_id) FROM netflix WHERE country = 'India')` is used to get the total number of Indian titles on Netflix. This total is used as the denominator for the percentage calculation.
    * **Main Query:** The main query filters for content from 'India', groups it by `release_year`, and counts the releases for each year.
    * **Calculation:** It then divides the count for each year by the total from the subquery and multiplies by 100 to get the percentage. `::NUMERIC` is used to ensure floating-point division.
    * The results are ordered and limited to the top 5 years.
    * **Note:** The user's original query was slightly simplified to focus on the core result.

#### 11. 🎞️ List All Documentary Movies
* **Objective:** To find all content that includes 'Documentaries' in its genre list.
* **Solution:**
    ```sql
    SELECT * FROM netflix
    WHERE listed_in LIKE '%Documentaries%';
    ```
* **In-Depth Explanation:** This query uses the `LIKE` operator with wildcard characters (`%`). The expression `'%Documentaries%'` will match any `listed_in` string that contains "Documentaries" anywhere within it, making it an effective way to search for a specific genre in a comma-separated list.

#### 12. ❓ Find Content Without a Director
* **Objective:** To identify all titles where the director information is missing.
* **Solution:**
    ```sql
    SELECT * FROM netflix
    WHERE director IS NULL;
    ```
* **In-Depth Explanation:** This query uses the `IS NULL` operator to filter for rows where the `director` column has no value. This is the standard and most efficient way to check for missing data in SQL.
* **Note:** The user's original file had a syntax error (`FROM netflix; WHERE...`), which has been corrected here.

#### 13. 🎭 Find Salman Khan's Movies from the Last Decade
* **Objective:** To list all movies starring 'Salman Khan' that were released in the last 10 years.
* **Solution:**
    ```sql
    SELECT *
    FROM netflix
    WHERE casts LIKE '%Salman Khan%'
      AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;
    ```
* **In-Depth Explanation:** This query combines two conditions. `casts LIKE '%Salman Khan%'` searches for the actor's name within the `casts` string. `release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10` dynamically calculates the start of the 10-year window and filters for movies released since then.

#### 14. 🇮🇳 Top 10 Actors in Indian Productions
* **Objective:** To find the actors who have appeared in the most content produced in India.
* **Solution:**
    ```sql
    SELECT
        UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
        COUNT(*) AS appearance_count
    FROM netflix
    WHERE country = 'India'
    GROUP BY actor
    ORDER BY appearance_count DESC
    LIMIT 10;
    ```
* **In-Depth Explanation:** This query combines several techniques:
    1.  It first filters the dataset to include only content where the `country` is 'India'.
    2.  It then uses the `UNNEST(STRING_TO_ARRAY(...))` pattern to expand the `casts` list into individual actor rows.
    3.  Finally, it groups by these actor names, counts their appearances, and returns the top 10.

#### 15. ⚠️ Categorize Content Based on Keywords
* **Objective:** To classify content as 'Bad' or 'Good' based on whether their descriptions contain potentially sensitive keywords.
* **Solution:**
    ```sql
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
    ```
* **In-Depth Explanation:**
    * **`CASE` Statement:** The core of this query is the `CASE` statement, which acts like an if-then-else logical block. It checks the `description` of each title.
    * **`ILIKE`:** The `ILIKE` operator is used for a case-insensitive search, so it will match 'kill', 'Kill', 'KILL', etc.
    * **Subquery:** The `CASE` statement runs inside a subquery that creates a temporary `category` column.
    * **Outer Query:** The outer query then simply groups by this newly created category ('Good' or 'Bad') and counts the number of titles in each.