--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/
with ranked_sal as 
(select d.name as Department,
 e.name as Employee,
 e.salary as Salary,
 dense_rank() over (partition by e.departmentId order by e.salary desc) as r
from Employee e
join Department d on e.departmentId = d.id
)
select Department, Employee, Salary from ranked_sal
where r<=3;;
--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17
select f.member_name, f.status, sum(p.unit_price*p.amount) as costs
from FamilyMembers f
join Payments p on f.member_id = p.family_member
where YEAR(p.date)=2005
group by f.member_name, f.status;;
--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13
select name 
from passenger p
group by name
having count(name)>1;;
--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
select count(first_name) as 'count'
from Student
where first_name = "Anna"
group by first_name;;
--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35
with dated as (select distinct classroom, date
from Schedule
where date = '2019-09-02T00:00:00.000Z')
select count(classroom) as count
from dated;;
--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
select count(first_name) as 'count'
from Student
where first_name = "Anna"
group by first_name;;
--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32
select floor(avg(DATEDIFF(CURDATE(), birthday)/365)) as age
from FamilyMembers;;
--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27
with expenses as (
select good_type_name, good_name, amount*unit_price as spent 
from GoodTypes t
join Goods g on g.type = t.good_type_id
join payments p on p.good = g.good_id
where YEAR(date) = 2005
)
select good_type_name, sum(spent) as costs
from expenses
group by good_type_name;;
--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37
select floor(min(DATEDIFF(CURDATE(), birthday)/365)) as year
from Student;;
--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44
select floor(max(DATEDIFF(CURDATE(), birthday)/365)) as max_year
from Student_in_class c 
join Student s on s.id = c.student
join Class cl on c.class = cl.id
where name like '10%';;
--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20
with ent_costs as (
select member_name, status, amount*unit_price as paid
from FamilyMembers f
join Payments p on f.member_id = p.family_member
join Goods g on p.good = g.good_id
join GoodTypes t on g.type = t.good_type_id
where good_type_name = 'entertainment'
)
select member_name, status, sum(paid) as costs
from ent_costs
group by member_name, status;;
--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55
with num_flights as (select name, count(t.id) as flights
from Trip t
join Company c on c.id = t.company
group by name)
delete from Company
where name in (
select name from num_flights
where flights = (select min(flights) from num_flights));;
--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45
with counted as (select classroom, count(classroom) as num
from Schedule
group by classroom)
select classroom
from counted
where num = (select max(num) from counted);;
--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43
select last_name
from Teacher t 
join Schedule s on t.id = s.teacher
join Subject sub on sub.id = s.subject
where name = 'Physical Culture'
order by last_name;;
--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63
select CONCAT(last_name, '.', left(first_name,1), '.', left(middle_name,1), '.') as name
from Student
order by name