USE SD;


/*
****Create a new user data type named loc with the following Criteria:
�	nchar(2)
�	default:NY 
�	create a rule for this Datatype :values in (NY,DS,KW)) and associate it to the Location
*/
CREATE DEFAULT D1_Loc AS 'NY';

CREATE RULE R1_LOC AS @LOC IN ('NY', 'DS', 'KW');

EXEC sp_addtype LOC_DT , 'nchar(2)' , 'not null';

EXEC sp_bindrule 'R1_LOC' , 'LOC_DT';
EXEC sp_bindefault 'D1_Loc' , 'LOC_DT';

/*Creating Table and Assign NEW_DT to Location */
CREATE TABLE Departments
(
   DepNo  int PRIMARY KEY ,
   DepName  varchar(50) ,
   Location LOC_DT
);

/*Inserting Values into Departments*/
INSERT INTO Departments(DepNo,DepName) 
VALUES (1,'Research');
INSERT INTO Departments
VALUES
(2 , 'Accounting' , 'DS'),
(3 , 'Markting' , 'KW');

/******************************************************/
/***************** Employee Table *********************/
/******************************************************/

/*Create it by code*/
/*PK constraint on EmpNo*/
/*FK constraint on DeptNo*/
CREATE TABLE Employee
(
   EmpNo  int PRIMARY KEY,
   Emp_Fname varchar(30),
   Emp_Lname varchar(30),
   Salary int,
   Dept_No int
   CONSTRAINT C1 FOREIGN KEY(Dept_No) REFERENCES Departments(DepNo)
);

/*Unique constraint on Salary*/
ALTER TABLE Employee ADD CONSTRAINT C2 UNIQUE(Salary);

/*EmpFname, EmpLname don�t accept null values*/
CREATE RULE R1_NOTNULL AS @Name IS NOT NULL;
EXEC sp_bindrule 'R1_NOTNULL' , 'Employee.Emp_Fname';
EXEC sp_bindrule 'R1_NOTNULL' , 'Employee.Emp_Lname';


/*Create a rule on Salary column to ensure that it is less than 6000*/
CREATE RULE R2_Salary AS @SAL < 6000;
EXEC sp_bindrule 'R2_Salary' , 'Employee.Salary';

/*Inserting Data in Employee*/
INSERT INTO Employee VALUES
(25348 , 'Mathew' , 'Smith'     , 2500 , 3),
(10102 , 'Ann'    , 'Jones'     , 3000 , 3),
(18316 , 'John'   , 'Barrimore' , 2400 , 1),
(29346 , 'James'  , 'James'     , 2800 , 2),
(9031  , 'Lisa'   , 'Bertoni'   , 4000 , 2),
(2581 , 'Elisa'  , 'Moser'     , 3600 , 2),
(28559 , 'Sybl'   , 'Moser'     , 2900 , 1);

		
/******************************************************/
/***************** Project Table  *********************/
/******************************************************/
/*1-Create it using wizard*/
/*2-ProjectName can't contain null values*/
/*3-Budget allow null*/


/******************************************************/
/***************** Works_on Table  ********************/
/******************************************************/
/*1-Create it using wizard*/
/*2- EmpNo INTEGER NOT NULL*/
/*3-ProjectNo doesn't accept null values*/
/*4-Job can accept null*/
/*5-Enter_Date can�t accept null*/
/*6-The primary key will be EmpNo,ProjectNo) 
and has the current system date as a default 
value[visually]*/
/*7-there is a relation between works_on and employee,
Project  tables*/


/******************************************************/
/****           Testing Referential Integrity      ****/
/******************************************************/

/*1-Add new employee with EmpNo =11111 In the works_on 
table [what will happen]*/
insert into Works_On(Emp_No , Project_No) values
(11111  , 3);/*This row will not be inserted cuz there's no employee with ID 11111*/

/*Change the employee number 10102  to 11111  in the works on table
[what will happen]*/
update Works_On 
       SET Emp_No = 11111
where Emp_No = 10102;/*The update will not happen because ID Doesn't exist*/

/*Modify the employee number 10102 in the employee table to 22222. 
[what will happen]*/
UPDATE Employee
       SET EmpNo = 22222
WHERE EmpNo = 10102;/*The update will not happen cuz this ID is a Parent that Has Children in Works_on Table*/


/*Delete the employee with id 10102*/
delete from Employee
where EmpNo = 10102;/*The delete will not happen cuz this ID is a Parent that Has Children in Works_on Table*/


/******************************************************/
/****           Table modification                 ****/
/******************************************************/
/*Add  TelephoneNumber column to the employee table[programmatically]*/
Alter Table Employee Add TelephoneNumber int;

/*drop this column[programmatically]*/
Alter Table Employee drop column TelephoneNumber;

/*Bulid A diagram to show Relations between tables*/
/*->The Diagram is in Database Diagrams*/


/******************************************************/
/***************** Some Queries   *********************/
/******************************************************/

/*Create Company Schema*/
Create Schema Company;

/*Move Department table (Programmatically) to Company Schema*/
Alter Schema Company Transfer Departments;

/*Move Project table (using wizard) -> Done*/

/*Create Human Resources Schema*/
Create Schema HR;

/*Move Employee table (Programmatically) to HR Schema*/
Alter Schema HR Transfer Employee;




/*Write query to display the constraints for the Employee table.*/
select 
  CONSTRAINT_NAME , CONSTRAINT_TYPE , CONSTRAINT_SCHEMA
from 
    information_schema.table_constraints
where 
    table_name = 'Employee';



/*Create Synonym for table Employee as Emp and then run the following queries and describe the results
a.	Select * from Employee
b.	Select * from [Human Resource].Employee
c.	Select * from Emp
d.	Select * from [Human Resource].Emp
*/
Create Synonym Emp for HR.Employee;

Select * from Employee; /*Doesn't work because of Schema*/
Select * from HR.Employee;/*This will work and give data of table*/
Select * from Emp;/*This will work and give data of table*/
Select * from HR.Emp;/*This will not work because of HR.HR.Employee*/



/*Increase the budget of the project where the manager number is 10102 by 10%.*/
update Project
SET Project.Budget = Project.Budget * 1.10
from HR.Employee AS Employee , Works_On AS Work , Company.Project AS Project
Where Employee.EmpNo = Work.Emp_No and Project.Project_No = Work.Project_No and Employee.EmpNo = 10102


/*Change the name of the department for which the employee named James works.The new department name is Sales.*/

Update Department
Set Department.DepName = 'Sales'
From HR.Employee AS Employee , Company.Departments AS Department
where Department.DepNo = Employee.Dept_No AND Employee.Emp_Fname = 'James';


/*Change the enter date for the projects for those employees who work in project p1 and belong to department ‘Sales’. 
The new date is 12.12.2007.*/

update Work
SET Enter_Date = '12.12.2007'
from Company.Departments AS Department,
     Company.Project AS Project,
     HR.Employee AS Employee, 
	 Works_On AS Work
where Department.DepNo = Employee.Dept_No AND
      Employee.EmpNo = Work.Emp_No AND
	  Project.Project_No = Work.Project_No AND
	  Project.Project_No = 1 AND
	  Department.DepName = 'SALES';


/*Delete the information in the works_on table for all
employees who work for the department located in KW.*/

DELETE Work
from Company.Departments AS Department,
     HR.Employee AS Employee, 
	 Works_On AS Work
where Department.DepNo = Employee.Dept_No AND
      Employee.EmpNo = Work.Emp_No AND
	  Department.Location = 'KW';







