--������������ ������ �10 � ���� � 2 ����
--������� � T-SQL.

--1.����������� ������, ������� ������� ��� ������ � �������.
--select*from customers;
DECLARE @order_num int,
        @company varchar(20),
		@cust_rep int,
		@credit_limit decimal(9,2),
		@message varchar(80);

DECLARE customers_info CURSOR FOR --�������� ������, �� ��������� �� � OPEN
SELECT CUST_NUM, COMPANY, CUST_REP, CREDIT_LIMIT FROM CUSTOMERS;

OPEN customers_info --��� ����� ������ ��������, ������ ��������� ������ ������� 
--� ������������� ��������� �� ����������� ����� ������ �������

FETCH FROM customers_info INTO @order_num, @company, @cust_rep, @credit_limit; --���������� � ����������
WHILE @@FETCH_STATUS = 0 --��������� ���� �� ��������� ������. ���� -1 �� ���, ���� 0 �� ����
BEGIN 
SELECT @message=CAST(@order_num AS varchar(20))+'   '+ @company + '   ' 
                +CAST(@cust_rep AS varchar(20)) + '   ' + CAST(@credit_limit AS varchar(20));
PRINT @message;
FETCH FROM customers_info INTO @order_num, @company, @cust_rep, @credit_limit;
END;
CLOSE customers_info;
DEALLOCATE customers_info; --���������� ��� ������� �� ��� �����������

----------------------------------------------------------------------------------------------------------------
--�������:
--����������� - ������ ��� ��������� � ���� ���-�� ������� �����-�� ������, �� ������ �������� ��������
--������������ - ��������� ����� ���������� � �������
--��������� - ������ ��������� � ������ ��������-�������� �������
--���������� - ����� ����������� ��������� ��� � ������ �������, ��� ����������� ����� DEALLOCATE
--�� ��������� ��������� ������������ � ���������� ������
----------------------------------------------------------------------------------------------------------------
---------------------- ������� ----- scroll --------------------
--�������� ����� scroll:
-- FIRST
-- LAST
-- PRIOR - ����������
-- NEXT
-- ABSOLUTE N - ����� � ������ ������
-- RELATIVE N - ����� � ������� ������

--2.����������� ������, ������� ������� ��� ������ � ����������� ������ � �� ����������.
DECLARE @EMPL_NUM int, @NAME varchar(15), @AGE int, @REP_OFFICE int,
        @TITLE varchar(15), @HIRE_DATE date, @MANAGER int, @QUOTA decimal(9,2),
		@SALES decimal(9,2), @message2 varchar(200);

DECLARE salesreps_info CURSOR FOR
SELECT EMPL_NUM,NAME,AGE,REP_OFFICE,TITLE,HIRE_DATE,MANAGER,QUOTA,SALES FROM SALESREPS;
OPEN salesreps_info 
--PRINT '���������� ����� - '+CAST(@@CURSOR_ROWS  AS VARCHAR(10))
FETCH FROM salesreps_info INTO @EMPL_NUM, @NAME, @AGE, @REP_OFFICE, @TITLE, @HIRE_DATE, @MANAGER, @QUOTA, @SALES;

WHILE @@FETCH_STATUS = 0 --��������� ���� �� ��������� ������. ���� -1 �� ���, ���� 0 �� ����
BEGIN 
SELECT @message2=CAST(@EMPL_NUM AS varchar(20))+' | '+ @NAME + ' | ' + CAST(@AGE AS varchar(20)) + ' | ' + 
                 CAST(@REP_OFFICE AS varchar(20)) + ' | ' + @TITLE + ' | ' + CAST(@HIRE_DATE AS varchar(20)) + 
				 ' | ' + CAST(@MANAGER AS varchar(20)) + ' | ' + CAST(@QUOTA AS varchar(20)) + ' | ' +
				 CAST(@SALES AS varchar(20));
