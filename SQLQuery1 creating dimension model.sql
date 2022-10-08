USE [DM_Trg]
GO

Create Table DimProduct
(ProductKey int identity NOT NULL PRIMARY KEY NONCLUSTERED,
ProductAltKey nvarchar(50) NOT NULL,
ProductDescription nvarchar(100) NULL,
ProductUnitMeasure nvarchar(100) NULL,
ProductType nvarchar(50)NULL,
ProductTypeDescr nvarchar(50)NULL,
ProductUnitPrice money NULL
)
GO 


Create Table DimCustomer
(CustomerKey int identity NOT NULL PRIMARY KEY NONCLUSTERED,
CustomertAltKey nvarchar(50) NOT NULL,
CustomerName nvarchar(100) NULL,
CustomerSegId int NULL,
CustomerSegName nvarchar(50) NULL)
GO

Create Table DimGeography
(GeoKey int NOT NULL identity PRIMARY KEY NONCLUSTERED, 
StateProvince nvarchar(50) NULL,
City nvarchar(50)NULL,
CountryRegionName nvarchar (50) NULL)
GO 

Create Table DimDate
(DateKey int NOT NULL PRIMARY KEY NONCLUSTERED,
DateAltKey datetime NOT NULL,
CalendarYear int NOT NULL,
CalendarQuarter int NOT NULL,
MonthOfYear int NOT NULL,
[MonthName] nvarchar(20)NOT NULL,
[DayOfMonth] int NOT NULL,
[DayOfWeek] int NOT NULL,
[DayName] nvarchar(15)NOT NULL,
FiscalYear int NOT NULL,
FiscalQuarter int NOT NULL)
GO 

--Create a fact table

Create Table FactSalesOrders
(ProductKey int NOT NULL REFERENCES DimProduct(ProductKey),
CustomerKey int NOT NULL REFERENCES DimCustomer(CustomerKey),
OrderDateKey int NOT NULL REFERENCES DimDate(DateKey),
GeographyKey int NOT NULL REFERENCES DimGeography(GeoKey),
OrderNo int NOT NULL,
SalesQuantity int NOt Null,
SalesAmount money Not NULL,
CONSTRAINT [PK_FactSalesOrders]PRIMARY KEY NONCLUSTERED
(
[ProductKey],[CustomerKey],[OrderDateKey],[OrderNo],[GeographyKey])
)