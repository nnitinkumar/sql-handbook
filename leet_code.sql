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