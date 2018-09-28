#1
select
    a.Manager_id, b.manager_name, a.job,a. manager_name as boss_name
from
    Pms_manager_details a
         join
    pms_manager_details b ON a.manager_id = b.boss_code;
    
    #2
SELECT Manager_ID,Manager_Name,Job,Salary,Commission,Department_ID,max(salary)
 FROM PMS_MANAGER_DETAILS
 where salary< (Select max(salary) from PMS_MANAGER_DETAILS);
 #3
 select manager_id,manager_name,job,salary from pms_manager_details
where manager_name like '_a%' and salary > all(select max(salary) from pms_manager_details where manager_name like 'v%'); 

 #4
 SELECT MANAGER_ID, MANAGER_NAME, JOB, (salary+(salary*12*(7.5/100)))as net_salary 
 FROM PMS_MANAGER_DETAILS;
 #5
 SELECT MANFATURE_ID, PRODUCT_NAME, UNIT_ID, QUANTITY, PRODUCT_MANFACTURE_DATE, PRODUCT_EXPIRY_DATE
 FROM PMS_MANAGER_DETAILS pmd join PMS_DEPARTMENT_DETAILS pdd join PMS_MANUFACTURING pm join PMS_PRODUCT pp
 on pmd.department_id=pdd.department_id and pm.product_id=pp.product_id
 where DEPARTMENT_NAME='GHEE SECTION';
 #6
 Select quantity,sum(quantity)
 from PMS_MANUFACTURING
 group by quantity;
 #7
 select pp.product_id,product_name
 from PMS_MANUFACTURING pm join PMS_PRODUCT pp
 on pm.product_id=pp.product_id
 where PRODUCT_MANFACTURE_DATE>='2012-12-15';
 #8
 select pp.product_id,product_name,count(*) count_Product
 from PMS_MANUFACTURING pm join PMS_PRODUCT pp
 on pm.product_id=pp.product_id
 group by pp.product_id
 having pp.product_id not in (select product_id from PMS_MANUFACTURING pm
 where PRODUCT_MANFACTURE_DATE='2012-12-15');
 #9
 select manager_name,MANAGER_ID
 from PMS_MANAGER_DETAILS
 where salary>(select avg(salary) from PMS_MANAGER_DETAILS 
 where job<>'MANAGER');
 
 #10
 SELECT Manager_ID, CONCAT(UPPER(substring(MANAGER_NAME,1,1)),LOWER(SUBSTRING(MANAGER_NAME,2))),pdd.Department_ID
 FROM PMS_MANAGER_DETAILS pmd join PMS_DEPARTMENT_DETAILS pdd
 on pmd.department_id=pdd.department_id
 where salary>20000
 order by Department_id;
 
 ###############################################################
 #1
 SELECT Department_Name, Department_Location ,count(*)
FROM PMS_MANAGER_DETAILS pmd join PMS_DEPARTMENT_DETAILS pdd
 on pmd.department_id=pdd.department_id
 group by pdd.department_id
 having count(*)>=4;
 #2
select manager_name from PMS_MANAGER_DETAILS
where job in (select t2.jobb from
(select max(t.mx),jobb from (
 select avg(pm1.salary) mx, pm1.job jobb  from PMS_MANAGER_DETAILS PM1 join PMS_MANAGER_DETAILS pm2
 where pm1.job=pm2.job
 group by pm1.job
 )t)t2 );
 
 
 #3
 SELECT MANAGER_ID, MANAGER_NAME, JOB, SALARY,pdd.DEPARTMENT_ID
 FROM PMS_MANAGER_DETAILS pmd join PMS_DEPARTMENT_DETAILS pdd
 on pmd.department_id=pdd.department_id
 having salary >(select avg(salary) FROM PMS_MANAGER_DETAILS pmd join PMS_DEPARTMENT_DETAILS pd1
 on pmd.department_id=pd1.department_id
 where pdd.department_id=pd1.department_id);
 #4
 select ppu.PRODUCT_ID, PRODUCT_NAME, ppu.UNIT_ID,UNIT_WEIGHT
 from PMS_UNIT_DETAILS pud join PMS_PRODUCT pp join PMS_PRODUCT_UNIT ppu
 on ppu.product_id=pp.product_id and ppu.unit_id=pud.unit_id
 where product_name like '%MILK';
#5
select PRODUCT_NAME, UNIT_NAME, TOTAL_PIECES,UNIT_WEIGHT
from PMS_UNIT_DETAILS pud join PMS_PRODUCT pp join PMS_PRODUCT_UNIT ppu
 on ppu.product_id=pp.product_id and ppu.unit_id=pud.unit_id;
 #6#######################sum
 select product_id,sum(quantity)
  from PMS_MANUFACTURING
where Availability='YES';
#8
select manager_name
FROM PMS_MANAGER_DETAILS 
 where salary>all(select manager_name from PMS_MANAGER_DETAILS pmd join PMS_DEPARTMENT_DETAILS pdd
 on pmd.department_id=pdd.department_id
 where department_location='ONGOLE');
 
#9
select manager_name from pms_manager_details
where salary<
(select max(salary) from 
(select  max(mc),t.department_id,salary from 
(select count(manager_id )mc,department_id,salary from pms_manager_details group by Department_id)t)t1)
; 
 
#10
SELECT pdd.DEPARTMENT_ID
 FROM PMS_MANAGER_DETAILS pmd join PMS_DEPARTMENT_DETAILS pdd
 on pmd.department_id=pdd.department_id
 group by department_id
 having count(manager_id) is null;
 ###########################################################
 #1#####offset
 SELECT DISTINCT Salary FROM PMS_MANAGER_DETAILS
 ORDER BY Salary DESC LIMIT 1 OFFSET 6;
 #2
 select S.MANAGER_ID,S.MANAGER_NAME,S.JOB,S.SALARY,S.DEPARTMENT_ID,B.MANAGER_ID,B.MANAGER_NAME,B.SALARY 
 from PMs_manager_details S join
    pms_manager_details B ON S.manager_id = B.boss_code
    where S.salary>B.SAlary;
   
#3
select product_name,month(PRODUCT_MANFACTURE_DATE) mon,total_pieces
 from PMS_PRODUCT pp join PMS_MANUFACTURING pm join PMS_UNIT_DETAILS pud
on pp.product_id=pm.product_id and pud.unit_id=pm.unit_id
where  pud.total_pieces>4;

#4##################
select sum(quantity),pp.product_id,product_name,department_id from PMS_MANUFACTURING pm join pms_product pp
on pm.product_id=pp.product_id where quantity=
(select max(s) from (select pm.product_id,product_name,department_id,sum(quantity) s from PMS_MANUFACTURING pm join pms_product pp
on pm.product_id=pp.product_id
group by pp.product_id)t);

#5
select  pp.product_id, product_name, Quantity,max(quantity)
from PMS_MANUFACTURING pm join PMS_PRODUCT pp
 on pm.product_id=pp.product_id
 group by pp.product_id;
 