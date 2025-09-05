-- Business Database Schema with Sample Data
-- This creates a comprehensive business database with multiple related tables

-- Drop existing tables if they exist
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS categories;

-- Create tables
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(50) NOT NULL,
    manager_id INT,
    location VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2),
    department_id INT,
    manager_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(50),
    contact_email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(200),
    city VARCHAR(50),
    country VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    category_id INT,
    supplier_id INT,
    discontinued BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50),
    registration_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    employee_id INT,
    order_date DATE DEFAULT CURRENT_DATE,
    required_date DATE,
    shipped_date DATE,
    ship_name VARCHAR(100),
    ship_address VARCHAR(200),
    ship_city VARCHAR(50),
    ship_state VARCHAR(50),
    ship_postal_code VARCHAR(20),
    ship_country VARCHAR(50),
    freight DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(10,2),
    status ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(5,2) DEFAULT 0,
    line_total DECIMAL(10,2) GENERATED ALWAYS AS (quantity * unit_price * (1 - discount/100)) STORED,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert sample data

-- Departments
INSERT INTO departments (department_name, location) VALUES
('Sales', 'New York'),
('Marketing', 'Chicago'),
('IT', 'San Francisco'),
('Human Resources', 'Boston'),
('Finance', 'New York');

-- Employees
INSERT INTO employees (first_name, last_name, email, phone, hire_date, salary, department_id) VALUES
('John', 'Smith', 'john.smith@company.com', '555-0101', '2020-01-15', 75000.00, 1),
('Sarah', 'Johnson', 'sarah.johnson@company.com', '555-0102', '2019-03-22', 85000.00, 2),
('Michael', 'Chen', 'michael.chen@company.com', '555-0103', '2021-06-01', 90000.00, 3),
('Emily', 'Davis', 'emily.davis@company.com', '555-0104', '2022-02-10', 65000.00, 4),
('Robert', 'Wilson', 'robert.wilson@company.com', '555-0105', '2018-11-05', 80000.00, 5),
('Lisa', 'Brown', 'lisa.brown@company.com', '555-0106', '2021-09-15', 72000.00, 1),
('David', 'Martinez', 'david.martinez@company.com', '555-0107', '2023-01-20', 60000.00, 3);

-- Update manager relationships
UPDATE employees SET manager_id = 1 WHERE employee_id IN (2, 6);
UPDATE employees SET manager_id = 3 WHERE employee_id = 7;
UPDATE departments SET manager_id = 1 WHERE department_id = 1;
UPDATE departments SET manager_id = 2 WHERE department_id = 2;
UPDATE departments SET manager_id = 3 WHERE department_id = 3;
UPDATE departments SET manager_id = 4 WHERE department_id = 4;
UPDATE departments SET manager_id = 5 WHERE department_id = 5;

-- Suppliers
INSERT INTO suppliers (company_name, contact_name, contact_email, phone, address, city, country) VALUES
('TechSupply Co', 'Alice Cooper', 'alice@techsupply.com', '555-1001', '123 Tech Street', 'Austin', 'USA'),
('Global Electronics', 'Bob Taylor', 'bob@globalelec.com', '555-1002', '456 Global Ave', 'Toronto', 'Canada'),
('Quality Parts Ltd', 'Carol White', 'carol@qualityparts.com', '555-1003', '789 Quality Rd', 'London', 'UK'),
('Asian Imports', 'David Kim', 'david@asianimports.com', '555-1004', '321 Import Blvd', 'Seoul', 'South Korea'),
('European Solutions', 'Elena Rossi', 'elena@eurosol.com', '555-1005', '654 Euro Street', 'Milan', 'Italy');

-- Categories
INSERT INTO categories (category_name, description) VALUES
('Electronics', 'Electronic devices and components'),
('Computers', 'Desktop and laptop computers'),
('Office Supplies', 'General office supplies and equipment'),
('Furniture', 'Office and home furniture'),
('Software', 'Software licenses and applications'),
('Networking', 'Network equipment and accessories');

