USE [DM_Srcs]
GO


Create Table ProductType
(ProductType nvarchar(50) NOT NULL PRIMARY KEY NONCLUSTERED,
ProductTypeDescription nvarchar(50) NULL)
GO


Create Table Product
(ProdId int NOT NULL PRIMARY KEY NONCLUSTERED,
ProductDescription nvarchar(50) NULL,
ProductUnitMeasure nvarchar(50) NULL,
QTYinHand int NULL,
ProdType nvarchar(50) NULL REFERENCES ProductType(ProductType))
GO  

Create Table CustomerSegment
(SegmentId int NOT NULL PRIMARY KEY NONCLUSTERED,
SegmentName nvarchar(50) NULL)
GO 

Create Table Customer
(CustomerId int NOT NULL PRIMARY KEY NONCLUSTERED, 
CustomerName nvarchar(50)NULL,
CustomerAdd nvarchar (50) NULL,
CustomerState nvarchar (50) NULL,
CustomerCity nvarchar (50) NULL,
CustomerCountry nvarchar (50) NULL,
CustomerSegmentId int NULL REFERENCES CustomerSegment(SegmentId)
)
GO 


Create Table OrderHeader
(OrderId int NOT NULL PRIMARY KEY NONCLUSTERED,
OrderDate datetime NOT NULL,
CustomerId int NOT NULL REFERENCES Customer(CustomerId))
GO 

USE [DM_Srcs]
GO
Create Table OrderDetails
(OrderId int NOT NULL REFERENCES OrderHeader(OrderId),
ProductId int NOT NULL REFERENCES Product(ProdId),
QTY int NULL,
UnitPrice money NULL,
CONSTRAINT [PK_OrderDetails] PRIMARY KEY NONCLUSTERED
(
[OrderId],[ProductId]))
GO





