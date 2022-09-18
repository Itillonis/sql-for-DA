--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц
CREATE VIEW pages_all_products AS 
with paged as (SELECT *, 
row_number() over (partition by mod(code, 2)) page
FROM laptop
order by code)
select *,
row_number() over (partition by page) num_on_page
from paged
order by code;;
--sample:
--1 1
--2 1
--1 2
--2 2
--1 3
--2 3

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства. Вывод: производитель, тип, процент (%)
CREATE VIEW distribution_by_type AS 
with counted as (
select maker, type, ((count(*) over (partition by maker,type))/count(*) over (partition by maker)::float*100) percent
from product)
select *
from counted
group by maker, type, percent
order by maker;;
--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. Пример https://plotly.com/python/histograms/
request = "select * from distribution_by_type order by maker, type"
df = pd.read_sql_query(request, conn)
labels = df["type"].unique()
#Добавляем нулевые значения для правильного отображения на графиках
for item in df["maker"].unique():
    for t in df["type"].unique():
        if not (t in df[df["maker"]==item]["type"].to_list()):
            df = df.append({'maker': item, "type":t, "percent":0}, ignore_index=True)
df = df.sort_values(by=["maker", "type"])

import plotly.graph_objects as go
from plotly.subplots import make_subplots
y=1
fig = make_subplots(rows=1, cols=5, specs=[[{'type':'domain'}, {'type':'domain'}, {'type':'domain'}, {'type':'domain'}, {'type':'domain'}]], subplot_titles = df["maker"].unique())
for item in df["maker"].unique():
    fig.add_trace(go.Pie(labels=labels, values=df[df["maker"]==item]["percent"], name=item), 1, y)
    y+=1
fig.show();;
--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов
create table ships_two_words as
select * from ships
where name like '% %';;
--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"
select * from ships
where name like 'S%' and "class" is null;;
--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' и три самых дорогих (через оконные функции). Вывести model
with printer_with_makers as (
select p.model, price, maker, row_number() over (order by price desc) as row
from printer p
join product p2 on p.model = p2.model)
select model
from printer_with_makers
where maker = 'A' and price>(select avg(price) from printer_with_makers where maker = 'C')
union all 
select model
from printer_with_makers
where row<=3