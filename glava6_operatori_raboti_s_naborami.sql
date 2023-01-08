-- Напишите запрос, который генерирует виртуальную вспомогательную таблицу
-- с десятью числами в диапазоне от 1 до 10, не используя при этом цикл. Конечный
-- результат можно не упорядочивать.
-- Не используется ни одной таблицы.
--Решение:
select n
from (values (1), (2), (3), (4), (5), (6), (7), (8), (9), (10)) as nums(n)


-- Напишите запрос, который возвращает пары «клиент — сотрудник», работавшие
-- с заказами в январе, а не в феврале 2008 г.
-- Используется таблица Sales.Orders.
--Решение:
select custid, empid
from Sales.Orders
where orderdate >= '20080101' and orderdate < '20080201'
except
select custid, empid
from Sales.Orders
where orderdate >= '20080201' and orderdate < '20080301'


-- Напишите запрос, который возвращает пары «клиент — сотрудник», работавшие
-- с заказами как в январе, так и в феврале 2008 г.
-- Используется таблица Sales.Orders.
--Решение
select custid, empid
from Sales.Orders
where orderdate >= '20080101' and orderdate < '20080201'
intersect
select custid, empid
from Sales.Orders
where orderdate >= '20080201' and orderdate < '20080301'


-- Напишите запрос, который возвращает пары «клиент — сотрудник», работавшие
-- с заказами в январе и феврале 2008 г., но не в 2007 г.
-- Используется таблица Sales.Orders.
--Решение:
(select custid, empid
from Sales.Orders
where orderdate >= '20080101' and orderdate < '20080201'
intersect
select custid, empid
from Sales.Orders
where orderdate >= '20080201' and orderdate < '20080301')
except
select custid, empid
from Sales.Orders
where orderdate >= '20070101' and orderdate < '20071231'


-- У вас есть следующий запрос.
-- SELECT country, region, city
-- FROM HR.Employees
-- UNION ALL
-- SELECT country, region, city
-- FROM Production.Suppliers;
-- Вы должны добавить в него код, благодаря которому строки из таблицы Employees
-- будут находиться в результирующем наборе перед строками из таблицы Suppliers.
-- Кроме того, каждый сегмент должен быть отсортирован по стране, региону и городу.
-- Используются таблицы HR.Employees и Production.Suppliers.
--Решение (сложная задача, решение подсмотрел):
select country, region, city
from (select 1 as sortcol, country, region, city
from HR.Employees
union all
select 2, country, region, city
from Production.Suppliers) as D
order by by sortcol, country, region, city;
