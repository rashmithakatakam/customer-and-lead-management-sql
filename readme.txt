# Customer and Lead Management System

## 1. Project Overview

The Customer and Lead Management System is a database project developed using MySQL.

The main purpose of this project is to manage customer information, track potential leads, assign leads to employees, record customer interactions, monitor follow-up activities, and maintain lead status history.

The project demonstrates SQL concepts ranging from basic database operations to advanced database management techniques.

## 2. Project Objectives

- Store and manage customer information.
- Register and track potential leads.
- Assign leads to employees.
- Monitor lead statuses such as New, Contacted, Qualified, Converted, and Lost.
- Record interactions through calls, emails, and meetings.
- Schedule and manage follow-up activities.
- Maintain lead status history.
- Generate business reports.
- Improve database performance using indexes.
- Maintain data consistency using constraints, triggers, and transactions.

## 3. Technologies Used

- **Database:** MySQL
- **Database Tool:** MySQL Workbench
- **Language:** SQL
- **Database Design:** Relational Database Management System (RDBMS)

## 4. Database Structure

Database Name: `customer_lead_management`

The database contains six tables.

### 1. users

Stores employee details.

Columns:
- user_id (Primary Key)
- user_name
- email
- role
- created_at

### 2. customers

Stores registered customer information.

Columns:
- customer_id (Primary Key)
- customer_name
- phone
- email
- segment
- created_at

### 3. leads

Stores information about potential customers.

Columns:
- lead_id (Primary Key)
- lead_name
- phone
- email
- source
- status
- assigned_to (Foreign Key)
- customer_id (Foreign Key)
- created_at

### 4. interactions

Records communications with leads.

Columns:
- interaction_id (Primary Key)
- lead_id (Foreign Key)
- user_id (Foreign Key)
- interaction_type
- notes
- interaction_date

### 5. lead_status_history

Tracks changes in lead statuses.

Columns:
- history_id (Primary Key)
- lead_id (Foreign Key)
- old_status
- new_status
- changed_by (Foreign Key)
- changed_at

### 6. follow_ups

Stores scheduled follow-up activities.

Columns:
- follow_up_id (Primary Key)
- lead_id (Foreign Key)
- assigned_to (Foreign Key)
- due_date
- status
- notes

## 5. SQL Concepts Implemented

### Basic SQL

- CREATE DATABASE
- CREATE TABLE
- INSERT
- SELECT
- UPDATE
- DELETE
- WHERE
- ORDER BY
- DISTINCT
- LIMIT

### Intermediate SQL

- Aggregate Functions
- GROUP BY
- HAVING
- INNER JOIN
- LEFT JOIN
- RIGHT JOIN
- Subqueries
- CASE
- COALESCE
- UNION

### Advanced SQL

- Views
- Stored Procedures
- Stored Functions
- Triggers
- Indexes
- Transactions
- COMMIT
- ROLLBACK
- SAVEPOINT
- EXPLAIN

## 6. Main Features

**Customer Management:** Stores customer details and classifies customers into Premium and Regular segments.

**Lead Management:** Registers leads, assigns employees, and tracks lead status.

**Interaction Management:** Maintains communication records for calls, emails, and meetings.

**Follow-Up Management:** Schedules follow-ups and tracks pending, completed, and cancelled activities.

**Lead Conversion:** Converts qualified leads into registered customers.

**Status History:** Maintains records of changes in lead status.

**Business Reporting:** Generates reports on lead conversion, customer segmentation, employee performance, and follow-up activities.

## 7. Business Reports

The project includes reports for:

1. Total customers
2. Total leads
3. Lead status summary
4. Lead conversion rate
5. Monthly lead registrations
6. Monthly customer registrations
7. Employee-wise assigned leads
8. Employee-wise converted leads
9. Lead source performance
10. Pending follow-ups
11. Overdue follow-ups
12. Customer segmentation
13. Interaction types
14. Leads with the most interactions
15. Overall business summary

## 8. Database Normalization

The database is designed using First Normal Form (1NF), Second Normal Form (2NF), and Third Normal Form (3NF) principles.

Related information is organized into separate tables to reduce unnecessary duplication and improve consistency.

Primary keys uniquely identify records, while foreign keys establish relationships between tables.

## 9. Project Folder Structure

```text
Customer_Lead_Management_System/
|
|-- database/
|   |-- 01_create_database.sql
|   |-- 02_create_tables.sql
|   |-- 03_insert_data.sql
|   |-- 04_queries.sql
|   |-- 05_views.sql
|   |-- 06_procedures.sql
|   |-- 07_functions.sql
|   |-- 08_triggers.sql
|   |-- 09_indexes.sql
|   |-- 10_transactions.sql
|   |-- 11_business_reports.sql
|
|-- documentation/
|   |-- requirements.md
|   |-- database-design.md
|   |-- er-diagram.md
|   |-- ER_Diagram.txt
|
|-- README.md
```

## 10. How to Run the Project

1. Install MySQL Server and MySQL Workbench.
2. Open MySQL Workbench and connect to the server.
3. Execute `01_create_database.sql`.
4. Execute `02_create_tables.sql`.
5. Execute `03_insert_data.sql`.
6. Execute the SQL queries and create the views.
7. Create the stored procedures and functions.
8. Create the triggers.
9. Create the indexes.
10. Execute transaction examples carefully.
11. Run the business reporting queries.
12. Verify the database structure and results.

**Note:** Some transaction scripts modify data, and some procedures insert records. Run these examples individually rather than repeatedly executing the entire file.

## 11. Sample SQL Queries

### Display all customers

```sql
SELECT * FROM customers;
```

### Display all leads

```sql
SELECT * FROM leads;
```

### Display converted leads

```sql
SELECT *
FROM leads
WHERE status = 'Converted';
```

### Count leads by status

```sql
SELECT status, COUNT(*) AS total_leads
FROM leads
GROUP BY status;
```

### Display assigned employees

```sql
SELECT
    l.lead_name,
    u.user_name AS employee_name
FROM leads l
JOIN users u
    ON l.assigned_to = u.user_id;
```

## 12. Project Benefits

- Centralized customer and lead information
- Improved lead tracking
- Organized employee assignments
- Better follow-up management
- Automated status tracking
- Reduced data duplication
- Useful business reports
- Improved data integrity

## 13. Future Enhancements

- Python and MySQL integration
- User authentication and role-based access
- Web-based dashboard
- Automated follow-up reminders
- Power BI dashboard integration
- Advanced reporting and analytics

## 14. Conclusion

The Customer and Lead Management System demonstrates how MySQL can be used to build a structured database application for managing customers, leads, interactions, and follow-ups.

The project covers fundamental and advanced SQL concepts, including joins, subqueries, views, stored procedures, functions, triggers, indexes, and transactions.

It provides practical experience in relational database design, data integrity, business reporting, and SQL query optimization.