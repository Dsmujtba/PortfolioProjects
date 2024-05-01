```sql
-- Establishing connection to the MySQL database
%load_ext sql
%sql mysql://studentuser:studentpw@localhost/dognitiondb
%sql USE dognitiondb

-- Query 1: Extracting the original created_at time stamps and corresponding day of the week
-- Using the DAYOFWEEK function to get the day of the week
-- Displaying 200 rows starting at row 50
%%sql
SELECT created_at, DAYOFWEEK(created_at) AS Day
FROM complete_tests
LIMIT 50, 200;

-- Query 2: Including a CASE statement to provide weekday names instead of numbers
%%sql
SELECT created_at, DAYOFWEEK(created_at) AS day_num,
CASE 
    WHEN DAYOFWEEK(created_at) = 1 THEN 'Sun'
    WHEN DAYOFWEEK(created_at) = 2 THEN 'Mon'
    WHEN DAYOFWEEK(created_at) = 3 THEN 'Tue'
    WHEN DAYOFWEEK(created_at) = 4 THEN 'Wed'
    WHEN DAYOFWEEK(created_at) = 5 THEN 'Thu'
    WHEN DAYOFWEEK(created_at) = 6 THEN 'Fri'
    WHEN DAYOFWEEK(created_at) = 7 THEN 'Sat'
END AS day_of_week
FROM complete_tests
LIMIT 20, 100;

-- Query 3: Reporting the total number of tests completed on each weekday
-- Sorting the results by the total number of tests completed in descending order
%%sql
SELECT created_at,
    DAYOFWEEK(created_at) AS day,
CASE 
    WHEN DAYOFWEEK(created_at) = 1 THEN 'Sun'
    WHEN DAYOFWEEK(created_at) = 2 THEN 'Mon'
    WHEN DAYOFWEEK(created_at) = 3 THEN 'Tus'
    WHEN DAYOFWEEK(created_at) = 4 THEN 'Wend'
    WHEN DAYOFWEEK(created_at) = 5 THEN 'Thu'
    WHEN DAYOFWEEK(created_at) = 6 THEN 'Fri'
    WHEN DAYOFWEEK(created_at) = 7 THEN 'Sat'
END AS days,
COUNT(created_at) AS count
FROM complete_tests
GROUP BY day
ORDER BY count DESC;

-- Query 4: Excluding dog_guids with exclude flag from the results
%%sql
SELECT
    d.dog_guid AS DogID,
    d.exclude,
    c.created_at, 
    DAYNAME(c.created_at) AS day, 
    COUNT(d.dog_guid) AS count
FROM complete_tests c JOIN dogs d
ON c.dog_guid=d.dog_guid
WHERE d.exclude!= 1 OR d.exclude IS NULL
GROUP BY DAYNAME(c.created_at)
ORDER BY count DESC;

-- Query 5: Retrieving common dog_guids for users using inner join
%%sql
SELECT COUNT(d.dog_guid)
FROM dogs d JOIN users u
ON d.user_guid=u.user_guid;

-- Query 6: Retrieving distinct dog_guids using inner join
%%sql
SELECT COUNT(DISTINCT(d.dog_guid))
FROM dogs d JOIN users u
ON d.user_guid=u.user_guid;

-- Query 7: Retrieving distinct dog_guids excluding excluded ones
%%sql  
(SELECT DISTINCT dog_guid  
FROM dogs d JOIN users u    
ON d.user_guid=u.user_guid 
WHERE (u.exclude IS NULL OR u.exclude=0) AND (d.exclude IS NULL OR d.exclude=0));

-- Query 8: Adapting previous query to exclude excluded dog_guids
%%sql 
SELECT DAYOFWEEK(c.created_at) AS dayasnum,
    YEAR(c.created_at) AS year,
    COUNT(c.created_at) AS numtests, 
    (CASE    
        WHEN DAYOFWEEK(c.created_at)=1 THEN "Su"    
        WHEN DAYOFWEEK(c.created_at)=2 THEN "Mo"    
        WHEN DAYOFWEEK(c.created_at)=3 THEN "Tu"    
        WHEN DAYOFWEEK(c.created_at)=4 THEN "We"    
        WHEN DAYOFWEEK(c.created_at)=5 THEN "Th"   
        WHEN DAYOFWEEK(c.created_at)=6 THEN "Fr"    
        WHEN DAYOFWEEK(c.created_at)=7 THEN "Sa" 
    END) AS daylabel 
FROM complete_tests c JOIN          
    (SELECT DISTINCT dog_guid     
     FROM dogs d JOIN users u        
     ON d.user_guid=u.user_guid    
     WHERE ((u.exclude IS NULL OR u.exclude=0)          
            AND (d.exclude IS NULL OR d.exclude=0))) AS dogs_cleaned     
    ON c.dog_guid=dogs_cleaned.dog_guid 
GROUP BY daylabel 
ORDER BY numtests DESC; 

-- Query 9: Providing a count of tests completed on each weekday of each year
%%sql 
SELECT DAYOFWEEK(c.created_at) AS dayasnum,
YEAR(c.created_at) AS year, 
COUNT(c.created_at) AS numtests, 
(CASE 
    WHEN DAYOFWEEK(c.created_at)=1 THEN "Su"   
    WHEN DAYOFWEEK(c.created_at)=2 THEN "Mo"    
    WHEN DAYOFWEEK(c.created_at)=3 THEN "Tu"    
    WHEN DAYOFWEEK(c.created_at)=4 THEN "We"    
    WHEN DAYOFWEEK(c.created_at)=5 THEN "Th"    
    WHEN DAYOFWEEK(c.created_at)=6 THEN "Fr"    
    WHEN DAYOFWEEK(c.created_at)=7 THEN "Sa" 
END) AS

 daylabel 
FROM complete_tests c JOIN          
    (SELECT DISTINCT dog_guid     
     FROM dogs d JOIN users u        
     ON d.user_guid=u.user_guid    
     WHERE ((u.exclude IS NULL OR u.exclude=0)          
            AND (d.exclude IS NULL OR d.exclude=0))) AS dogs_cleaned     
    ON c.dog_guid=dogs_cleaned.dog_guid 
GROUP BY year, daylabel 
ORDER BY year ASC, numtests DESC; 

-- Query 10: Grouping by day and month to visualize the distribution of tests over time
%%sql
SELECT DAYOFWEEK(created_at) AS Day_of_Week,
MONTH(created_at) AS Month,
COUNT(*) AS Num_Tests
FROM complete_tests
GROUP BY Day_of_Week, Month;

-- Query 11: Calculating the average duration of tests by breed
%%sql
SELECT d.breed, AVG(TIMESTAMPDIFF(MINUTE, c.start_time, c.end_time)) AS Avg_Duration_Minutes
FROM complete_tests c JOIN dogs d
ON c.dog_guid = d.dog_guid
GROUP BY d.breed
ORDER BY Avg_Duration_Minutes DESC;

-- Query 12: Investigating the average number of tests completed by breed
%%sql
SELECT d.breed, COUNT(*) AS Num_Tests
FROM complete_tests c JOIN dogs d
ON c.dog_guid = d.dog_guid
GROUP BY d.breed
ORDER BY Num_Tests DESC;

-- Query 13: Identifying the top 10 most common breeds in the dataset
%%sql
SELECT d.breed, COUNT(*) AS Num_Tests
FROM complete_tests c JOIN dogs d
ON c.dog_guid = d.dog_guid
GROUP BY d.breed
ORDER BY Num_Tests DESC
LIMIT 10;

```sql
-- Query 14: Identifying user countries where English is the primary language
SELECT u.country, 
       AVG(TIMESTAMPDIFF(MINUTE, c.start_time, c.end_time)) AS Avg_Duration_Minutes
FROM complete_tests c JOIN dogs d
ON c.dog_guid = d.dog_guid
JOIN users u
ON d.user_guid = u.user_guid
WHERE u.language = 'en'
GROUP BY u.country
ORDER BY Avg_Duration_Minutes DESC;

-- Query 15: Analyzing the relationship between English-speaking user countries and test completion rates
SELECT u.country, 
       COUNT(*) AS Num_Tests,
       SUM(t.correct) AS Num_Correct_Answers,
       AVG(t.correct) AS Avg_Correctness_Rate
FROM complete_tests c JOIN dogs d
ON c.dog_guid = d.dog_guid
JOIN users u
ON d.user_guid = u.user_guid
JOIN exam_answers t
ON c.test_name = t.test_name
WHERE u.language = 'en'
GROUP BY u.country
ORDER BY Num_Tests DESC, Avg_Correctness_Rate DESC;
```