-- Products
INSERT INTO products (product_name, description, price, stock_quantity, category_id, supplier_id) VALUES
('Laptop Pro 15"', 'High-performance laptop with 16GB RAM', 1299.99, 50, 2, 1),
('Wireless Mouse', 'Ergonomic wireless mouse with USB receiver', 29.99, 200, 1, 2),
('Office Chair', 'Ergonomic office chair with lumbar support', 249.99, 75, 4, 3),
('USB-C Cable', '6ft USB-C charging cable', 19.99, 500, 1, 1),
('Standing Desk', 'Adjustable height standing desk', 399.99, 30, 4, 4),
('Network Switch', '8-port gigabit ethernet switch', 89.99, 100, 6, 2),
('Office Printer', 'All-in-one laser printer', 299.99, 25, 3, 5),
('Wireless Keyboard', 'Bluetooth wireless keyboard', 59.99, 150, 1, 1),
('Monitor 27"', '27-inch 4K monitor', 349.99, 40, 1, 3),
('Office Software Suite', 'Annual license for office software', 99.99, 1000, 5, 5);

-- Customers
INSERT INTO customers (first_name, last_name, email, phone, address, city, state, postal_code, country) VALUES
('Jane', 'Austin', 'jane.austin@email.com', '555-2001', '123 Main St', 'Seattle', 'WA', '98101', 'USA'),
('Tom', 'Brady', 'tom.brady@email.com', '555-2002', '456 Oak Ave', 'Boston', 'MA', '02101', 'USA'),
('Maria', 'Garcia', 'maria.garcia@email.com', '555-2003', '789 Pine Rd', 'Miami', 'FL', '33101', 'USA'),
('James', 'Lee', 'james.lee@email.com', '555-2004', '321 Elm St', 'San Francisco', 'CA', '94101', 'USA'),
('Anna', 'Petrov', 'anna.petrov@email.com', '555-2005', '654 Birch Blvd', 'New York', 'NY', '10001', 'USA'),
('Carlos', 'Rodriguez', 'carlos.rodriguez@email.com', '555-2006', '987 Maple Dr', 'Los Angeles', 'CA', '90001', 'USA'),
('Sophie', 'Martin', 'sophie.martin@email.com', '555-2007', '147 Cedar Ln', 'Chicago', 'IL', '60601', 'USA'),
('Ahmed', 'Hassan', 'ahmed.hassan@email.com', '555-2008', '258 Spruce Way', 'Houston', 'TX', '77001', 'USA');

-- Orders
INSERT INTO orders (customer_id, employee_id, order_date, required_date, ship_name, ship_address, ship_city, ship_state, ship_postal_code, ship_country, freight, total_amount, status) VALUES
(1, 1, '2024-01-15', '2024-01-20', 'Jane Austin', '123 Main St', 'Seattle', 'WA', '98101', 'USA', 15.50, 1349.48, 'Delivered'),
(2, 6, '2024-01-16', '2024-01-21', 'Tom Brady', '456 Oak Ave', 'Boston', 'MA', '02101', 'USA', 12.00, 339.97, 'Shipped'),
(3, 1, '2024-01-17', '2024-01-22', 'Maria Garcia', '789 Pine Rd', 'Miami', 'FL', '33101', 'USA', 18.75, 449.97, 'Processing'),
(4, 7, '2024-01-18', '2024-01-23', 'James Lee', '321 Elm St', 'San Francisco', 'CA', '94101', 'USA', 10.00, 1419.96, 'Pending'),
(5, 2, '2024-01-19', '2024-01-24', 'Anna Petrov', '654 Birch Blvd', 'New York', 'NY', '10001', 'USA', 25.00, 649.95, 'Delivered'),
(6, 6, '2024-01-20', '2024-01-25', 'Carlos Rodriguez', '987 Maple Dr', 'Los Angeles', 'CA', '90001', 'USA', 20.00, 829.94, 'Shipped'),
(7, 1, '2024-01-21', '2024-01-26', 'Sophie Martin', '147 Cedar Ln', 'Chicago', 'IL', '60601', 'USA', 15.00, 309.98, 'Processing'),
(8, 7, '2024-01-22', '2024-01-27', 'Ahmed Hassan', '258 Spruce Way', 'Houston', 'TX', '77001', 'USA', 22.50, 739.96, 'Pending');

