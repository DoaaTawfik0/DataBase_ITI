USE ITI;

/*
  Create a view that displays student full name, course name if the student has a grade
  more than 50.
*/
DROP VIEW IF EXISTS Display_Student; 

CREATE VIEW Display_Student 
WITH ENCRYPTION
AS
SELECT 
    Student.St_Fname AS Name,
    Course.Crs_Name AS Course,
    Std_Course.Grade AS Grade
FROM 
    ITI_Stud.Student AS Student
INNER JOIN 
    Stud_Course AS Std_Course ON Student.St_Id = Std_Course.St_Id
INNER JOIN 
    ITI_Stud.Course AS Course ON Course.Crs_Id = Std_Course.Crs_Id
WHERE 
    Std_Course.Grade > 50;

-- To select from the view
SELECT * FROM dbo.Display_Student;


/*
  Create an Encrypted view that displays manager names and the topics they teach.
*/

DROP VIEW IF EXISTS Display_Manager;

CREATE VIEW Display_Manager 
WITH ENCRYPTION
AS
SELECT
     Instructor.Ins_Name AS Manager,
	 Topic.Top_Name AS Topic
FROM 
     Instructor 
INNER JOIN 
     Ins_Course ON Instructor.Ins_Id = Ins_Course.Ins_Id
INNER JOIN
     ITI_Stud.Course AS Course ON Course.Crs_Id = Ins_Course.Crs_Id
INNER JOIN
     Topic ON Topic.Top_Id = Course.Top_Id
INNER JOIN Department ON Instructor.Ins_Id = Department.Dept_Manager

SELECT * FROM Display_Manager

/*
  Create a view that will display Instructor Name, Department Name for the ‘SD’ or
  ‘Java’ Department 
*/

DROP VIEW IF EXISTS Display_Instructor

CREATE VIEW Display_Instructor 
WITH ENCRYPTION 
AS
SELECT
      Instructor.Ins_Name AS Instructor,
	  Department.Dept_Name AS Department
FROM
     Instructor
INNER JOIN
     Department ON Department.Dept_Id = Instructor.Dept_Id
WHERE
     Dept_Name IN('SD' , 'Java')

SELECT * FROM Display_Instructor

/*
  Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
  Note: Prevent the users to run the following query 
  Update V1 set st_address=’tanta’
  Where st_address=’alex’;
*/

DROP VIEW IF EXISTS V1;

CREATE VIEW V1
WITH ENCRYPTION
AS
SELECT 
       CONCAT(ISNULL(St_Fname , '') , ' ' , ISNULL(St_Lname , '')) AS Student,
	   St_Address AS Address,
	   St_Age AS Age,
	   Dept_Id AS Department_ID,
	   St_super AS Supervisor_ID
FROM ITI_Stud.Student AS Student
WHERE St_Address IN ('Alex' , 'Cairo')
WITH CHECK OPTION;

SELECT * FROM V1;

UPDATE V1
SET Address = 'Tanta'
FROM ITI_Stud.Student
where Address = 'Alex'

/**************************************************************************************/
/********************************* Company DB *****************************************/
/**************************************************************************************/

USE Company_SD;

/*Create a view that will display the project name and the number of employees 
work on it. “Use Company DB”*/

DROP VIEW IF EXISTS Count_Employee;

CREATE VIEW Count_Employee
WITH ENCRYPTION
AS
SELECT
      Project.Pname AS Project,
	  COUNT(Employee.Fname) AS Counting
FROM
     Employee 
INNER JOIN 
     Works_for AS Work ON Employee.SSN = Work.ESSn
INNER JOIN 
     Project ON Project.Pnumber = Work.Pno
GROUP BY  Project.Pname
WITH CHECK OPTION;

SELECT * FROM Count_Employee;


/*Create index on column (Hiredate) that allow u to cluster the data in table 
Department. What will happen?*/


--A table can have only one clustered index 
CREATE NONCLUSTERED INDEX Hiredate_Index 
ON 
Departments(MGRStartDate)

SELECT * FROM Departments
WHERE MGRStartDate BETWEEN '2002-01-01' AND '2008-01-01'
ORDER BY MGRStartDate;


/**************************************************************************************/
/********************************* ITI DB *****************************************/
/**************************************************************************************/


/*Create index that allow u to enter unique ages in student table. 
  What will happen?*/

USE ITI;

DROP INDEX IF EXISTS ITI_Stud.Student.Unique_Age;

CREATE UNIQUE INDEX Unique_Age
ON
ITI_Stud.Student(St_Age)

select* from ITI_Stud.Student


UPDATE ITI_Stud.Student
SET st_Age = 17
where st_id = 11

--When the values weren't unique there was an error
--as the unique index affects the old and new data 



/*Using Merge statement between the following two tables
  [User ID, Transaction Amount]*/

CREATE TABLE #Daily_Transaction
(
   Id INT,
   Trans_Amount INT
)

CREATE TABLE #Last_Transaction
(
   Id INT,
   Trans_Amount INT
)

insert into #Daily_Transaction values
(1 , 1000),
(2 , 2000),
(3 , 1000)

insert into #Last_Transaction values
(1 , 4000),
(4 , 2000),
(2 , 10000)

MERGE INTO #Daily_Transaction AS T
USING #Last_Transaction AS S
ON T.Id = S.Id
WHEN MATCHED THEN
	UPDATE SET T.Trans_Amount = S.Trans_Amount
