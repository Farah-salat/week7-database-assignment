-- ============================================================================
-- WEEK 7 ASSIGNMENT: DATABASE DESIGN AND NORMALIZATION
-- Student: Farah Salat
-- File: answer.sql
-- ============================================================================

-- Create and select a working database (optional, helpful for MySQL Workbench testing)
CREATE DATABASE IF NOT EXISTS normalization_db;
USE normalization_db;


-- ============================================================================
-- QUESTION 1: ACHIEVING FIRST NORMAL FORM (1NF)
-- ============================================================================
-- Explanation:
-- In the original ProductDetail table, the 'Products' column contains multiple
-- comma-separated values in a single cell, violating 1NF (atomicity).
-- To achieve 1NF, we create a new table where each row stores only one atomic
-- product per order, using a composite primary key (OrderID, Product).

DROP TABLE IF EXISTS ProductDetail_1NF;

CREATE TABLE ProductDetail_1NF (
    OrderID INT NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    Product VARCHAR(100) NOT NULL,
    PRIMARY KEY (OrderID, Product)
);

-- Insert normalized 1NF records (one product per row)
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
    (101, 'John Doe', 'Laptop'),
    (101, 'John Doe', 'Mouse'),
    (102, 'Jane Smith', 'Tablet'),
    (102, 'Jane Smith', 'Keyboard'),
    (102, 'Jane Smith', 'Mouse'),
    (103, 'Emily Clark', 'Phone');

-- Verify Question 1 output
SELECT * FROM ProductDetail_1NF;


-- ============================================================================
-- QUESTION 2: ACHIEVING SECOND NORMAL FORM (2NF)
-- ============================================================================
-- Explanation:
-- Partial Dependency Identified:
-- In the OrderDetails table with composite primary key (OrderID, Product),
-- 'CustomerName' depends only on 'OrderID' (part of the primary key) rather
-- than the entire composite key.
--
-- Solution:
-- Split OrderDetails into two tables:
-- 1. Orders: Stores OrderID (Primary Key) and CustomerName.
-- 2. OrderItems: Stores OrderID, Product (Composite Primary Key), and Quantity,
--    linked to Orders via a Foreign Key on OrderID.

DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;

-- 1. Create the Orders table (eliminates partial dependency)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL
);

-- 2. Create the OrderItems table (stores order-specific products & quantities)
CREATE TABLE OrderItems (
    OrderID INT NOT NULL,
    Product VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY (OrderID, Product),
    CONSTRAINT fk_orderitems_orders
        FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Insert normalized records into Orders
INSERT INTO Orders (OrderID, CustomerName) VALUES
    (101, 'John Doe'),
    (102, 'Jane Smith'),
    (103, 'Emily Clark');

-- Insert normalized records into OrderItems
INSERT INTO OrderItems (OrderID, Product, Quantity) VALUES
    (101, 'Laptop', 2),
    (101, 'Mouse', 1),
    (102, 'Tablet', 3),
    (102, 'Keyboard', 1),
    (102, 'Mouse', 2),
    (103, 'Phone', 1);

-- Verify Question 2 output using a JOIN
SELECT 
    o.OrderID,
    o.CustomerName,
    oi.Product,
    oi.Quantity
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
ORDER BY o.OrderID, oi.Product;
