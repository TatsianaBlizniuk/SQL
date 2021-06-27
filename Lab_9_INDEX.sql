--������������ ������ � 9 � ���� � 2 ����

SELECT*FROM CUSTOMERS;
SELECT*FROM OFFICES;
SELECT*FROM ORDERS;
SELECT*FROM PRODUCTS;
SELECT*FROM SALESREPS;

--������� � T-SQL.
--1. ������� ��� ������� ��� ������ ���� ������.
---  sp_helpindex--���������� �� ������� ���������� �������
exec sp_helpindex 'CUSTOMERS'
exec sp_helpindex 'OFFICES'
exec sp_helpindex 'ORDERS'
exec sp_helpindex 'PRODUCTS'
exec sp_helpindex 'SALESREPS'


--2. �������� ������ ��� ������� ��� ������ ������� � ����������������� ��� ����������.
--0.0146606 �� �������� �������
SELECT*FROM OFFICES WHERE SALES BETWEEN 400000 AND 900000 ORDER BY SALES;

CREATE INDEX index_offices ON OFFICES(SALES); 
SELECT*FROM OFFICES WHERE SALES BETWEEN 400000 AND 900000 ORDER BY SALES;
--0.0068971 ����� �������� �������

DROP INDEX index_offices ON OFFICES;


--3. �������� ������ ��� ������� ��� ���������� �������� � ����������������� ��� ����������.
--SELECT*FROM ORDERS;
SELECT*FROM ORDERS WHERE AMOUNT BETWEEN 2000 AND 30000 ORDER BY ORDER_DATE;
--0.0147941 �� �������� �������

CREATE INDEX index_ORDERS ON ORDERS(AMOUNT,ORDER_DATE);
SELECT*FROM ORDERS WHERE AMOUNT BETWEEN 2000 AND 30000 ORDER BY ORDER_DATE;
--0.0147941 ����� �������� �������
exec sp_helpindex 'ORDERS'

DROP INDEX index_ORDERS ON ORDERS;

--4. �������� ����������� ������ ��� ������� � ����������������� ��� ����������.
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

--5. �������� ������ �������� ��� ������� � ����������������� ��� ����������.

--6. �������� ������ ��� ������� � ����������� ������ � ����������������� ��� ����������.
--�� ����� 8

--7. �������� ��������� �������� ��� ������� � ����������������� �� ����������� � �������������.
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
--����� ����� ����????

DELETE FROM OFFICES WHERE OFFICE>99
DROP INDEX INDEX_TASK7 ON OFFICES;


--8. ��� ��������, ������������� � ������������ ������ � 3, �������� � ��������������� ����� ��������.
--9. �������� ������� ��� ����������� �������� �� ������������ ������ � 3.
--3.29. ����� �����������, � ������� ���� ������ � ������������ ������.
SELECT
C.COMPANY,
O.ORDER_DATE
FROM CUSTOMERS C JOIN ORDERS O
ON O.CUST=C.CUST_NUM
WHERE O.ORDER_DATE between '2007-10-01' and '2008-01-01' ORDER BY ORDER_DATE;
--0.0191634 ��
CREATE INDEX index_task9 ON ORDERS(ORDER_DATE);
--0.0121373

exec sp_helpindex 'CUSTOMERS'
exec sp_helpindex 'ORDERS'
DROP INDEX index_task9 ON ORDERS;


--10. �������� ����������� ������� ��� ���� ������ ������ ��������.
SELECT*FROM PROVIDERS;
SELECT*FROM PRICE;
--0.018266
SELECT*FROM PROVIDERS A JOIN PRICE B
ON A.PROVIDER=B.PROVIDER
ORDER BY B.PRICE;

CREATE INDEX index_task10 ON PRICE(PRICE);
--0.010509

DROP INDEX index_task10 ON PRICE;