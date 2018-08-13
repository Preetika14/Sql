use mr1;
#######################SIMPLE QUESTIONS###############################
 #1
 Select Count(date_of_registration) as Customer_count from customer_master 
 where extract(year from date_of_registration )='2012';
 #2
select customer_name,coalesce(
 contact_no,contact_address) as contact_details     ######## we can use ifnull() instead of coalesce########
 from customer_master;
 
 ##or
 select customer_name,
case
when contact_no is null then contact_address end

  from customer_master;
 
 #3
 select customer_id,customer_name
 from customer_master
  order by date_of_registration desc;
 #4 
  select movie_category,count(*)as No_Of_Movies
  from movies_master
  group by movie_category;
  
  #5
  select customer_id,customer_name,issue_id     ##########left outer join#############
  from customer_master
  natural join customer_issue_details;
 #6 
  select issue_id, cm.customer_id, cm.customer_name, mm.movie_id, mm.movie_name
  from customer_master cm,movies_master mm,customer_issue_details ci
  where cm.customer_id=ci.customer_id 
  and mm.movie_id=ci.movie_id;
 #7 
  select issue_id,customer_id
  from customer_issue_details
  where(datediff(actual_date_of_return,return_date)<0);
 #8 
  select mm.movie_id,movie_name
  from movies_master mm natural join customer_issue_details 
 where not exists(Select movie_id from customer_issue_details);
 #9
 select customer_name,count(movie_id) as Movie_count#################### left outer join################333
 from customer_issue_details natural join customer_master 
 group by(customer_id);
 #10
select cm.customer_id, cm.customer_name, count(mm.movie_id)*mm.rental_cost as Total_cost from
         customer_master cm join customer_issue_details cid join movies_master mm on
         cm.customer_id=cid.customer_id and cid.movie_id=mm.movie_id
         group by cm.customer_id;
  
 
##################AVERAGE QUESTIONS####################################

#1
select cm.customer_id, cm.customer_name, cid.card_id, description, count(mm.movie_id)*mm.rental_cost as Total_cost
from customer_master cm  join movies_master mm  join customer_issue_details cid on
         cm.customer_id=cid.customer_id and cid.movie_id=mm.movie_id 
    ### where datediff(issue_date,date_of_registration)=0;
       where issue_date= date_of_registration;
 #2        
select distinct cid.customer_id, cm.customer_name 
         from customer_issue_details cid join customer_master cm
         on cm.customer_id=cid.customer_id 
         where cid.customer_id not in 
         (select customer_id from customer_card_details);
#3
select count(description) as count
from library_card_master
where description like '%silver%';

#4
select cm.customer_id, cm.customer_name, cid.movie_id, count(cid.movie_id) as Movie_Count
         from customer_master cm join customer_issue_details cid
         on cm.customer_id = cid.customer_id
         group by cm.customer_id
         having count(Movie_Count)>1;
#5         
select cm.customer_id, cm.customer_name, count(mm.movie_id) as Count from 
         customer_master cm join movies_master mm join customer_issue_details cid on
         cm.customer_id=cid.customer_id and mm.movie_id=cid.movie_id
         where mm.movie_category='comedy' 
         group by cm.customer_id having Count>1;
 #6        
select director_name,count(movie_id) from movies_master
group by director_name having count(movie_id)>1;
 #7 
select lead_actor_name1,count(movie_id) from movies_master
group by lead_actor_name1 having count(movie_id)>1;
 
#8
select movie_name,count(issue_id) as count_issues
from movies_master left outer join
customer_issue_details
on movies_master.movie_id=customer_issue_details.movie_id
group by movies_master.movie_id
order by count(issue_id) desc;
#9
select mm.movie_id, mm.movie_name, cm.customer_id, cm.customer_name,datediff(return_date,issue_date) as No_of_days
from  customer_master cm join movies_master mm join customer_issue_details cid on
         cm.customer_id=cid.customer_id and mm.movie_id=cid.movie_id;
#10
select distinct cm.customer_id,customer_name
from customer_master cm join customer_issue_details cid join library_card_master lcm join customer_card_details ccd on 
cm.customer_id=cid.customer_id and ccd.card_id=lcm.card_id
where current_date()>cid.issue_date+number_of_years;
	#################complex questions############################
    
#1
select director_name,movie_name,mm.movie_id,release_year,sum(datediff(return_date,issue_date)) day
from movies_master mm join customer_issue_details cid on
 mm.movie_id=cid.movie_id
 group by mm.movie_id 
 order by day desc limit 1;
 
#2    incomplete
 (select customer_id,customer_name,count(customer_id) as Movie_count
 from customer_issue_details natural join customer_master
 group by customer_id 
 order by movie_count desc limit 1)
 union
 (select customer_id,customer_name,count(customer_id) as Movie_count
 from customer_issue_details natural join customer_master
 group by customer_id 
 order by movie_count limit 1);
 
 ###or####
 
 
 select t.mcount,t.customer_id from(
 select count(cm.customer_id) mcount,cm.customer_id from
  customer_issue_details natural join customer_master cm #####calculate count for movie issuance
group by cm.customer_id)t
 where t.mcount in(
 select min(t.mcount) from (select count(cm.customer_id) mcount,cm.customer_id from    ####calculate min of this
 customer_issue_details natural join customer_master cm
 group by cm.customer_id )t)
 or 
 t.mcount in(
 select max(t.mcount) from (select count(cm.customer_id) mcount,cm.customer_id from    ####calculate min of this
 customer_issue_details natural join customer_master cm
 group by cm.customer_id )t);


#3
select cm.customer_id,cm.customer_name,count(cm.customer_id) as Movie_count ,extract(month from issue_date) month from 
customer_master cm join movies_master mm join customer_issue_details cid on
         cm.customer_id=cid.customer_id and mm.movie_id=cid.movie_id
         where mm.movie_category='comedy' 
 group by  customer_name,month;
 
 select* from customer_issue_details;
 select* from movies_master;
 
#4
select * from 
(select cm.customer_id, cm.customer_name ,adddate(ccd.issue_date, INTERVAL lcm.number_of_years YEAR) date
  from customer_master cm join customer_card_details ccd join library_card_master lcm
  on cm.customer_id=ccd.customer_id and ccd.card_id=lcm.card_id)t
  where current_date() >t.date;

#5
select* from
(select cm.customer_id,cm.customer_name,mm.movie_category, mm.movie_id,count(if(mm.movie_category='action',1,NULL)) as Amovies,count(if(movie_category='comedy',1,NULL)) as Cmovies
from customer_master cm join movies_master mm join customer_issue_details cid
on cm.customer_id=cid.customer_id and mm.movie_id=cid.movie_id
group by movie_id,customer_name)t
where t.Amovies<t.Cmovies;
####or#######


select t1.customer_id,t1.movie_category t1mt,t2.movie_category t2mt,t1.cnum t1cnum,IFNULL(t2.cnum,0) t2cnum from
(
select mm.movie_category,count(mm.movie_category) cnum,customer_id from customer_issue_details cid
natural join movies_master mm
group by movie_category,customer_id
having movie_category='Comedy'
order by cid.customer_id)
t1 left outer join
(select mm.movie_category,count(mm.movie_category) cnum,customer_id from customer_issue_details cid
natural join movies_master mm
group by movie_category,customer_id
having movie_category='Action'
order by cid.customer_id)t2 on t1.customer_id=t2.customer_id
where t1.cnum>IFNULL(t2.cnum,0);


 