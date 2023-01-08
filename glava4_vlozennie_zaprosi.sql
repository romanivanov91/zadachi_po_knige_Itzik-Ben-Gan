-- Напишите запрос, который возвращает все заказы, сделанные в последний день,
-- учтенный в таблице Orders.
-- Используется таблица Sales.Orders.
--Решение:
select orderid, orderdate, custid, empid
from Sales.Orders
where orderdate in (select max(orderdate)
					from Sales.Orders)

-- Напишите запрос, который будет возвращать все заказы, размещенные клиен-
-- том (или клиентами) с самым большим количеством заказов. Учитывайте вероят-
-- ность того, что одно и то же количество заказов может быть сразу у нескольких
-- клиентов.
--Решение:
select custid, orderid, orderdate, empid
from Sales.Orders
where custid in (select top(1) with ties custid
				from Sales.Orders
				group by custid
				order by count(*) desc)

-- Напишите запрос, который возвращает список сотрудников, не обрабатывавших
-- заказы 1 мая 2008 г.
-- Используются таблицы HR.Employees и Sales.Orders.
--Решение:
select empid, FirstName, lastname
from HR.Employees
where empid not in (select empid
					from Sales.Orders
					where orderdate >= '20080501')

-- Получите список стран, в которых есть клиенты, но нет сотрудников.
-- Используются таблицы HR.Employees и Sales.Customers.
--Решение:
select distinct country
from Sales.Customers
where country not in (select country
					  from HR.Employees)

-- Напишите запрос, который возвращает все заказы, размещенные в последний
-- день активности каждого клиента.
-- Используется таблица Sales.Orders.
--Решение:
select custid, orderid, orderdate, empid
from Sales.Orders as o1
where orderdate = (select max(o2.orderdate)
					from Sales.Orders as o2
					where o2.custid = o1.custid)

-- Напишите запрос, который возвращает список клиентов, размещавших заказы
-- в 2007-м, но не в 2008 г.
-- Используются таблицы Sales.Orders и Sales.Customers.
--Решение:
select custid, companyname
from Sales.Customers as c
where exists (select *
					from Sales.Orders as o1
					where o1.custid = c.custid
					and orderdate >= '20070101'
					and orderdate <= '20071231')
	and
	not exists (select *
					from Sales.Orders as o2
					where o2.custid = c.custid
					and orderdate >= '20080101'
					and orderdate <= '20081231')

-- Напишите запрос, который возвращает список клиентов, заказывавших товар
-- под номером 12.
-- Используются таблицы Sales.Orders, Sales.Customers и Sales.OrderDetails.
--Решение (сложная задача, решение подсмотрел):
select custid, companyname
from Sales.Customers AS c
where exists
(select *
from Sales.Orders as o
where o.custid = c.custid
and exists
(select *
from Sales.OrderDetails as od
where od.orderid = o.orderid
and od.ProductID = 12))

-- Напишите запрос, который вычисляет общее текущее количество заказанного
-- товара для каждого клиента за каждый месяц.
-- Используется таблица Sales.CustOrders.
--Решение (сложная задача, решение подсмотрел):
select custid, ordermonth, qty,
(select SUM(o2.qty)
from Sales.CustOrders as o2
where o2.custid = o1.custid
and o2.ordermonth <= O1.ordermonth) as runqty
from Sales.CustOrders as o1
order by custid, ordermonth
