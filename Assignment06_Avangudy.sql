--*************************************************************************--
-- Title: Assignment06
-- Author: Avangundy
-- Desc: This file demonstrates how to use Views
-- Change Log: When,Who,What
-- 2017-01-01,YourNameHere,Created File
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment06DB_Avangundy')
	 Begin 
	  Alter Database [Assignment06DB_Avangundy] set Single_user With Rollback Immediate;
	  Drop Database Assignment06DB_Avangundy;
	 End
	Create Database Assignment06DB_Avangundy;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment06DB_Avangundy;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [mOney] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, UnitsInStock
From Northwind.dbo.Products
UNIOn
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, UnitsInStock + 10 -- Using this is to create a made up value
From Northwind.dbo.Products
UNIOn
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, UnitsInStock + 20 -- Using this is to create a made up value
From Northwind.dbo.Products
Order By 1, 2
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From Categories;
go
Select * From Products;
go
Select * From Employees;
go
Select * From Inventories;
go

/********************************* Questions and Answers *********************************/
print 
'NOTES------------------------------------------------------------------------------------ 
 1) You can use any name you like for you views, but be descriptive and consistent
 2) You can use your working code from assignment 5 for much of this assignment
 3) You must use the BASIC views for each table after they are created in Question 1
------------------------------------------------------------------------------------------'

-- Question 1 (5% pts): How can you create BACIC views to show data from each table in the database.
-- NOTES: 1) Do not use a *, list out each column!
--        2) Create one view per table!
--		  3) Use SchemaBinding to protect the views from being orphaned!


--Select CategoryID, CategoryName
--From Categories

--Create View VCategories
--As
--Select CategoryID, CategoryName
--From Categories

--Select * From VCategories


--Go
--Create View [dbo].[vCategories]
--As
--	Select CategoryID, CategoryName
--	From Categories;
--Go

--Create View [dbo].[vProducts]
--As
--	Select ProductID, ProductName, CategoryID,UnitPrice
--	From Products;
--Go

--Create View [dbo].[vInventories]
--As
--	Select InventoryID, InventoryDate, EmployeeID, ProductID, Count
--	From Inventories;
--Go

--Create View [dbo].[vEmployees]
--As
--	Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID
--	From Employees;
--Go

Go
Create View [dbo].[vCategories]
With Schemabinding
As
	Select CategoryID, CategoryName
	From dbo.Categories;
Go

Create View [dbo].[vProducts]
With Schemabinding
As
	Select ProductID, ProductName, CategoryID,UnitPrice
	From dbo.Products;
Go

Create View [dbo].[vInventories]
With Schemabinding
As
	Select InventoryID, InventoryDate, EmployeeID, ProductID, Count
	From dbo.Inventories;
Go

Create View [dbo].[vEmployees]
With Schemabinding
As
	Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID
	From dbo.Employees;
Go



-- Question 2 (5% pts): How can you set permissions, so that the public group CANNOT select data 
-- from each table, but can select data from each view?


-- Question 3 (10% pts): How can you create a view to show a list of Category and Product names, 
-- and the price of each product?
-- Order the result by the Category and Product!

--Go
--Select CategoryName, ProductName,UnitPrice
--From Categories 
--  Inner Join Products On Products.CategoryID=Categories.CategoryID
--Order by 1,2; 


Go
Create View [dbo].[vProductsByCategories]
AS
	Select Top 1000000 CategoryName, ProductName,UnitPrice
	From Categories 
		Inner Join Products On Products.CategoryID=Categories.CategoryID
		Order By 1,2;
Go


-- Question 4 (10% pts): How can you create a view to show a list of Product names 
-- and Inventory Counts on each Inventory Date?
-- Order the results by the Product, Date, and Count!

--Select ProductName, InventoryDate, Count
--From Products Join Inventories
--	On Products.ProductID=Inventories.ProductID
--		Order By 1,2,3;

Go
Create View [dbo].[vInventoriesByProductsByDates]
AS
	Select Top 1000000 ProductName, InventoryDate, Count 
