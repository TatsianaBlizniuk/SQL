--������������ ������ �6 � ���� � 2 ����

--���������������� T-SQL.

--1. ����������� �������� ���������: 
--1.1. ���������� ������ �������; ��� ������� ������������ ������ � ������� ��������� �� ������.
--select*from customers
--delete customers where company='test';
create procedure NewCustomer @cust_num int, @company varchar(20), @cust_rep int, @limit decimal(9, 2)
as
declare @rc int = 0;
begin
begin try
  insert into customers (cust_num, company, cust_rep, credit_limit) values (@cust_num, @company, @cust_rep, @limit)
end try
begin catch
	set @rc = -1
	print '������';
end catch
return @rc;
end

--declare @cust_num1 int, @company1 varchar(20), @cust_rep1 int, @limit1 decimal(9, 2);
--	set @cust_num1 = 0000
--	set @company1 = 'test'
--	set @cust_rep1 = 105
--	set @limit1 = 100.00
--exec NewCustomer @cust_num1, @company1, @cust_rep1, @limit1;

exec NewCustomer 0000, 'test', 105, 100.00;
select*from customers

drop procedure NewCustomer;

--1.2. ������ ������� �� ����� ��������; ���� ������ �� ������� � ������� ���������.
go
create procedure SearchCustomer @part_name varchar(10)
as
begin
   if not exists (select*from CUSTOMERS where COMPANY like '%' + @part_name + '%')
   print '�������� � ����� ������ �� �������.';
   else select*from CUSTOMERS where COMPANY like '%' + @part_name + '%'
end

-------����� ��������� � ��������
exec SearchCustomer @part_name = 'hbjhjjh';

drop procedure SearchCustomer;


--1.3. ���������� ������ �������.
--select*from Customers
go
create procedure UpdateCustomer @num int
as
begin
   update customers set company = 'test2'
   where cust_num = @num;
end

-------����� ��������� � ��������
insert into customers values(1000,'test',103,90);
exec UpdateCustomer 1000;

select * from customers;

delete customers where cust_num=1000;
drop procedure UpdateCustomer;


--1.4. �������� ������ � �������; ���� � ������� ���� ������, � ��� ������ ������� � ������� ���������. 
--select*from orders
INSERT INTO ORDERS VALUES (112961,'2007-12-17',2117,106,'REI','2A44L',7,31500.00);

go
create procedure DeleteCustomer
as
begin
    delete orders where cust=67755
	return @@rowcount
end

declare @code int = 15;
exec @code = DeleteCustomer
if @code=0 print '������ �� �������'
else print '����� ������o ' + cast(@code as varchar(10))

drop procedure DeleteCustomer;



--2. ������� ������������� ��������� � ���������� ����������� ��� ������������.
--3. ����������� ���������������� �������: 
--3.1. ���������� ���������� ������� ���������� � ������������ ������. ���� ������ ���������� ��� � ������� -1. 
--���� ��������� ����, � ������� ��� � ������� 0.
--select*from orders
--select*from salesreps
go
create function CountOrders2(@rep int, @dateStart date, @dateEnd date) returns int
begin
   if (select empl_num from salesreps where empl_num = @rep) is null
   return -1;

   declare @countOrders2 int =(select count(*)order_num from ORDERS where REP=@rep and ORDER_DATE between @dateStart and @dateEnd);
   return @countOrders2;
end
go

print '���������� ������� ���������� � ������������ ������ '
+cast(dbo.CountOrders2(108, '2001-01-01', '2019-10-10') as varchar(100));
go

drop function CountOrders2;

--3.2. ���������� ���������� ������� ��������� �������������� ����� ���� ���������. 
--select*from products
go
create function CountProducts(@price money) returns int
begin
   declare @count int = (select count(*) from PRODUCTS where PRICE > @price);
   return @count;
end
go

declare @count_for_print int = dbo.CountProducts(2000);
print '���������� ������� ' + cast(@count_for_print as varchar(10));

drop function CountProducts;

--3.3. ���������� ���������� ���������� ������� ��� ������������� �������������.
--select*from orders
--select*from products

create function CountOrders3(@mfr char(5)) returns int
begin
  declare @count int=(select count(*)from orders where mfr=@mfr);
  return @count;
end
go

print '���������� ���������� ������� '+cast(dbo.CountOrders3('ACI') as varchar(10));
go

drop function CountOrders3;

--4. ������� ������������� ������� ���������� ��������� � ���������� ����������� ��� ������������.
