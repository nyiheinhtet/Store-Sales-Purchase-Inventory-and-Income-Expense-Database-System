create table Customers(
CustomerID int not null,
CustomerCode int,
CustomerName varchar,
Address varchar
);


delete from Customers where CustomerID >=10000;



create table Employees(
EmployeeID int not null,
EmployeeName varchar,
Weight decimal
);

select (3*weight)-50 as Åu50minus3timesthe weightÅv from Employees;

select count(CustomerID) as NumberofCustomers from Customers;

create table Sales(
SaleID int not null,
SaleDate Date
);

select * from Sales where SaleDate<='2020-06-01';