From Products Join Inventories
	On Products.ProductID=Inventories.ProductID
		Order By 1,2,3;
Go

-- Question 5 (10% pts): How can you create a view to show a list of Inventory Dates 
-- and the Employee that took the count?
-- Order the results by the Date and return only one row per date!

-- Here is are the rows selected from the view:

-- InventoryDate	EmployeeName
-- 2017-01-01	    Steven Buchanan
-- 2017-02-01	    Robert King
-- 2017-03-01	    Anne Dodsworth

--Select Distinct InventoryDate, EmployeeName=EmployeeFirstName+' '+EmployeeLastName
--	From Inventories Join Employees
--	On Inventories.EmployeeID=Employees.EmployeeID;

--Select Distinct InventoryDate, EmployeeName=EmployeeFirstName+' '+EmployeeLastName
--	From Inventories Join Employees
--	On Inventories.EmployeeID=Employees.EmployeeID
--	Order By 1;

Go
Create View [dbo].[vInventoriesByEmployeesByDates]
AS
Select Distinct InventoryDate, EmployeeName=EmployeeFirstName+' '+EmployeeLastName
	From Inventories Join Employees
	On Inventories.EmployeeID=Employees.EmployeeID;  -- Adding the order gave me an error
Go

-- Question 6 (10% pts): How can you create a view show a list of Categories, Products, 
-- and the Inventory Date and Count of each product?
-- Order the results by the Category, Product, Date, and Count!

--Select CategoryName, ProductName, InventoryDate, Count
--	From Categories 
--	Join Products 
--		On Categories.CategoryID=Products.CategoryID
--	Join Inventories
--		On Products.ProductID=Inventories.ProductID
--	Order By 1,2,3,4;

Go
Create View [dbo].[vInventoriesByProductsByCategories] 	
As
Select Top 1000000 CategoryName, ProductName, InventoryDate, Count
	From Categories 
	Join Products 
		On Categories.CategoryID=Products.CategoryID
	Join Inventories
		On Products.ProductID=Inventories.ProductID
	Order By 1,2,3,4;
Go
-- Question 7 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the EMPLOYEE who took the count?
-- Order the results by the Inventory Date, Category, Product and Employee!

--Select CategoryName,ProductName, InventoryDate, Count,EmployeeName=EmployeeFirstName+' '+EmployeeLastName
--From Categories
--	Join Products
--		On Categories.CategoryID=Products.CategoryID
--	Join Inventories
--		On Products.ProductID=Inventories.ProductID
--	Join Employees
--		On Inventories.EmployeeID =Employees.EmployeeID
--	Order By 3,1,2,5;

GO
Create View [dbo].[vInventoriesByProductsByEmployees]
As
Select Top 1000000 CategoryName,ProductName, InventoryDate, Count,EmployeeName=EmployeeFirstName+' '+EmployeeLastName
From Categories
	Join Products
		On Categories.CategoryID=Products.CategoryID
	Join Inventories
		On Products.ProductID=Inventories.ProductID
	Join Employees
		On Inventories.EmployeeID =Employees.EmployeeID
	Order By 3,1,2,5;
GO

-- Question 8 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the Employee who took the count
-- for the Products 'Chai' and 'Chang'? 

--Select Top 1000000 CategoryName,ProductName, InventoryDate, Count,EmployeeName=EmployeeFirstName+' '+EmployeeLastName
--From Categories
--	Join Products
--		On Categories.CategoryID=Products.CategoryID
--	Join Inventories
--		On Products.ProductID=Inventories.ProductID
--	Join Employees
--		On Inventories.EmployeeID =Employees.EmployeeID
--	Where ProductName in ('Chai','Chang');

--Go
--Create View [dbo].[vInventoriesForChaiAndChangByEmployees]
--As
--Select Top 1000000 CategoryName,ProductName, InventoryDate, Count,EmployeeName=EmployeeFirstName+' '+EmployeeLastName
--From Categories
--	Join Products
--		On Categories.CategoryID=Products.CategoryID
--	Join Inventories
--		On Products.ProductID=Inventories.ProductID
--	Join Employees
--		On Inventories.EmployeeID =Employees.EmployeeID
--	Where ProductName in ('Chai','Chang');
--Go

