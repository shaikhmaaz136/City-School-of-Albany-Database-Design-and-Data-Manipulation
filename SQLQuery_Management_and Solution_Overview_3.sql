-- SOLUTION ON TASK 3
SELECT TOP (100) * 
FROM Enrollment


-- Taking important columns that we may need.
SELECT
	SchoolYr,
	Stu_id,
	Grade,
	Cohort,
	((SchoolYr - Cohort) + 9) AS EffectiveGrade,
	CASE
	WHEN ((SchoolYr - Cohort) + 9) > 12 THEN '12+'
	ELSE CAST(((SchoolYr - Cohort) + 9) AS VARCHAR(10))
	END AS Grade_Level,
	Graduated
FROM Enrollment





-- Final Query

WITH Potential_Graduates AS (
    SELECT 
		SchoolYr,
        Cohort,
        COUNT(Stu_id) AS Potential_Count
    FROM 
    (
        SELECT
            SchoolYr,
            Stu_id,
            Grade,
            Cohort,
            ((SchoolYr - Cohort) + 9) AS EffectiveGrade,
            CASE
            WHEN ((SchoolYr - Cohort) + 9) > 12 THEN '12+'
            ELSE CAST(((SchoolYr - Cohort) + 9) AS VARCHAR(10))
            END AS Grade_Level,
            Graduated
        FROM Enrollment
    ) sub
    WHERE Graduated = 0 AND (Grade_Level = '12+' OR Grade_Level = '12')
    GROUP BY Cohort, SchoolYr
),
Actual_Graduates AS (
    SELECT 
		SchoolYr,
        Cohort,
        COUNT(Stu_id) AS August_Count
    FROM 
    (
        SELECT
            SchoolYr,
            Stu_id,
            Grade,
            Cohort,
            ((SchoolYr - Cohort) + 9) AS EffectiveGrade,
            CASE
            WHEN ((SchoolYr - Cohort) + 9) > 12 THEN '12+'
            ELSE CAST(((SchoolYr - Cohort) + 9) AS VARCHAR(10))
            END AS Grade_Level,
            Graduated
        FROM Enrollment
    ) sub
    WHERE Graduated = 1 AND (Grade_Level = '12+' OR Grade_Level = '12')
    GROUP BY Cohort, SchoolYr
)

-- Main Query
SELECT
	PG.SchoolYr,
    PG.Cohort AS CohortYear,
    PG.Potential_Count AS PotentialGraduates,
    ISNULL(AG.August_Count, 0) AS ActualGraduatesInAugust,
    CAST((ISNULL(AG.August_Count, 0) * 100.0 / PG.Potential_Count) AS DECIMAL(5,2)) AS GraduationRate
FROM Potential_Graduates PG
LEFT JOIN Actual_Graduates AG ON PG.Cohort = AG.Cohort
ORDER BY PG.Cohort;


-- It's an approach, The analyysis on calculations and percetange calculation is done in EXCEL AND Tableau