-- MariaDB Business Database - Useful JOIN Queries
-- This file contains practical queries that join tables to get meaningful business insights

-- ========================================
-- EMPLOYEE & DEPARTMENT QUERIES
-- ========================================

-- Query 1: Get all employees with their department information
-- Purpose: Shows complete employee directory with departmental context
-- Use Case: HR reports, organizational charts, contact directories
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.email,
    e.phone_number,
    d.department_name,
    d.location
FROM employees e
JOIN departments d ON e.department_id = d.department_id
ORDER BY d.department_name, e.last_name;

-- Query 2: Get employees with their managers
-- Purpose: Shows organizational hierarchy and reporting structure
-- Use Case: Management reporting, team structure analysis
SELECT
    CONCAT(emp.first_name, ' ', emp.last_name) AS employee_name,
    CONCAT(mgr.first_name, ' ', mgr.last_name) AS manager_name,
    d.department_name
FROM employees emp
LEFT JOIN employees mgr ON emp.manager_id = mgr.employee_id
JOIN departments d ON emp.department_id = d.department_id
ORDER BY d.department_name, emp.last_name;

-- Query 3: Department employee count and salary statistics
-- Purpose: Provides department-level workforce analytics and budget overview
-- Use Case: Budget planning, department performance analysis
SELECT
    d.department_name,
    d.location,
    COUNT(e.employee_id) AS employee_count,
    AVG(e.salary) AS avg_salary,
    MIN(e.salary) AS min_salary,
    MAX(e.salary) AS max_salary
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name, d.location
ORDER BY employee_count DESC;

-- ========================================
-- CUSTOMER & ORDER QUERIES
-- ========================================

-- Query 4: Get customers with their order history
-- Purpose: Complete customer transaction history with order details
-- Use Case: Customer service, order tracking, sales analysis
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    c.city,
    c.state,
    o.order_id,
    o.order_date,
    o.status,
    o.total_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.last_name, o.order_date DESC;

-- Query 5: Customer order statistics and lifetime value
-- Purpose: Analyzes customer purchasing behavior and identifies high-value customers
-- Use Case: Customer segmentation, loyalty programs, marketing campaigns
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    AVG(o.total_amount) AS avg_order_value,
    MAX(o.order_date) AS last_order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
ORDER BY total_spent DESC;

-- Query 6: Top customers by revenue (completed orders only)
-- Purpose: Identifies most valuable customers based on completed transactions
-- Use Case: VIP customer identification, revenue analysis
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.city,
    c.state,
    SUM(o.total_amount) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY c.customer_id, c.first_name, c.last_name, c.city, c.state
ORDER BY total_revenue DESC
LIMIT 10;

-- ========================================
-- PRODUCT, CATEGORY & SUPPLIER QUERIES
-- ========================================

-- Query 7: Products with category and supplier information
-- Purpose: Complete product catalog with sourcing and classification details
-- Use Case: Inventory management, vendor analysis, product categorization
SELECT
    p.product_id,
    p.product_name,
    p.price,
    p.stock_quantity,
    cat.category_name,
    s.company_name AS supplier_name,
    s.contact_name AS supplier_contact,
    CASE
        WHEN p.stock_quantity < 10 THEN 'Low Stock'
        WHEN p.stock_quantity < 50 THEN 'Medium Stock'
        ELSE 'Good Stock'
    END AS stock_status
FROM products p
JOIN categories cat ON p.category_id = cat.category_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE p.discontinued = FALSE
ORDER BY cat.category_name, p.product_name;

-- Query 8: Product sales performance analysis
-- Purpose: Measures product success through sales volume and revenue
-- Use Case: Product optimization, inventory planning, sales reporting
SELECT
    p.product_name,
    cat.category_name,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.line_total) AS total_revenue,
    AVG(oi.unit_price) AS avg_selling_price,
    COUNT(DISTINCT oi.order_id) AS orders_count
FROM products p
JOIN categories cat ON p.category_id = cat.category_id
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, cat.category_name
ORDER BY total_revenue DESC;

-- Query 9: Category performance summary
-- Purpose: Evaluates category-level business performance and inventory health
-- Use Case: Category management, inventory allocation, business strategy
SELECT
    cat.category_name,
    COUNT(p.product_id) AS products_count,
    SUM(p.stock_quantity) AS total_inventory,
    AVG(p.price) AS avg_price,
    COALESCE(SUM(oi.quantity), 0) AS total_units_sold,
    COALESCE(SUM(oi.line_total), 0) AS total_revenue
FROM categories cat
LEFT JOIN products p ON cat.category_id = p.category_id AND p.discontinued = FALSE
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY cat.category_id, cat.category_name
ORDER BY total_revenue DESC;

-- ========================================
-- COMPREHENSIVE ORDER ANALYSIS
-- ========================================

