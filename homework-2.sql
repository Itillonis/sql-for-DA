--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.
select c.class, count(result = 'sunk') 
from classes c
full join ships s on c."class" = s."class"
full join outcomes o on o.ship = s."name"
group by c.class;;

--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.
select c."class", min(s.launched)
from ships s
full join classes c on s."class"  = c."class" 
group by c."class";;
--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.
with class_count as (select class, count(class)
from ships s 
group by class)
select c.class, c."count"
from outcomes o
full join ships s on o.ship = s."name" 
join class_count c on c.class = s."class" 
where c."count" >=3 and o."result" = 'sunk';;

--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).

with guns as (select max(numguns), displacement
from classes 
group by displacement)
select s.name 
from classes c
join guns g on c.displacement = g.displacement
join ships s on c."class" = s."class" 
where c.numguns = g."max" and s."name" in (select ship from outcomes);;

--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker

with min_ram_pc as(select * 
from pc 
where ram in (select min(ram) from pc))
select p.maker 
from min_ram_pc m
join product p on m.model = p.model 
where m.speed in (select max(speed) from min_ram_pc)
and p.maker in (select maker 
from product 
where type = 'Printer'
group by maker)
