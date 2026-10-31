-- 1. View to display customer details
USE customer_lead_management;

CREATE VIEW customer_details_view AS
SELECT
    customer_id,
    customer_name,
    phone,
    email,
    segment,
    created_at
FROM customers;
SELECT * FROM customer_details_view;
-- 2. View to display lead details
CREATE VIEW lead_details_view AS
SELECT
    lead_id,
    lead_name,
    phone,
    email,
    source,
    status,
    created_at
FROM leads;
SELECT * FROM lead_details_view;
-- 3. View to display leads with assigned employees
CREATE VIEW lead_employee_view AS
SELECT
    l.lead_id,
    l.lead_name,
    l.status,
    l.source,
    u.user_name AS assigned_employee
FROM leads l
LEFT JOIN users u
ON l.assigned_to = u.user_id;
SELECT * FROM lead_employee_view;
-- 4. View to display converted leads
CREATE VIEW converted_leads_view AS
SELECT
    l.lead_id,
    l.lead_name,
    l.status,
    c.customer_id,
    c.customer_name,
    c.segment
FROM leads l
INNER JOIN customers c
ON l.customer_id = c.customer_id
WHERE l.status = 'Converted';
SELECT * FROM converted_leads_view;
-- 5. View to display pending follow-ups
CREATE VIEW pending_followups_view AS
SELECT
    f.follow_up_id,
    l.lead_name,
    u.user_name AS assigned_employee,
    f.due_date,
    f.status,
    f.notes
FROM follow_ups f
INNER JOIN leads l
ON f.lead_id = l.lead_id
INNER JOIN users u
ON f.assigned_to = u.user_id
WHERE f.status = 'Pending';
SELECT * FROM pending_followups_view;
-- 6. View to display interaction history
CREATE VIEW interaction_history_view AS
SELECT
    i.interaction_id,
    l.lead_name,
    u.user_name AS employee_name,
    i.interaction_type,
    i.notes,
    i.interaction_date
FROM interactions i
INNER JOIN leads l
ON i.lead_id = l.lead_id
INNER JOIN users u
ON i.user_id = u.user_id;
SELECT * FROM interaction_history_view
-- 7. View to display lead status history
CREATE VIEW lead_status_view AS
SELECT
    h.history_id,
    l.lead_name,
    h.old_status,
    h.new_status,
    u.user_name AS changed_by,
    h.changed_at
FROM lead_status_history h
INNER JOIN leads l
ON h.lead_id = l.lead_id
INNER JOIN users u
ON h.changed_by = u.user_id;
SELECT * FROM lead_status_view;
-- 8. View to display employee-wise lead count
CREATE VIEW employee_lead_count_view AS
SELECT
    u.user_id,
    u.user_name,
    u.role,
    COUNT(l.lead_id) AS total_leads
FROM users u
LEFT JOIN leads l
ON u.user_id = l.assigned_to
GROUP BY
    u.user_id,
    u.user_name,
    u.role;
 SELECT * FROM employee_lead_count_view;   
 -- 9. View to display lead status summary
 CREATE VIEW lead_status_summary_view AS
SELECT
    status,
    COUNT(*) AS total_leads
FROM leads
GROUP BY status;
SELECT * FROM lead_status_summary_view;
-- 10. View to display monthly lead reports
CREATE VIEW monthly_lead_report_view AS
SELECT
    YEAR(created_at) AS lead_year,
    MONTH(created_at) AS lead_month,
    COUNT(*) AS total_leads
FROM leads
GROUP BY
    YEAR(created_at),
    MONTH(created_at);
SELECT * FROM monthly_lead_report_view;
-- 11. Check all created views
SHOW FULL TABLES
WHERE Table_type = 'VIEW';
DESCRIBE lead_employee_view;
SELECT * FROM lead_employee_view;
