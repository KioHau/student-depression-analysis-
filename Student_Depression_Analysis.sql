CREATE DATABASE Student_Depression_Detection;
SELECT * FROM Student_Depression_Dataset;
--Count_records
SELECT COUNT(*) FROM Student_Depression_Dataset;
--Detail_columns
SELECT s.name AS schema_name, t.name AS table_name, c.name AS column_name, ty.name AS data_type,
c.max_length, c.is_nullable
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
JOIN sys.columns c ON t.object_id = c.object_id
JOIN sys.types ty ON c.user_type_id = ty.user_type_id
ORDER BY s.name, t.name, c.column_id;
--Check_10_frist_records
SELECT TOP 10 *
FROM Student_Depression_Dataset;
--Check_count_null
SELECT 
SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS sum_Gender,
SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS sum_Age,
SUM(CASE WHEN Family_background IS NULL THEN 1 ELSE 0 END) AS sum_Family_background,
SUM(CASE WHEN Relationship_status IS NULL THEN 1 ELSE 0 END) AS sum_Relationship_status,
SUM(CASE WHEN Marital_status IS NULL THEN 1 ELSE 0 END) AS sum_Marital_status,
SUM(CASE WHEN Living_style IS NULL THEN 1 ELSE 0 END) AS sum_Living_style,
SUM(CASE WHEN Current_semester IS NULL THEN 1 ELSE 0 END) AS sum_Current_semester,
SUM(CASE WHEN CGPA IS NULL THEN 1 ELSE 0 END) AS sum_CGPA,
SUM(CASE WHEN friend_circle IS NULL THEN 1 ELSE 0 END) AS sum_friend_circle,
SUM(CASE WHEN Health_condition IS NULL THEN 1 ELSE 0 END) AS sum_Health_condition,
SUM(CASE WHEN Cost_without_study IS NULL THEN 1 ELSE 0 END) AS sum_Cost_without_study,
SUM(CASE WHEN Home_division IS NULL THEN 1 ELSE 0 END) AS sum_Home_division,
SUM(CASE WHEN Depression IS NULL THEN 1 ELSE 0 END) AS sum_Depression
FROM Student_Depression_Dataset;
--Check_duplicate_records
WITH check_duplicate_records AS(SELECT Gender, Age, Family_background, Relationship_status, Marital_status, Living_style, Current_semester, CGPA, friend_circle, Health_condition, Cost_without_study, Home_division, Depression,
ROW_NUMBER()OVER(PARTITION BY Gender, Age, Family_background, Relationship_status, Marital_status, Living_style, Current_semester, CGPA, friend_circle, Health_condition, Cost_without_study, Home_division, Depression ORDER BY (SELECT NULL)) AS rn
FROM Student_Depression_Dataset)
SELECT * FROM check_duplicate_records WHERE rn > 1;
--Check_distinct_Categorical
--Family_background
SELECT COUNT(*) AS Count_family_background,
Family_background
FROM Student_Depression_Dataset
GROUP BY Family_background
ORDER BY Count_family_background DESC;
--Gender
SELECT COUNT(*) AS Count_Gender,
Gender
FROM Student_Depression_Dataset
GROUP BY Gender
ORDER BY Count_Gender DESC;
--Relationship_status
SELECT COUNT(*) AS Count_Relationship_status,
Relationship_status
FROM Student_Depression_Dataset
GROUP BY Relationship_status
ORDER BY Count_Relationship_status DESC;
--Marital_status
SELECT COUNT(*) AS Count_Marital_status,
Marital_status
FROM Student_Depression_Dataset
GROUP BY Marital_status
ORDER BY Count_Marital_status DESC;
--Living_style
SELECT COUNT(*) AS Count_Living_style,
Living_style
FROM Student_Depression_Dataset
GROUP BY Living_style
ORDER BY Count_Living_style DESC;
--Health_condition
SELECT COUNT(*) AS Count_Health_condition,
Health_condition
FROM Student_Depression_Dataset
GROUP BY Health_condition
ORDER BY Count_Health_condition DESC;
--Home_division
SELECT COUNT(*) AS Count_Home_division,
Home_division
FROM Student_Depression_Dataset
GROUP BY Home_division
ORDER BY Count_Home_division DESC;
--Mim,Max,Avg_numerical
SELECT MIN(Age) AS min_age, MAX(Age) AS max_age, AVG(CAST(Age AS DECIMAL(10,2))) AS Avg_Age,
MIN(Current_semester) AS min_current_semester, MAX(Current_semester) AS max_current_semester, AVG(CAST(Current_semester AS DECIMAL(10,2))) AS Avg_Current_Semester,
MIN(CGPA) AS min_CGPA, MAX(CGPA) AS max_CGPA, AVG(CGPA) AS avg_CGPA,
MIN(Cost_without_study) AS min_Cost_without_study, MAX(Cost_without_study) AS max_Cost_without_study, AVG(Cost_without_study) AS avg_Cost_without_study
FROM Student_Depression_Dataset;
--Basic Quanlity Data Check
WITH Basic_quanlity_data AS 
(SELECT *,
CASE WHEN Age < 0 OR Age > 100 THEN 'Invalid Data' ELSE 'Valid' END AS check_age,
CASE WHEN Current_semester < 0 THEN 'Invalid Data' ELSE 'Valid' END AS check_current_semester,
CASE WHEN CGPA < 0  THEN 'Invalid Data' ELSE 'Valid' END AS check_CGPA,
CASE WHEN Cost_without_study < 0 THEN 'Invalid Data' ELSE 'Valid' END AS check_cost_without_study
FROM Student_Depression_Dataset)
SELECT *
FROM Basic_quanlity_data
WHERE check_age = 'Invalid Data'
OR check_current_semester = 'Invalid Data'
OR check_CGPA = 'Invalid Data'
OR check_cost_without_study = 'Invalid Data';
--Có 4464 dòng records
--Không phát hiện NULL ở 13 cột đã kiểm tra
--Không có dữ liệu duplicate hoan toan
--Không có dữ liệu âm ở 4 cột numerical columns
--Chưa phát hiện giá trị categorical bất thường qua việc kiểm tra phân bố.
--Data all valid
WITH check_final AS(SELECT Gender, Age, Family_background, Relationship_status, Marital_status, Living_style, Current_semester, CGPA, friend_circle, Health_condition, Cost_without_study, Home_division, Depression,
SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END)OVER() AS sum_Gender,
SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END)OVER() AS sum_Age,
SUM(CASE WHEN Family_background IS NULL THEN 1 ELSE 0 END)OVER() AS sum_Family_background,
SUM(CASE WHEN Relationship_status IS NULL THEN 1 ELSE 0 END)OVER() AS sum_Relationship_status,
SUM(CASE WHEN Marital_status IS NULL THEN 1 ELSE 0 END)OVER() AS sum_Marital_status,
SUM(CASE WHEN Living_style IS NULL THEN 1 ELSE 0 END)OVER() AS sum_Living_style,
SUM(CASE WHEN Current_semester IS NULL THEN 1 ELSE 0 END)OVER() AS sum_Current_semester,
SUM(CASE WHEN CGPA IS NULL THEN 1 ELSE 0 END)OVER() AS sum_CGPA,
SUM(CASE WHEN friend_circle IS NULL THEN 1 ELSE 0 END)OVER() AS sum_friend_circle,
SUM(CASE WHEN Health_condition IS NULL THEN 1 ELSE 0 END)OVER() AS sum_Health_condition,
SUM(CASE WHEN Cost_without_study IS NULL THEN 1 ELSE 0 END)OVER() AS sum_Cost_without_study,
SUM(CASE WHEN Home_division IS NULL THEN 1 ELSE 0 END)OVER() AS sum_Home_division,
SUM(CASE WHEN Depression IS NULL THEN 1 ELSE 0 END)OVER() AS sum_Depression,
ROW_NUMBER()OVER(PARTITION BY Gender, Age, Family_background, Relationship_status, Marital_status, Living_style, Current_semester, CGPA, friend_circle, Health_condition, Cost_without_study, Home_division, Depression ORDER BY (SELECT NULL)) AS rn,
CASE WHEN Age IS NULL THEN 'Missing'
WHEN Age < 0 OR Age > 100 THEN 'Invalid Data' 
ELSE 'Valid' END AS check_age,
CASE WHEN Current_semester < 0 THEN 'Invalid Data' ELSE 'Valid' END AS check_current_semester,
CASE WHEN CGPA < 0  THEN 'Invalid Data' ELSE 'Valid' END AS check_CGPA,
CASE WHEN Cost_without_study < 0 THEN 'Invalid Data' ELSE 'Valid' END AS check_cost_without_study
FROM Student_Depression_Dataset),
all_result_valid AS(
SELECT Gender, Age, Family_background, Relationship_status, Marital_status, Living_style, Current_semester, CGPA, friend_circle, Health_condition, Cost_without_study, Home_division, Depression,
CASE WHEN sum_Gender = 0
AND sum_Age = 0
AND sum_Relationship_status = 0
AND sum_Marital_status = 0
AND sum_Living_style = 0
AND sum_Family_background = 0
AND sum_Current_semester = 0
AND sum_CGPA = 0
AND sum_friend_circle = 0
AND sum_Health_condition = 0
AND sum_Cost_without_study = 0
AND sum_Home_division = 0 
AND sum_Depression = 0
AND rn = 1
AND check_age = 'Valid'
AND check_current_semester = 'Valid'
AND check_CGPA = 'Valid'
AND check_cost_without_study = 'Valid' THEN 'Valid' ELSE 'Error' END AS final_result
FROM check_final)
--Tao bang phu
SELECT * INTO #all_data FROM all_result_valid;

