USE customer_lead_management;
-- 1. Index on lead status
CREATE INDEX idx_lead_status
ON leads(status);
SELECT lead_id, lead_name, status
FROM leads
WHERE status = 'New';
-- 2. Index on lead source
CREATE INDEX idx_lead_source
ON leads(source);
SELECT lead_id, lead_name, source
FROM leads
WHERE source = 'Website';
-- 3. Index on customer segment
CREATE INDEX idx_customer_segment
ON customers(segment);
SELECT customer_id, customer_name, segment
FROM customers
WHERE segment = 'Premium';
-- 4. Index on lead creation date
CREATE INDEX idx_lead_created_at
ON leads(created_at);
SELECT lead_id, lead_name, created_at
FROM leads
WHERE created_at >= '2026-10-01'
  AND created_at < '2026-11-01';
  -- 5. Index on interaction date
  CREATE INDEX idx_interaction_date
ON interactions(interaction_date);
SELECT interaction_id, lead_id, interaction_date
FROM interactions
WHERE interaction_date >= '2026-10-01'
  AND interaction_date < '2026-11-01';
  -- 6. Composite index on follow-up status and due date
 CREATE INDEX idx_followup_status_date
ON follow_ups(status, due_date); 
SELECT follow_up_id, lead_id, due_date, status
FROM follow_ups
WHERE status = 'Pending'
ORDER BY due_date;
-- 7. Composite index on assigned employee and lead status
CREATE INDEX idx_lead_employee_status
ON leads(assigned_to, status);
SELECT lead_id, lead_name, status
FROM leads
WHERE assigned_to = 2
  AND status = 'New';
  -- 8. Composite index on interaction type and date
 CREATE INDEX idx_interaction_type_date
ON interactions(interaction_type, interaction_date); 
SELECT interaction_id, lead_id, interaction_type
FROM interactions
WHERE interaction_type = 'Call'
  AND interaction_date >= '2026-10-01';
  -- 9. Index on status history date
  CREATE INDEX idx_history_changed_at
ON lead_status_history(changed_at);
SELECT history_id, lead_id, old_status, new_status
FROM lead_status_history
WHERE changed_at >= '2026-10-01'
  AND changed_at < '2026-11-01';
-- 10. Index on customer creation date
  CREATE INDEX idx_customer_created_at
ON customers(created_at);
SELECT customer_id, customer_name, created_at
FROM customers
ORDER BY created_at DESC
LIMIT 5;
-- Step 2: Understand UNIQUE indexes
SHOW INDEX FROM customers;
-- Step 3: Check existing indexes before creating new ones
SHOW INDEX FROM users;

SHOW INDEX FROM customers;

SHOW INDEX FROM leads;

SHOW INDEX FROM interactions;

SHOW INDEX FROM lead_status_history;

SHOW INDEX FROM follow_ups;
