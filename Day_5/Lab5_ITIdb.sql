use ITI;

insert into Instructor values
(16,'Osama',NULL,NULL,40);

/*1.Retrieve number of students who have a value in their age. */

select count(St_Id) AS Student_With_Age
from Student
where St_Age is not null;

/*2.Get all instructors Names without repetition*/

select distinct(Ins_Name)
from Instructor;

/*3.Display student with the following Format (use isNull function)
Student ID	Student Full Name	Department name*/

select St_Id as ID,
       concat(isnull(St_Fname,''),' ',isnull(St_Lname,'')) as full_name,
	   isnull(dp.Dept_Name,'not-Exist') as Department
from Student as st 
     join Department as dp
on dp.Dept_Id = st.Dept_Id;	

/*4.Display instructor Name and Department Name 
Note: display all the instructors if they are attached to a department or not*/

select Ins_Name as Instructor_Name,
       Dept_Name as Department_Name
from Department as Dep,
Instructor as Ins
where Dep.Dept_Id = Ins.Dept_Id;

/*5.Display student full name and the name of the course he is taking
For only courses which have a grade  */

SELECT CONCAT(St_Fname , ' ' , St_Lname) AS FULL_NAME,
       course.Crs_Name AS Course,
       st_course.Grade AS Grade
FROM Student AS student
JOIN Stud_Course AS st_course ON student.St_Id = st_course.St_Id
JOIN Course AS course ON course.Crs_Id = st_course.Crs_Id
WHERE st_course.Grade IS NOT NULL;

/*6.Display number of courses for each topic name*/

select topic.Top_Name as Topic,
       count(course.Crs_Id) as Courses_Count
from Course as course inner join 
     Topic as topic
	 on topic.Top_Id = course.Top_Id
	 group by Top_Name;

/*7.Display max and min salary for instructors*/

select max(Salary) as Max_Salary,
       min(Salary) as Min_Salary
from Instructor;

/*8.Display instructors who have salaries less than the average salary of all instructors.*/

select Ins_Name as Instructor,
       Salary as Instructor_Salary,
	   Dept_Id as Department
from Instructor
where Salary < (select AVG(Salary) from Instructor);

/*9.Display the Department name that contains the instructor who receives the minimum salary.*/

select instructor.Ins_Name AS Instructor,
       instructor.Salary AS Salary,
       department.Dept_Name AS Department
from Instructor as instructor join
     Department as department
on department.Dept_Id = instructor.Dept_Id
where instructor.Salary = (select  MIN(Salary)from Instructor)

/*10.Select max two salaries in instructor table*/

select TOP 2 Salary
from Instructor
group by Salary
order by Salary desc

/*11.Select instructor name and his salary but if there is no salary display instructor bonus.
“use one of coalesce Function”*/

SELECT Ins_Name AS Instructor,
       coalesce(convert(nvarchar(20),salary),'Instructor Bonus')
FROM Instructor
select * from Instructor

/*12.Select Average Salary for instructors */
select avg(salary)
from Instructor

/*13.Select Student first name and the data of his supervisor */

select concat(student.St_Fname,' ',student.St_Lname) as Student,
       concat(Supervisor.St_Fname,' ',Supervisor.St_Lname) as Supervisor,
	   Supervisor.St_Id AS Supervisor_ID,
	   Supervisor.St_Address AS Supervisor_Address,
	   Supervisor.St_Age as Supervisor_Age
FROM Student as student join
     Student as Supervisor
	 on Supervisor.St_Id = student.St_super;

/*14.Write a query to select the highest two salaries in Each Department for instructors 
who have salaries. “using one of Ranking Functions”*/

select * from 
(
select Ins_Name AS Instructor,
       Salary,
	   Dept_Id,
	   ROW_NUMBER() over (partition by Dept_Id order by salary) as RowNumber 
from instructor where salary is not null
)
as newtable where RowNumber <=2

/*15.Write a query to select a random  student from each department. 
“using one of Ranking Functions”*/

SELECT Student,
       Department
FROM (SELECT Student.St_Fname AS Student, 
             Department.Dept_Name AS Department,
             ROW_NUMBER() OVER (PARTITION BY Department.Dept_Name ORDER BY NEWID()) AS RowNum
    FROM Student
    JOIN Department 
	ON Department.Dept_Id = Student.Dept_Id
) AS RankedStudents
WHERE RowNum = 1;
