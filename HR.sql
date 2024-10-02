-- Create Table for database
DROP TABLE IF EXISTS human_resource;
CREATE TABLE human_resource(
	Employee_Name varchar(100),	
	EmpID int,	
	MarriedID int,	
	MaritalStatusID int,	
	GenderID	int,
	EmpStatusID int,
	DeptID	int,
	PerfScoreID int,	
	FromDiversityJobFairID int,	
	Salary	int,
	Termd	int,
	PositionID	int,
	Position	varchar(50),
	State	varchar(50),
	Zip	int,
	DOB	date,
	Sex varchar(10),
	MaritalDesc	varchar(20),
	CitizenDesc		varchar(50),
	HispanicLatino varchar(20),
	RaceDesc varchar(50)
	DateofHire	date,
	DateofTermination	date,
	TermReason	varchar(100),
	EmploymentStatus varchar(100),	
	Department	varchar(100),
	ManagerName		varchar(100),
	ManagerID	int,
	RecruitmentSource 	varchar(20),	
	PerformanceScore	varchar(20),
	EngagementSurvey float,	
	EmpSatisfaction	int,
	SpecialProjectsCount int,	
	LastPerformanceReview_Date date,	
	DaysLateLast30 int,
	Absences int
);
-- EDA
SELECT * FROM human_resource;

-- Checking status of employees
SELECT DISTINCT employmentstatus,
	COUNT (*)
FROM human_resource
GROUP BY 1;

-- Checking most used recruitment source   
SELECT DISTINCT recruitmentsource,
	COUNT (*)
FROM human_resource
GROUP BY 1
ORDER BY 2 DESC; 

--Citizenship description
SELECT citizendesc,
COUNT (*)
FROM human_resource
GROUP BY 1

--Analyzing performance and allocating bonus
SELECT *
FROM 
(
SELECT empid, performancescore, position, salary,
	CASE WHEN performancescore = 'Exceeds' THEN 'Raise by 7%'
		 WHEN performancescore ='Fully Meets' THEN 'Raise by 5%'
		 WHEN performancescore ='PIP' THEN 'Raise by 2%'
	END 
FROM human_resource
) AS bonus
		

--Comparing Salaries
-- Salary distribution by gender
SELECT sex, AVG(salary), MAX(salary),MIN(salary),COUNT(salary)
FROM human_resource
GROUP BY 1

--Where employee in production has more than 50k salary
SELECT position, employee_name, MAX(salary)
FROM human_resource
WHERE position ILIKE '%production%'
GROUP BY 1,2
HAVING MAX(salary) >= 50000 


-- Adding a new column "age" 
SELECT
	dob,
	EXTRACT(YEAR FROM AGE(dob)) AS age
FROM human_resource;

ALTER TABLE human_resource ADD COLUMN age int;

UPDATE human_resource
SET age = EXTRACT(YEAR FROM AGE(dob));


--Solving 11 Problem Statements

--1. What is the gender breakdown of employees in the company?
SELECT sex,
	COUNT (*)
FROM  human_resource
GROUP BY 1;

--2. What is the race/ethnicity breakdown of employees in the company?
SELECT racedesc,
	COUNT (*)
FROM  human_resource
GROUP BY 1
ORDER BY 2 DESC;

--3. What is the age distribution of employees in the company?
--lowest and highest age
SELECT sex,
	MIN(age) min_age,
	MAX(age) max_age
FROM human_resource
GROUP BY 1;
--Age distribution of employees
SELECT 
    CASE 
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        WHEN age BETWEEN 50 AND 59 THEN '50-59'
        WHEN age >= 60 THEN '60 and above'
    END AS age_range,
    COUNT(*) AS employee_count
FROM (
    SELECT age
    FROM human_resource
) AS age_data
GROUP BY 1
ORDER BY 2 DESC;


--4. How many employees are always late and absent?
SELECT employee_name, dayslatelast30, absences
FROM human_resource
WHERE dayslatelast30 <> 0 AND absences <> 0
ORDER BY 2,3 DESC


--5. What is the average length of employment for employees who have been terminated?
SELECT * FROM human_resource;
--Avg length of employment:
SELECT
	ROUND(AVG(dateoftermination - dateofhire)/365) AS avg_employment_length
FROM human_resource
WHERE employmentstatus <> 'Active' AND dateoftermination IS NOT NULL;

--Checking length for all terminated employees
SELECT *,
	(dateoftermination - dateofhire)/365 AS employment_length
FROM human_resource
WHERE employmentstatus <> 'Active' AND dateoftermination IS NOT NULL
ORDER BY employment_length DESC;

--6. How does the gender distribution vary across departments and job titles?
SELECT DISTINCT sex, department, position,
COUNT (*) AS gender_count
--COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (PARTITION BY department, position) AS gender_distribution
FROM human_resource
GROUP BY 1,2,3
ORDER BY 4 DESC;

--7. What is the distribution of job titles across the company?
SELECT position,
	COUNT (*)
FROM  human_resource
--WHERE employmentstatus = 'Active'
GROUP BY 1
ORDER BY 2 DESC;

--8. Which department has the highest turnover rate?
SELECT department, total_count, termination_count,
 ROUND(termination_count/total_count * 100, 3) AS turnover_rate 
FROM (
SELECT department,
	COUNT(*) AS total_count,
	SUM(CASE WHEN dateoftermination IS NOT NULL AND
dateoftermination <= CURRENT_DATE THEN 1 ELSE 0 END ::numeric) AS termination_count
FROM human_resource
WHERE age >= 30
GROUP BY 1 	
) AS dept_calc
ORDER BY 4 DESC;

--9. What is the distribution of employees across locations by state?
SELECT state, 
COUNT (empid) 
FROM human_resource
WHERE age >= 30
GROUP BY 1
ORDER BY 2 DESC

--10. How has the company's employee count changed over time based on hire and term dates?
WITH change_data AS 
(
SELECT EXTRACT (YEAR FROM dateofhire) AS years,
COUNT(*) AS hires, 
SUM(CASE WHEN dateoftermination IS NOT NULL AND
dateoftermination <= CURRENT_DATE THEN 1 ELSE 0 END ::numeric) AS terminated
FROM human_resource
GROUP BY 1
)
SELECT years, hires, terminated, 
hires - terminated AS net_change,
ROUND((hires - terminated)/hires * 100 , 3) AS net_change_percent
FROM change_data
ORDER BY 5;

--11. What is the tenure distribution for each department?
SELECT department,
ROUND(AVG((dateoftermination - dateofhire)/365), 0) AS avg_tenure
FROM human_resource
WHERE dateoftermination IS NOT NULL AND
dateoftermination <= CURRENT_DATE
GROUP BY 1;
