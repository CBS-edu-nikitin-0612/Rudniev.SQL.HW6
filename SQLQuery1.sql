/* aditional task */

use AdventureWorks2012_Data

select FirstName, LastName, PhoneNumber 
from Person.Person inner join Person.PersonPhone
on Person.Person.BusinessEntityID = Person.PersonPhone.BusinessEntityID
where FirstName like 'Pa%'
order by FirstName

select FirstName, LastName, CardType, CardNumber, ExpMonth, ExpYear
from Person.Person inner join
(select BusinessEntityID, CardType, CardNumber, ExpMonth, ExpYear
from Sales.CreditCard inner join Sales.PersonCreditCard
on Sales.CreditCard.CreditCardID = Sales.PersonCreditCard.CreditCardID) as TempTable
on Person.Person.BusinessEntityID = TempTable.BusinessEntityID

select Name, ProductNumber, StandardCost, TransactionType, TransactionDate, Quantity
from Production.Product inner join Production.TransactionHistory
on Production.Product.ProductID = Production.TransactionHistory.ProductID
order by Name

select FirstName, LastName, EmailAddress 
from Person.Person inner join Person.EmailAddress
on Person.Person.BusinessEntityID = Person.EmailAddress.BusinessEntityID
order by FirstName

/* task 2 */

use master

create database MyJoinsDB
on
(
	name = 'MyJoinsDB',
	filename = 'D:\hardWork\courses\SQL\lesson5\MyJoinsDB.mdf',
	size = 2mb,
	maxsize = 4mb,
	filegrowth = 1mb
)
log on
(
	name = 'LogMyJoinsDB',
	filename = 'D:\hardWork\courses\SQL\lesson5\MyJoinsDB.ldf',
	size = 2mb,
	maxsize = 4mb,
	filegrowth = 1mb
)
collate cyrillic_general_ci_as

/* task 3 */

use MyJoinsDB

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

select Name, PhoneNumber, Residence
from Employees left outer join OtherInfo
on Employees.EmployeeID = OtherInfo.EmployeeID

select Name, BirthDate, PhoneNumber 
from Employees inner join 
(select EmployeeID, BirthDate
from OtherInfo
where MaritalStatus = 'single') as TempTable
on Employees.EmployeeID = TempTable.EmployeeID

select Name, PhoneNumber, BirthDate
from Employees inner join
(select EmployeeID, BirthDate
from OtherInfo inner join
(select EmployeeID from Salaryes
where Position = 'manager') as TempTable
on OtherInfo.EmployeeID = TempTable.EmployeeID) as TempTable2
on Employees.EmployeeID = TempTable2.EmployeeID
order by Name