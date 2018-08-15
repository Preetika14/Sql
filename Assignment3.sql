#1
select * from countries;
select * from departments;
select * from employees;
select * from job_history;
select * from jobs;
select * from locations;
select * from regions;

#2
select salary,first_name
from employees;

#3
select salary,last_name
from employees
where salary>12000;

#4
select last_name,d.department_id
from employees e  join departments d 
on e.department_id=d.department_id
where e.employee_id = 176;

#5
select salary,last_name
from employees
where salary not between 5000 and 12000;

#6
select last_name,job_id,hire_date
from employees
where last_name in("Matos","Taylor") 
order by hire_date;

#7
select last_name,e.department_id
from employees e  join departments d 
on e.department_id=d.department_id
where e.department_id =20 or e.department_id =50
order by last_name;

#8
select last_name,job_title
from employees e natural join jobs
where manager_id is null;

#9
Select last_name,salary,(commission_pct*salary) 
from hr.employees 
where commission_pct is not null 
order by salary desc,(commission_pct*salary) desc;

#10
Select max(salary) as Maximum,min(salary) as Minimum,avg(salary) as Average,sum(salary) As Sum
from hr.employees;

#11
Select job_id,max(salary) as Maximum,min(salary) as Minimum,avg(salary) as Average,sum(salary) As Sum
from hr.employees
group by job_id;

#12
select job_id,count(*)
from employees
group by job_id;

#13
select count(manager_id) NUMBER_OF_MANAGERS
from employees
where manager_id is not null;

#14
select max(salary)-min(salary) as Difference from employees;

#15
select department_name,l.location_id,street_address,city,state_province,c.country_id,country_name
from locations l join departments d join countries c
on l.location_id=d.location_id and l.country_id=c.country_id
group  by department_name;

#16
select l.location_id,street_address,city,state_province,country_id from locations l natural join countries;

#17
select distinct last_name,department_name
from employees e join departments d 
on e.department_id=d.department_id;

#18
select last_name,job_id,d.department_name,d.department_id,city
from employees e join departments d join locations l
on e.department_id=d.department_id and d.location_id=l.location_id
where city ="Toronto";