Go
Create View [dbo].[vInventoriesForChaiAndChangByEmployees]
As
Select Top 1000000 
    CategoryName,
    ProductName, 
    InventoryDate, 
    Count,
    EmployeeName = EmployeeFirstName + ' ' + EmployeeLastName
From Categories
    Join Products
        On Categories.CategoryID = Products.CategoryID
    Join Inventories
        On Products.ProductID = Inventories.ProductID
    Join Employees
        On Inventories.EmployeeID = Employees.EmployeeID
Where ProductName IN (Select ProductName From Products Where ProductName IN ('Chai', 'Chang'));
Go


-- Question 9 (10% pts): How can you create a view to show a list of Employees and the Manager who manages them?
-- Order the results by the Manager's name!

--Select Mgr.EmployeeFirstName+' '+Mgr.EmployeeLastName As Manager,
--	   Emp.EmployeeFirstName+' '+Emp.EmployeeLastName As Employee
--	   From Employees As Emp
--	   Inner Join Employees As Mgr
--	   On Emp.EmployeeID=Mgr.ManagerID;

--Select Mgr.EmployeeFirstName+' '+Mgr.EmployeeLastName As Manager,
--	   Emp.EmployeeFirstName+' '+Emp.EmployeeLastName As Employee
--	   From Employees As Emp
--	   Inner Join Employees As Mgr
--	   On Mgr.ManagerID=Emp.EmployeeID;

--Select Emp.EmployeeFirstName+' '+Emp.EmployeeLastName As Manager,
--	   Mgr.EmployeeFirstName+' '+Mgr.EmployeeLastName As Employee
--	   From Employees As Emp
--	   Inner Join Employees As Mgr
--	   On Emp.EmployeeID=Mgr.ManagerID;

--Select Emp.EmployeeFirstName+' '+Emp.EmployeeLastName As Manager,
--	   Mgr.EmployeeFirstName+' '+Mgr.EmployeeLastName As Employee
--	   From Employees As Emp
--	   Inner Join Employees As Mgr
--	   On Emp.EmployeeID=Mgr.ManagerID
--	   Order by 1,2;

Go
Create View[dbo].[vEmployeesByManager]
As
Select Top 1000000 Emp.EmployeeFirstName+' '+Emp.EmployeeLastName As Manager,
	   Mgr.EmployeeFirstName+' '+Mgr.EmployeeLastName As Employee
	   From Employees As Emp
	   Inner Join Employees As Mgr
	   On Emp.EmployeeID=Mgr.ManagerID
	   Order by 1,2;
Go

-- Question 10 (20% pts): How can you create one view to show all the data from all four 
-- BASIC Views? Also show the Employee's Manager Name and order the data by 
-- Category, Product, InventoryID, and Employee.


--Select vCategories.CategoryID,vCategories.CategoryName,vProducts.ProductID,vProducts.ProductName,vproducts.UnitPrice,
--       vInventories.InventoryID,vInventories.InventoryDate,
--	   Count,vEmployees.EmployeeID
--	   From vCategories 
--	   Join vproducts
--	   On vcategories.CategoryID=vProducts.CategoryID
--	   Join vInventories
--	   On vProducts.ProductID=vInventories.ProductID
--	   Join vEmployees
--		On vInventories.EmployeeID =vEmployees.EmployeeID;

--Select vCategories.CategoryID,vCategories.CategoryName,
--       vProducts.ProductID,vProducts.ProductName,vproducts.UnitPrice,
--       vInventories.InventoryID,vInventories.InventoryDate,vInventories.Count,
--	   vEmployees.EmployeeID, 
--	   vEmployees.EmployeeFirstName+' '+vEmployees.EmployeeLastName As Employee,
--	   vEmployees.EmployeeFirstName+' '+vEmployees.EmployeeLastName As Manager
--	   From vCategories 
--	   Join vproducts
--	   On vcategories.CategoryID=vProducts.CategoryID
--	   Join vInventories
--	   On vProducts.ProductID=vInventories.ProductID
--	   Join vEmployees
--	   On vInventories.EmployeeID =vEmployees.EmployeeID;

