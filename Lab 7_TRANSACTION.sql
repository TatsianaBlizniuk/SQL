--������������ ������ �7 � ���� � 2 ����

--���������� � T-SQL.
--1. ����������� ������, ��������������� ������ � ������ ������� ����������.
--SELECT*FROM OFFICES
SET IMPLICIT_TRANSACTIONS ON; --��������� ������� ����������
INSERT OFFICES VALUES (100, 'TEST 1', 'Eastern',null,10000.00,100.00);
COMMIT;

SELECT*FROM OFFICES;
DELETE FROM OFFICES WHERE OFFICE=100;


--2. ����������� ������, ��������������� �������� ACID ����� ����������. 
--� ����� CATCH ������������� ������ ��������������� ��������� �� �������.
--XACT_STATE ��� �������, ������� ���������� ������������ ��������� ���������� ����������
--���������������, �����������
SELECT*FROM CUSTOMERS;


insert into customers values(1000,'JCP Inc.',103,90);
begin try
begin transaction
	delete CUSTOMERS WHERE CUST_NUM=1000;
end try
begin catch
	if (xact_state()) = -1
	begin 
		print '���������� �� ���������'
		rollback transaction;
	end;
	if (xact_state()) = 1
	begin 
		print '���������� ���������'
		commit transaction;
	end;
end catch;

--3. ����������� ������, ��������������� ���������� ��������� SAVETRAN. 
--� ����� CATCH ������������� ������ ��������������� ��������� �� �������.
SELECT*FROM OFFICES;

BEGIN TRY
BEGIN TRANSACTION
   INSERT INTO OFFICES VALUES (100, 'TEST 3A', 'Eastern', null, 10000.00, 100.00);
   SAVE TRANSACTION A;

   INSERT INTO OFFICES VALUES (200, 'TEST 3B', 'Eastern', null, 10000.00, 100.00);
   SAVE TRANSACTION B;

   INSERT INTO OFFICES VALUES (300, 'TEST 3C', 'Eastern', null, 10000.00, 100.00);
   ROLLBACK TRANSACTION B;

   INSERT INTO OFFICES VALUES (400, 'TEST 3D', 'Eastern', null, 10000.00, 100.00);
   ROLLBACK TRANSACTION A;
END TRY
BEGIN CATCH
  IF (xact_state()) = -1
  BEGIN
     PRINT '���������� �� ���������'
	 ROLLBACK TRANSACTION
  END;
  BEGIN
     PRINT '���������� ���������'
	 COMMIT TRANSACTION
  END;
END CATCH;

SELECT*FROM OFFICES;
DELETE FROM OFFICES WHERE CITY='TEST 3A';

--4. ����������� ��� ������� A � B. ������������������ ����������������, 
--��������������� � ��������� ������. �������� �������� ������� ���������������.
CREATE TABLE TEST_ISOLATION_LEVEL
(NAME CHAR(10), AGE INT, LOCATION CHAR(20))
INSERT INTO TEST_ISOLATION_LEVEL VALUES ('TANYA',32,'MINSK');
INSERT INTO TEST_ISOLATION_LEVEL VALUES ('VIKA',33,'WARSHAVA');
INSERT INTO TEST_ISOLATION_LEVEL VALUES ('DIMA',35,'RIGA');

SELECT*FROM TEST_ISOLATION_LEVEL;
DELETE FROM TEST_ISOLATION_LEVEL WHERE AGE=37;
drop table TEST_ISOLATION_LEVEL
----- �������, ��� ������� ��������������� READ UNCOMMITTED ��������� ���������������� ������

-- 1
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM TEST_ISOLATION_LEVEL -- ��������� ����������, ���������: 3
--  3
SELECT COUNT(*) FROM TEST_ISOLATION_LEVEL
-- ���������: , ������ ���������������� ������
 
-- 5
SELECT COUNT(*) FROM TEST_ISOLATION_LEVEL -- ���������: , ����� ������ ���������� �
COMMIT TRAN

----- �������, ��� ������� ��������������� READ COMMITTED �� ��������� ���������������� ������

-- 6
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM TEST_ISOLATION_LEVEL -- ��������� ����������, ���������: 
 
--  8
SELECT COUNT(*) FROM TEST_ISOLATION_LEVEL -- ���������: ��������, ����������������� ������ ���
 
-- 10
SELECT COUNT(*) FROM TEST_ISOLATION_LEVEL -- ����� ����� ������ ���������� � ���������: , 
COMMIT TRAN

----- �������, ��� ������� ��������������� READ COMMITTED  ��������� ��������������� ������

-- 11
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM TEST_ISOLATION_LEVEL -- ���������: 
 
-- 13
SELECT COUNT(*) FROM TEST_ISOLATION_LEVEL -- ���������: 
-- ���� ������ ���������� ������� ������, ������ ������ ����������� ��-�������.
COMMIT TRAN


----- �������, ��� ������� ��������������� REPEATABLE READ  ��������� �������� ��������� �������
INSERT INTO TEST_ISOLATION_LEVEL VALUES ('DIMA',35,'RIGA'); -- ������ ������
-- 18
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ 
BEGIN TRAN
SELECT COUNT(*) FROM TEST_ISOLATION_LEVEL -- ���������: 
 
-- 20
SELECT COUNT(*) FROM TEST_ISOLATION_LEVEL -- ���������: 
--- � ������ ����� ���������� � ��� ����������
COMMIT TRAN


--5. ����������� ������, ��������������� �������� ��������� ����������. 
BEGIN TRANSACTION ONETRAN;
INSERT OFFICES VALUES (200, 'TEST 5A', 'TEST',null,20000.00,200.00);
    BEGIN TRANSACTION TWOTRAN;
    UPDATE OFFICES SET CITY='TEST 5B' WHERE REGION ='TEST';
	COMMIT TRANSACTION TWOTRAN;
COMMIT TRANSACTION ONETRAN;

--SELECT*FROM OFFICES;
DELETE FROM OFFICES WHERE CITY='TEST 5B';