#1
SELECT fname,custid,dob
FROM customer
order by year(dob),fname;

#2
SELECT fname,custid,coalesce(mname,ltname) Cust_Name
FROM customer;

#3
select c.custid,fname,aod,acnumber
FROM customer c join account a
on c.custid=a.custid;

#4
SELECT count(*) Cust_Count
FROM customer
where city="Delhi";

#5
SELECT c.custid,fname,acnumber,aod
FROM customer c join account a
on a.custid=c.custid
where Day(aod)>"15";

#6#########################female
SELECT fname,city,acnumber
FROM customer c join account a
on a.custid=c.custid
where occupation NOT IN('Business','Service','Studies');

#7
SELECT bcity,count(*) Count_Branch
FROM branch
group by bcity;

#8
SELECT acnumber,fname,ltname
FROM customer c join account a
on a.custid=c.custid
where astatus='Active';

#9
SELECT c.custid,fname,b.bid,loan_amount
FROM customer c join branch b join loan l
on l.custid=c.custid and l.bid=b.bid;

#10
SELECT acnumber,fname,ltname
FROM customer c join account a
on a.custid=c.custid
where astatus='Terminated';
############################################################
#1
SELECT count(transaction_type='Withdrawal'),count(transaction_type='Deposit')
FROM trandetails t join account a
on t.acnumber=a.acnumber
where custid='C00001';

#2
SELECT fname,c.custid,city,bcity
FROM customer c join branch b join loan l
on l.custid=c.custid and l.bid=b.bid
where bcity<>city;

#3
select custid,fname,ltname from customer where custid in(
select custid from loan group by custid having count(*)>1);

#4
select count(*) Count from loan where custid not in
(select distinct custid from account);

#5
select distinct a.acnumber,sum(t.transaction_amount)+a.opening_balance as Deposit_Amount from account a,trandetails t 
where  t.acnumber=a.acnumber and transaction_type="deposit" group by acnumber
union
select acnumber,opening_balance from account where acnumber not in
(select acnumber from trandetails);

#6
select count(*) as Count_Customer from customer where custid not in
(select distinct custid from account);

#7
select b.bcity,count(*) from branch b,account a where b.bid=a.bid group by bcity
union
select bcity,0 from branch where bcity not in
(select bcity from branch b,account a where a.bid=b.bid group by bcity)
union
select b.bid,count(*) from branch b,account a where a.bid=b.bid group by bid
union
select bid,0 from branch where bid not in
(select a.bid from branch b,account a where a.bid=b.bid group by bid);

#8
SELECT c.fname
FROM customer c,account a
WHERE a.custid = c.custid
GROUP BY c.fname
HAVING COUNT(*) > 1;

#9
select c.fname from customer c,account a,branch b where a.custid=c.custid 
and a.bid=b.bid group by c.fname having count(*)>1;

#10
select c.custid,c.fname,a.acnumber,count(*) as Count_Trans 
from customer c,account a,trandetails t
where a.custid=c.custid and t.acnumber=a.acnumber 
group by t.acnumber;
#################################################################################
#1
select acnumber from trandetails t group by acnumber having count(*)in
(select max(c) from
(select count(*)c from trandetails t group by t.acnumber)a
);
#2
select bname,bcity,max(m) from(
select b.bid,b.bname,b.bcity,count(*)m from branch b,account a,customer c where
a.custid=c.custid and a.bid=b.bid
group by b.bid)a;
#3
select a.acnumber,(s.de+a.opening_balance)-m.wt as balnce_amount from account a,(
select sum(transaction_amount)de from trandetails where acnumber="A00001" and transaction_type="deposit")s,
(select sum(transaction_amount)wt from trandetails where acnumber="A00001" and transaction_type="withdrawal")m
where a.acnumber="A00001";
#4
select distinct t.acnumber,d.tr_am as deposit,w.tr_am as withdrawal from trandetails t,
(select acnumber,sum(transaction_amount) as tr_am from trandetails where transaction_type="withdrawal" group by acnumber)w,
(select acnumber,sum(transaction_amount) as tr_am from trandetails where  transaction_type="deposit" group by acnumber)d
where w.tr_am>d.tr_am and w.acnumber=t.acnumber and t.acnumber=d.acnumber;
#5
#5
select custid,c.fname,c.ltname from customer c where custid=
(select custid from loan group by custid having sum(loan_amount)=(
select max(c)amt from
(select custid,sum(loan_amount)c from loan group by custid having count(*)>1)l
)
);

use sms;
select max(t.c)amt,custid from
(select custid,sum(loan_amount)c from loan group by custid having count(*)>1)t;

select custid,sum(loan_amount)c from loan group by custid having count(*)>1;

select custid,c.fname,c.ltname from customer c where custid=
(select custid from loan group by custid having sum(loan_amount)in (
select max(c)amt from
(select custid,sum(loan_amount)c from loan group by custid having count(*)>1)l
,select min(l2.c)amt from
(select custid,sum(loan_amount)c from loan group by custid having count(*)>1)l2
));