WHEN NOT MATCHED THEN
     INSERT (Id, Trans_Amount)
	 Values(S.Id , S.Trans_Amount);

SELECT * FROM #Daily_Transaction;




/**************************************************************************************/
/*********************************     SD DB     **************************************/
/**************************************************************************************/

USE SD;

/*Create view named “v_clerk” that will display employee#,project#,
  the date of hiring of all the jobs of the type 'Clerk'.*/

DROP VIEW IF EXISTS V_Clerk

CREATE VIEW V_Clerk
WITH ENCRYPTION
AS
SELECT 
       CONCAT(ISNULL(Employee.Emp_Fname,''),' ',ISNULL(Employee.Emp_Lname,''))AS Employee,
	   Project.Project_Name AS Project,
       Project.Project_No AS Project_ID,
	   Work.Job

FROM 
    HR.Employee AS Employee
INNER JOIN 
    Works_On AS Work ON Employee.EmpNo = Work.Emp_No
INNER JOIN Company.Project AS Project ON Project.Project_No = Work.Project_No
WHERE Work.Job = 'Clerk';

SELECT * FROM V_Clerk;


/*Create view named “v_without_budget” that will display all the projects data 
without budget*/

DROP VIEW IF EXISTS v_without_budget

CREATE VIEW v_without_budget
WITH ENCRYPTION
AS
SELECT 
     Project_No AS Project_ID,
	 Project_Name AS Project
FROM
    Company.Project

SELECT * FROM v_without_budget;

/*Create view named  “v_count “ that will display the project name and 
the # of jobs in it*/

DROP VIEW IF EXISTS v_count

CREATE VIEW v_count
WITH ENCRYPTION
AS
SELECT 
     Project.Project_Name,
	 Work.Job,
FROM 
    Company.Project AS Project
INNER JOIN
	Works_On AS Work ON Project.Project_No = Work.Project_No
WHERE Work.Job IS NOT NULL
GROUP BY Project.Project_Name,Work.Job

SELECT * FROM v_count;


/*Create view named ” v_project_p2” that will display the emp# s for the project# ‘p2’
use the previously created view  “v_clerk”*/


DROP VIEW IF EXISTS v_project_p2;

CREATE VIEW v_project_p2
WITH ENCRYPTION
AS
SELECT *
FROM v_clerk
WHERE Project_ID = 2;

SELECT * FROM v_project_p2;


/*modifey the view named  “v_without_budget”  to display all DATA in project p1 
  and p2*/

ALTER VIEW v_without_budget
AS
SELECT *
FROM Company.Project
WHERE Project_No IN(1,2) 

SELECT * FROM v_without_budget; 


/*Delete the views  “v_ clerk” and “v_count”*/

DROP VIEW IF EXISTS V_Clerk;
DROP VIEW IF EXISTS v_count;



/*Create view that will display the emp# and emp lastname who works 
  on dept# is ‘d2’*/

DROP VIEW IF EXISTS Emp_Data;

CREATE VIEW Emp_Data
WITH ENCRYPTION
AS
SELECT 
     Employee.EmpNo AS ID,
	 Employee.Emp_Lname AS Last_Name,
	 Employee.Salary,
	 Departemt.DepName
FROM 
    HR.Employee AS Employee
INNER JOIN 
    Company.Departments AS Departemt ON Departemt.DepNo = Employee.Dept_No
WHERE Departemt.DepNo = 2;

SELECT * FROM Emp_Data;

/*Display the employee  lastname that contains letter “J”
Use the previous view created in Q#7*/

DROP VIEW IF EXISTS J_Lname;

CREATE VIEW J_Lname
WITH ENCRYPTION
AS
SELECT *
FROM Emp_Data
WHERE Last_Name LIKE '%J%'

SELECT * FROM J_Lname;

/*Create view named “v_dept” that will display the department# and
  department name*/

DROP VIEW IF EXISTS v_dept;

CREATE VIEW v_dept
WITH ENCRYPTION 
AS
SELECT 
    Department.DepNo AS ID,
	Department.DepName AS Department
FROM Company.Departments AS Department

SELECT * FROM v_dept;


/*using the previous view try enter new department data where dept# is ’d4’ 
  and dept name is ‘Development’*/

INSERT v_dept(ID,Department) VALUES (4,'Development');

SELECT * FROM V_dept;


/*Create view name “v_2006_check” that will display employee#, 
the project #where he works and the date of joining the project 
which must be from the first of January and the last of December 2006.
this view will be used to insert data so make sure that the coming new data
must match the condition*/

DROP VIEW IF EXISTS v_2006_check

CREATE VIEW v_2006_check
WITH ENCRYPTION
AS
SELECT 
      Employee.EmpNo AS Employee_ID,
	  Project.Project_No AS Project_ID,
	  Work.Enter_Date
FROM 
    HR.Employee AS Employee
INNER JOIN 
    Works_On AS Work ON Employee.EmpNo = Work.Emp_No
INNER JOIN 
    Company.Project AS Project ON Project.Project_No = Work.Project_No
WHERE Work.Enter_Date BETWEEN '2006-01-01' AND '2006-12-31'
WITH CHECK OPTION;

SELECT * FROM v_2006_check;

