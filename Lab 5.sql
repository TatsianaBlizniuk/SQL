--������������ ������ �5 � ���� � 4 ����

--���������������� T-SQL.
--����������� T-SQL-������  ���������� ����������: 
--�������� ���������� ����: char, varchar, datetime, time, int, smallint,  tinint, numeric(12, 5).
--������ ��� ���������� ������������������� � ��������� ����������.
--���������  ������������ �������� ��������� ���� ���������� � ������� ��������� SET, 
--����� ��  ���� ����������  ��������� ��������, ���������� � ���������� ������� SELECT.
--���� �� ���������� �������� ��� ������������� � �� ����������� �� ��������, 
--���������� ���������� ��������� ��������� �������� � ������� ��������� SELECT;. 
--�������� �������� ���������� ������� � ������� ��������� SELECT, 
--�������� ������ �������� ���������� ����������� � ������� ��������� PRINT. 

DECLARE @char char(15)='������';
DECLARE @varchar varchar(15)='������������ 5';
SELECT @char char, @varchar varchar;
GO

DECLARE @date date;
SET @date='01/01/2021';
SELECT @date date;
GO

DECLARE @time time;
SET @time='11:11:11';
SELECT @time time;
GO

DECLARE @int int;
SELECT @int=5;
PRINT @int;
GO

DECLARE @smallint smallint;
PRINT @smallint;
GO

DECLARE @tinyint tinyint;
SELECT @tinyint=1;
PRINT @tinyint;
GO

DECLARE @numeric numeric(12, 5);
SELECT @numeric=3.14;
PRINT @numeric;
GO

--����������� ������, � ������� ������������ ������� ��������� ��������.
--���� ������� ��������� �������� ��������� 10, �� ������� ���������� ���������, ������� ��������� ��������, ������������ ��������� ��������. 
--���� ������� ��������� �������� ������ 10, �� ������� ����������� ��������� ��������. 
DECLARE @AVG_PRICE_PRODUCT numeric(8,3), 
        @COUNT_PRICE_PRODUCT numeric(8,3),
		@MAX_PRICE_PRODUCT numeric(8,3),
		@MIN_PRICE_PRODUCT numeric(8,3);
SELECT @AVG_PRICE_PRODUCT= (SELECT CAST(AVG(PRICE) as numeric(8,3)) FROM PRODUCTS);
SELECT @COUNT_PRICE_PRODUCT= (SELECT CAST(COUNT(PRICE) as numeric(8,3)) FROM PRODUCTS);
SELECT @MAX_PRICE_PRODUCT= (SELECT CAST(MAX(PRICE) as numeric(8,3)) FROM PRODUCTS);
SELECT @MIN_PRICE_PRODUCT= (SELECT CAST(MIN(PRICE) as numeric(8,3)) FROM PRODUCTS);

IF @AVG_PRICE_PRODUCT>10  -- =889
     SELECT @COUNT_PRICE_PRODUCT 'COUNT_PRICE_PRODUCT',
	        @AVG_PRICE_PRODUCT 'AVG_PRICE_PRODUCT', 
			@MAX_PRICE_PRODUCT 'MAX_PRICE_PRODUCT'
ELSE SELECT @MIN_PRICE_PRODUCT 'MIN_PRICE_PRODUCT';
GO

--���������� ���������� ������� ���������� � ������������ ������.
DECLARE @begin_year char(4) = '2007';
DECLARE @finish_year char(4) = '2008';
DECLARE @ORDERS_IN_PERIOD INT=
(SELECT SUM(QTY) FROM ORDERS WHERE YEAR(ORDER_DATE) BETWEEN @begin_year AND @finish_year);
SELECT @ORDERS_IN_PERIOD 'ORDERS_IN_PERIOD';
GO
--SELECT*FROM ORDERS

--����������� T-SQL-�������, �����������: 
--�������������� ����� ���������� � ��������.
SELECT SUBSTRING(NAME, 1, 1) NAME FROM SALESREPS;
SELECT PATINDEX('% %', NAME) FROM SALESREPS;--��������� ������ ������ ����� �������
--��������� ���������� ������� ����� ������ �������� ������� SUBSTRING

