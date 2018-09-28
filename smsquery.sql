#1
select sname
from student 
where sname like 'S%' and LENGTH(sname) between 5 and 20 and squal='Undergraduate' ;
use sms;
#2
SELECT sname FROM student
where TIMESTAMPDIFF(YEAR, sdob, CURDATE())>=60;

#3
SELECT sname FROM student
where sdob >'1980-06-01';

#4
SELECT sname FROM student 
where sphone REGEXP '0[0-9]{10}';

#5
SELECT count(sname) as Invalid_Email FROM student
where semail NOT LIKE '%@%' or  '_%@%' or '%.com';

#6
SELECT sname,semail FROM student
where semail LIKE '%gmail%';

#7
SELECT sname,semail FROM student
where semail LIKE '%gmail%'
and semail  not LIKE '%@%' or  '_%@%' or '%.com';

#8
SELECT squal,count(sname) as totalstud FROM student 
group by squal;

#9
SELECT MONTHNAME(sdob) as Month,count(sname) Total  FROM student 
group by Month;

#10
SELECT sname FROM student
where (YEAR(sdob) % 4 = 0) AND ((YEAR(sdob) % 100 != 0) OR (YEAR(sdob) % 400 = 0))
order by sname,sdob;

#11
SELECT sname,if(scity='Kolkata','Home City','Others') REMARKS,scity FROM student;

#12
SELECT batchid,bsdate,coursename,adddate(bsdate,courseduration) as Batch_End_Date FROM 
batch b join course c
on b.courseid=c.courseid;

#13
SELECT batchid,bsdate,coursename,adddate(bsdate,courseduration) as bedate FROM 
batch b join course c
on b.courseid=c.courseid
where timestampdiff(bedate,bsdate)<10;

#14
SELECT batchid,bstrength,bsdate FROM batch
group by batchid,bsdate;

#15
SELECT sname FROM 
student s join batch b join enrollment e
on b.batchid=e.batchid and e.sid=s.sid
where bsdate<edate;

#16
SELECT sname,s.sid,sum(coursefees) total_fees FROM student s join enrollment e join batch b join course c
on e.sid=s.sid and e.batchid=b.batchid and c.courseid=b.courseid
group by sid;

#17

SELECT coursename,case
when (bsdate+courseduration)< curdate()
then batchid
when (bsdate+courseduration)> curdate() then 'NULL'
end BATCH_STATUS
FROM course c join batch b
on c.courseid=b.courseid;

#18
SELECT count(sname) FROM student
where semail is null or sphone is null ;

#19
SELECT coursename 
FROM course
WHERE coursefees > (SELECT AVG(coursefees) FROM course);

#20
SELECT c1.coursename
FROM course AS c1 
where c1.coursefees<(Select avg(c1.coursefees) from course c1 join course c2 on
c1.coursecategory=c2.coursecategory);
  
#21######################################tally
select t3.mcount,t3.courseid, t3.coursename from
(select max(t.dcount) mxdc from (
select count(e.sid) dcount,c.courseid,coursename 
FROM student s join enrollment e join batch b join course c
on e.sid=s.sid and e.batchid=b.batchid and c.courseid=b.courseid
group by c.courseid,c.coursename
)t)t2
join
(select count(s.sid) mcount , c.courseid, coursename
FROM student s join enrollment e join batch b join course c
on e.sid=s.sid and e.batchid=b.batchid and c.courseid=b.courseid
group by c.courseid,c.coursename
order by mcount
)t3
where t2.mxdc = t3.mcount;

#22 #################alternate way
SELECT sname FROM student
group by semail
having count(semail)>1;
select * from student;
#23
Select s1.sname
from student s1 join student s2
where s1.sname=s2.sname and s1.semail <> s2.semail ;
#24
select sname, sdob, 
case  
WHEN (MONTH(sdob) = 3 AND DAYOFMONTH(sdob) >= 21) OR (MONTH(sdob) = 4 AND DAYOFMONTH(sdob) <= 19) THEN 'Aries'
WHEN (MONTH(sdob) = 4 AND DAYOFMONTH(sdob) >= 20) OR (MONTH(sdob) = 5 AND DAYOFMONTH(sdob) <= 20) THEN 'Taurus'
WHEN (MONTH(sdob) = 5 AND DAYOFMONTH(sdob) >= 21) OR (MONTH(sdob) = 6 AND DAYOFMONTH(sdob) <= 20) THEN 'Gemini'
WHEN (MONTH(sdob) = 6 AND DAYOFMONTH(sdob) >= 21) OR (MONTH(sdob) = 7 AND DAYOFMONTH(sdob) <= 20) THEN 'Cancer'
WHEN (MONTH(sdob) = 7 AND DAYOFMONTH(sdob) >= 21) OR (MONTH(sdob) = 8 AND DAYOFMONTH(sdob) <= 20) THEN 'Leo'
WHEN (MONTH(sdob) = 8 AND DAYOFMONTH(sdob) >= 21) OR (MONTH(sdob) = 9 AND DAYOFMONTH(sdob) <= 20) THEN 'Virgo'
WHEN (MONTH(sdob) = 9 AND DAYOFMONTH(sdob) >= 21) OR (MONTH(sdob) = 10 AND DAYOFMONTH(sdob) <= 20) THEN 'Libra'
WHEN (MONTH(sdob) = 10 AND DAYOFMONTH(sdob) >= 21) OR (MONTH(sdob) = 11 AND DAYOFMONTH(sdob) <= 20) THEN 'Scorpio'
WHEN (MONTH(sdob) = 11 AND DAYOFMONTH(sdob) >= 21) OR (MONTH(sdob) = 12 AND DAYOFMONTH(sdob) <= 20) THEN 'Sagittarius'
WHEN (MONTH(sdob) = 12 AND DAYOFMONTH(sdob) >= 21) OR (MONTH(sdob) = 1 AND DAYOFMONTH(sdob) <= 20) THEN 'Capricorn'
WHEN (MONTH(sdob) = 1 AND DAYOFMONTH(sdob) >= 21) OR (MONTH(sdob) = 2 AND DAYOFMONTH(sdob) <= 20) THEN 'Aquarius'
WHEN (MONTH(sdob) = 2 AND DAYOFMONTH(sdob) >= 21) OR (MONTH(sdob) = 3 AND DAYOFMONTH(sdob) <= 20) THEN 'Pisces'
end 'SunSign'
from student;

#25
SELECT coursename,coursefees*count(s.sid) as total_revenue FROM student s join enrollment e join batch b join course c
on e.sid=s.sid and e.batchid=b.batchid and c.courseid=b.courseid
group by c.courseid
order by total_revenue desc
limit 1;

#26
SELECT b.batchId,
  (b.bstrength-count(sid)) as VacantSeats
FROM batch b
LEFT JOIN enrollment e
ON b.batchid=e.batchid
GROUP BY b.batchid,
  b.bstrength
HAVING b.bstrength>COUNT(e.sid);

#27
SELECT s.squal, COUNT(*) AS count FROM student s
JOIN Enrollment e ON s.sid=e.sid
GROUP BY squal
HAVING count = MAX(e.sid)