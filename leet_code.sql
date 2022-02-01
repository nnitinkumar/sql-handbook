--Q: find first name, last name, city, state

/* Write your T-SQL query statement below */

--Table 1 : person - personId, lastName, firstName

--Table 2 : address - addressId, personId, city, state

select P.firstName, P.lastName, A.city, A.state  
from Person P
left join Address A
on P.personId = A.personId
;


--Q: Find the duplicate rows (INCORRECT)

/* Write your T-SQL query statement below */

--Table 1: Person - id, email

with cte_1 as
(
select 
    id, 
    email,
    count(*) as countOfDuplicates
from Person
group by id, email
having count(*) >1
)

select
    p.email
from Person p 
inner join cte_1 c
on c.id = p.id
and c.email = p.email
order by p.id, p.email ;


with cte_1 as 
(
select 
	id,
	email,
	row_number() over(partition by id, email order by id, email) as rn
from Person 
)

select 
	email
from cte_1
where rn >1;



--Q : Employees earning more than their managers

--Table 1 - Employee - id, name, salary, managerId

/* Write your T-SQL query statement below */


select 
    E1.name as Employee 
--E2.name will give wrong result because emp details are coming from E1

from Employee E1

inner join Employee E2  
--inner join or left join both fetch the same result 

on E1.managerId = E2.Id 
--E1.id = E2.managerId will give wrong result, match manager id from E1 and emp id from E2

where E1.salary > E2.salary; 
--E2.salary > E1.salary will fetch wrong result, compare emp E1 salary with E2 manager salary 


--185 : Department top three salaries

--Table 1: Employee - id, name, salary, departmentId

/*
Write a query to find the employees who are high earnrers
in each dept. 
A high earner in a dept is an emp who has a salary
in top three unique salaries for that department.

Return the result table in any order. 
*/

/* Write your T-SQL query statement below */

with cte_1 as
(
select 
	D.name as Department,	
	E.name as Employee,
	E.salary as Salary,
	dense_rank() over (partition by E.DepartmentId order by E.salary desc) as rn
from employee E
left join Department D 
on E.departmentId = D.Id
)

select 
	Department, 
	Employee, 
	Salary 
from cte_1
where rn in (1,2,3);


--262. Trips and Users

--Table 1: Trips - id, client_id, driver_id, city_id, status, request_at
--Table 2: Users - users_id, banned, role 
/*
Write a sql query
find the cancellation rate of requests with unbanned users, 
(both client and driver must not be banned) 
each day between "2013-10-01" and "2013-10-03"
round cancellation rate to two decimal points 
return the result table in any order  

The cancellation rate = dividing the number of cancelled (by client or driver) requests
with unbanned users / total number of requests with  unbanned users on that day

*/


--176. Second highest salary

--Table1: Employee - id, salary

/* Write your T-SQL query statement below */


with cte_1 as
(
select id, salary,
dense_rank() over (order by salary desc) as rn
from Employee
)

select isnull(salary,null) as SecondHighestSalary
from cte_1
where rn = 2;


--196. Delete duplicate emails

--SOURCE: https://stackoverflow.com/questions/18390574/how-to-delete-duplicate-rows-in-sql-server#:~:text=It%20can%20be%20done%20by,no%20duplicates%20as%20shown%20below.

-----CASE1: When the id column is also repeating-----

create table rider_info(
user_id int,
user_name varchar(100),
pickup_loc varchar(100),
drop_loc varchar(100)
)
go

--DROP table rider_info;

insert into rider_info values (1, 'Nitin', 'HRBR', 'Kalyan');
insert into rider_info values (1, 'Nitin', 'HRBR', 'Kalyan');
insert into rider_info values (1, 'Nitin', 'HRBR', 'Kalyan');
insert into rider_info values (2, 'Reshma', 'Whitefield', 'HSR');
insert into rider_info values (2, 'Reshma', 'Whitefield', 'HSR');
insert into rider_info values (3, 'Anshuman', 'HSR', 'EC');


with cte as(
select 
	t1.*,
	row_number()over(partition by user_id order by user_id) as rn
from rider_info t1
)
delete from cte where rn > 1;


select * from rider_info;


-----CASE2: When the id column is different even for repeating records-----

create table rider_info_diff_userid(
user_id int,
user_name varchar(100),
pickup_loc varchar(100),
drop_loc varchar(100)
)
go

--DROP table rider_info_diff_userid;

insert into rider_info_diff_userid values (1, 'Nitin', 'HRBR', 'Kalyan');
insert into rider_info_diff_userid values (2, 'Nitin', 'HRBR', 'Kalyan');
insert into rider_info_diff_userid values (3, 'Nitin', 'HRBR', 'Kalyan');
insert into rider_info_diff_userid values (4, 'Reshma', 'Whitefield', 'HSR');
insert into rider_info_diff_userid values (5, 'Reshma', 'Whitefield', 'HSR');
insert into rider_info_diff_userid values (6, 'Anshuman', 'HSR', 'EC');

select * from rider_info_diff_userid;


delete --delete command
	p1 --this is an entire table 
from 
	rider_info_diff_userid p1, --table aliased as p1
	rider_info_diff_userid p2  --there are two tables in from statement and no join is happening explictly 
where 
	p1.user_name = p2.user_name --common column which is repeating
	and
	p1.user_id > p2.user_id; --picking the different user ids



------------------------------------------

--180: Consecutive numbers 

USE TempDB
create table consecutive_nums(
id_id int,
num_num int,  
)
go



insert into consecutive_nums values (1, 1);
insert into consecutive_nums values (2, 1);
insert into consecutive_nums values (3, 1);
insert into consecutive_nums values (4, 2);
insert into consecutive_nums values (5, 3);
insert into consecutive_nums values (6, 4);
insert into consecutive_nums values (7, 4);
insert into consecutive_nums values (8, 4);
insert into consecutive_nums values (9, 4);
insert into consecutive_nums values (10, 4);



select distinct l1.num_num as consecutivenums 
from consecutive_nums l1
join consecutive_nums l2 on l1.num_num = l2.num_num
join consecutive_nums l3 on l2.num_num = l3.num_num
where (l1.id_id + 1) = l2.id_id 
       and (l2.id_id + 1) = l3.id_id
;