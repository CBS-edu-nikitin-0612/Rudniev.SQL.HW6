/* aditional task */

use AdventureWorks2012_Data

select FirstName, LastName, 
(select PhoneNumber
from Person.PersonPhone as PF
where PF.BusinessEntityID = PP.BusinessEntityID)
from Person.Person as PP
where FirstName like 'Pa%'
order by FirstName

select FirstName, LastName,
(select CardType from Sales.CreditCard as CC where BusinessEntityID in 
(select BusinessEntityID from Sales.PersonCreditCard as PCC where CC.CreditCardID = PCC.CreditCardID)) as CardType,
(select CardNumber from Sales.CreditCard as CC where BusinessEntityID in 
(select BusinessEntityID from Sales.PersonCreditCard as PCC where CC.CreditCardID = PCC.CreditCardID)) as CardNumber,
(select ExpMonth from Sales.CreditCard as CC where BusinessEntityID in 
(select BusinessEntityID from Sales.PersonCreditCard as PCC where CC.CreditCardID = PCC.CreditCardID)) as ExpMonth,
(select ExpYear from Sales.CreditCard as CC where BusinessEntityID in 
(select BusinessEntityID from Sales.PersonCreditCard as PCC where CC.CreditCardID = PCC.CreditCardID)) as ExpYear
from Person.Person as PP

select [Name], ProductNumber, StandardCost, 
(select TransactionType from Production.TransactionHistory where ProductID = PP.ProductID) as TransactionType,
(select TransactionDate from Production.TransactionHistory where ProductID = PP.ProductID) as TransactionDate,
(select Quantity from Production.TransactionHistory where ProductID = PP.ProductID) as Quantity
from Production.Product as PP
order by [Name]

select FirstName, LastName, 
( select EmailAddress
from Person.EmailAddress as PE
where PE.BusinessEntityID = PP.BusinessEntityID)
from Person.Person as PP
order by FirstName

/* task 2 */

use master

create database MySubqueryDB
on
(
	name = 'MySubqueryDB',
	filename = 'D:\courses\sql-hw\lesson6\MySubqueryDB.mdf',
	size = 2mb,
	maxsize = 4mb,
	filegrowth = 1mb
)
log on
(
	name = 'LogMySubqueryDB',
	filename = 'D:\courses\sql-hw\lesson6\MySubqueryDB.ldf',
	size = 2mb,
	maxsize = 4mb,
	filegrowth = 1mb
)
collate cyrillic_general_ci_as

/* task 3 */

use MySubqueryDB

create table Employees
(
	EmployeeID int identity not null primary key,
	Name nvarchar(20) not null,
	PhoneNumber char(12) not null
)

create table Salaryes
(
	EmployeeID int not null foreign key references Employees(EmployeeID),
	Salary money not null,
	Position nvarchar(20) not null
)

create table OtherInfo
(
	EmployeeID int not null foreign key references Employees(EmployeeID),
	MaritalStatus varchar(10) not null,
	BirthDate date not null,
	Residence nvarchar(40) null
)

/* task 4 */

select Name, PhoneNumber, 
(select Residence
from OtherInfo) as Residence
from Employees

select BirthDate,
(select [Name] from Employees as EMP where EMP.EmployeeID = OI.EmployeeID) as [Name],
(select PhoneNumber from Employees as EMP where EMP.EmployeeID = OI.EmployeeID) as PhoneNumber
from OtherInfo as OI
where MaritalStatus = 'single'

select Name, PhoneNumber, BirthDate
from Employees inner join
(select EmployeeID, BirthDate
from OtherInfo inner join
(select EmployeeID from Salaryes
where Position = 'manager') as TempTable
on OtherInfo.EmployeeID = TempTable.EmployeeID) as TempTable2
on Employees.EmployeeID = TempTable2.EmployeeID
order by Name