-- Question 1: Explain the fundamental differences between DDL, DML, and DQL commands in SQL. 
-- Provide one example for each type. 

-- DDL (Data Definition Language): Used to define or modify the structure of the database, such as creating, altering, or deleting tables.
-- Example: CREATE TABLE Employees (ID INT, Name VARCHAR(50)); 

-- DML (Data Manipulation Language): Used to manage data within existing tables, including adding, updating, or deleting records.
-- Example: INSERT INTO Employees (ID, Name) VALUES (1, 'Alice'); 

-- DQL (Data Query Language): Specifically used to retrieve or fetch data from the database.
-- Example: SELECT * FROM Employees;



-- Question 2: What is the purpose of SQL constraints? 
-- Name and describe three common types. 
-- The purpose of SQL constraints is to specify rules for the data in a table, ensuring the accuracy and reliability (integrity) of the information.

-- PRIMARY KEY: Uniquely identifies each record in a table. It cannot contain NULL values.
-- Scenario: A CustomerID in a Customers table to ensure every customer is unique.


-- FOREIGN KEY: Prevents actions that would destroy links between tables by ensuring a value matches a record in another table.
-- Scenario: A CategoryID in a Products table that must exist in the Categories table.


-- NOT NULL: Ensures that a column cannot have a NULL value.
-- Scenario: Ensuring every product has a ProductName so items aren't listed without names.



-- Question 3: Explain the difference between LIMIT and OFFSET. 
-- How would you retrieve the third page of results (10 records per page)? LIMIT: Specifies the maximum number of records to return in the result set.OFFSET: Specifies the number of rows to skip before starting to return rows.
-- To retrieve the third page: You skip the first 20 records (2 pages $\times$ 10 records) to show the next 10.


SELECT * FROM Products
ORDER BY ProductID
LIMIT 10 OFFSET 20;


 
-- Question 4 : What is a Common Table Expression (CTE) in SQL, and what are its main 
-- benefits? Provide a simple SQL example demonstrating its usage. 

-- In SQL, a Common Table Expression (CTE) is a temporary, named result set that you can reference within a larger query. 
-- It is defined using the WITH clause and exists only during the execution of that specific query.Main Benefits of a CTEImproved Readability: 
-- It breaks down complex queries into smaller, logical blocks, making the code easier to follow.Simplified Logic: 
-- It allows you to replace complicated subqueries and multiple joins with a more structured approach.Reusability: 
-- You can reference the same CTE multiple times within a single query without rewriting the underlying logic.Recursive Capabilities:
--  CTEs can reference themselves, which is essential for querying hierarchical data like organizational charts

/* Step 1: Define the CTE using the WITH clause.
We name it 'HighPriceProducts'.
*/
WITH HighPriceProducts AS (
    SELECT 
        ProductName, 
        Price, 
        StockQuantity
    FROM Products
    WHERE Price > 100.00
)

/* Step 2: Use the CTE in a main SELECT statement 
just like a regular table.
*/
SELECT * FROM HighPriceProducts
ORDER BY Price DESC;


-- Question 5 : Describe the concept of SQL Normalization and its primary goals. Briefly 
-- explain the first three normal forms (1NF, 2NF, 3NF). 

-- First Normal Form (1NF): A table is in 1NF if it is organized into rows and columns where every cell contains only atomic, or single, values. 
-- This form requires that there are no repeating groups or multiple values within a single field.


-- Second Normal Form (2NF): To reach 2NF, a table must first meet all the requirements of 1NF. Additionally, 
-- it must ensure that all non-key columns are fully functional and dependent on the entire primary key, thereby removing partial dependencies.


-- Third Normal Form (3NF): A table is in 3NF if it meets all the requirements of 2NF.
--  It further requires that there are no transitive functional dependencies, meaning non-key columns should not depend on other non-key columns; 
--  they must only depend on the primary key



-- Question 6 :

-- Categories Table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO Categories VALUES
(1, 'Electronics'),
(2, 'Books'),
(3, 'Home Goods'),
(4, 'Apparel');


-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL UNIQUE,
    CategoryID INT,
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

INSERT INTO Products VALUES
(101, 'Laptop Pro', 1, 1200.00, 50),
(102, 'SQL Handbook', 2, 45.50, 200),
(103, 'Smart Speaker', 1, 99.99, 150),
(104, 'Coffee Maker', 3, 75.00, 80),
(105, 'Novel: The Great SQL', 2, 25.00, 120),
(106, 'Wireless Earbuds', 1, 150.00, 100),
(107, 'Blender X', 3, 120.00, 60),
(108, 'T-Shirt Casual', 4, 20.00, 300);



-- Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    JoinDate DATE
);

