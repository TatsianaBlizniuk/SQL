--Лабораторная работа № 9 – СУБД – 2 часа

SELECT*FROM CUSTOMERS;
SELECT*FROM OFFICES;
SELECT*FROM ORDERS;
SELECT*FROM PRODUCTS;
SELECT*FROM SALESREPS;

--Индексы в T-SQL.
--1. Найдите все индексы для таблиц базы данных.
---  sp_helpindex--информация об индксах конкретной таблицы
exec sp_helpindex 'CUSTOMERS'
exec sp_helpindex 'OFFICES'
exec sp_helpindex 'ORDERS'
exec sp_helpindex 'PRODUCTS'
exec sp_helpindex 'SALESREPS'


--2. Создайте индекс для таблицы для одного столбца и продемонстрируйте его применение.
--0.0146606 до создания индекса
SELECT*FROM OFFICES WHERE SALES BETWEEN 400000 AND 900000 ORDER BY SALES;

CREATE INDEX index_offices ON OFFICES(SALES); 
SELECT*FROM OFFICES WHERE SALES BETWEEN 400000 AND 900000 ORDER BY SALES;
--0.0068971 после создания индекса

DROP INDEX index_offices ON OFFICES;


--3. Создайте индекс для таблицы для нескольких столбцов и продемонстрируйте его применение.
--SELECT*FROM ORDERS;
SELECT*FROM ORDERS WHERE AMOUNT BETWEEN 2000 AND 30000 ORDER BY ORDER_DATE;
--0.0147941 до создания индекса

CREATE INDEX index_ORDERS ON ORDERS(AMOUNT,ORDER_DATE);
SELECT*FROM ORDERS WHERE AMOUNT BETWEEN 2000 AND 30000 ORDER BY ORDER_DATE;
--0.0147941 после создания индекса
exec sp_helpindex 'ORDERS'

DROP INDEX index_ORDERS ON ORDERS;

--4. Создайте фильтрующий индекс для таблицы и продемонстрируйте его применение.
SELECT*FROM OFFICES;

SET NOCOUNT ON;
DECLARE @I INT = 100;
WHILE (@I<1000)
	BEGIN
	INSERT OFFICES VALUES (@I,'Denver','Western',null,FLOOR(30000*rand()),100.00);
	SET @I=@I+1;
	END;

DELETE FROM OFFICES WHERE OFFICE>99

--0.0079812
SELECT TARGET FROM OFFICES where TARGET BETWEEN 5000 AND 20000;

--0.0079812
SELECT TARGET FROM OFFICES where TARGET>15000 AND TARGET<19999;

--0.0079812
SELECT TARGET FROM OFFICES where TARGET=17999;

CREATE INDEX INDEX_OF ON OFFICES(TARGET) WHERE TARGET>=15000 AND TARGET<20000;

--0.0032831
SELECT OFFICE,TARGET FROM OFFICES where TARGET=17999;

CREATE INDEX INDEX_OF2 ON OFFICES(TARGET) include (OFFICE) WHERE TARGET>=15000 AND TARGET<21000;

DROP INDEX INDEX_OF ON OFFICES;
DROP INDEX INDEX_OF2 ON OFFICES;
DELETE FROM OFFICES WHERE OFFICE>99;

--5. Создайте индекс покрытия для таблицы и продемонстрируйте его применение.

--6. Создайте индекс для запроса с соединением таблиц и продемонстрируйте его применение.
--см пункт 8

--7. Покажите состояние индексов для таблицы и продемонстрируйте их перестройку и реорганизацию.
SELECT*FROM OFFICES;

SET NOCOUNT ON;
DECLARE @I INT = 100;
WHILE (@I<1000)
	BEGIN
	INSERT OFFICES VALUES (@I,'Denver','Western',null,FLOOR(30000*rand()),100.00);
	SET @I=@I+1;
	END;

CREATE NONCLUSTERED INDEX INDEX_TASK7 ON OFFICES(TARGET);

SELECT  * FROM SYS.dm_db_index_physical_stats(DB_iD('tempdb'), OBJECT_ID('OFFICES'), NULL,NULL,NULL)

ALTER INDEX INDEX_TASK7 ON OFFICES REORGANIZE
SELECT  * FROM SYS.dm_db_index_physical_stats(DB_iD('tempdb'), OBJECT_ID('OFFICES'), NULL,NULL,NULL)

ALTER INDEX INDEX_TASK7 ON OFFICES REBUILD WITH (ONLINE=OFF)
SELECT  * FROM SYS.dm_db_index_physical_stats(DB_iD('tempdb'), OBJECT_ID('OFFICES'), NULL,NULL,NULL)
--КАКАЯ ЗДЕСЬ СУТЬ????

DELETE FROM OFFICES WHERE OFFICE>99
DROP INDEX INDEX_TASK7 ON OFFICES;


--8. Для запросов, разработанных в лабораторной работе № 3, покажите и проанализируйте планы запросов.
--9. Создайте индексы для оптимизации запросов из лабораторной работы № 3.
--3.29. Найти покупателей, у которых есть заказы в определенный период.
SELECT
C.COMPANY,
O.ORDER_DATE
FROM CUSTOMERS C JOIN ORDERS O
ON O.CUST=C.CUST_NUM
WHERE O.ORDER_DATE between '2007-10-01' and '2008-01-01' ORDER BY ORDER_DATE;
--0.0191634 до
CREATE INDEX index_task9 ON ORDERS(ORDER_DATE);
--0.0121373

exec sp_helpindex 'CUSTOMERS'
exec sp_helpindex 'ORDERS'
DROP INDEX index_task9 ON ORDERS;


--10. Создайте необходимые индексы для базы данных своего варианта.
SELECT*FROM PROVIDERS;
SELECT*FROM PRICE;
--0.018266
SELECT*FROM PROVIDERS A JOIN PRICE B
ON A.PROVIDER=B.PROVIDER
ORDER BY B.PRICE;

CREATE INDEX index_task10 ON PRICE(PRICE);
--0.010509

DROP INDEX index_task10 ON PRICE;
