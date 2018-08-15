#1
select m.last_name, e.phone_number, count(*) 
from employees m join employees e 
on e.employee_id = m.manager_id 
group by e.employee_id, e.last_name;

#2
 select l.city,e.salary,j.job_title,d.department_name
 from departments d join employees e join locations l join jobs j
 on e.department_id=d.department_id and d.location_id=l.location_id and e.job_id=j.job_id
 group by l.city;
 
 #3
 select count(*)
 from employees
 where last_name like'%n';
 
 #4
 select e.first_name,d.department_id, l.location_id, d.department_name, count(*) 
from locations l inner join departments d 
on d.location_id=l.location_id inner join employees e on e.department_id=d.department_id 
group by d.department_id, l.location_id;

#5
 SELECT *FROM job_history 
where extract(day from start_date )<='15';

#6
select e.department_id, min(e.salary),avg(e.salary) avg
  from employees e
  group by e.department_id
  having cast(avg(e.salary) as decimal(10,4))= (select cast(max(t.mavg) as decimal(10,4)) from ( select avg(e.salary) mavg
                          from employees e
                         group by e.department_id)t);

#7
select distinct department_name,city,e.department_id
from departments d join locations l join employees e
on d.location_id=l.location_id and e.department_id=d.department_id
where job_id <>"SA REP";

#8
#a and b
select t3.mcount,t3.department_id, t3.department_name from
(select max(t.dcount) mxdc, min(t.dcount) minc  from (
select count(d.department_id) dcount,d.department_id,department_name from
departments d natural join employees e 
group by d.department_id,d.department_name
)t)t2
join
(select count(d.department_id) mcount , d.department_id, department_name from
departments d natural join employees e
group by d.department_id, d.department_name
order by mcount
)t3
where t2.mxdc = t3.mcount
OR t2.minc = t3.mcount;

#c
select count(d.department_id) count,d.department_id,d.department_name from    
 departments d natural join employees e 
group by d.department_id having
 count <3;
#9
select count(*),extract(year from start_date) as years
from job_history
group by years;

#10
select country_name,count(location_id) No_Of_Locations
from countries natural join locations
group by country_name;