USE customer_lead_management;
-- 1. Total customers report
SELECT
    COUNT(*) AS total_customers
FROM customers;
-- 2. Total leads report
SELECT
    COUNT(*) AS total_leads
FROM leads;
-- 3. Lead status summary report
SELECT
    status,
    COUNT(*) AS total_leads
FROM leads
GROUP BY status
ORDER BY total_leads DESC;
-- 4. Lead conversion rate report
SELECT
    COUNT(*) AS total_leads,
    SUM(CASE
        WHEN status = 'Converted' THEN 1
        ELSE 0
    END) AS converted_leads,
    COALESCE(
        ROUND(
            SUM(CASE
                WHEN status = 'Converted' THEN 1
                ELSE 0
            END) * 100.0 / NULLIF(COUNT(*), 0),
            2
        ),
        0
    ) AS conversion_rate
FROM leads;
-- 5. Monthly lead registration report
SELECT
    DATE_FORMAT(created_at, '%Y-%m') AS month,
    COUNT(*) AS total_leads
FROM leads
GROUP BY DATE_FORMAT(created_at, '%Y-%m')
ORDER BY month;
-- 6. Monthly customer registration report
SELECT
    DATE_FORMAT(created_at, '%Y-%m') AS month,
    COUNT(*) AS total_customers
FROM customers
GROUP BY DATE_FORMAT(created_at, '%Y-%m')
ORDER BY month;
-- 7. Employee-wise lead performance report
SELECT
    u.user_id,
    u.user_name,
    COUNT(l.lead_id) AS assigned_leads
FROM users u
LEFT JOIN leads l
    ON u.user_id = l.assigned_to
GROUP BY u.user_id, u.user_name
ORDER BY assigned_leads DESC;
-- 8. Employee-wise lead conversion report
SELECT
    u.user_name,
    COUNT(l.lead_id) AS total_leads,
    SUM(CASE
        WHEN l.status = 'Converted' THEN 1
        ELSE 0
    END) AS converted_leads
FROM users u
LEFT JOIN leads l
    ON u.user_id = l.assigned_to
GROUP BY u.user_id, u.user_name
ORDER BY converted_leads DESC;
-- 9. Lead source performance report
SELECT
    COALESCE(source, 'Unknown') AS lead_source,
    COUNT(*) AS total_leads,
    SUM(CASE
        WHEN status = 'Converted' THEN 1
        ELSE 0
    END) AS converted_leads
FROM leads
GROUP BY source
ORDER BY total_leads DESC;
-- 10. Pending follow-ups report
SELECT
    f.follow_up_id,
    l.lead_name,
    u.user_name AS assigned_employee,
    f.due_date,
    f.status
FROM follow_ups f
INNER JOIN leads l
    ON f.lead_id = l.lead_id
INNER JOIN users u
    ON f.assigned_to = u.user_id
WHERE f.status = 'Pending'
ORDER BY f.due_date;
-- 11. Overdue follow-ups report
SELECT
    f.follow_up_id,
    l.lead_name,
    u.user_name AS assigned_employee,
    f.due_date,
    f.status
FROM follow_ups f
INNER JOIN leads l
    ON f.lead_id = l.lead_id
INNER JOIN users u
    ON f.assigned_to = u.user_id
WHERE f.status = 'Pending'
  AND f.due_date < NOW()
ORDER BY f.due_date;
-- 12. Customer segmentation report
SELECT
    segment,
    COUNT(*) AS total_customers
FROM customers
GROUP BY segment
ORDER BY total_customers DESC;
-- 13. Interaction type report
SELECT
    interaction_type,
    COUNT(*) AS total_interactions
FROM interactions
GROUP BY interaction_type
ORDER BY total_interactions DESC;
-- 14. Leads with the highest number of interactions
SELECT
    l.lead_id,
    l.lead_name,
    COUNT(i.interaction_id) AS total_interactions
FROM leads l
LEFT JOIN interactions i
    ON l.lead_id = i.lead_id
GROUP BY l.lead_id, l.lead_name
ORDER BY total_interactions DESC
LIMIT 5;
-- 15. Complete business summary report
SELECT
    (SELECT COUNT(*)
     FROM customers) AS total_customers,

    (SELECT COUNT(*)
     FROM leads) AS total_leads,

    (SELECT COUNT(*)
     FROM leads
     WHERE status = 'Converted') AS converted_leads,

    (SELECT COUNT(*)
     FROM users) AS total_employees,

    (SELECT COUNT(*)
     FROM interactions) AS total_interactions,

    (SELECT COUNT(*)
     FROM follow_ups
     WHERE status = 'Pending') AS pending_followups,

    (SELECT COUNT(*)
     FROM follow_ups
     WHERE status = 'Pending'
       AND due_date < NOW()) AS overdue_followups;
       -- Step 2: Create reusable report views
       -- View 1: Employee performance
       CREATE OR REPLACE VIEW employee_performance_report AS
SELECT
    u.user_id,
    u.user_name,
    COUNT(l.lead_id) AS total_leads,
    SUM(CASE
        WHEN l.status = 'Converted' THEN 1
        ELSE 0
    END) AS converted_leads
FROM users u
LEFT JOIN leads l
    ON u.user_id = l.assigned_to
GROUP BY u.user_id, u.user_name;
SELECT *
FROM employee_performance_report;
-- View 2: Lead source report
CREATE OR REPLACE VIEW lead_source_report AS
SELECT
    COALESCE(source, 'Unknown') AS lead_source,
    COUNT(*) AS total_leads,
    SUM(CASE
        WHEN status = 'Converted' THEN 1
        ELSE 0
    END) AS converted_leads
FROM leads
GROUP BY source;
SELECT *
FROM lead_source_report;
-- View 3: Customer segmentation report
CREATE OR REPLACE VIEW customer_segment_report AS
SELECT
    segment,
    COUNT(*) AS total_customers
FROM customers
GROUP BY segment;
SELECT *
FROM customer_segment_report;

