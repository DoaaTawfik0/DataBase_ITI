use Company_SD;


insert into Dependent values
(669955,'Doaa Tawfik','M','2020-5-20');

update Dependent
set sex = 'F'
where Dependent_name like 'd%'

insert into Employee values
('Ziad','Tarek',123476,NULL,'Mansoura','M',3500,112233,10);

update Employee
set Salary = 3600
where ssn = 123476;

/********************* DQL *********************/

/*1. Display (Using Union Function)
       a.The name and the gender of the dependence that's gender is Female and depending 
	   on Female Employee.
       b.And the male dependence that depends on Male Employee.
*/

select child.Dependent_name , child.Sex
from   Employee parent, Dependent child
where parent.SSN = child.ESSN and parent.Sex = 'F' and child.Sex = 'F'

union all

select child.Dependent_name , child.Sex
from   Employee parent, Dependent child
where parent.SSN = child.ESSN and parent.Sex = 'M' and child.Sex = 'M';

select * from Employee;
select * from Dependent;

/*2.For each project, list the project name and the total hours per week 
(for all employees)spent on that project.*/

select project.Pname , SUM(work.Hours) as Hours
from Project as project inner join Works_for as work
on project.Pnumber = work.Pno
group by project.Pname

/*3.Display the data of the department which has the smallest employee ID
over all employees' ID.*/
                               /*Method 1*/
select *
from Departments
where Dnum = 
(
select top 1 Dno
from Employee 
order by SSN asc
); 
                               /*Method 2*/
select Departments.*
from Employee inner join Departments
on Dnum = Dno  
where Employee.ssn = (select min(SSN) from Employee);

/*4.For each department, retrieve the department name and the maximum, minimum 
and average salary of its employees.*/

                               /*Method 1*/
SELECT Dname AS Department,
       MIN(salary) AS Min_Salary,
	   MAX(salary) AS Max_Salary, 
	   AVG(Salary) AS Avg_Salary
FROM (SELECT Dname,
             Salary
	  FROM Employee 
	  INNER JOIN Departments 
	  ON  Departments.Dnum = Employee.Dno)
	  AS NewTable
GROUP BY Dname;
                               /*Method 2*/
SELECT dep.Dname AS Department, 
       MIN(emp.salary) AS Min_Salary, 
       MAX(emp.salary) AS Max_Salary, 
       AVG(emp.salary) AS Avg_Salary
FROM Employee AS emp
INNER JOIN Departments AS dep 
ON emp.Dno = dep.Dnum
GROUP BY dep.Dname;

/*5.List the last name of all managers who have no dependents.*/

SELECT Last_Name
FROM (
SELECT Parent.Lname AS Last_Name,
       Child.Dependent_name AS Dependant_Name
FROM Employee AS Parent
LEFT JOIN Dependent AS Child
ON SSN = ESSN
GROUP BY Child.Dependent_name, Parent.Lname)
AS NewTable
WHERE Dependant_Name IS NULL;

/*6.For each department-- if its average salary is less than the average salary
of all employees-- display its number,name and number of its employees.*/

                               /*Method 1*/
SELECT Department,
       Avg_Salary,
	   Employee_Num
FROM(
SELECT dep.Dname AS Department,
       AVG(emp.Salary) AS Avg_Salary,
	   COUNT(emp.SSN) AS Employee_Num
FROM Employee AS emp 
INNER JOIN Departments AS dep
ON dep.Dnum = emp.Dno
GROUP BY dep.Dname)
AS new_Table
where Avg_Salary < (select avg(Salary) from Employee);

                               /*Method 2*/
SELECT dep.Dname AS Department,
       dep.Dnum AS ID,
	   COUNT(emp.SSN) as Emp_Count
FROM Departments AS dep
LEFT JOIN Employee AS emp
on dep.Dnum = emp.dno
group by Dname,Dnum
having avg(emp.Salary) < (select avg(Salary) from Employee);

/*7.Retrieve a list of employees and the projects they are working on ordered by 
department and within each department, ordered alphabetically
by last name, first name.*/

SELECT Fname AS First_Name,
       Lname AS Last_Name, 
       project.pname AS Project_Name,
	   dep.Dname AS Department
FROM Employee AS emp,
     Works_for AS work,
	 Project AS project,
	 Departments AS dep
where emp.SSN = work.ESSn 
and project.Pnumber = work.Pno
and dep.Dnum = emp.Dno 
order by Department,
         Last_Name,
		 First_Name;
		

/*8.Try to get the max 2 salaries using subquery*/

SELECT DISTINCT Salary
FROM Employee
WHERE salary IN (
    SELECT DISTINCT TOP 2 salary
    FROM Employee
    ORDER BY salary DESC
)
ORDER BY salary DESC;

/*9.Get the full name of employees that is similar to any dependent name*/

SELECT distinct(CONCAT(Fname ,' ' , Lname))
FROM Employee AS emp,
Dependent AS dep
where SSN = ESSN and dep.Dependent_name like '%'+Fname+' '+Lname+'%';

/*10.Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30% */

update employee
set Salary = Salary*1.3
where SSN IN (select SSN
from Employee , Works_for , project
where SSN = ESSn AND Pnumber=Pno and Pname = 'Al Rabwah');

/*11.Display the employee number and name if at least one 
of them have dependents (use exists keyword) self-study.*/
select CONCAT(Fname ,' ',Lname),
SSN as ID
from Employee
where exists(
select *
from Dependent
WHERE SSN = ESSN
);

/***************** DML ****************/


/*1.In the department table insert new department called "DEPT IT" , with id 100, employee with SSN = 112233 as a manager 
for this department. The start date for this manager is '1-11-2006'*/
insert into Departments values
('DEPT IT',100,112233,'2006-11-1');


/*2.Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)  moved to be the manager of the new department (id = 100),
and they give you(your SSN =102672) her position (Dept. 20 manager)*/

/*a.First try to update her record in the department table*/
update Departments
set MGRSSN = 968574
where Dnum = 100;

/*b.Update your record to be department 20 manager.*/
update Departments
set MGRSSN = 102672
where Dnum = 20;

/*c.Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)*/
update Employee
set Superssn = 102672
where SSN = 102660;

/*3.Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344) so try to delete his data from your database in case
you know that you will be temporarily in his position.
Hint: (Check if Mr. Kamel has dependents, works as a department manager, supervises any employees or works in any projects
and handle these cases).*/
delete 
from Dependent 
where ESSN=223344

update Departments
set MGRSSN = 102672
where MGRSSN =223344

update Employee
set Superssn = 102672
where Superssn =223344

update Works_for
set ESSn = 102672
where ESSn =223344
delete from Employee where SSN=223344