-- Order Items
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES
(1, 1, 1, 1299.99, 0),  -- Laptop Pro 15"
(1, 4, 2, 19.99, 5),     -- USB-C Cable with 5% discount
(1, 8, 1, 59.99, 0),     -- Wireless Keyboard
(2, 3, 1, 249.99, 10),   -- Office Chair with 10% discount
(2, 9, 1, 349.99, 10),   -- Monitor 27" with 10% discount
(3, 5, 1, 399.99, 0),    -- Standing Desk
(3, 7, 1, 299.99, 0),    -- Office Printer
(4, 1, 1, 1299.99, 0),   -- Laptop Pro 15"
(4, 2, 4, 29.99, 0),     -- Wireless Mouse
(5, 6, 2, 89.99, 0),     -- Network Switch
(5, 10, 5, 99.99, 0),    -- Office Software Suite
(6, 5, 2, 399.99, 0),    -- Standing Desk
(6, 3, 1, 249.99, 0),    -- Office Chair
(7, 8, 2, 59.99, 0),     -- Wireless Keyboard
(7, 4, 5, 19.99, 0),     -- USB-C Cable
(8, 1, 1, 1299.99, 0),   -- Laptop Pro 15"
(8, 9, 2, 349.99, 0),    -- Monitor 27"
(8, 2, 3, 29.99, 0);     -- Wireless Mouse

-- Update order total amounts based on order items
UPDATE orders o 
SET total_amount = (
    SELECT SUM(quantity * unit_price * (1 - discount/100))
    FROM order_items oi
    WHERE oi.order_id = o.order_id
);

-- Create indexes for better performance
CREATE INDEX idx_employee_department ON employees(department_id);
CREATE INDEX idx_product_category ON products(category_id);
CREATE INDEX idx_product_supplier ON products(supplier_id);
CREATE INDEX idx_order_customer ON orders(customer_id);
CREATE INDEX idx_order_employee ON orders(employee_id);
CREATE INDEX idx_order_item_order ON order_items(order_id);
CREATE INDEX idx_order_item_product ON order_items(product_id);

-- Create views for common queries
CREATE VIEW order_summary AS
SELECT 
    o.order_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    e.first_name || ' ' || e.last_name AS employee_name,
    o.order_date,
    o.status,
    o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN employees e ON o.employee_id = e.employee_id;

CREATE VIEW product_inventory AS
SELECT 
    p.product_id,
    p.product_name,
    c.category_name,
    s.company_name AS supplier_name,
    p.price,
    p.stock_quantity,
    CASE 
        WHEN p.stock_quantity < 10 THEN 'Low Stock'
        WHEN p.stock_quantity < 50 THEN 'Medium Stock'
        ELSE 'Good Stock'
    END AS stock_status
FROM products p
JOIN categories c ON p.category_id = c.category_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE p.discontinued = FALSE;

-- Display sample data
SELECT '=== DEPARTMENTS ===' AS info;
SELECT * FROM departments;

SELECT '=== EMPLOYEES ===' AS info;
SELECT employee_id, first_name, last_name, email, department_id, manager_id FROM employees;

SELECT '=== CUSTOMERS ===' AS info;
SELECT customer_id, first_name, last_name, email, city, country FROM customers;

SELECT '=== PRODUCTS ===' AS info;
SELECT product_id, product_name, price, stock_quantity, category_id, supplier_id FROM products;

SELECT '=== ORDERS ===' AS info;
SELECT * FROM order_summary LIMIT 5;

SELECT '=== PRODUCT INVENTORY ===' AS info;
SELECT * FROM product_inventory LIMIT 5;