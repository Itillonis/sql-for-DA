--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
with graded as (
    select * from students s
    join Grades g on s.marks between g.min_mark and g.max_mark
) 
select name, grade, marks
from graded where grade>=8
union ALL
select NULL, grade, marks 
from graded where grade<8 
order by grade desc, name, marks;;
--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem
with Doctor as(
select name as Doctor, 
row_number() over (partition by occupation order by name) AS ind
from OCCUPATIONS
where occupation = 'Doctor'
order by name),
Professor as(
select name as Professor, 
row_number() over (partition by occupation order by name) AS ind
from OCCUPATIONS
where occupation = 'Professor'
order by name),
Singer as(
select name as Singer, 
row_number() over (partition by occupation order by name) AS ind
from OCCUPATIONS
where occupation = 'Singer'
order by name),
Actor as(
select name as Actor, 
row_number() over (partition by occupation order by name) AS ind
from OCCUPATIONS
where occupation = 'Actor'
order by name)
select Doctor, Professor, Singer, Actor from Doctor
full join Professor on Doctor.ind = Professor.ind
full join Singer on Professor.ind = Singer.ind
full join Actor on Singer.ind = Actor.ind;;
--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem
select distinct CITY from STATION
where CITY not like 'A%' and CITY not like 'E%' and CITY not like 'I%' and CITY not like 'O%' and CITY not like 'U%';;
--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem
select distinct CITY from STATION
where CITY not like '%a' and CITY not like '%e' and CITY not like '%i' and CITY not like '%o' and CITY not like '%u';;
--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem
select distinct CITY from STATION
where (CITY not like 'A%' and CITY not like 'E%' and CITY not like 'I%' and CITY not like 'O%' and CITY not like 'U%')
or (CITY not like '%a' and CITY not like '%e' and CITY not like '%i' and CITY not like '%o' and CITY not like '%u');
--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem
select distinct CITY from STATION
where (CITY not like 'A%' and CITY not like 'E%' and CITY not like 'I%' and CITY not like 'O%' and CITY not like 'U%'
and CITY not like '%a' and CITY not like '%e' and CITY not like '%i' and CITY not like '%o' and CITY not like '%u');
--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem
select name from Employee
where salary>2000 and months<10
order by employee_id;
--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
-- Задание такое же, как первое, возможно лишнее