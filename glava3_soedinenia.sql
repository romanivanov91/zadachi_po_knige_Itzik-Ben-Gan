-- Напишите запрос, который генерирует по пять копий каждой строки из таблицы
-- HR.Employees.
-- Используются таблицы HR.Employees и dbo.Nums.
--Решение:
select empid, firstname, lastname, n
from HR.Employees, dbo.Nums
where n < 6

-- Напишите запрос, который возвращает по одной строке для каждого сотрудника
-- и дня в диапазоне с 12 по 16 июня 2009 г.
-- Используются таблицы HR.Employees и dbo.Nums.
--Решение (задача сложная, сам решить не смог - данное решение из книги):
SELECT E.empid,
DATEADD(day, D.n - 1, '20090612') AS dt
FROM HR.Employees AS E
CROSS JOIN dbo.Nums AS D
WHERE D.n <= DATEDIFF(day, '20090612', '20090616') + 1
ORDER BY empid, dt

-- Запрос должен отобрать всех клиентов из США и вернуть для каждого из них
-- количество сделанных заказов и общее число заказанных товаров.
-- Используются таблицы Sales.Customers, Sales.Orders и Sales.OrderDetails.
--Решение:
select c.custid, count(distinct o.orderid) as numorders, sum(od.qty) as totalqty
from Sales.Customers as c
	join
	Sales.Orders as o
	on c.custid = o.custid
	join
	Sales.OrderDetails as od
	on o.orderid = od.orderid
where c.country = N'США'
group by c.custid

-- Нужно получить список клиентов с их заказами. В результат должны попасть
-- даже те клиенты, которые ничего не заказывали.
-- Используются таблицы Sales.Customers и Sales.Orders.
--Решение:
select c.custid, companyname, orderid, orderdate
from Sales.Customers as c
	left join
	Sales.Orders as o
	on c.custid = o.custid

-- Запрос должен вернуть всех клиентов, которые не делали заказов.
-- Используются таблицы Sales.Customers и Sales.Orders.
--Решение:
select c.custid, companyname, orderid, orderdate
from Sales.Customers as c
	left join
	Sales.Orders as o
	on c.custid = o.custid
where orderid is null


-- Получите список клиентов, которые размещали заказы 12 февраля 2007 г.
-- В результат должны войти столбцы из таблицы Sales.Orders.
-- Используются таблицы Sales.Customers и Sales.Orders.
--Решение:
select c.custid, c.companyname, o.orderid, o.orderdate
from Sales.Customers as c
	join
	Sales.Orders as o
	on c.custid = o.custid
where o.orderdate = '20070212'

-- Получите список клиентов, которые размещали заказы 12 февраля 2007 г.
-- В результат должны войти столбцы из таблицы Sales.Orders и клиенты, у которых
-- не было заказов в этот день.
-- Используются таблицы Sales.Customers и Sales.Orders.
--Решение
select c.custid, c.companyname, o.orderid, o.orderdate
from Sales.Customers as c
	left join
	Sales.Orders as o
	on c.custid = o.custid and o.orderdate = '20070212'

-- Получите список всех клиентов. Результат должен содержать столбец со значе-
-- ниями «Да/Нет», которые определяются тем, размещал ли клиент заказ 12 февраля
-- 2007 г.
-- Используются таблицы Sales.Customers и Sales.Orders.
--Решение
select distinct c.custid, c.companyname, case
											when o.orderdate='20070212' then N'да'
											else N'нет'
											end as HasOrderOn20070212
from Sales.Customers as c
	left join
	Sales.Orders as o
	on c.custid = o.custid
