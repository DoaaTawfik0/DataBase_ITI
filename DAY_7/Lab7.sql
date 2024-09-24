USE ITI;

/*Create a scalar function that takes date and returns Month name of that date*/

CREATE FUNCTION Get_Month(@DateInput DATE)
RETURNS VARCHAR(50)
AS
BEGIN
    RETURN FORMAT(@DateInput, 'MMMM')
END

SELECT dbo.Get_Month('5-11-2010');

/*Create a multi-statements table-valued function that takes 2 integers and
returns the values between them*/

CREATE FUNCTION Get_In_Between(@Low INT , @High INT)
RETURNS @t TABLE
(
    Result INT
)
AS
BEGIN
  SET @Low = @Low + 1
	 while (@Low < @High)
	 BEGIN
	
	   insert into @t 
	   SELECT @Low
	    SET @Low = @Low + 1
	  
	 END
   return
END

SELECT * FROM Get_In_Between(1,5)

/*Create inline function that takes Student No and returns Department Name 
with Student full name*/

CREATE FUNCTION Get_DepName(@Std_ID INT)
RETURNS TABLE
AS
RETURN
(
   SELECT ST.St_Id AS Std_ID,
          CONCAT(ST.st_fname , ' ' , ST.st_lname) AS Name,
		  dp.Dept_Name AS Department
   FROM ITI_Stud.Student AS ST , Department AS DP
   WHERE ST.Dept_id = DP.Dept_Id AND ST.St_Id = @Std_ID

)

SELECT * FROM Get_DepName(5);


/*Create a scalar function that takes Student ID and returns a message 
  to user 
a.If first name and Last name are null then display 'First name 
& last name are null'
b.If First name is null then display 'first name is null'
c.If Last name is null then display 'last name is null'
d.Else display 'First name & last name are not null'
*/
DROP FUNCTION IF EXISTS Print_Message;  -- Drop the function if it exists

CREATE FUNCTION Print_Message(@Std_ID INT)
RETURNS VARCHAR(50)
AS
BEGIN 
    DECLARE @Fname VARCHAR(20), @Lname VARCHAR(20);

    -- Select first name and last name for the given Student ID
    SELECT @Fname = st_fname, @Lname = st_lname
    FROM ITI_Stud.Student
    WHERE St_id = @Std_ID;

    -- Check for null values and return appropriate message
    IF (@Fname IS NULL AND @Lname IS NULL)
    BEGIN
        RETURN 'First name & last name are null';
    END
    ELSE IF (@Fname IS NULL)
    BEGIN
        RETURN 'First name is null';
    END
    ELSE IF (@Lname IS NULL)
    BEGIN
        RETURN 'Last name is null'; 
    END
    
        RETURN 'First name & last name are not null';
    
END;

SELECT dbo.Print_Message(2)


/*Create inline function that takes integer which represents
  manager ID and displays department name, Manager Name and hiring date 
*/

CREATE FUNCTION Display_Data(@Manager_ID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT Department.Dept_Name AS Department,
	       Instructor.Ins_Name AS Manager,
		   Department.Manager_hiredate AS Hire_Data
	FROM Department , Instructor
	Where Instructor.Ins_Id = Department.Dept_Manager AND Dept_Manager = @Manager_ID
)
select * from Display_Data(2)

/*Create multi-statements table-valued function that takes a string
If string='first name' returns student first name
If string='last name' returns student last name 
If string='full name' returns Full Name from student table 
Note: Use “ISNULL” function
*/

CREATE FUNCTION Check_String(@Str_Var VARCHAR(20))
RETURNS @T TABLE (Name VARCHAR(50))

AS 
BEGIN
   
    IF @Str_Var = 'first name'
    BEGIN
        INSERT INTO @T
        SELECT ISNULL(St_Fname , 'N/A') 
		from ITI_Stud.Student;
    END
    ELSE IF @Str_Var = 'last name'
    BEGIN
        INSERT INTO @T
        SELECT ISNULL(St_Lname , 'N/A') 
		from ITI_Stud.Student;
    END
    ELSE IF @Str_Var = 'full name'
    BEGIN
        INSERT INTO @T
        SELECT CONCAT(ISNULL(St_Fname , 'N/A'), ' ', ISNULL(St_Lname , 'N/A') ) 
		from ITI_Stud.Student;
    END
    ELSE
    BEGIN
        INSERT INTO @T
        SELECT 'Invalid input';
    END

    RETURN;
END;


SELECT *FROM  Check_String('First Name')


/*Write a query that returns the Student No and Student first name without
the last char*/

SELECT ID , SUBSTRING(NAME ,1 , Length-1)
from (SELECT St_Id AS ID,
             St_Fname AS Name,
			 LEN(St_Fname) AS Length
FROM ITI_Stud.Student) AS new_Table
select st_fname from ITI_Stud.Student

/*Wirte query to delete all grades for the students Located in SD Department */

update Course 
set Grade = 0
FROM ITI_Stud.Student AS Student,
     Department,
	 Stud_Course AS Course
WHERE Department.Dept_Id = Student.Dept_Id AND
      Student.St_Id = Course.St_Id AND
	  Department.Dept_Name = 'SD'



SELECT Student.St_Fname,
       Department.Dept_Name,
	   Course.Grade AS Grade,
	   Course.Crs_Id
FROM ITI_Stud.Student AS Student,
     Department,
	 Stud_Course AS Course
WHERE Department.Dept_Id = Student.Dept_Id AND
      Student.St_Id = Course.St_Id AND
	  Department.Dept_Name = 'SD'
order by St_Fname asc


