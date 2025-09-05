# Business Database Structure Documentation

## Overview
This document describes the structure and design of a comprehensive business database that models a typical e-commerce/retail business with inventory management, sales processing, and customer relationship management.

## Database Architecture

### Core Entities
The database consists of 8 main tables organized into logical groups:

#### 1. **Organizational Structure**
- **departments**: Company departments and their management structure
- **employees**: Staff information with hierarchical relationships

#### 2. **Product Management**
- **suppliers**: Vendor/Supplier information
- **categories**: Product categorization system
- **products**: Product catalog with inventory tracking

#### 3. **Customer & Sales**
- **customers**: Customer information and contact details
- **orders**: Sales transactions and order processing
- **order_items**: Detailed line items for each order

## Table Details

### Departments Table
**Purpose**: Organizational structure and department management

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| department_id | INT PK | Unique identifier | AUTO_INCREMENT |
| department_name | VARCHAR(50) | Department name | NOT NULL |
| manager_id | INT | Manager's employee ID | FK to employees |
| location | VARCHAR(100) | Office location | - |
| created_at | TIMESTAMP | Creation timestamp | DEFAULT NOW() |

**Relationships**:
- Self-referencing through manager_id (employee who manages the department)

### Employees Table
**Purpose**: Staff information with hierarchical management structure

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| employee_id | INT PK | Unique identifier | AUTO_INCREMENT |
| first_name | VARCHAR(50) | First name | NOT NULL |
| last_name | VARCHAR(50) | Last name | NOT NULL |
| email | VARCHAR(100) | Email address | UNIQUE |
| phone | VARCHAR(20) | Contact number | - |
| hire_date | DATE | Employment start | NOT NULL |
| salary | DECIMAL(10,2) | Annual salary | - |
| department_id | INT | Assigned department | FK to departments |
| manager_id | INT | Direct manager | FK to employees (self) |

**Relationships**:
- Many-to-one with departments (many employees per department)
- Self-referencing hierarchy (manager-subordinate relationships)

### Suppliers Table
**Purpose**: Vendor and supplier information management

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| supplier_id | INT PK | Unique identifier | AUTO_INCREMENT |
| company_name | VARCHAR(100) | Supplier company name | NOT NULL |
| contact_name | VARCHAR(50) | Primary contact person | - |
| contact_email | VARCHAR(100) | Contact email | - |
| phone | VARCHAR(20) | Contact phone | - |
| address | VARCHAR(200) | Business address | - |
| city | VARCHAR(50) | City | - |
| country | VARCHAR(50) | Country | - |
| created_at | TIMESTAMP | Creation timestamp | DEFAULT NOW() |

### Categories Table
**Purpose**: Product categorization for organization and reporting

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| category_id | INT PK | Unique identifier | AUTO_INCREMENT |
| category_name | VARCHAR(50) | Category name | NOT NULL |
| description | TEXT | Category description | - |
| created_at | TIMESTAMP | Creation timestamp | DEFAULT NOW() |

### Products Table
**Purpose**: Product catalog with inventory management

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| product_id | INT PK | Unique identifier | AUTO_INCREMENT |
| product_name | VARCHAR(100) | Product name | NOT NULL |
| description | TEXT | Product description | - |
| price | DECIMAL(10,2) | Unit price | NOT NULL |
| stock_quantity | INT | Current inventory | DEFAULT 0 |
| category_id | INT | Product category | FK to categories |
| supplier_id | INT | Primary supplier | FK to suppliers |
| discontinued | BOOLEAN | Discontinued flag | DEFAULT FALSE |
| created_at | TIMESTAMP | Creation timestamp | DEFAULT NOW() |

**Relationships**:
- Many-to-one with categories (products belong to categories)
- Many-to-one with suppliers (products sourced from suppliers)

### Customers Table
**Purpose**: Customer information and contact management

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| customer_id | INT PK | Unique identifier | AUTO_INCREMENT |
| first_name | VARCHAR(50) | First name | NOT NULL |
| last_name | VARCHAR(50) | Last name | NOT NULL |
| email | VARCHAR(100) | Email address | UNIQUE |
| phone | VARCHAR(20) | Contact phone | - |
| address | VARCHAR(200) | Street address | - |
| city | VARCHAR(50) | City | - |
| state | VARCHAR(50) | State/Province | - |
| postal_code | VARCHAR(20) | ZIP/Postal code | - |
| country | VARCHAR(50) | Country | - |
| registration_date | DATE | Customer since | DEFAULT CURRENT_DATE |

### Orders Table
**Purpose**: Sales transactions and order processing

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| order_id | INT PK | Unique identifier | AUTO_INCREMENT |
| customer_id | INT | Customer who placed order | FK to customers |
| employee_id | INT | Employee who processed order | FK to employees |
| order_date | DATE | Order placement date | DEFAULT CURRENT_DATE |
| required_date | DATE | Customer required delivery | - |
| shipped_date | DATE | Actual shipment date | - |
| ship_name | VARCHAR(100) | Shipping recipient name | - |
| ship_address | VARCHAR(200) | Shipping street address | - |
| ship_city | VARCHAR(50) | Shipping city | - |
| ship_state | VARCHAR(50) | Shipping state | - |
| ship_postal_code | VARCHAR(20) | Shipping ZIP code | - |
| ship_country | VARCHAR(50) | Shipping country | - |
| freight | DECIMAL(10,2) | Shipping cost | DEFAULT 0 |
| total_amount | DECIMAL(10,2) | Order total (calculated) | - |
| status | ENUM | Order status | DEFAULT 'Pending' |

