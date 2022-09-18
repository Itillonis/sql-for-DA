--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type
with allprods as (SELECT model
FROM pc
UNION ALL
SELECT model
FROM printer
UNION ALL
SELECT model
FROM laptop)
select a.model, maker, type
from product p
join allprods a on p.model = a.model;;
--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"
select *, 
case when (price > (select avg(price) from pc))
then 1
else 0
end flag
from printer;;
--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)
select *
from ships
where class is null;;
--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.

with b_years as (select *, EXTRACT(YEAR FROM date) as year
from battles)
select name from b_years
where year not in (select launched from ships);;
--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.
select o.battle
from ships s
join outcomes o on s."name" = o.ship 
where s."class" = 'Kongo';;
--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag
create view all_products_flag_300 as
(select model, price, 
case when (price>300)
then 1
else 0
end flag
from pc
union all
select model, price, 
case when (price>300)
then 1
else 0
end flag
from printer
union all
select model, price, 
case when (price>300)
then 1
else 0
end flag
from laptop);;
--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag
with allprods as (
select model, price
from pc
union all
select model, price
from printer
union all
select model, price
from laptop)
create view all_products_flag_avg_price as
select *, 
case when (price > (select avg(price) from allprods))
then 1
else 0
end flag
from allprods;;
--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
with avg_d_c as
(
select avg(price) 
from product p 
join printer pr on p.model = pr.model 
where p.maker in ('D','C')
)
select pr.model
from product p 
join printer pr on p.model = pr.model 
where pr.price > (select * from avg_d_c) and p.maker = 'A';;
--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
with avg_d_c as
(
select avg(price) 
from product p 
join printer pr on p.model = pr.model 
where p.maker in ('D','C')
)
select distinct all_prod.model from 
(select p.model, maker, price
from product p
join pc on p.model=pc.model
union all 
select p.model, maker, price
from product p
join printer on p.model=printer.model
union all
select p.model, maker, price
from product p
join laptop on p.model=laptop.model) all_prod
where all_prod.price > (select * from avg_d_c) and all_prod.maker = 'A';;
--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)
select distinct avg(price) from 
(select distinct p.model, maker, price
from product p
join pc on p.model=pc.model
union all 
select distinct p.model, maker, price
from product p
join printer on p.model=printer.model
union all
select distinct p.model, maker, price
from product p
join laptop on p.model=laptop.model) all_prod
where all_prod.maker = 'A';;
--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count
create view count_products_by_makers as
select maker, count(model)
from product
group by maker;;
--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)

df = pd.read_sql('select * from count_products_by_makers order by maker', conn)
px.bar(x=df['maker'], y=df['count']);;

--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'
create table printer_updated as
select * from printer p 
where p.model not in (select model from product where maker = 'D' and type = 'Printer');;
--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)
create view printer_updated_with_makers as
select pu.code, pu.model, pu.color, pu."type", pu.price, p.maker 
from printer_updated pu 
join product p on p.model = pu.model;;
--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)
create view sunk_ships_by_classes as
select count(s.name), s.class 
from ships s
join outcomes o on o.ship = s.name 
where o.result ='sunk'
group by s.class;;

--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

df = pd.read_sql('select * from sunk_ships_by_classes', conn)
px.bar(x=df['class'], y=df['count']);;

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0
create table classes_with_flag as
select *, case 
	when numguns >=9
	then 1
	else 0
end flag
from classes;;
--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

df = pd.read_sql('select country, count(*) from classes group by country', conn)
px.bar(x=df['country'], y=df['count']);;

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".
select count(*)
from ships
where "name" like 'O%' or name like 'M%';;
--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.
select count(*)
from ships
where "name" like '% %';;
--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)

df = pd.read_sql('select launched, count(*) from ships group by launched', conn)
px.bar(x=df['launched'], y=df['count'])