SELECT * INTO dbo.Student_Cleaned
FROM #all_data
WHERE 1 = 0;

INSERT INTO Student_Cleaned 
SELECT * FROM #all_data WHERE final_result = 'Valid';


SELECT
    (SELECT COUNT(*) FROM Student_Depression_Dataset) AS Raw_Count,
    (SELECT COUNT(*) FROM Student_Cleaned) AS Cleaned_Count;
SELECT COUNT(*) AS Total_Columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Student_Cleaned';
SELECT * FROM Student_Cleaned;

SELECT Gender, Age, Family_background, Relationship_status,
       Marital_status, Living_style, Current_semester, CGPA,
       friend_circle, Health_condition, Cost_without_study,
       Home_division, Depression
FROM Student_Depression_Dataset
EXCEPT
SELECT Gender, Age, Family_background, Relationship_status,
       Marital_status, Living_style, Current_semester, CGPA,
       friend_circle, Health_condition, Cost_without_study,
       Home_division, Depression
FROM Student_Cleaned;
--Đếm số lượng sinh viên theo từng giá trị của Depression.
WITH number_of_depression AS (
SELECT 
SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS sum_yes_depression,
SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) AS sum_no_depression,
COUNT(*) AS count_student_despression
FROM Student_Cleaned)
SELECT *, 
ROUND(sum_yes_depression * 100.0 / NULLIF(count_student_despression,0),2) AS proportion_yes,
ROUND(sum_no_depression * 100.0 / NULLIF(count_student_despression,0),2) AS proportion_no
FROM number_of_depression;
--Tỷ lệ trầm cảm giữa nam và nữ có sự khác biệt như thế nào?
WITH number_of_depression_gender AS (SELECT Gender,
COUNT(*) AS total_student,
SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depression_count
FROM Student_Cleaned
GROUP BY Gender)
SELECT *,
ROUND(depression_count * 100.0 / NULLIF(total_student,0), 2) AS depression_rate
FROM number_of_depression_gender;
--Tình trạng quan hệ (Relationship_status) có liên quan như thế nào đến tỷ lệ trầm cảm của sinh viên?
WITH number_of_depression_relationship_status AS 
(SELECT Relationship_status,
COUNT(*) AS total_student,
SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depression_count
FROM Student_Cleaned
GROUP BY Relationship_status)
SELECT *,
ROUND (depression_count * 100.0 / NULLIF(total_student,0), 2) AS depression_rate
FROM number_of_depression_relationship_status;
--Tỷ lệ trầm cảm có khác nhau giữa các nhóm tình trạng sức khỏe (Health_condition) không?
WITH number_of_depression_health_condition AS 
(SELECT Health_condition,
COUNT(*) AS total_student,
SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depression_count
FROM Student_Cleaned
GROUP BY Health_condition)
SELECT *,
ROUND (depression_count * 100.0 / NULLIF(total_student,0), 2) AS depression_rate
FROM number_of_depression_health_condition;
--Tỷ lệ trầm cảm có khác nhau giữa các nhóm lối sống (Living_style) không?
WITH number_of_depression_living_style AS 
(SELECT Living_style,
COUNT(*) AS total_student,
SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depression_count
FROM Student_Cleaned
GROUP BY Living_style)
SELECT *,
ROUND (depression_count * 100.0 / NULLIF(total_student,0), 2) AS depression_rate
FROM number_of_depression_living_style;
--Tỷ lệ trầm cảm có khác nhau giữa các nhóm hoàn cảnh gia đình (Family_background) không?
WITH number_of_depression_family_background AS 
(SELECT Family_background,
COUNT(*) AS total_student,
SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depression_count
FROM Student_Cleaned
GROUP BY Family_background)
SELECT *,
ROUND (depression_count * 100.0 / NULLIF(total_student,0), 2) AS depression_rate
FROM number_of_depression_family_background;
--Tỷ lệ trầm cảm có thay đổi theo từng học kỳ của sinh viên không?
WITH number_of_depression_current_semester AS
(SELECT Current_semester,
COUNT(*) AS total_student,
SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depression_count
FROM Student_Cleaned
GROUP BY Current_semester)
SELECT *,
ROUND (depression_count * 100.0/ NULLIF(total_student, 0), 2) AS depression_rate
FROM number_of_depression_current_semester
ORDER BY Current_semester ASC;
--Tỷ lệ trầm cảm có thay đổi theo độ tuổi sinh viên không?
WITH number_of_depression_age AS
(SELECT Age,
COUNT(*) AS total_student,
SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depression_count
FROM Student_Cleaned
GROUP BY Age)
SELECT *,
ROUND (depression_count * 100.0/ NULLIF(total_student, 0), 2) AS depression_rate
FROM number_of_depression_age
ORDER BY Age ASC;
--Tỷ lệ trầm cảm có thay đổi theo mức điểm CGPA của sinh viên không?
WITH number_of_depression_CGPA AS
(SELECT CGPA,
COUNT(*) AS total_student,
SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depression_count
FROM Student_Cleaned
GROUP BY CGPA)
SELECT *,
ROUND (depression_count * 100.0/ NULLIF(total_student, 0), 2) AS depression_rate
FROM number_of_depression_CGPA
ORDER BY CGPA ASC;
--Chi phí sinh hoạt (Cost_without_study) có mối liên hệ như thế nào với tỷ lệ trầm cảm?
WITH number_of_depression_cost_without_study AS
(SELECT Cost_without_study,
COUNT(*) AS total_student,
SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depression_count
FROM Student_Cleaned
GROUP BY Cost_without_study)
SELECT *,
ROUND (depression_count * 100.0/ NULLIF(total_student, 0), 2) AS depression_rate
FROM number_of_depression_cost_without_study
ORDER BY Cost_without_study ASC;
--Tỷ lệ trầm cảm giữa nam và nữ có khác nhau khi xét thêm tình trạng quan hệ (Relationship_status) không?
WITH number_of_depression_gender_relationship_status AS 
(SELECT Gender, Relationship_status,
COUNT(*) AS total_student,
SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depression_count
FROM Student_Cleaned
GROUP BY Gender, Relationship_status)
SELECT *,
ROUND(depression_count * 100.0 / NULLIF(total_student, 0),2) AS depression_rate
FROM number_of_depression_gender_relationship_status
ORDER BY Gender, Relationship_status;
--Tỷ lệ trầm cảm có khác nhau giữa các nhóm sức khỏe khi xét thêm lối sống của sinh viên không?
WITH number_of_depression_health_living AS 
(SELECT Health_condition, Living_style,
COUNT(*) AS total_student,
SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depression_count
FROM Student_Cleaned
GROUP BY Health_condition, Living_style)
SELECT *,
ROUND(depression_count * 100.0 / NULLIF(total_student, 0),2) AS depression_rate
FROM number_of_depression_health_living
ORDER BY Health_condition, Living_style;
--Tỷ lệ trầm cảm của từng nhóm giới tính cao hay thấp hơn tỷ lệ trầm cảm chung của toàn bộ sinh viên?
WITH gender_stats AS (SELECT Gender,
COUNT(*) AS total_student,
SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depression_count
FROM Student_Cleaned
GROUP BY Gender),
overall_stats AS
(SELECT 
SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS number_depression_yes,
COUNT(*) AS all_student
FROM Student_Cleaned),
cal_depression AS(
SELECT gs.Gender, gs.total_student, gs.depression_count, os.number_depression_yes, os.all_student,
ROUND(depression_count * 100.0 / NULLIF(total_student, 0), 2) AS depression_rate_gender,
ROUND(number_depression_yes * 100.0/NULLIF(all_student, 0) ,2) AS depression_rate
FROM gender_stats gs CROSS JOIN overall_stats os)
SELECT *,
depression_rate_gender - depression_rate AS depression_rate_difference,
CASE WHEN depression_rate_gender > depression_rate THEN 'Greater than'
WHEN depression_rate_gender < depression_rate THEN 'Smaller'
ELSE 'Equal' END AS depression_rate_status
FROM cal_depression;
--Trong mỗi nhóm giới tính, tỷ lệ sinh viên không bị Depression là bao nhiêu?
WITH number_no_gender_stats AS (SELECT Gender,
COUNT(*) AS total_student,
SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) AS depression_no_count,
SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depression_yes_count
FROM Student_Cleaned
GROUP BY Gender),
cal_no_yes_gender AS(
SELECT *, 
ROUND(depression_no_count * 100.0 / NULLIF(total_student, 0), 2) AS no_depression_rate,
ROUND(depression_yes_count * 100.0 / NULLIF(total_student, 0), 2) AS yes_depression_rate
FROM number_no_gender_stats
)
SELECT *,
CASE WHEN depression_no_count + depression_yes_count = total_student THEN 'Right'
ELSE 'Wrong' END AS check_status
FROM cal_no_yes_gender;
--Dựa trên cột Relationship_status, hãy tìm nhóm có tỷ lệ Depression cao nhất.
WITH number_of_relationship AS(
SELECT Relationship_status, COUNT(*) AS total_student_relationship,
SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depression_student_relationshion
FROM Student_Cleaned
GROUP BY Relationship_status),
cal_depression_rate AS (
SELECT *,
ROUND(depression_student_relationshion * 100.0 / NULLIF(total_student_relationship, 0) , 2) AS depression_rate 
FROM number_of_relationship
),
dense_rank_depression AS (
SELECT *, DENSE_RANk()OVER(ORDER BY depression_rate DESC) AS dense_rank_depression_rate
FROM cal_depression_rate
)
SELECT *
FROM dense_rank_depression
WHERE dense_rank_depression_rate = 1
--Xếp hạng theo depression_count giảm dần.
WITH number_of_relationship AS(
SELECT Relationship_status, COUNT(*) AS total_student_relationship,
SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depression_student_relationshion
FROM Student_Cleaned
GROUP BY Relationship_status)
SELECT *, DENSE_RANk()OVER(ORDER BY depression_student_relationshion DESC) AS dense_rank_depression_count
FROM number_of_relationship;
--Xem nhóm nào có tỷ lệ cao nhất và nhóm nào có số lượng sinh viên Depression cao nhất.
WITH relationship_status_stats AS (
SELECT Relationship_status, 
COUNT(*) AS count_depression_relationship,
SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS sum_student_depression_relationship
FROM Student_Cleaned 
GROUP BY Relationship_status)
SELECT *,
ROUND(sum_student_depression_relationship * 100.0 / NULLIF(count_depression_relationship, 0), 2) AS depression_rate,
DENSE_RANK()OVER(ORDER BY(ROUND(sum_student_depression_relationship * 100.0 / NULLIF(count_depression_relationship, 0), 2)) DESC) AS dense_rank_depression_rate,
DENSE_RANK()OVER(ORDER BY(sum_student_depression_relationship) DESC) AS dense_rank_count_depression
FROM relationship_status_stats rss 
