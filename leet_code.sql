--Q: find first name, last name, city, state

/* Write your T-SQL query statement below */

--Table 1 : person - personId, lastName, firstName

--Table 2 : address - addressId, personId, city, state

select P.firstName, P.lastName, A.city, A.state  
from Person P
left join Address A
on P.personId = A.personId
;