**Status Values**: 'Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'

### Order_Items Table
**Purpose**: Detailed line items for each order

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| order_item_id | INT PK | Unique identifier | AUTO_INCREMENT |
| order_id | INT | Parent order | FK to orders |
| product_id | INT | Product being ordered | FK to products |
| quantity | INT | Quantity ordered | NOT NULL |
| unit_price | DECIMAL(10,2) | Price per unit at order time | NOT NULL |
| discount | DECIMAL(5,2) | Discount percentage | DEFAULT 0 |
| line_total | DECIMAL(10,2) | Calculated line total | GENERATED |

**Generated Column**: `line_total = quantity * unit_price * (1 - discount/100)`

## Relationship Diagram

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   departments   │    │   employees     │    │   suppliers     │
│  (manager_id)   │◄───┤  (manager_id)   │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │                        │
                                │                        │
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   customers     │    │     orders      │    │   categories    │
│                 │◄───┤  (customer_id)  │    │                 │
│                 │    │  (employee_id)  │◄───┤                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                │
                    ┌─────────────────┐
                    │  order_items    │
                    │   (order_id)    │◄───┐
                    │  (product_id)   │    │
                    └─────────────────┘    │
                                        ┌─────────────────┐
                                        │    products     │
                                        │  (category_id)  │◄───┐
                                        │  (supplier_id)  │    │
                                        └─────────────────┘    │
                                                            ┌─────────────────┐
                                                            │   suppliers     │
                                                            └─────────────────┘
```

## Design Decisions

### 1. **Hierarchical Relationships**
- **Employees**: Self-referencing for manager-subordinate relationships
- **Departments**: Linked to employee managers for department leadership

### 2. **Data Integrity**
- **Foreign Keys**: All relationships enforced with proper foreign keys
- **Unique Constraints**: Email addresses for employees and customers
- **Check Constraints**: Order status limited to predefined values
- **Generated Columns**: Automatic calculation of line totals and order totals

### 3. **Audit Trail**
- **Timestamps**: Created_at fields for all major entities
- **Historical Pricing**: Order items store price at time of order
- **Status Tracking**: Order status progression tracking

### 4. **Scalability Features**
- **Indexes**: Strategic indexes on foreign keys and frequently queried columns
- **Views**: Pre-built views for common reporting needs
- **Flexible Addressing**: Separate shipping addresses from customer addresses

## Usage Patterns

### Common Queries

#### 1. **Sales Analytics**
```sql
-- Monthly sales by category
SELECT
    c.category_name,
    DATE_FORMAT(o.order_date, '%Y-%m') as month,
    SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100)) as revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
WHERE o.status IN ('Shipped', 'Delivered')
GROUP BY c.category_name, month
ORDER BY month, revenue DESC;
```

#### 2. **Inventory Management**
```sql
-- Low stock alerts
SELECT
    p.product_name,
    p.stock_quantity,
    s.company_name as supplier,
    c.category_name
FROM products p
JOIN suppliers s ON p.supplier_id = s.supplier_id
JOIN categories c ON p.category_id = c.category_id
WHERE p.stock_quantity < 20 AND p.discontinued = FALSE
ORDER BY p.stock_quantity ASC;
```

#### 3. **Customer Analysis**
```sql
-- Top customers by revenue
SELECT
    c.first_name || ' ' || c.last_name as customer_name,
    c.email,
    SUM(o.total_amount) as total_revenue,
    COUNT(o.order_id) as order_count,
    AVG(o.total_amount) as avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status IN ('Shipped', 'Delivered')
GROUP BY c.customer_id
ORDER BY total_revenue DESC
LIMIT 10;
```

### Performance Optimizations

#### 1. **Indexes Created**
- `idx_employee_department`: For department-based employee queries
- `idx_product_category`: For category-based product filtering
- `idx_product_supplier`: For supplier-based product queries
- `idx_order_customer`: For customer order history
- `idx_order_employee`: For employee sales tracking
- `idx_order_item_order`: For order detail queries
- `idx_order_item_product`: For product sales analysis

#### 2. **Views for Common Reports**
- **order_summary**: Simplified order information with customer and employee names
- **product_inventory**: Enhanced product view with stock status indicators

## Data Flow

### Order Processing Flow
1. **Customer** places an **Order** (status: 'Pending')
2. **Employee** processes the order (status: 'Processing')
3. **Order** is shipped (status: 'Shipped')
4. **Customer** receives order (status: 'Delivered')

### Inventory Impact
- **Order creation**: Validates stock availability
- **Order fulfillment**: Decrements product stock_quantity
- **Returns processing**: Increments product stock_quantity (manual process)

### Financial Calculations
- **Line totals**: Automatically calculated based on quantity × price × discount
- **Order totals**: Sum of all line items plus freight
- **Revenue reporting**: Based on shipped/delivered orders only

## Maintenance Considerations

### Regular Tasks
- **Stock replenishment**: Monitor low stock alerts
- **Order cleanup**: Archive cancelled orders
- **Customer updates**: Maintain current contact information
- **Pricing updates**: Historical pricing preserved in order items

### Data Retention
- **Active products**: Marked as discontinued rather than deleted
- **Order history**: Maintained indefinitely for reporting
- **Customer data**: Soft delete capability for GDPR compliance

### Backup Strategy
- **Daily incremental**: Transaction logs
- **Weekly full**: Complete database backup
- **Monthly archive**: Historical data to cold storage

This database structure provides a robust foundation for a business management system with proper normalization, data integrity, and scalability considerations.
