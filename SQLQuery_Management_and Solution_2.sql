-- SOLUTION ON TASK 2


-- Examining the first 100 rows of the scheduled data
SELECT TOP(100) *
FROM Schedule_Data




-- JOINING Enrollment Data With Schedule Data and taking the fields that we need into condideration and adding filters
SELECT
	E.Stu_id,
	E.SchoolYr,
	E.Grade,
	E.Cohort,
	((E.SchoolYr - Cohort) + 9) AS EffectiveGrade,
	CASE
	WHEN ((E.SchoolYr - Cohort) + 9) > 12 THEN '12+'
	ELSE CAST(((E.SchoolYr - Cohort) + 9) AS VARCHAR(10))
	END AS Grade_Level,
	E.Graduated,
	S.CourseID,
	S.CourseName,
	S.Department,
	S.DropDate,
	S.WithdrawDate,
	S.WithdrawReasonCode
	FROM Enrollment E
LEFT JOIN Schedule_Data S
ON E.Stu_id = S.Stu_ID
WHERE S.DropDate IS NOT NULL
OR S.WithdrawReasonCode IS NOT NULL 
OR S.Department = 'Exams'





-- Final Query to solution 2
SELECT 
	Grade_Level,
	SchoolYr,
	COUNT(DISTINCT Stu_id) AS Student_Count_Exams_CD_Withdrawn
FROM 
(
SELECT
	E.Stu_id,
	E.SchoolYr,
	E.Grade,
	E.Cohort,
	((E.SchoolYr - Cohort) + 9) AS EffectiveGrade,
	CASE
	WHEN ((E.SchoolYr - Cohort) + 9) > 12 THEN '12+'
	ELSE CAST(((E.SchoolYr - Cohort) + 9) AS VARCHAR(10))
	END AS Grade_Level,
	E.Graduated,
	S.CourseID,
	S.CourseName,
	S.Department,
	S.DropDate,
	S.WithdrawDate,
	S.WithdrawReasonCode
	FROM Enrollment E
LEFT JOIN Schedule_Data S
ON E.Stu_id = S.Stu_ID
WHERE S.DropDate IS NOT NULL
OR S.WithdrawReasonCode IS NOT NULL 
OR S.Department = 'Exams'
) AS DerivedTable_2
	GROUP BY Grade_level, SchoolYr