PRINT @message2;
FETCH FROM salesreps_info INTO @EMPL_NUM, @NAME, @AGE, @REP_OFFICE, @TITLE, @HIRE_DATE, @MANAGER, @QUOTA, @SALES;
END;
CLOSE salesreps_info;
DEALLOCATE salesreps_info;
--PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))



--3.����������� ��������� ������, ������� ������� ��� �������� � ������� � �� ������� ����.
DECLARE @MFR_ID CHAR(3), @PRODUCT_ID CHAR(5), @DESCRIPTION varchar(15), @PRICE MONEY, 
        @QTY_ON_HAND INT,@AVG_PRICE MONEY, @message3 varchar(200);
DECLARE PRODUCT_INFO CURSOR LOCAL FOR
SELECT MFR_ID,PRODUCT_ID,DESCRIPTION,PRICE,QTY_ON_HAND FROM PRODUCTS;
OPEN PRODUCT_INFO
FETCH FROM PRODUCT_INFO INTO @MFR_ID, @PRODUCT_ID, @DESCRIPTION, @PRICE, @QTY_ON_HAND;
WHILE @@FETCH_STATUS = 0 --��������� ���� �� ��������� ������. ���� -1 �� ���, ���� 0 �� ����
BEGIN 
SELECT @message3=CAST(@MFR_ID AS varchar(20))+' | '
                + CAST(@PRODUCT_ID AS varchar(20))+ ' | ' 
				+ @DESCRIPTION + ' | ' 
				+ CAST(@PRICE AS varchar(20)) + ' | ' 
				+ CAST(@QTY_ON_HAND AS varchar(20));
PRINT @message3;
FETCH FROM PRODUCT_INFO INTO @MFR_ID, @PRODUCT_ID, @DESCRIPTION, @PRICE, @QTY_ON_HAND;
END;
CLOSE PRODUCT_INFO;
DEALLOCATE PRODUCT_INFO;
--��������
SELECT AVG([PRICE]) FROM [dbo].[PRODUCTS];

--4.����������� ���������� ������, ������� ������� �������� � �������, ����������� � 2008 ����.
DECLARE @ORDER_NUM INT,
        @ORDER_DATE DATE,
		@CUST INT,
		@REP INT,
		@MFR CHAR(3),
		@PRODUCT CHAR(5),
		@QTY INT,
		@AMOUNT decimal(9,2),
		@message4 varchar(200);
DECLARE ORDERS_INFO CURSOR GLOBAL FOR
SELECT ORDER_NUM,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AMOUNT FROM ORDERS WHERE year(order_date) = '2008';
OPEN ORDERS_INFO
FETCH FROM ORDERS_INFO INTO @ORDER_NUM, @ORDER_DATE, @CUST, @REP, @MFR, @PRODUCT, @QTY, @AMOUNT;
WHILE @@FETCH_STATUS = 0 --��������� ���� �� ��������� ������. ���� -1 �� ���, ���� 0 �� ����
BEGIN 
SELECT @message4=CAST(@ORDER_NUM AS varchar(20))+' | '
               + CAST(@ORDER_DATE AS varchar(20))+ ' | ' 
			   + CAST(@CUST AS varchar(20))+ ' | '
			   + CAST(@REP AS varchar(20))+ ' | '
			   + @MFR + ' | '
			   + @PRODUCT + ' | '
			   + CAST(@QTY AS varchar(20))+ ' | '
			   + CAST(@AMOUNT AS varchar(20));
PRINT @message4;
FETCH FROM ORDERS_INFO INTO @ORDER_NUM,@ORDER_DATE,@CUST,@REP,@MFR,@PRODUCT,@QTY,@AMOUNT;
END;
CLOSE ORDERS_INFO;
DEALLOCATE ORDERS_INFO;


--����������� ����������� ������, ������� ������� �������� � ����������� � �� �������.
--����������� ������������ ������, ������� ��������� ������ � ���������� � ����������� �� ����� ����������� ������� (���� SALES).
--������������������ �������� SCROLL.
