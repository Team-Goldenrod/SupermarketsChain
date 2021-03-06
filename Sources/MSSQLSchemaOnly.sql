﻿USE master
GO

CREATE DATABASE SupermarketsChain
GO

USE SupermarketsChain
GO

CREATE TABLE Vendors (
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(50) NOT NULL
)

CREATE TABLE Measures (
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(50) NOT NULL
)

CREATE TABLE Products (
	Id INT PRIMARY KEY IDENTITY,
	VendorId INT NOT NULL FOREIGN KEY REFERENCES Vendors(Id),
	Name NVARCHAR(50) NOT NULL,
	MeasureId INT NOT NULL FOREIGN KEY REFERENCES Measures(Id),
	Price MONEY NOT NULL
)

CREATE TABLE Supermarkets (
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(50) NOT NULL
)

CREATE TABLE SupermarketsProducts (
	SupermarketId INT FOREIGN KEY REFERENCES Supermarkets(Id),
	ProductId INT FOREIGN KEY REFERENCES Products(Id)
	CONSTRAINT [PK_SupermarketsProducts] PRIMARY KEY CLUSTERED 
	(
		SupermarketId ASC,
		ProductId ASC
	)
)

CREATE TABLE Sales(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	SupermarketId INT FOREIGN KEY REFERENCES Supermarkets(Id),
	ProductId INT FOREIGN KEY REFERENCES Products(Id),
	OrderedOn DATE NOT NULL
)

CREATE TABLE Expenses(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Month] DATE NOT NULL,
	Expense MONEY NOT NULL
)
	
CREATE TABLE VendorExpenses(
	VendorId INT FOREIGN KEY REFERENCES Vendors(Id) NOT NULL,
	ExpenseId INT FOREIGN KEY REFERENCES Expenses(Id) NOT NULL,
)

CREATE PROC EmptySqlDatabase
AS

EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL' 

EXEC sp_MSForEachTable 'DELETE ?' 

EXEC sp_MSForEachTable 'DBCC CHECKIDENT (''?'', RESEED,  0)'

EXEC sp_MSForEachTable 'ALTER TABLE ? CHECK CONSTRAINT ALL' 

/*
EXEC EmptySqlDatabase
*/