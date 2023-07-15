-- Database Manipulation Queries

-- Create Views
-- Customers

CREATE VIEW Customers_View AS
	SELECT CustomerID, Customer_Name AS CustomerName, City, StateProvince_Name AS State
FROM customers;

-- Employees

CREATE VIEW Employees_View AS
	SELECT EmployeeID, CONCAT(FirstName, ' ', LastName) AS EmployeeName, Title
FROM employees;

-- Products

CREATE VIEW Products_View AS
	SELECT ProductNumber AS ProductID, ProductName, ListPrice, products.SegmentID, 		
    segments.CategoryName
	FROM products
    JOIN segments ON products.SegmentID = segments.SegmentID;
    
-- Invoice Date

CREATE VIEW InvoiceDate_View AS
	SELECT DISTINCT DATE(InvoiceDate) as FullDate, MONTH(InvoiceDate) as Month, DAY(InvoiceDate) as Day, 
    QUARTER(InvoiceDate) as Quarter, YEAR(InvoiceDate) as Year
	FROM salesinvoices
	WHERE YEAR(InvoiceDate) >= 2014
	ORDER BY FullDate;
    
    
-- Sales

CREATE VIEW Sales_View AS
	SELECT Date(InvoiceDate) AS FullDate, CustomerID, SalesEmployeeID AS EmployeeID, 
    ProductNumber AS ProductID, OrderQty AS QtySold, LineTotal AS TotalSold
    FROM salesinvoices
    INNER JOIN salesinvoicedetails 
    ON salesinvoices.SalesInvoiceID = salesinvoicedetails.SalesInvoiceID
    WHERE YEAR(InvoiceDate) >= 2014
	ORDER BY FullDate;
    

    
-- Database Manipulation Queries


-- Total # of Unit Sold per product (in descending order)
SELECT Products_View.ProductID, ProductName, COUNT(QtySold) AS 'Total Sold' FROM Products_View
LEFT JOIN Sales_View
ON Products_View.ProductID = Sales_View.ProductID
GROUP BY Products_View.ProductID
ORDER BY Count(QtySold) DESC;

-- Total Revenue for each product category

SELECT Products_View.ProductID, CategoryName, ROUND(SUM(TotalSold), 2) AS 'Total Revenue' FROM Products_View
LEFT JOIN Sales_View
ON Products_View.ProductID = Sales_View.ProductID
GROUP BY CategoryName
ORDER BY SUM(TotalSold) DESC;


-- Top 10 customers with the most orders

SELECT CustomerName, COUNT(Sales_View.CustomerID) AS 'Order Total' FROM Sales_View
LEFT JOIN Customers_View
ON Sales_View.CustomerID = Customers_View.CustomerID
GROUP BY CustomerName
ORDER BY COUNT(Sales_View.CustomerID) DESC
LIMIT 10;

-- Average order value for each customer

SELECT Customers_View.CustomerID, CustomerName, ROUND(AVG(TotalSold),2) AS 'Average Order' FROM Customers_View
INNER JOIN Sales_View
ON Customers_View.CustomerID = Sales_View.CustomerID
GROUP BY CustomerName
ORDER BY Customers_View.CustomerID;

-- Total revenue for each month

SELECT InvoiceDate_View.Month, ROUND(SUM(TotalSold),2) AS 'Total Revenue' FROM InvoiceDate_View
INNER JOIN Sales_View
ON InvoiceDate_View.FullDate = Sales_View.FullDate
GROUP BY Month;


-- Top 5 products ordered the most and how many times
SELECT Products_View.ProductID, ProductName, COUNT(QtySold) AS 'Total Qty Sold' FROM Products_View
INNER JOIN Sales_View
ON Products_View.ProductID = Sales_View.ProductID
GROUP BY ProductName
ORDER BY COUNT(QtySold) DESC
LIMIT 5;


-- Customers have ordered BK-M18B-40 and how many times?

SELECT CustomerName, ProductName, COUNT(QtySold) FROM Customers_View
JOIN Sales_View ON Customers_View.CustomerID = Sales_View.CustomerID
JOIN Products_View ON Sales_View.ProductID = Products_View.ProductID
WHERE Products_View.ProductID = 'BK-M18B-40'
GROUP BY CustomerName
ORDER BY COUNT(QtySold) DESC;

-- Average Order Value Each Month

SELECT Month, ROUND(AVG(TotalSold),2) AS 'Average Order Value' FROM Sales_View
JOIN InvoiceDate_View ON Sales_View.FullDate = InvoiceDate_View.FullDate
GROUP BY Month;

-- Average Quantity Ordered Per Product 

SELECT ProductName, ROUND(AVG(QtySold),2) AS 'Average Qty Ordered' FROM Sales_View
JOIN Products_View ON Sales_View.ProductID = Products_View.ProductID
GROUP BY ProductName
ORDER BY ProductName;

-- Top 5 category with the highest revenue per customer on average

SELECT CustomerName, CategoryName, ROUND(SUM(TotalSold),2) AS Revenue FROM Customers_View
JOIN Sales_View ON Customers_View.CustomerID = Sales_View.CustomerID
JOIN Products_View ON Sales_View.ProductID = Products_View.ProductID
GROUP BY CategoryName
ORDER BY Revenue DESC
LIMIT 5;