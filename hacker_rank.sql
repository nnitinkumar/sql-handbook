

CREATE TABLE contests(
CONTEST_ID INT,
HACKER_ID INT,
CNAME VARCHAR(50)
)
GO

CREATE TABLE colleges(
COLLEGE_ID INT,
CONTEST_ID INT,
)
GO

CREATE TABLE challenges(
CHALLENGE_ID INT,
COLLEGE_ID INT
)
GO

CREATE TABLE view_stats(
CHALLENGE_ID INT,
TOTAL_VIEWS INT,
TOTAL_UNIQUE_VIEWS INT
)
GO

CREATE TABLE submission_stats(
CHALLENGE_ID INT,
TOTAL_SUBMISSIONS INT,
TOTAL_ACCEPTED_SUBMISSIONS INT 
)
GO


insert into Contests values (66406, 17973, 'Rose');
insert into Contests values (66556, 79153, 'Angela');
insert into Contests values (94828, 80275, 'Frank');

insert into Colleges values (11219, 66406); 
insert into Colleges values (32473, 66556); 
insert into Colleges values (56685, 94828);

insert into Challenges values (18765, 11219);
insert into Challenges values (47127, 11219);
insert into Challenges values (60292, 32473);
insert into Challenges values (72974, 56685);

insert into View_Stats values (47127, 26, 19);
insert into View_Stats values (47127, 15, 14);
insert into View_Stats values (18765, 43, 10);
insert into View_Stats values (18765, 72, 13);
insert into View_Stats values (75516, 35, 17);
insert into View_Stats values (60292, 11, 10);
insert into View_Stats values (72974, 41, 15);
insert into View_Stats values (75516, 75, 11);

insert into Submission_Stats values (75516, 34, 12);
insert into Submission_Stats values (47127, 27, 10);
insert into Submission_Stats values (47127, 56, 18);
insert into Submission_Stats values (75516, 74, 12);
insert into Submission_Stats values (75516, 83, 8);
insert into Submission_Stats values (72974, 68, 24);
insert into Submission_Stats values (72974, 82, 14);
insert into Submission_Stats values (47127, 28, 11);


select 
con.contest_id,
con.hacker_id,
con.cname,
sum(ss.total_submissions) as total_submissions,
sum(ss.total_accepted_submissions) as total_accepted_submissions,
sum(vs.total_views) as total_views,
sum(vs.total_unique_views) as total_unique_views

from contests con 
left join colleges col --inner join 
on con.contest_id = col.contest_id 

left join challenges chal --inner join 
on col.college_id = chal.college_id

left join view_stats vs
on vs.challenge_id = chal.challenge_id
left join submission_stats ss
on chal.challenge_id = ss.challenge_id 
group by con.contest_id, con.hacker_id, con.cname, chal.challenge_id, 
ss.total_submissions, ss.total_accepted_submissions, vs.total_views, vs.total_unique_views

having 
ss.total_submissions is not null and 
ss.total_accepted_submissions is not null and 
vs.total_views is not null and  
vs.total_unique_views is not null and 
(ss.total_submissions + ss.total_accepted_submissions + vs.total_views + vs.total_unique_views) >0
;


--Q: Draw The Triangle 1

DECLARE @var int               -- Declare
SELECT @var = 20               -- Initialization
WHILE @var > 0                 -- condition
BEGIN                          -- Begin
PRINT replicate('* ', @var)    -- Print
SET @var = @var - 1            -- decrement
END

--Q: Draw The Triangle 2

DECLARE @var int               -- Declare
SELECT @var = 1               -- Initialization
WHILE @var <= 20               -- condition
BEGIN                          -- Begin
PRINT replicate('* ', @var)    -- Print
SET @var = @var + 1            -- decrement
END


--Q: Print prime numbers

DECLARE @range_start int = 3;
DECLARE @range_end int = 1000;

-DROP table prime_numbers;
CREATE TABLE prime_numbers (n int);
INSERT INTO prime_numbers VALUES(2);
WHILE (@range_start < @range_end)
BEGIN
IF (SELECT COUNT(*) FROM prime_numbers WHERE @range_start % n = 0) = 0
INSERT INTO prime_numbers VALUES (@range_start);
ELSE
SET @range_start = @range_start + 1;
END

SELECT string_agg(n, '&') FROM prime_numbers;
