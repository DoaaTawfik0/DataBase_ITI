USE ITI;

/*Create a stored procedure without parameters to show the number of students 
per department name.[use ITI DB] */

DROP PROCEDURE IF EXISTS Show_Students;

CREATE PROCEDURE Show_Students
AS 
SELECT 
      Department.Dept_Name AS Department,
	  COUNT(Student.St_Id) AS Num_Of_Students

FROM 
    ITI_Stud.Student AS Student 
INNER JOIN
    Department ON Department.Dept_Id = Student.Dept_Id
GROUP BY Department.Dept_Name;

EXECUTE Show_Students ;--Calling Stored Procedure


/*Create a stored procedure that will check for the # of employees in the project p100 
if they are more than 3 print message to the user 
“'The number of employees in the project p100 is 3 or more'” 
if they are less display a message to the user
“'The following employees work for the project p100'” 
in addition to the first name and last name of each one. [Company DB] */

USE Company_SD;


DROP PROC IF EXISTS CheckEmployeesInP100;

CREATE PROCEDURE CheckEmployeesInP100
AS 

BEGIN

DECLARE @Emp_Count INT  -- Declaring Variable for Counting

SELECT @Emp_Count = COUNT(Employee.SSN)

FROM 
    Employee
INNER JOIN
    Works_for AS Work ON Employee.SSN = Work.ESSn
INNER JOIN 
    Project ON Project.Pnumber = Work.Pno
WHERE Project.Pnumber = 100;


IF(@Emp_Count >= 3)
    PRINT 'The number of employees in the project p100 is 3 or more'
ELSE
  BEGIN
	PRINT 'The following employees work for the project p100' 

	SELECT
	    Employee.Fname AS First_Name,
		Employee.Lname AS Last_Name
	FROM 
        Employee
    INNER JOIN
        Works_for AS Work ON Employee.SSN = Work.ESSn
    INNER JOIN 
        Project ON Project.Pnumber = Work.Pno
    WHERE Project.Pnumber = 100;
  END

END

EXECUTE CheckEmployeesInP100;



/*Create a stored procedure that will be used in case there is an old employee 
has left the project and a new one become instead of him. The procedure should take
3 parameters (old Emp. number, new Emp. number and the project number) 
and it will be used to update works_on table. [Company DB]*/


DROP PROC IF EXISTS From_Old_To_New;

CREATE PROCEDURE From_Old_To_New (@Old_ID INT , @New_ID INT , @Project_ID INT)
AS
UPDATE Works_for
   SET ESSn = @New_ID
WHERE 
   ESSn = @Old_ID AND Pno = @Project_ID


EXECUTE From_Old_To_New 102672,112233,100; 



/*add column budget in project table and insert any draft values in it then Create an 
  Audit table with the following structure 

  ProjectNo 	UserName 	ModifiedDate 	Budget_Old 	Budget_New 
  p2 	        Dbo 	    2008-01-31	    95000 	    200000 

This table will be used to audit the update trials on the Budget column
(Project table, Company DB)
Example:
If a user updated the budget column then the project number,user name that made
that update, the date of the modification and the value of the old and the new budget 
will be inserted into the Audit table
Note: This process will take place only if the user updated the budget column
*/

ALTER TABLE Project ADD Budget INT; --Adding Budget Column into project table

--Creating Audit Table
CREATE TABLE Audit_Table
(
   UserName  VARCHAR(50),
   Modification_Date DATE,
   Old_Budget INT,
   New_Budget INT
)


DROP TRIGGER IF EXISTS Update_Budget;





CREATE TRIGGER Update_Budget
ON Project
INSTEAD OF UPDATE
AS
BEGIN
    -- Check if the Budget column is updated
    IF UPDATE(Budget)
    BEGIN
        -- Insert audit log into Audit_Table for all affected rows
        INSERT INTO Audit_Table (UserName, Modification_Date, Old_Budget, New_Budget)
        SELECT 
            SUSER_NAME(), 
            GETDATE(), 
            d.Budget AS Old_Budget, 
            i.Budget AS New_Budget
        FROM 
            deleted d
        INNER JOIN 
            inserted i ON d.Pnumber = i.Pnumber;

        -- Perform the actual update on the Project table
        UPDATE Project
              SET Project.Budget = i.Budget
        FROM 
		    Project 
        INNER JOIN 
		    INSERTED i ON Project.Pnumber = i.Pnumber;
    END
END;


UPDATE Project
   SET Budget = 300000
Where Pnumber = 100;

SElect * from Audit_Table






/*Create a trigger to prevent anyone from inserting a new record in the Department table
[ITI DB]
“Print a message for user to tell him that he can’t insert a new record in that table”*/

USE ITI;

DROP TRIGGER IF EXISTS No_Insert_Department;

CREATE TRIGGER No_Insert_Department
ON Department
INSTEAD OF INSERT
AS
Select 'You can’t insert a new record in Department Table'

INSERT INTO Department VALUES(100,'Technical',NULL,NULL,2,GETDATE());




/*Create a trigger that prevents the insertion Process for Employee table
in March [Company DB].*/

USE Company_SD;

DROP TRIGGER IF EXISTS No_Insert_In_March;

CREATE TRIGGER No_Insert_In_March
ON Employee
INSTEAD OF INSERT
AS
BEGIN

IF(MONTH(GETDATE()) = 3)
    Select 'You can’t insert a new record in March'
ELSE 
 BEGIN
    INSERT INTO Employee(Fname,Lname,SSN,Bdate,Address,Sex,Salary,Superssn,Dno) 
	SELECT Fname,Lname,SSN,Bdate,Address,Sex,Salary,Superssn,Dno 
	FROM
	INSERTED
 END
END

INSERT INTO Employee VALUES('ALI','KHALED',112299,'1-1-2002',NULL,'M',2000,112233,30);



/*Create a trigger on student table after insert to add Row in Student Audit table
(Server User Name , Date, Note) where note will be
“[username] Insert New Row with Key=[Key Value] in table [table name]”
Server_User_Name   Date   Note 
*/
USE ITI;

--Creating Audit_Table for Students
CREATE TABLE Std_Audit_Table
(
  Server_User_Name VARCHAR(50),
  Insertion_Date DATE,
  Note VARCHAR(100) 
)


DROP TRIGGER IF EXISTS Insert_Student;

CREATE TRIGGER Insert_Student
ON ITI_Stud.Student
AFTER INSERT
AS
BEGIN
    DECLARE  @ID INT;
	SELECT @ID = St_id FROM INSERTED;

    INSERT INTO Std_Audit_Table(Server_User_Name , Insertion_Date,Note) VALUES
	(SUSER_SNAME(),
	 GETDATE(),
	 CONCAT(
	        SUSER_SNAME(),
	        ' ',
			'Insert New Row with Key= ',
			@ID,
			' In Table [Student]'
			)
	)
END

INSERT INTO ITI_Stud.Student VALUES(42,'Ahmed','Marwan',NULL,15,40,2);

SELECT * FROM STD_AUDIT_TABLE;



/*
Display Each Department Name with its instructors. “Use ITI DB”
A)	Use XML Auto
B)	Use XML Path
*/

USE ITI;

--Using Auto XML
SELECT * FROM Department
FOR XML AUTO , ELEMENTS , ROOT('ITI');


--Using Path XML
SELECT 
     Dept_Id '@Depatment_ID',
	 Manager_hiredate '@Hire_Date',
	 Dept_Name 'Department_Name',
	 Dept_Desc 'Department_Description',
	 Dept_Manager 'Department_Manager_ID'
FROM
     Department
FOR XML PATH ('Department');




















































































































































