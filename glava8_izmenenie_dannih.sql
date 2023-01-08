-- Запустите следующий код, чтобы создать в БД TSQL2012 таблицу dbo.Customers.
-- USE TSQL2012;
-- IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
-- CREATE TABLE dbo.Customers
-- (
-- custid INT NOT NULL PRIMARY KEY,
-- companyname NVARCHAR(40) NOT NULL,
-- country NVARCHAR(15) NOT NULL,
-- region NVARCHAR(15) NULL,
-- city NVARCHAR(15) NOT NULL
-- );


-- Добавьте в таблицу dbo.Customers строку со следующими значениями:
-- custid: 100
-- companyname: Рога и копыта
-- country: США
-- region: WA
-- city: Редмонд
--Решение:
insert into dbo.Customers (custid, companyname, country, region, city)
values(100, N'Рога и копыта', N'США', 'WA', N'Редмонд')


-- Выберите из таблицы Sales.Customers записи о всех клиентах, которые размещали
-- заказы, и скопируйте их в таблицу dbo.Customers.
--Решение:
insert into dbo.Customers(custid, companyname, country, region, city)
select custid, companyname, country, region, city
from Sales.Customers as c
where exists
(select * from sales.orders as o
where o.custid = c.custid)

-- С помощью команды SELECT INTO создайте таблицу dbo.Orders и заполните ее
-- заказами из таблицы Sales.Orders, которые были размещены в 2006–2008 гг. Стоит
-- отметить, что это упражнение можно выполнить только на локальной версии SQL
-- Server, поскольку SQL Database не поддерживает команду SELECT INTO (вместо
-- этого используются команды CREATE TABLE и INSERT SELECT).
--Решение:
select *
into dbo.Orders
from Sales.Orders
where orderdate >= '20060101'
and orderdate < '20090101'


-- Удалите из таблицы dbo.Orders заказы, размещенные до августа 2006 г. Исполь-
-- зуйте инструкцию OUTPUT, чтобы вернуть атрибуты orderid и orderdate, при-
-- надлежащие удаленным строкам.
--Решение:
delete from dbo.Orders
output deleted.orderid, deleted.orderdate
where orderdate < '20060801'


-- Удалите из таблицы dbo.Orders заказы, размещенные бразильскими клиентами.
--Решение:
delete from dbo.orders
where exists
(select *
from dbo.Customers as c
where orders.custid = c.custid
and c.country = N'Бразилия')

-- Выполните запрос к таблице dbo.Customers, представленный ниже. Обратите
-- внимание, что некоторые строки содержат NULL в столбце region.
-- SELECT * FROM dbo.Customers;
-- Теперь обновите таблицу dbo.Customers, заменяя отметки NULL значениями
-- '<None>'. Используйте инструкцию OUTPUT, чтобы вывести содержимое столб-
-- цов custid, oldregion и newregion.
--Решение:
update dbo.Customers
set region = '<None>'
output
deleted.custid,
deleted.region as oldregion,
inserted.region as newregion
where region is null

-- Обновите в таблице dbo.Orders все заказы, которые были размещены клиен-
-- тами из Великобритании; присвойте их атрибутам shipcountry, shipregion
-- и shipcity значения country, region и city, взятые из таблицы dbo.Customers.
--Решение:
update o
set shipcountry = c.country,
shipregion = c.region,
shipcity = c.city
from dbo.Orders as o
join dbo.Customers as c
on o.custid = c.custid
where c.country = 'Великобритания'