-- Query 10: Complete order details with all related information
-- Purpose: Provides full order context including customer, employee, and product details
-- Use Case: Order fulfillment, customer service, detailed reporting
SELECT
    o.order_id,
    o.order_date,
    o.status,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email AS customer_email,
    c.city AS customer_city,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    d.department_name,
    p.product_name,
    cat.category_name,
    oi.quantity,
    oi.unit_price,
    oi.discount,
    oi.line_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN employees e ON o.employee_id = e.employee_id
LEFT JOIN departments d ON e.department_id = d.department_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
ORDER BY o.order_date DESC, o.order_id, oi.order_item_id;

-- Query 11: Employee sales performance metrics
-- Purpose: Evaluates employee performance in sales processing and customer management
-- Use Case: Performance reviews, sales team analysis, commission calculations
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    d.department_name,
    COUNT(DISTINCT o.order_id) AS orders_handled,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(o.total_amount) AS total_sales,
    AVG(o.total_amount) AS avg_order_value
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN orders o ON e.employee_id = o.employee_id
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY e.employee_id, e.first_name, e.last_name, d.department_name
ORDER BY total_sales DESC;

-- ========================================
-- BUSINESS INSIGHTS QUERIES
-- ========================================

-- Query 12: Monthly sales trends and patterns
-- Purpose: Tracks business performance over time to identify seasonal patterns
-- Use Case: Financial reporting, trend analysis, forecasting
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    COUNT(o.order_id) AS orders_count,
    SUM(o.total_amount) AS total_revenue,
    AVG(o.total_amount) AS avg_order_value,
    COUNT(DISTINCT o.customer_id) AS unique_customers
FROM orders o
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month DESC;

-- Query 13: Supplier performance analysis
-- Purpose: Evaluates supplier contribution to business through product performance
-- Use Case: Vendor management, procurement decisions, supplier negotiations
SELECT
    s.company_name AS supplier_name,
    s.contact_name,
    s.country,
    COUNT(p.product_id) AS products_supplied,
    SUM(p.stock_quantity) AS total_inventory,
    COALESCE(SUM(oi.quantity), 0) AS units_sold,
    COALESCE(SUM(oi.line_total), 0) AS revenue_generated
FROM suppliers s
LEFT JOIN products p ON s.supplier_id = p.supplier_id AND p.discontinued = FALSE
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY s.supplier_id, s.company_name, s.contact_name, s.country
ORDER BY revenue_generated DESC;

-- Query 14: Cross-selling analysis (products frequently bought together)
-- Purpose: Identifies product combinations for cross-selling and bundling opportunities
-- Use Case: Marketing campaigns, product bundling, upselling strategies
SELECT
    p1.product_name AS product1,
    p2.product_name AS product2,
    COUNT(*) as times_bought_together
FROM order_items oi1
JOIN order_items oi2 ON oi1.order_id = oi2.order_id AND oi1.product_id < oi2.product_id
JOIN products p1 ON oi1.product_id = p1.product_id
JOIN products p2 ON oi2.product_id = p2.product_id
GROUP BY p1.product_id, p1.product_name, p2.product_id, p2.product_name
HAVING times_bought_together > 1
ORDER BY times_bought_together DESC
LIMIT 20;

-- Query 15: Customer geographic distribution with sales
-- Purpose: Analyzes customer base and sales performance by geographic location
-- Use Case: Market analysis, regional performance, expansion planning
SELECT
    c.state,
    c.country,
    COUNT(DISTINCT c.customer_id) AS customer_count,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_revenue
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.state, c.country
ORDER BY total_revenue DESC;

-- ========================================
-- INVENTORY AND STOCK ANALYSIS
-- ========================================

-- Query 16: Low stock products with supplier contact information
-- Purpose: Identifies products needing reorder with supplier contact details for procurement
-- Use Case: Inventory replenishment, supplier communication, stock management
SELECT
    p.product_name,
    cat.category_name,
    p.stock_quantity,
    p.price,
    s.company_name AS supplier_name,
    s.contact_name,
    s.contact_email,
    s.phone
FROM products p
JOIN categories cat ON p.category_id = cat.category_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE p.stock_quantity < 20 AND p.discontinued = FALSE
ORDER BY p.stock_quantity ASC;

-- Query 17: Product turnover rate (sales velocity vs current inventory)
-- Purpose: Measures how quickly products sell relative to current stock levels
-- Use Case: Inventory optimization, reorder planning, product performance analysis
SELECT
    p.product_name,
    cat.category_name,
    p.stock_quantity AS current_stock,
    COALESCE(SUM(oi.quantity), 0) AS total_sold,
    CASE
        WHEN p.stock_quantity > 0 THEN ROUND(COALESCE(SUM(oi.quantity), 0) / p.stock_quantity, 2)
        ELSE 0
    END AS turnover_ratio
FROM products p
JOIN categories cat ON p.category_id = cat.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE p.discontinued = FALSE
GROUP BY p.product_id, p.product_name, cat.category_name, p.stock_quantity
ORDER BY turnover_ratio DESC;
