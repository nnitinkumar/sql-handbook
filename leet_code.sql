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

with cte_1 as
(
select 
    E2.name as EmpName,
    E1.name as MgrName,
    E2.salary as EmpSalary,
    E1.salary as MgrSalary
from 
Employee E1
inner join Employee E2
on E1.id = E2.managerId
)
select 
    EmpName
from cte_1
where EmpSalary > MgrSalary

;

/* Write your T-SQL query statement below */

/*
with cte_1 as
(
select 
    --E2.name as Employee,
    E2.name as Employee,
    --E1.name as MgrName,
    E2.salary as EmpSalary,
    E1.salary as MgrSalary
from 
Employee E1
inner join Employee E2
on E1.id = E2.managerId
)
select 
    Employee
from cte_1
where EmpSalary > MgrSalary

;
*/

/*
select 
    --E2.name as Employee,
    E2.name as Employee
    --E1.name as MgrName,
    --E2.salary as EmpSalary,
    --E1.salary as MgrSalary
from 
Employee E1
inner join Employee E2
on E1.id = E2.managerId
where E2.salary > E1.salary;
*/

select 
    a.Name as Employee
from 
Employee a 
inner join Employee b 
on a.ManagerId=b.Id
where a.Salary>b.Salary;


