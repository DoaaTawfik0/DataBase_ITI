use Compant_Wizard_DB;

/*1)Display all the employees Data.*/
select * From Employee;

/*2.Display the employee First name, last name, Salary and Department number.*/
Select F_Name , L_Name , Salary ,D_Num 
from Employee;


/*3.Display all the projects names, locations and the department which is responsible about it.*/
select P_Name , P_Location , D_Num
from Project;

/*4.]If you know that the company policy is to pay an annual commission for each employee with 
specific percent equals 10% of his/her annual salary .Display each employee full name and 
his annual commission in an ANNUAL COMM column (alias).*/

Select F_Name+''+L_Name as Full_Name , (Salary*(0.1)*12) as Annual_Salary 
From Employee;

/*5.Display the employees Id, name who earns more than 1000 LE monthly.*/
select SSN , CONCAT(F_Name,' ',L_Name) as "Full Name" , Salary
from Employee
where Salary > 1000;

/*6.Display the employees Id, name who earns more than 10000 LE annually.*/
select SSN , CONCAT(F_Name,' ',L_Name) as "Full Name" , Salary
from Employee
where Salary*12 > 10000;

/*7.Display the names and salaries of the female employees*/ 
select CONCAT(F_Name,' ',L_Name) as "Full Name" , Salary
from Employee
where sex = 'Female';



/*8.Display each department id, name which managed by a manager with id equals 968574.*/
Select D_Num , D_Name
From Department
where D_Num = 968574;




/*9.Dispaly the ids, names and locations of  the pojects which controled with department 10.*/
select P_Num , P_Name , P_Location
from Project
where D_Num = 10;



