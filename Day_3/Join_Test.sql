use Company_SD;

delete from Dependent
where Dependent_name = 'Omar Amr Omran';


/*Inner Join*/
select Fname , Dependent_name
from Employee inner join Dependent
on SSN = ESSN;

/*Outer Join*/
   /*Left Outer Join*/
select Fname , Dependent_name
from Employee left outer join Dependent
on SSN = ESSN;

   /*Right Outer Join*/
select Fname , Dependent_name
from Employee Right outer join Dependent
on SSN = ESSN;


   /*Full Outer Join*/
select Fname , Dependent_name
from Employee full outer join Dependent
on SSN = ESSN;


/*Self Join*/
select parent.Fname as SuperVisor, child.Fname as Employee
from Employee as Parent , Employee as Child
where parent.SSN = Child.Superssn;

/*Manager and His Department*/
select Fname as Manager , Dname as Department
from Employee inner join Departments
on SSN = MGRSSN;

/*Each Department and its Projects*/
select Dname as Department , Pname as Project
from Departments as Department, Project as Project
where Department.Dnum = Project.Dnum;

/*Multi_Join-> Get each Department with its Manager and Projects*/
select Fname as Manager, Dname as Department, Pname as Project
from Employee , Departments Dep, Project Proj
where SSN = MGRSSN  AND Dep.Dnum = Proj.Dnum;

/*Kamel to Manage DP5 - > Join with DML*/
update Departments
  set Dname = 'DP5'
from Employee , Departments
where SSN = MGRSSN and Dname = 'Dp1';







select * from Employee;
select * from Departments;
select * from Dependent;

