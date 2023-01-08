-- Напишите запрос, который возвращает максимальное значение столбца orderdate
-- для каждого сотрудника.
-- Используется таблица Sales.Orders.
--Решение:
select empid, maxorderdate
from (select empid, max(orderdate) as maxorderdate
	  from Sales.Orders
	  group by empid) as t

-- Выразите запрос, приведенный в предыдущем упражнении, в виде производной
-- таблицы. Выполните соединение полученного результата с таблицей Orders, чтобы
-- вернуть для каждого сотрудника заказ с последней датой.
-- Используется таблица Sales.Orders.
--Решение:
select t1.empid, t1.orderdate, t1.orderid, t1.custid
from Sales.Orders as t1
	join
	(select empid, max(orderdate) as maxorderdate
	 from Sales.Orders
	 group by empid) as t2
	on t1.empid = t2.empid
		and t1.orderdate = t2.maxorderdate


-- Напишите запрос, который вычисляет номер строки для каждого заказа, вы-
-- полняя предварительную сортировку по столбцам orderdate и orderid.
-- Используется таблица Sales.Orders.
--Решение:
select orderid, orderdate, custid, empid, row_number() over(order by orderid, orderdate) as rownum
from Sales.Orders


-- Напишите запрос, который возвращает строки с 11 по 20 с учетом сортировки
-- по столбцам orderdate и orderid. Прибегните к ОТВ, чтобы инкапсулировать код из
-- предыдущего упражнения.
-- Используется таблица Sales.Orders.
--Решение:
with otb as
(select orderid, orderdate, custid, empid, row_number() over(order by orderid, orderdate) as rownum
from Sales.Orders)

select orderid, orderdate, custid, empid, rownum
from otb
where rownum >= 11 and rownum <= 20


-- Напишите запрос, который возвращает управленческую цепочку, связанную
-- с Зоей Долгопятовой (сотрудник под номером 9). Задействуйте рекурсивное ОТВ.
-- Используется таблица HR.Employees.
--Решение (Сложная задача, решение подсмотрел):
with EmpsCTE as
(
select empid, mgrid, firstname, lastname
from HR.Employees
where empid = 9
union all
select P.empid, P.mgrid, P.firstname, P.lastname
from EmpsCTE as C
join HR.Employees as P
on C.mgrid = P.empid
)

select empid, mgrid, firstname, lastname
from EmpsCTE



-- Напишите представление, которое возвращает общий объем заказанной про-
-- дукции для каждого сотрудника, разбитый по годам.
-- Используются таблицы Sales.Orders и Sales.OrderDetails.
-- При выполнении запроса
-- SELECT * FROM Sales.VEmpOrders ORDER BY empid, orderyear;
-- результат должен быть следующим:
-- empid orderyear qty
-- ----------- ----------- -----------
-- 1 2006 1620
-- 1 2007 3877
-- 1 2008 2315
-- 2 2006 1085
-- 2 2007 2604
-- 2 2008 2366
-- 3 2006 940
-- 3 2007 4436
-- 3 2008 2476
-- 4 2006 2212
-- 4 2007 5273
-- 4 2008 2313
-- 192
-- Глава 5
-- 5 2006 778
-- 5 2007 1471
-- 5 2008 787
-- 6 2006 963
-- 6 2007 1738
-- 6 2008 826
-- 7 2006 485
-- 7 2007 2292
-- 7 2008 1877
-- 8 2006 923
-- 8 2007 2843
-- 8 2008 2147
-- 9 2006 575
-- 9 2007 955
-- 9 2008 1140
-- (строк обработано: 27)
--Решение:
create view Sales.VEmpOrders
as
select
empid,
year(orderdate) as orderyear,
sum(qty) AS qty
from Sales.Orders as O
join Sales.OrderDetails as OD
on O.orderid = OD.orderid
group by empid, YEAR(orderdate)

-- Напишите запрос к представлению Sales.VEmpOrders, который возвращает
-- общее текущее количество заказанных товаров для сотрудников, с разбиением по годам.
-- Используется представление Sales.VEmpOrders.
--Решение (Сложная задача, решение подсмотрел):
select empid, orderyear, qty, (select SUM(qty)
								from Sales.VEmpOrders AS v2
								where v2.empid = v1.empid
								AND v2.orderyear <= v1.orderyear) as runqty
from Sales.VEmpOrders as v1


-- Создайте встроенную функцию, которая в качестве аргументов принимает иден-
-- тификатор поставщика (@supid AS INT) и произвольное число товаров (@n AS
-- INT). Функция должна возвращать @n самых дорогих товаров, предоставленных
-- заданным поставщиком.
-- Используется таблица Production.Products.
-- При выполнении запроса:
-- SELECT * FROM Production.TopProducts(5, 2);
-- результат должен быть следующим:
-- productid productname unitprice
-- 12 Продукт OSFNS 38,00
-- 11 Продукт QMVUN 21,00
--Решение:
create function Production.TopProducts
(@supid as int, @n as int)
returns table
as
return
select top (@n) productid, productname, unitprice
from Production.Products
where supplierid = @supid
order by unitprice desc;
go

-- С помощью оператора CROSS APPLY и функции, созданной вами в упражне-
-- нии 4-1, получите для каждого поставщика список из двух самых дорогих товаров.
--Решение (решение подсмотрел):
select s.supplierid, s.companyname, p.productid, p.productname, p.unitprice
from Production.Suppliers as s
	cross apply
	Production.TopProducts(s.supplierid, 2) as p

SELECT * FROM Production.TopProducts(5, 2)