SELECT SUBSTRING(CITY, 1, 4) l4, SUBSTRING(CITY, 4, 4) r4 FROM OFFICES;
-- SUBSTRING() �������� �� ������ ��������� ������������ �����
-- ������� � ������������� �������
-- ������ �������� ������� - ������
-- ������ - ��������� ������
-- ������ - ���������� ���������� ��������

SELECT CITY, PATINDEX('%a%n%', CITY) Str_Pos FROM OFFICES;
-- PATINDEX() ���������� ������, �� �������� ���������
-- ������ ��������� ������������� ������� � ������

SELECT CITY, CHARINDEX('an', CITY) Str_Pos FROM OFFICES;
-- CHARINDEX() ���������� ������, �� �������� ��������� ������ ��������� ��������� � ������
-- � �������� ������� ��������� ���������� ��������� ������,
-- � �������� ������� ��������� - ������, � ������� ���� ����� �����


--����� �����������, � ������� ���� ����� � ��������� ������.
SELECT NAME, HIRE_DATE FROM SALESREPS
WHERE MONTH(HIRE_DATE) = MONTH(GETDATE()) + 1;
GO

--����� �����������, ������� ����������� ����� 10 ���.
SELECT NAME, HIRE_DATE FROM SALESREPS
WHERE (YEAR(GETDATE())-YEAR(HIRE_DATE))>10;
GO

--����� ��� ������, � ������� �������� ������.
SELECT DATENAME(weekday, GETDATE());

SELECT ORDER_DATE, DATENAME(weekday, ORDER_DATE)  FROM ORDERS

--������������������ ���������� ��������� IF� ELSE.
--������ ����
DECLARE @X int = 7;
IF @x > 10 PRINT 'x > 10'
 ELSE PRINT 'x < 10';
GO

--������������������ ���������� ��������� CASE.
SELECT PRODUCT_ID,
	CASE 
		WHEN PRICE BETWEEN 0 AND 100 THEN '�������� 0-100'
		WHEN PRICE BETWEEN 100 AND 1000 THEN '�������� 100-1000'
		WHEN PRICE BETWEEN 1000 AND 10000 THEN '�������� 1000-10000'
		ELSE '�������� ����� 10000'
	END
FROM PRODUCTS;
 
--������������������ ���������� ��������� RETURN.
PRINT '������';
RETURN;              -- ����� �� ������
PRINT '�� ����������'; -- �� ����������
GO
PRINT '����';

--����������� ������ � ��������, � ������� ������������ ��� ��������� ������ ����� TRY � CATCH. 
--��������� ������� ERROR_NUMBER (��� ��������� ������), 
--ERROR_MESSAGE (��������� �� ������), 
--ERROR_LINE(��� ��������� ������), 
--ERROR_PROCEDURE (���  ��������� ��� NULL), 
--ERROR_SEVERITY (������� ����������� ������), 
--ERROR_ STATE (����� ������). 
DECLARE @X int;
BEGIN TRY
 SET @X = 'NELLO'; -- ERR
END TRY
BEGIN CATCH
 PRINT (CAST(ERROR_NUMBER() AS VARCHAR(100)) +'-��� ��������� ������')
 PRINT (CAST(ERROR_MESSAGE() AS VARCHAR(100)) + '-��������� �� ������') 
 PRINT (CAST(ERROR_LINE() AS VARCHAR(100)) + '-��� ��������� ������')
 PRINT (CAST(ERROR_PROCEDURE() AS VARCHAR(100)) + '-���  ��������� ��� NULL') 
 PRINT (CAST(ERROR_SEVERITY() AS VARCHAR(100)) + '-������� ����������� ������') 
 PRINT (CAST(ERROR_STATE() AS VARCHAR(100)) + '-����� ������')
END CATCH
GO

--������� ��������� ��������� ������� �� ���� ��������. �������� ������ (10 �����) 
--� �������������� ��������� WHILE. ������� �� ����������.
CREATE TABLE #T2 (������� VARCHAR(20), ��� VARCHAR(20), �������� VARCHAR(20));

DECLARE @X INT = 1;
WHILE (@X<=10)
BEGIN
INSERT INTO #T2(�������, ���, ��������) VALUES ('D', 'D', 'D');
SET @X = @x+1;
END
GO

SELECT*FROM #T2;
DROP TABLE #T2;