INSERT INTO Customers VALUES
(1, 'Alice Wonderland', 'alice@example.com', '2023-01-10'),
(2, 'Bob the Builder', 'bob@example.com', '2022-11-25'),
(3, 'Charlie Chaplin', 'charlie@example.com', '2023-03-01'),
(4, 'Diana Prince', 'diana@example.com', '2021-04-26');



-- Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Orders VALUES
(1001, 1, '2023-04-26', 1245.50),
(1002, 2, '2023-10-12', 99.99),
(1003, 1, '2023-07-01', 145.00),
(1004, 3, '2023-01-14', 150.00),
(1005, 4, '2023-09-24', 120.00),
(1006, 1, '2023-06-19', 20.00);


-- Question 7 : Generate a report showing CustomerName, Email, and the 
-- TotalNumberofOrders for each customer. Include customers who have not placed 
-- any orders, in which case their TotalNumberofOrders should be 0. Order the results 
-- by CustomerName. 
-- Answer : 


SELECT 
    c.CustomerName,
    c.Email,
    COUNT(o.OrderID) AS TotalNumberOfOrders
FROM Customers c
LEFT JOIN Orders o 
    ON c.CustomerID = o.CustomerID
GROUP BY 
    c.CustomerName, c.Email
ORDER BY 
    c.CustomerName;


-- Question 8 :  Retrieve Product Information with Category: Write a SQL query to 
-- display the ProductName, Price, StockQuantity, and CategoryName for all 
-- products. Order the results by CategoryName and then ProductName alphabetically. 
-- Answer : 

SELECT 
    p.ProductName,
    p.Price,
    p.StockQuantity,
    c.CategoryName
FROM Products p
JOIN Categories c 
    ON p.CategoryID = c.CategoryID
ORDER BY 
    c.CategoryName ASC,
    p.ProductName ASC;


-- Question 9 : Write a SQL query that uses a Common Table Expression (CTE) and a 
-- Window Function (specifically ROW_NUMBER() or RANK()) to display the 
-- CategoryName, ProductName, and Price for the top 2 most expensive products in 
-- each CategoryName. 
-- Answer :  

WITH RankedProducts AS (
    SELECT 
        c.CategoryName,
        p.ProductName,
        p.Price,
        ROW_NUMBER() OVER (
            PARTITION BY c.CategoryName 
            ORDER BY p.Price DESC
        ) AS rn
    FROM Products p
    JOIN Categories c 
        ON p.CategoryID = c.CategoryID
)

SELECT 
    CategoryName,
    ProductName,
    Price
FROM RankedProducts
WHERE rn <= 2;

-- Question 10 : You are hired as a data analyst by Sakila Video Rentals, a global movie 
-- rental company. The management team is looking to improve decision-making by 
-- analyzing existing customer, rental, and inventory data. 
-- Using the Sakila database, answer the following business questions to support key strategic 
-- initiatives. 


-- Tasks & Questions: 
-- 1. Identify the top 5 customers based on the total amount they’ve spent. Include customer 
-- name, email, and total amount spent. 

SELECT 
    c.first_name,
    c.last_name,
    c.email,
    SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p 
    ON c.customer_id = p.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, c.email
ORDER BY 
    total_spent DESC
LIMIT 5;



-- 2. Which 3 movie categories have the highest rental counts? Display the category name 
-- and number of times movies from that category were rented. 

SELECT 
    cat.name AS category_name,
    COUNT(r.rental_id) AS rental_count
FROM category cat
JOIN film_category fc 
    ON cat.category_id = fc.category_id
JOIN inventory i 
    ON fc.film_id = i.film_id
JOIN rental r 
    ON i.inventory_id = r.inventory_id
GROUP BY 
    cat.name
ORDER BY 
    rental_count DESC
LIMIT 3;


-- 3. Calculate how many films are available at each store and how many of those have 
-- never been rented. 

SELECT 
    s.store_id,
    COUNT(i.inventory_id) AS total_films,
    SUM(CASE 
            WHEN r.rental_id IS NULL THEN 1 
            ELSE 0 
        END) AS never_rented
FROM store s
JOIN inventory i 
    ON s.store_id = i.store_id
LEFT JOIN rental r 
    ON i.inventory_id = r.inventory_id
GROUP BY 
    s.store_id;


-- 4. Show the total revenue per month for the year 2023 to analyze business seasonality. 

SELECT 
    MONTH(payment_date) AS month,
    SUM(amount) AS total_revenue
FROM payment
WHERE YEAR(payment_date) = 2023
GROUP BY 
    MONTH(payment_date)
ORDER BY 
    month;


-- 5. Identify customers who have rented more than 10 times in the last 6 months.


SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_rentals
FROM customer c
JOIN rental r 
    ON c.customer_id = r.customer_id
WHERE r.rental_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY 
    c.customer_id, c.first_name, c.last_name
HAVING 
    COUNT(r.rental_id) > 10;










