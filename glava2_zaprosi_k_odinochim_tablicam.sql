-- Напишите запрос к таблице Sales.Orders, который возвращает заказы, размещен-
-- ные в июне 2007 г.
-- Используются БД TSQL2012 и таблица Sales.Orders.
-- Решение:
select orderid, orderdate, custid, empid
from Sales.Orders
where orderdate >= '2007-06-01' and orderdate <= '2007-06-30'

-- Напишите запрос к таблице Sales.Orders, который возвращает заказы, размещен-
-- ные в последний день месяца.
-- Используются БД TSQL2012 и таблица Sales.Orders.
-- Решение:
select orderid, orderdate, custid, empid
from Sales.Orders
where orderdate >= eomonth(orderdate)

-- Напишите запрос к таблице HR.Employees, который возвращает записи о сотруд-
-- никах, чьи фамилии содержат больше одной буквы «о».
-- Используются БД TSQL2012 и таблица HR.Employees.
-- Решение:
select empid, firstname, lastname
from HR.Employees
where lastname like '%о%о%'

-- Напишите запрос к таблице Sales.OrderDetails, который возвращает заказы с общей
-- стоимостью (вычисляется как количество, умноженное на цену отдельного товара)
-- более 10 000. Сортировка выполняется по общей стоимости.
-- Используются БД TSQL2012 и таблица Sales.OrderDetails.
-- Решение:
select orderid, sum (unitprice * qty) as totalvalue
from Sales.OrderDetails
group by orderid
having sum (unitprice * qty) > 10000
order by totalvalue desc

-- Напишите запрос к таблице Sales.Orders, чтобы он возвращал три страны, средняя
-- стоимость отправки заказов в которые была самой высокой в 2007 г.
-- Используются БД TSQL2012 и таблица Sales.Orders.
-- Решение:
select top(3) shipcountry, avg(freight) as avgfreight
from Sales.Orders
where orderdate > '20070101' and orderdate < '20071231'
group by shipcountry
order by avgfreight desc

-- Напишите запрос к таблице Sales.Orders, который вычисляет номера строк от-
-- дельно для каждого клиента, исходя из даты размещения заказа (примените иден-
-- тификатор заказа в качестве дополнительного условия).
-- Используются БД TSQL2012 и таблица Sales.Orders.
-- Решение:
select custid, orderdate, orderid, row_number () over (partition by custid order by orderid) as rownum
from Sales.Orders

-- Используя таблицу HR.Employees, создайте инструкцию SELECT, которая опре-
-- деляет пол каждого сотрудника, исходя из формы обращения к нему. Значения
-- 'мисс' и 'миссис' означают 'женщина'; 'мистер' означает 'мужчина'; во всех
-- остальных случаях (например, 'доктор') должно возвращаться 'неизвестно'.
-- Используются БД TSQL2012 и таблица HR.Employees.
-- Решение:
select empid, firstname, lastname, titleofcourtesy, case titleofcourtesy
														when 'мисс' then 'женщина'
														when 'миссис' then 'женщина'
														when 'мистер' then 'мужчина'
														else 'неизвестно'
														end as gender
from HR.Employees

-- Напишите запрос к таблице Sales.Customers, который возвращает для каждого
-- клиента его идентификатор и регион. Сортировка должна выполняться по региону,
-- а отметки NULL находиться после «ненулевых» значений. Помните, что по умол-
-- чанию язык T-SQL размещает отметки NULL в начале результирующего набора.
-- Используются БД TSQL2012 и таблица Sales.Customers.
-- Решение:
select custid, region
from Sales.Customers
order by
case when region is null then 1 else 0 end, region
