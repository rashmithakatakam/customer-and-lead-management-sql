-- Query 1: Display all users--
select * from users;
-- Query 2: Display all customers--
select * from customers;
-- Query 3: Display all leads--
select * from leads;
-- Query 4: Display all interactions--
select * from interactions;
-- Query 5: Display all lead_status_history--
select * from lead_status_history;
-- Query 6: Display all follows_ups
select * from follow_ups;
-- Query 7: Find leads with the status New--
SELECT lead_id, lead_name, source, status
FROM leads
WHERE status = 'New';
-- Query 8: Display unique lead sources--
 SELECT DISTINCT source FROM leads;
-- Query 9: Display customers alphabetically--
SELECT customer_id, customer_name
FROM customers
ORDER BY customer_name ASC;
-- Query 10: Display the first five leads--
SELECT lead_id, lead_name, status FROM leads LIMIT 5;
-- Query 11: Skip the first five leads and display the next five --
SELECT lead_id, lead_name, status
FROM leads
ORDER BY lead_id
LIMIT 5 OFFSET 5;
-- Query 12: Find customers whose names start with A --
SELECT customer_id, customer_name
FROM customers
WHERE customer_name LIKE 'A%';
-- Query 13: Find leads created within a date range --
SELECT lead_id, lead_name, created_at
FROM leads
WHERE created_at BETWEEN
      '2026-10-01 00:00:00'
      AND '2026-10-31 23:59:59';
-- Query 14: Find leads with selected statuses 
  SELECT lead_name, status
FROM leads
WHERE status IN ('New', 'Contacted', 'Qualified');  
 -- Query 15: Exclude converted and lost leads
SELECT lead_name, status FROM leads WHERE status NOT IN ('Converted', 'Lost');
-- Query 16: Find leads not linked to a customer
SELECT lead_id, lead_name FROM leads WHERE customer_id IS NULL;
-- Query 17: Find leads that have an assigned employee
SELECT lead_id, lead_name, assigned_to FROM leads WHERE assigned_to IS NOT NULL;
-- Query 18: Find leads that are New and assigned to user 2
SELECT lead_id, lead_name, status FROM leads WHERE status = 'New' AND assigned_to = 2;
-- Query 19: Find leads that are New or Lost
SELECT lead_id, lead_name, status FROM leads WHERE status = 'New' OR status = 'Lost';
-- Query 20: Find leads that are not Converted
SELECT lead_id, lead_name, status FROM leads WHERE NOT status = 'Converted';
-- Query 21: Count all customers
SELECT COUNT(*) AS total_customers FROM customers;
-- Query 22: Count leads by status
SELECT status, COUNT(*) AS total_leads FROM leads GROUP BY status;
-- Query 23: Display lead statuses with more than one lead
SELECT status, COUNT(*) AS total_leads FROM leads GROUP BY status HAVING COUNT(*) > 1;
-- Query 24: Count customers in each segment
SELECT segment, COUNT(*) AS total_customers FROM customers GROUP BY segment;
-- Query 25: Count interactions by type
SELECT interaction_type, COUNT(*) AS total_interactions FROM interactions
GROUP BY interaction_type
ORDER BY total_interactions DESC;
-- Query 26: INNER JOIN — Display leads with assigned employee names
SELECT l.lead_id,l.lead_name,l.status,u.user_name AS assigned_employee FROM leads l
INNER JOIN users u ON l.assigned_to = u.user_id;
-- Query 27: LEFT JOIN — Display all leads, including unassigned leads
SELECT l.lead_name,l.status,u.user_name AS assigned_employee FROM leads l
LEFT JOIN users u ON l.assigned_to = u.user_id;
-- Query 28: RIGHT JOIN — Display all users and their assigned leads
SELECT u.user_name,l.lead_name,l.status FROM leads l
RIGHT JOIN users u ON l.assigned_to = u.user_id;
-- Query 29: SELF JOIN — Find leads assigned to the same employee
SELECT l1.lead_name AS first_lead,l2.lead_name AS second_lead,l1.assigned_to AS user_id
FROM leads l1 INNER JOIN leads l2 ON l1.assigned_to = l2.assigned_to
AND l1.lead_id < l2.lead_id WHERE l1.assigned_to IS NOT NULL;
-- Query 30: Join interactions with leads and users
SELECT l.lead_name,i.interaction_type,i.notes,u.user_name AS handled_by FROM interactions i
INNER JOIN leads l ON i.lead_id = l.lead_id INNER JOIN users u ON i.user_id = u.user_id;
-- Query 31: Find leads assigned to employees with the role Manager  
 SELECT lead_id, lead_name, assigned_to FROM leads WHERE assigned_to IN (
SELECT user_id FROM users WHERE role = 'Manager'); 
-- Query 32: Find leads with at least one interaction
SELECT l.lead_id, l.lead_name FROM leads l WHERE EXISTS (SELECT 1 FROM interactions i
WHERE i.lead_id = l.lead_id);
-- Query 33: Find leads without any follow-ups
SELECT l.lead_id, l.lead_name FROM leads l WHERE NOT EXISTS (SELECT 1 FROM follow_ups f
WHERE f.lead_id = l.lead_id);
-- Query 34: Find leads with more interactions than the average number per lead
SELECT
    l.lead_id,
    l.lead_name,
    COUNT(i.interaction_id) AS total_interactions
FROM leads l
LEFT JOIN interactions i
    ON l.lead_id = i.lead_id
GROUP BY l.lead_id, l.lead_name
HAVING COUNT(i.interaction_id) > (
    SELECT AVG(interaction_count)
    FROM (
        SELECT COUNT(*) AS interaction_count
        FROM interactions
        GROUP BY lead_id
    ) AS interaction_totals
);
-- Query 35: CASE — Categorize leads by status
SELECT
    lead_name,
    status,
    CASE
        WHEN status = 'Converted' THEN 'Successful'
        WHEN status = 'Lost' THEN 'Unsuccessful'
        WHEN status = 'Qualified' THEN 'High Potential'
        ELSE 'In Progress'
    END AS lead_category
FROM leads;
-- Query 36: COALESCE — Display an alternative when the email is NULL
SELECT
    lead_name,
    COALESCE(email, 'Email not provided') AS contact_email
FROM leads;
-- Query 37: UNION — Combine customer names and lead names without duplicates
SELECT customer_name AS person_name
FROM customers
UNION
SELECT lead_name AS person_name
FROM leads;
-- Query 38: UNION ALL — Combine customer names and lead names including duplicates
SELECT customer_name AS person_name
FROM customers
UNION ALL
SELECT lead_name AS person_name
FROM leads;
-- Query 38: Count total leads, converted leads, and lost leads
SELECT
    COUNT(*) AS total_leads,
    SUM(status = 'Converted') AS converted_leads,
    SUM(status = 'Lost') AS lost_leads
FROM leads;
-- Query 39: Find the top five employees by number of assigned leads
SELECT u.user_id,u.user_name,COUNT(l.lead_id) AS total_leads
FROM users u
LEFT JOIN leads l
    ON u.user_id = l.assigned_to
GROUP BY u.user_id, u.user_name
ORDER BY total_leads DESC
LIMIT 5;
-- Query 40: Display monthly lead counts
SELECT
    DATE_FORMAT(created_at, '%Y-%m') AS lead_month,
    COUNT(*) AS total_leads
FROM leads
GROUP BY DATE_FORMAT(created_at, '%Y-%m')
ORDER BY lead_month;