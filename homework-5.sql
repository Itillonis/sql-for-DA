--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson6, дополнительно)
-- SQL: Создайте таблицу с синтетическими данными (10000 строк, 3 колонки, все типы int) и заполните ее случайными данными от 0 до 1 000 000. Проведите EXPLAIN операции и сравните базовые операции.
create table random_numbers as
select cast(random()*1000000 as int) as x,
cast(random()*1000000 as int) as y,
cast(random()*1000000 as int) as z
from generate_series(1, 10000);;

explain analyze select * from random_numbers; --Planning Time: 0.026 ms, Execution Time: 0.974 ms, cost=0.00..155.00
explain analyze insert into random_numbers values (cast(random()*1000000 as int), cast(random()*1000000 as int), cast(random()*1000000 as int)); --Planning Time: 0.019 ms, Execution Time: 0.022 ms, cost=0.00..0.03
explain analyze update random_numbers set x=0, y=0 where z=0; --Planning Time: 0.023 ms, Execution Time: 0.609 ms, cost=0.00..180.00
explain analyze delete from random_numbers WHERE x=cast(random()*1000000 as int);; --Planning Time: 0.015 ms, Execution Time: 0.739 ms, cost=0.00..255.00
--task2 (lesson6, дополнительно)
-- GCP (Google Cloud Platform): Через GCP загрузите данные csv в базу PSQL по личным реквизитам (используя только bash и интерфейс bash) 

