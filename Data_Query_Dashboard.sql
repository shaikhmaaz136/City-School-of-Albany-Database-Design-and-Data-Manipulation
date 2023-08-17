
With Enrollment1 AS(
SELECT DISTINCT E.Stu_id, E.Cohort, E.SchoolYr,
	((E.SchoolYr - E.Cohort) + 9) AS EffectiveGrade,
	CASE
	WHEN ((E.SchoolYr - E.Cohort) + 9) > 12 THEN '12+'
	ELSE CAST(((E.SchoolYr - E.Cohort) + 9) AS VARCHAR(10))
	END AS Grade_Level,
	E.Graduated
FROM
Enrollment E
),
Schedule_Data1 AS
(
	SELECT DISTINCT S.SectionID, S.Stu_ID, S.CourseID, S.Department, S.DropDate, S.WithdrawDate, S.WithdrawReasonCode, S.CrsID, S.isGraded
	FROM Schedule_Data S
),
Grade_Data1 AS
(
	SELECT DISTINCT G.SectionID, G.Stu_id, G.MarkingPeriod, G.CourseID, G.CourseName, G.Department, G.PotentialCredits, G.EarnedCredits, G.ScoreText, G.Score
	FROM 
	Grade_Data G
),
Summer_Attendance1 AS
(
	SELECT DISTINCT SA.SectionID, SA.Stu_id, SA.Date,  SA.Type, SA.CourseID, SA.CourseDepartment, SA.KnownAbsence
	FROM SummerAttendance SA
)

SELECT * FROM Enrollment1 E1
LEFT JOIN Schedule_Data1 S1
ON E1.Stu_id = S1.Stu_ID
LEFT JOIN Grade_Data1 G1
ON E1.Stu_id = G1.Stu_id
AND S1.SectionID = G1.SectionID
AND S1.CourseID = G1.CourseID
LEFT JOIN Summer_Attendance1 SA
ON E1.Stu_id = SA.Stu_ID
AND S1.CourseID = SA.CourseID
AND G1.SectionID = SA.SectionID