/*
Description
	Demonstrate 101 rows problem on SQL Server.
*/
USE [AdventureWorks];
GO

SET STATISTICS TIME, IO ON;
GO

SELECT TOP (100) *
FROM [Sales].[SalesOrderDetail]

SELECT TOP (101) *
FROM [Sales].[SalesOrderDetail]

SET STATISTICS TIME, IO OFF;
GO

/* Execution Times
(100 rows affected)
Table 'SalesOrderDetail'. Scan count 1, logical reads 7, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

(101 rows affected)
Table 'SalesOrderDetail'. Scan count 1, logical reads 7, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 50 ms.
*/
