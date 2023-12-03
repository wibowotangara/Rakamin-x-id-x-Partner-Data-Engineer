CREATE DATABASE DWH_Project

USE DWH_Project

CREATE TABLE DimCustomer (
	CustomerID int NOT NULL,
	CustomerName varchar(50) NOT NULL,
	Age varchar(50) NOT NULL,
	Gender varchar(50) NOT NULL,
	City varchar(50) NOT NULL,
	NoHP varchar(50) NOT NULL,
	CONSTRAINT PK_DimCustomer PRIMARY KEY (CustomerID)
)

CREATE TABLE DimProduct (
	ProductID int NOT NULL,
	ProductName varchar(255) NOT NULL,
	ProductCategory varchar(255) NOT NULL,
	ProductUnitPrice int NOT NULL,
	CONSTRAINT PK_DimProduct PRIMARY KEY (ProductID)
)

CREATE TABLE DimStatusOrder (
	StatusID int NOT NULL,
	StatusOrder varchar(50) NOT NULL,
	StatusOrderDesc varchar(50) NOT NULL,
	CONSTRAINT PK_DimStatusOrder PRIMARY KEY (StatusID)
)

CREATE TABLE FactSalesOrder (
	OrderID int NOT NULL,
	CustomerID int NOT NULL,
	ProductID int NOT NULL,
	Quantity int NOT NULL,
	Amount int NOT NULL,
	StatusID int NOT NULL,
	OrderDate date NOT NULL,
	CONSTRAINT PK_FactSalesOrder PRIMARY KEY (OrderID),
	CONSTRAINT FK_Customer FOREIGN KEY (CustomerID) REFERENCES DimCustomer (CustomerID),
	CONSTRAINT FK_Product FOREIGN KEY (ProductID) REFERENCES DimProduct (ProductID),
	CONSTRAINT FK_StatusOrder FOREIGN KEY (StatusID) REFERENCES DimStatusOrder (StatusID)
)

CREATE PROCEDURE summary_order_status
(@StatusID int) AS
BEGIN
	SELECT	fs.OrderID,
			dc.CustomerName,
			dp.ProductName,
			fs.Quantity,
			ds.StatusOrder
	FROM	FactSalesOrder fs
	INNER JOIN	DimCustomer dc
	ON	fs.CustomerID = dc.CustomerID
	INNER JOIN	DimProduct dp
	ON	fs.ProductID = dp.ProductID
	INNER JOIN DimStatusOrder ds
	ON fs.StatusID = ds.StatusID
	WHERE	ds.StatusID = @StatusID
END

SELECT * FROM DimStatusOrder

EXEC summary_order_status @StatusID = 1