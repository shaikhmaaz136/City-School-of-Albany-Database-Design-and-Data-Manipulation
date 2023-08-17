
-- SOLUTION ON TASK 1


-- SELECTING TOP 100 Rows just to take the idea of the table
SELECT TOP(100) *
FROM Enrollment;

-- Updating the current year first that will eventually lead us to the Grade Level
UPDATE [dbo].Enrollment
SET Cohort = CAST(Cohort AS INT),
SchoolYr = CAST(LEFT(SchoolYr, 4) AS INT);

-- Altered the tabled a bit and engineered the data as per the current need
ALTER TABLE [dbo].Enrollment
ADD SchoolYr_temp INT;

--Added 1 column as the effective grade which will be the defining factor for Grade Levels
SELECT SchoolYr, Stu_id, Grade, Cohort, (Cohort - [SchoolYr] + 9) AS [Effective Grade]
FROM Enrollment


-- Satisfying the conditions on kind of Unique Enrollments that we can get as per the business needs.
SELECT
	Stu_id,
	SchoolYr,
	Grade,
	Cohort,
	((SchoolYr - Cohort) + 9) AS EffectiveGrade,
	CASE
	WHEN ((SchoolYr - Cohort) + 9) > 12 THEN '12+'
	ELSE CAST(((SchoolYr - Cohort) + 9) AS VARCHAR(10))
	END AS Grade_Level
FROM Enrollment


-- Final Query

SELECT 
	Grade_Level,
	SchoolYr,
	COUNT(DISTINCT Stu_id) AS TotalStudents
FROM 
(
SELECT
	Stu_id,
	SchoolYr,
	Grade,
	Cohort,
	((SchoolYr - Cohort) + 9) AS EffectiveGrade,
	CASE
	WHEN ((SchoolYr - Cohort) + 9) > 12 THEN '12+'
	ELSE CAST(((SchoolYr - Cohort) + 9) AS VARCHAR(10))
	END AS Grade_Level
FROM Enrollment
) AS DerivedTable
GROUP BY Grade_level, SchoolYr