--Select vCategories.CategoryID,vCategories.CategoryName,
--       vProducts.ProductID,vProducts.ProductName,vproducts.UnitPrice,
--       vInventories.InventoryID,vInventories.InventoryDate,vInventories.Count,
--	   vEmployees.EmployeeID, 
--	   vEmployees.EmployeeFirstName+' '+vEmployees.EmployeeLastName As Manager,
--	   Mgr.EmployeeFirstName+' '+Mgr.EmployeeLastName As Employee
--	   From vCategories 
--	   Join vproducts
--	   On vcategories.CategoryID=vProducts.CategoryID
--	   Join vInventories
--	   On vProducts.ProductID=vInventories.ProductID
--	   Join vEmployees
--	   On vInventories.EmployeeID =vEmployees.EmployeeID
--	   Join vEmployees As Emp 
--	   On vInventories.EmployeeID=Emp.EmployeeID
--	   Join Employees As Mgr on Emp.ManagerID=Mgr.EmployeeID;

--Select vCategories.CategoryID,vCategories.CategoryName,
--       vProducts.ProductID,vProducts.ProductName,vproducts.UnitPrice,
--       vInventories.InventoryID,vInventories.InventoryDate,vInventories.Count,
--	   vEmployees.EmployeeID, 
--	   vEmployees.EmployeeFirstName+' '+vEmployees.EmployeeLastName As Manager,
--	   Mgr.EmployeeFirstName+' '+Mgr.EmployeeLastName As Employee
--	   From vCategories 
--	   Join vproducts
--	   On vcategories.CategoryID=vProducts.CategoryID
--	   Join vInventories
--	   On vProducts.ProductID=vInventories.ProductID
--	   Join vEmployees
--	   On vInventories.EmployeeID =vEmployees.EmployeeID
--	   Join vEmployees As Emp 
--	   On vInventories.EmployeeID=Emp.EmployeeID
--	   Join Employees As Mgr on Emp.ManagerID=Mgr.EmployeeID
--	   Order by 2,3,6,11; 

Go
Create View [dbo].[vInventoriesByProductsByCategoriesByEmployees]
As
Select Top 10000000 vCategories.CategoryID,vCategories.CategoryName,
       vProducts.ProductID,vProducts.ProductName,vproducts.UnitPrice,
       vInventories.InventoryID,vInventories.InventoryDate,vInventories.Count,
	   vEmployees.EmployeeID, 
	   vEmployees.EmployeeFirstName+' '+vEmployees.EmployeeLastName As Manager,
	   Mgr.EmployeeFirstName+' '+Mgr.EmployeeLastName As Employee
	   From vCategories 
	   Join vproducts
	   On vcategories.CategoryID=vProducts.CategoryID
	   Join vInventories
	   On vProducts.ProductID=vInventories.ProductID
	   Join vEmployees
	   On vInventories.EmployeeID =vEmployees.EmployeeID
	   Join vEmployees As Emp 
	   On vInventories.EmployeeID=Emp.EmployeeID
	   Join Employees As Mgr on Emp.ManagerID=Mgr.EmployeeID
	   Order by 2,3,6,11; 
Go

-- Test your Views (NOTE: You must change the your view names to match what I have below!)
Print 'Note: You will get an error until the views are created!'
Select * From [dbo].[vCategories]
Select * From [dbo].[vProducts]
Select * From [dbo].[vInventories]
Select * From [dbo].[vEmployees]

Select * From [dbo].[vProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByDates]
Select * From [dbo].[vInventoriesByEmployeesByDates]
Select * From [dbo].[vInventoriesByProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByEmployees]
Select * From [dbo].[vInventoriesForChaiAndChangByEmployees]
Select * From [dbo].[vEmployeesByManager]
Select * From [dbo].[vInventoriesByProductsByCategoriesByEmployees]

/***************************************************************************************/