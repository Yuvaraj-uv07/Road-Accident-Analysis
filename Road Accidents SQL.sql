USE Road_Accidents;

SELECT * FROM road_accident;

-- 1. CY_Casualties (Current Year Casualties)

WITH current_year_casualties AS
(
SELECT * FROM road_accident
WHERE YEAR(accident_date) = 2025
)
SELECT * FROM current_year_casualties;



-- 2. CY – Fatal Casualties - 2022

WITH year2022_fatalcasualties AS
(
SELECT * FROM road_accident
WHERE 
	YEAR(accident_date) = 2022
	AND 
	accident_severity = 'Fatal'
)
SELECT * FROM year2022_fatalcasualties;



-- 3. CY – Serious Casualties -2022

WITH year2022_seriouscasualties AS
(
SELECT * FROM road_accident
WHERE 
	YEAR(accident_date) = 2022
	AND 
	accident_severity = 'Serious'
)
SELECT * FROM year2022_seriouscasualties;



-- 4. CY – Slight Casualties – 2022


WITH year2022_slightcasuality AS
(
SELECT * FROM road_accident
WHERE 
	YEAR(accident_date) = 2022
	AND 
	accident_severity = 'Slight'
)
SELECT * FROM year2022_slightcasuality;



-- 5. Total Number of [Slight, Fatal, Serious] Casualties

WITH casualitytypescount AS (
SELECT accident_severity,
	   COUNT(accident_severity) AS Total_Number
FROM road_accident
GROUP BY accident_severity
)
SELECT * FROM casualitytypescount
ORDER BY Total_Number DESC;



-- 6. Percentage(%) of Accidents that got Severity – Slight

WITH total_num_acc AS (
    SELECT COUNT(*) AS total_accidents
    FROM road_accident
),
num_of_slight_acc AS (
    SELECT COUNT(*) AS slight_accidents
    FROM road_accident
    WHERE accident_severity = 'Slight'
)
SELECT 
    ROUND((slight_accidents * 100.0 / total_accidents), 2) AS slight_accident_percentage
FROM total_num_acc, num_of_slight_acc;



-- 7. Percentage(%) of Accidents that got Severity – Fatal
WITH total_num_acc AS (
	SELECT COUNT(*) AS total_accidents
	FROM road_accident
),
num_fatal_acc AS (
	SELECT COUNT(*) AS fatal_accidents
	FROM road_accident
	WHERE accident_severity = 'Fatal'
)
SELECT
	ROUND((fatal_accidents * 100.0) / total_accidents,2) AS Fatal_accident_percentage
FROM total_num_acc, num_fatal_acc;




-- 8. Percentage(%) of Accidents that got Severity – Serious

WITH Serious_accident AS (
SELECT 
ROUND(
(
SELECT COUNT(*)
FROM road_accident
WHERE accident_severity = 'Serious' ) * 100.0
/
(
SELECT COUNT(*)
FROM road_accident
),2)
AS Serious_accident_percentage
)
SELECT * FROM Serious_accident;



-- 9. Vehicle Group – Total Number of Casualties

WITH vehicle_type_casualties AS (
SELECT vehicle_type, SUM(number_of_casualties) AS total_casualties
FROM road_accident
GROUP BY vehicle_type
)
SELECT * FROM vehicle_type_casualties
ORDER BY total_casualties DESC;



-- 10. CY – Casualties Monthly Trend

SELECT MONTH(accident_date) AS month,
COUNT(*) AS total_accidents
FROM road_accident
WHERE YEAR(accident_date) = 2022
GROUP BY MONTH(accident_date)
ORDER BY MONTH;

SELECT MONTH(accident_date) AS month,
COUNT(*) AS total_accidents
FROM road_accident
WHERE YEAR(accident_date) = 2021
GROUP BY MONTH(accident_date)
ORDER BY MONTH;

SELECT MONTH(accident_date) AS month,
COUNT(*) AS total_accidents
FROM road_accident
GROUP BY MONTH(accident_date)
ORDER BY MONTH;



-- 11. Types of Road – Total Number of Casualties:

WITH road_type_casualties AS (
	SELECT road_type,
		   SUM(number_of_casualties) AS Total_casulaties
	FROM
		road_accident
	GROUP BY road_type
	)
SELECT * FROM road_type_casualties
ORDER BY Total_casulaties DESC;



-- 12. Area – wise Percentage(%) and Total Number of Casualties

SELECT 
    main.urban_or_rural_area,
    (SELECT 
        SUM(subq.number_of_casualties) 
     FROM road_accident subq
     WHERE subq.urban_or_rural_area = main.urban_or_rural_area
    ) AS total_casualties,
    ROUND(
        (
            (SELECT 
                SUM(subq.number_of_casualties) 
             FROM road_accident subq
             WHERE subq.urban_or_rural_area = main.urban_or_rural_area
            ) * 100.0 /
            (SELECT SUM(number_of_casualties) FROM road_accident)
        ), 2
    ) AS percentage
FROM road_accident main
GROUP BY main.urban_or_rural_area;



-- 13. Count of Casualties By Light Conditions

SELECT light_conditions,
	   SUM(number_of_casualties) AS total_casualties
FROM road_accident
GROUP BY light_conditions
ORDER BY total_casualties DESC;



-- 14. Percentage (%) and Segregation of Casualties by Different Light Conditions

SELECT 
    main.light_conditions,
    (SELECT 
        SUM(subq.number_of_casualties) 
     FROM road_accident subq
     WHERE subq.light_conditions = main.light_conditions
    ) AS total_casualties,
    ROUND(
        (
            (SELECT 
                SUM(subq.number_of_casualties) 
             FROM road_accident subq
             WHERE subq.light_conditions = main.light_conditions
            ) * 100.0 /
            (SELECT SUM(number_of_casualties) FROM road_accident)
        ), 2
    ) AS percentage
FROM road_accident main
GROUP BY main.light_conditions
ORDER BY percentage DESC;



-- 15. Top 10 Local Authority with Highest Total Number of Casualties

SELECT TOP 10 local_authority,
			SUM(number_of_casualties) AS total_casualties
FROM road_accident
GROUP BY local_authority
ORDER BY total_casualties DESC;