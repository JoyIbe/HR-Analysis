## Detailed HR Analysis using Postgresql
This analysis aims to understand an organization's workforce better and make data-driven decisions. It contains a variety of information related to employees, recruitment, performance, and retention.
Data cleaning and processing was carried out on both Ms Excel and postgres respectively.

# Major Features
1. Employee Demographics: Age, gender, race, etc provide insights into workforce diversity and help analyze trends related to age and gender in specific roles.
2. Employment Information: Job title, department, date hired and terminated help track employee tenure and departmental structure, facilitating workforce planning.
3. Compensation: Salary data allows for analysis of compensation trends, pay disparity, and financial forecasting.
4. Performance Metrics: Performance ratings and training hours enable evaluation of employee performance and the effectiveness of training programs.
5. Absenteeism: Tracking absences can help identify potential issues such as burnout or dissatisfaction within teams.
6. Employment Status: Understanding current employment status aids in retention analysis and identifying turnover rates.

# Concerns
1. What is the gender breakdown of employees in the company?
2. What is the race/ethnicity breakdown of employees in the company?
3. What is the age distribution of employees in the company?
4. How many employees are always late and absent?
5. What is the average length of employment for employees who have been terminated?
6. How does the gender distribution vary across departments and job titles?
7. What is the distribution of job titles across the company?
8. Which department has the highest turnover rate?
9. What is the distribution of employees across locations by state?
10. How has the company's employee count changed over time based on hire and term dates?
11. What is the tenure distribution for each department?

# Findings and Conclusion
1. According to this dataset, we have more female employees than male.
2. The production departments records more turnover than other departments in the organizations while Executive office records least.
3. The average length of employment for terminated employees is around 9 years.
4. This data records more white race and US Citizens over all other races and citizenship description.
5. Age distribution: A large number of employees are between 40-49. They are employees below 30-39 years.
6. The net change in employees has increased over the years.
7. The average tenure for each department is about 4 years with Software Engineering having the highest and Admin Offices and IT/IS having the lowest.
8. Bonus incentives should be giving to employees who exceed performance target.
9. Larger number of employees are ecruited from mostly Indeed and LinkedIn.
10. The gender distribution across departments is fairly distributed amongst male than female employees.
    
# Code:
Check [HR.sql]()
```sql
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
```