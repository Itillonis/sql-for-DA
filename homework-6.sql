--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонко

--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/
select email
from Person
group by email
having count(email)>=2
--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/
select e1.name as Employee from Employee e1
join Employee e2 on e1.managerId = e2.id
where e1.salary > e2.salary
--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/
select score, 
dense_rank() over (order by score desc) as 'rank'
from Scores
--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/
select p.firstName, p.lastName, a.city, a.state
from Person p
left join 
Address a on p.personId = a.personId