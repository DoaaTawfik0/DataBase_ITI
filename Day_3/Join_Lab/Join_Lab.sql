use Company_SD;

select * from Employee;
select * from Departments;
select * from Project;
select * from Works_for;
select * from Dependent;

/* 1)Display the Department id, name and id and the name of its manager. */

select 
    CONCAT(Fname,' ',Lname) as Manager_Name,
    SSN as Manager_ID,
    Dname as Department_Name,
    Dnum as Department_ID 
from 
    Employee 
	inner join 
	Departments
on 
    SSN = MGRSSN;

/* 2)Display the name of the departments and the name of the projects under its control.*/

select 
    Dname as Department_Name,
	Pname as Project_Name
from 
    Departments as Department 
	inner join
	Project as Project
on 
    Department.Dnum = Project.Dnum;

/* 3)Display the full data about all the dependence associated with the name of the employee 
     they depend on him/her.*/

select 
    CONCAT(Parent.Fname,' ',Parent.Lname) as Employee,
	Child.*
from 
    Employee as Parent 
	inner join
	Dependent as Child
on 
    SSN = ESSN;

/* 4)Display the Id, name and location of the projects in Cairo or Alex city.*/

select 
     Pnumber as Project_ID,
	 Pname as Project_Nmae,
	 Plocation as Project_Location
from Project
where City in ('Cairo','Alex');

/* 5)Display the Projects full data of the projects with a name starts with "a" letter.*/

select *
from Project
where Pname like 'a%';

/* 6)Display all the employees in department 30 whose salary from 1000 to 2000 LE monthly*/

select *
from Employee
where Dno = 30 AND Salary between 1000 and 2000
order by Salary asc;

/* 7)Retrieve the names of all employees in department 10 who works more than or equal10 hours per week 
     on "AL Rabwah" project.*/
	 
select
     CONCAT(Emp.Fname,' ',Emp.Lname) as Employee
from
     Employee as Emp,
	 Works_for as Work,
	 Project as Project
where
     Emp.SSN = Work.ESSn 
	 AND
	 Emp.Dno = 10
	 AND
	 Work.Hours >= 10
	 AND
	 Project.Pnumber = Work.Pno
	 AND
	 Project.Pname = 'AL Rabwah';

/* 8)Find the names of the employees who directly supervised with Kamel Mohamed.*/

select 
      Concat(Parent.Fname , ' ' , Parent.Lname) as SuperVisor,
	  Concat(Child.Fname , ' ' , Child.Lname) as Employee
from 
      Employee Parent inner join Employee Child
on 
      Parent.SSN = Child.Superssn 
	  and 
	  Concat(Parent.Fname , ' ' , Parent.Lname) = 'Kamel Mohamed';

  
/* 9)Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.*/

select
      CONCAT(Emp.Fname , ' ' , Emp.Lname) as Employee,
	  Pname as Project
from 
      Employee as Emp,
	  Works_for as Work,
	  Project as Project
where 
      Emp.SSN = Work.ESSn
      AND
	  Project.Pnumber = Work.Pno;


/* 10)For each project located in Cairo City , find the project number,
      the controlling department name ,the department manager last name,
	  address and birthdate.*/

Select
     Manager.Lname Manager_Lname,
	 Manager.Address as Address,
	 Manager.Bdate,
	 Dep.Dname as Department,
	 Project.Pnumber as Project_ID
from
    Employee Manager,
	Departments Dep,
	Project Project
where 
     Dep.Dnum = Project.Dnum 
	 AND
	 Project.City = 'Cairo'
	 AND
	 Manager.SSN = DEP.MGRSSN;

/* 11)Display All Data of the mangers*/

select Manager.*
from
    Employee Manager
	inner join
	Departments Department
on
    Manager.SSN = Department.MGRSSN;

/* 12)Display All Employees data and the data of their dependents even if they have no dependents*/

select *
from 
    Employee Parent
	left outer join
	Dependent Child
on 
    Parent.SSN = Child.ESSN;


/********************** Data Manipulating Language *******************/

/*Insert your personal data to the employee table as a new employee in department number 30,
SSN = 102672, Superssn = 112233, salary=3000.*/
insert into Employee
values('Doaa','Tawfik',102672,'2002-5-25',NULL,'F',3000,112233,30);

/*Insert another employee with personal data your friend as new employee in department number 30,
SSN = 102660,but don’t enter any value for salary or manager number to him.*/
insert into Employee(Fname,Lname,SSN,Bdate,Address,Sex,Dno)
values('Ahmed','Ali',102660,'2002-7-25',NULL,'M',30);

/*Upgrade your salary by 20 % of its last value*/
update Employee
    Set salary = Salary * 1.20
where SSN = 102672;