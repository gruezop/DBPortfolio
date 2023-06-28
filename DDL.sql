-- Patricia Gruezo
-- Ecommerce Database App

-- Disable Commits and Foreign Key Checks
SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;


-- Create table structure for Categories: Record categories for each product.

CREATE OR REPLACE TABLE `Categories` (
  `categoryID` int(11) NOT NULL AUTO_INCREMENT,
  `categoryName` varchar(255) NOT NULL,
  PRIMARY KEY (`categoryID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;


-- Insert sample data for table Categories

INSERT INTO `Categories` (`categoryName`) VALUES
('Food and Drink'),
('Vitamins and Supplements'),
('Immunity'),
('Fitness'),
('Beauty');


-- Create table structure for Customers: Records details of customers of the website

CREATE OR REPLACE TABLE `Customers` (
  `customerID` int(11) NOT NULL UNIQUE AUTO_INCREMENT,
  `firstName` varchar(75) NOT NULL,
  `lastName` varchar(75) NOT NULL,
  `addressLine1` varchar(255) NOT NULL,
  `addressLine2` varchar(50) DEFAULT NULL,
  `city` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `zipCode` int(5) NOT NULL,
  `country` varchar(50) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(50) NOT NULL,
  PRIMARY KEY (`customerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Set starting value for customerID

ALTER TABLE Customers AUTO_INCREMENT=10000;

-- Insert sample data for table Customers

INSERT INTO `Customers` (`firstName`, `lastName`, `addressLine1`, `addressLine2`, `city`, `state`, `zipCode`, `country`, `email`, `phone`) VALUES
('Georgia', 'Curtis', '7633 Sunset St', NULL, 'Ralston', 'NE', '68127', 'USA', 'gcurtis@example.com', '489-330-2385'),
('Craig', 'Fuller', '5648 Se Taylor St', 'Apt E104', 'Portland', 'OR', '97215', 'USA', 'craigfuller@example.com', '282-455-6568'),
('Savannah', 'Pearson', '7409 Brown Terrance', 'Unit 3', 'Nashville', 'TN', '37209', 'USA', 'savpearson@example.com', '412-238-5190'),
('Ricky', 'Harris', '3239 Nowlin Rd', NULL, 'Kennesaw', 'GA', '30144', 'USA', 'ricky.harris@example.com', '353-758-1008'),
('Gail', 'Hudson', '1313 Valwood Pkwy', NULL, 'Carrollton', 'TX', '75006', 'USA', 'gail_hudson10@example.com', '292-314-6801');


-- Create table structure for Orders: Records details of a customer’s order

CREATE OR REPLACE TABLE `Orders` (
  `orderID` int(11) NOT NULL UNIQUE AUTO_INCREMENT,
  `customerID` int(11) NOT NULL,
  `orderDate` date NOT NULL,
  `orderStatus` varchar(50) NOT NULL,
  `shippedDate` date DEFAULT NULL,
  `orderTotal` decimal(10,2) NOT NULL,
  PRIMARY KEY (`orderID`),
  FOREIGN KEY (`customerID`) REFERENCES Customers(`customerID`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Set starting value for orderID

ALTER TABLE Orders AUTO_INCREMENT=100;

-- Insert sample data for table Orders

INSERT INTO `Orders` (`customerID`, `orderDate`, `orderStatus`, `shippedDate`, `orderTotal`) VALUES
((SELECT customerID FROM Customers WHERE firstName='Georgia' AND lastName='Curtis'), '2023-01-13', 'Shipped', '2023-01-15', 63.00),
((SELECT customerID FROM Customers WHERE firstName='Craig' AND lastName='Fuller'), '2023-01-15', 'Shipped', '2023-01-17', 49.00),
((SELECT customerID FROM Customers WHERE firstName='Savannah' AND lastName='Pearson'), '2023-01-21', 'Shipped', '2023-01-23', 93.00),
((SELECT customerID FROM Customers WHERE firstName='Ricky' AND lastName='Harris'), '2023-02-02', 'Processing', NULL, 55.00),
((SELECT customerID FROM Customers WHERE firstName='Gail' AND lastName='Hudson'), '2023-02-05', 'Processing', NULL, 94.00);


-- Create table structure for Products: Record details of products available on the website

CREATE OR REPLACE TABLE `Products` (
  `productID` varchar(45) NOT NULL UNIQUE,
  `productName` varchar(75) NOT NULL,
  `categoryID` int(11) NULL,
  `quantityInStock` int(11) NOT NULL,
  `retailPrice` decimal(10,2) NOT NULL,
  `msrp` double NOT NULL,
  PRIMARY KEY (`productID`),
  FOREIGN KEY (`categoryID`) REFERENCES Categories(`categoryID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;




-- Insert sample data for table Products

INSERT INTO `Products` (`productID`, `productName`, `categoryID`, `quantityInStock`, `retailPrice`, `msrp`) VALUES
('BE001', 'Glycolic Acid Overnight Glow Peel', (SELECT categoryID FROM Categories WHERE categoryName='Beauty' ), 170, 45.00, 22.5),
('FD001', 'Plant Based Energy Bites', (SELECT categoryID FROM Categories WHERE categoryName='Food and Drink'), 499, 18.00, 9),
('FI001', 'Balance Blocks', (SELECT categoryID FROM Categories WHERE categoryName='Fitness'), 238, 49.00, 24.5),
('IM001', 'Immunity Wellness Shot', (SELECT categoryID FROM Categories WHERE categoryName='Immunity'), 250, 10.00, 5),
('VS001', 'Daily Multivitamin', (SELECT categoryID FROM Categories WHERE categoryName='Vitamins and Supplements'), 382, 15.00, 7.5),
('W001', 'Wellness Essential', NULL, 212, 35.00, 17.5);


-- Create table structure for OrderDetails: Intersection table to facilitate M:N between Orders and Products.

CREATE OR REPLACE TABLE `OrderDetails` (
  `orderDetailsID` int(11) NOT NULL AUTO_INCREMENT,
  `orderLine` int(11) NOT NULL,
  `orderID` int(11) NOT NULL,
  `productID` varchar(45) NOT NULL,
  `quantity` int(11) NOT NULL,
  `itemPrice` decimal(10,2) NOT NULL,
  PRIMARY KEY (`orderDetailsID`),
  FOREIGN KEY (`orderID`) REFERENCES Orders(`orderID`) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (`productID`) REFERENCES Products(`productID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Set starting value for orderDetailsID
ALTER TABLE OrderDetails AUTO_INCREMENT=1;


-- Insert sample data for table OrderDetails

INSERT INTO `OrderDetails` (`orderLine`, `orderID`, `productID`, `quantity`, `itemPrice`) VALUES
(1, (SELECT orderID FROM Orders WHERE orderID=100), (SELECT productID FROM Products WHERE productName='Plant Based Energy Bites'), 1, 18.00),
(2, (SELECT orderID FROM Orders WHERE orderID=100), (SELECT productID FROM Products WHERE productName='Glycolic Acid Overnight Glow Peel'), 1, 45.00),
(1, (SELECT orderID FROM Orders WHERE orderID=101), (SELECT productID FROM Products WHERE productName='Balance Blocks'), 1, 49.00),
(1, (SELECT orderID FROM Orders WHERE orderID=102), (SELECT productID FROM Products WHERE productName='Plant Based Energy Bites'), 1, 18.00),
(2, (SELECT orderID FROM Orders WHERE orderID=102), (SELECT productID FROM Products WHERE productName='Daily Multivitamin'), 2, 15.00),
(3, (SELECT orderID FROM Orders WHERE orderID=102), (SELECT productID FROM Products WHERE productName='Glycolic Acid Overnight Glow Peel'), 1, 45.00);

-- Enable Commit and Foreign Key Checks
SET FOREIGN_KEY_CHECKS=1;
COMMIT;
