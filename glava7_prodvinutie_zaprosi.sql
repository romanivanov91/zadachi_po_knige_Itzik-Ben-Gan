-- Тема очень сложная и я мало что в ней понял, поэтому все решение задач в этой теме подсмотрены

-- Напишите запрос к таблице dbo.Orders, который вычисляет для каждого
-- клиентcкого заказа значения функций RANK и DENSE_RANK, с секционированием
-- по столбцу custid и сортировкой по qty.
-- Используется таблица dbo.Orders.
--Решение:
select custid, orderid, qty,
rank() over(partition by custid order by qty) as rnk,
dense_rank() over(partition by custid order by qty) as drnk
from dbo.Orders


-- Напишите запрос к таблице dbo.Orders, который вычисляет для каждой строки
-- разницу между количеством товара в текущем и предыдущем, а также в текущем
-- и следующем заказах.
-- Используется таблица dbo.Orders.
--Решение:
select custid, orderid, qty,
qty - lag(qty) over(partition by custid
order by orderdate, orderid) as diffprev,
qty - lead(qty) over(partition by custid
order by orderdate, orderid) as diffnext
from dbo.Orders


-- Напишите запрос к таблице dbo.Orders, возвращающий строку для каждого со-
-- трудника, столбец для каждого года, в котором выполнялись заказы, и количество
-- заказов в каждом году и по каждому сотруднику.
-- Используется таблица dbo.Orders.
--Решение:
select empid,
count(case when orderyear = 2007 then orderyear end) as cnt2007,
count(case when orderyear = 2008 then orderyear end) as cnt2008,
count(case when orderyear = 2009 then orderyear end) as cnt2009
from (select empid, year(orderdate) as orderyear
from dbo.orders) as d
group by empid

-- Запустите следующий код, чтобы создать и заполнить таблицу EmpYearOrders.
-- USE TSQL2012;
-- IF OBJECT_ID('dbo.EmpYearOrders', 'U')
-- IS NOT NULL DROP TABLE dbo.EmpYearOrders;
-- CREATE TABLE dbo.EmpYearOrders
-- (
-- empid INT NOT NULL
-- CONSTRAINT PK_EmpYearOrders PRIMARY KEY,
-- cnt2007 INT NULL,
-- cnt2008 INT NULL,
-- cnt2009 INT NULL
-- );
-- INSERT INTO dbo.EmpYearOrders(empid, cnt2007, cnt2008, cnt2009)
-- SELECT empid, [2007] AS cnt2007, [2008] AS cnt2008, [2009] AS cnt2009
-- FROM (SELECT empid, YEAR(orderdate) AS orderyear
-- FROM dbo.Orders) AS D
-- PIVOT(COUNT(orderyear)
-- FOR orderyear IN([2007], [2008], [2009])) AS P;
-- SELECT * FROM dbo.EmpYearOrders;
-- Результат выполнения этого запроса представлен ниже.
-- empid cnt2007 cnt2008 cnt2009
-- ----------- ----------- ----------- -----------
-- 1 1 1 1
-- 2 1 2 1
-- 3 2 0 2
-- Теперь напишите запрос к таблице EmpYearOrders, который отменяет разворачи-
-- вание данных и возвращает строку с количеством заказов для каждого сотрудника
-- и за каждый год. Исключите из результата строки, в которых количество заказов
-- равно 0 (в данном случае это актуально для сотрудника под номером 3, поскольку
-- он не обработал ни одного заказа в 2008 г.).
-- Используется таблица EmpTearOrders
--Решение(2 варианта):
--1 вариант
select empid, cast(right(orderyear, 4) as int) as orderyear, numorders
from dbo.EmpYearOrders
unpivot(numorders for orderyear in(cnt2007, cnt2008, cnt2009)) as u
where numorders <> 0;
--2 вариант
select *
from (select empid, orderyear,
case orderyear
when 2007 then cnt2007
when 2008 then cnt2008
when 2009 then cnt2009
end as numorders
from dbo.EmpYearOrders
cross join (values(2007),(2008),(2009)) as years (orderyear)) as d
where numorders <> 0;


-- Напишите запрос к таблице dbo.Orders, который возвращает общее количество
-- заказанного товара для каждого из следующих наборов: (employee, customer,
-- and order year), (employee and order year) и (customer and order
-- year). В результат должен попасть столбец, который однозначно идентифицирует
-- группирующий набор, что связан с текущей строкой.
-- Используется таблица dbo.Orders.
--Решение:
select
grouping_id(empid, custid, year(orderdate)) as groupingset,
empid, custid, year(orderdate) as orderyear, sum(qty) as sumqty
from dbo.Orders
group by
grouping sets
(
(empid, custid, year(orderdate)),
(empid, year(orderdate)),
(custid, year(orderdate))
)
