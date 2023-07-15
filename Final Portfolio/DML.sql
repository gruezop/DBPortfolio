-- Patricia Gruezo
-- Ecommerce Database App

-- Database Manipulation Queries

-- SELECT from Customers, Orders, OrderDetails, Products and Categories Table
-- Use Alias for column names for each table

-- Customers Table

SELECT customerID AS 'ID', CONCAT(Customers.firstName, ' ', Customers.lastName) AS 'Name', 
CONCAT(Customers.addressLine1, ' ', Customers.addressLine2) AS 'Address', city, state, 
zipCode AS 'Zip Code', country, email, phone FROM Customers;

-- Orders Table: customerID is displayed as Customer's Full Name 
SELECT orderID AS 'ID', CONCAT(Customers.firstName, ' ', Customers.lastName) AS 'Name', 
orderDate AS 'Order Date', orderStatus AS 'Status', shippedDate AS 'Shipped Date', orderTotal AS 'Total' FROM Orders 
INNER JOIN Customers ON Orders.customerID = Customers.customerID;

-- OrderDetails Table: productID is displayed as product name 

SELECT orderDetailsID AS 'ID', orderLine AS 'Order Line', orderID AS 'Order ID', 
(Products.productName) as 'Product', quantity, itemPrice AS 'Item Price' FROM OrderDetails 
INNER JOIN Products ON Products.productID = OrderDetails.productID;

-- Products Table

SELECT productID AS 'Product ID', productName AS 'Product Name', categoryID AS 'Category ID',
quantityInStock AS 'Quantity In Stock', retailPrice AS 'Retail Price', msrp FROM Products;

-- Categories Table

SELECT categoryID AS 'Category ID', categoryName AS 'Category Names' FROM Categories;


-- Display content of an entity for the table and dropdowns

-- Customer Table

SELECT * FROM Customers;
SELECT * FROM Customers WHERE customerID = :customerIDdropdown;

-- Order Table

SELECT * FROM Orders;
SELECT * FROM Orders WHERE orderID = :orderIDdropdown;

-- Order Details Table

SELECT * FROM OrderDetails;

-- Products Table

SELECT * FROM Products;

-- Categories Table

SELECT * FROM Categories;
SELECT * FROM Categories WHERE categoryID = :categoryIDdropdown;


-- Search table by customer's name

SELECT customerID AS 'ID', CONCAT(Customers.firstName, ' ', Customers.lastName) AS 'Name', 
CONCAT(Customers.addressLine1, ' ', Customers.addressLine2) AS 'Address', city, state, zipCode 
AS 'Zip Code', country, email, phone FROM Customers 
WHERE CONCAT(Customers.firstName, ' ', Customers.lastName) = :Namedropdown;

-- Search order by customer name from dropdown

SELECT * FROM Orders WHERE customerID = :customerNamedropdown;

-- Search product from dropdown

SELECT * FROM Products WHERE productID = :productIDdropdown;

-- Search category from dropdown

SELECT * FROM Categories WHERE categoryID = :categoryIDropdown;


-- INSERT sample data to each table
-- customerID, orderID, orderDetailsID and categoryID uses auto_increment

INSERT INTO Customers (firstName, lastName, addressLine1, addressLine2, city, state, zipCode, country, email, phone) VALUES
(:firstNameinput:, :lastNameinput, :addressLine1input, :addressLine2input, :cityinput, :stateinput, :zipCodeinput, :countryinput, :emailinput, :phoneinput);

INSERT INTO Orders (customerID, orderDate, orderStatus, shippedDate, orderTotal) VALUES
(:customerIDdropdown, :orderDateinput, :orderStatusdropdown, :NULLIF(shippedDateinput),''), :orderTotalinput);

INSERT INTO Products (productID, productName, categoryID, quantityInStock, retailPrice, msrp) VALUES
(:productIDinput, :productNameinput, :NULLIF(categoryIDdropdown), :quantityInStockinput, :retailPriceinput, :msrpinput);

INSERT INTO OrderDetails (orderLine, orderID, productID, quantity, itemPrice) VALUES
(:orderLineinput, :orderIDdropdown, :productIDdropdown, :quantityinput, :itemPriceinput);

INSERT INTO Categories (categoryName) VALUES
(:categoryNameinput);


-- Update Orders Table
-- Shipped Date can be updated to NULL

UPDATE Orders SET customerID = :customerIDdropdown, orderDate = :orderDateinput, orderStatus = :orderStatusdropdown,
shippedDate =: shippedDateinput, orderTotal = :orderTotalinput
WHERE orderID = :orderIDdropdown;

-- Update OrderDetails Table

UPDATE OrderDetails SET orderLine= :orderLineinput, orderID = :orderIDdropdown, productID = :productIDdropdown,
quantity = :quantityinput,itemPrice = :itemPriceinput
WHERE orderDetailsID = :orderDetailsIDdropdown;

-- Update Products Table
-- FK categoryID can be updated to NULL

UPDATE Products SET productName = :productNamedropdown, categoryID = :categoryIDdropdown, quantityInStock = :quantityInStockinput,
retailPrice = :retailPriceinput, msrp = :msrpinput
WHERE productID = :productIDdropdown;

-- Delete order from Orders table

DELETE FROM Orders WHERE orderID = :orderIDselect;

-- Delete product from Products table

DELETE FROM Products WHERE productID = :productIDselect;

