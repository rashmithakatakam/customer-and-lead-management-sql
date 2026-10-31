USE customer_lead_management;
-- 1. Procedure to add a new customer
DELIMITER $$

CREATE PROCEDURE AddCustomer(
    IN p_name VARCHAR(100),
    IN p_phone VARCHAR(15),
    IN p_email VARCHAR(100),
    IN p_segment VARCHAR(20)
)
BEGIN
    INSERT INTO customers
        (customer_name, phone, email, segment)
    VALUES
        (p_name, p_phone, p_email, p_segment);
END $$

DELIMITER ;
CALL AddCustomer(
    'Sanjay',
    '9000000021',
    'sanjay@gmail.com',
    'Premium'
);
-- 2. Procedure to add a new lead
DELIMITER $$

CREATE PROCEDURE AddLead(
    IN p_name VARCHAR(100),
    IN p_phone VARCHAR(15),
    IN p_email VARCHAR(100),
    IN p_source VARCHAR(50),
    IN p_assigned_to INT
)
BEGIN
    INSERT INTO leads
        (lead_name, phone, email, source, assigned_to)
    VALUES
        (p_name, p_phone, p_email, p_source, p_assigned_to);
END $$

DELIMITER ;
CALL AddLead(
    'Nikhil',
    '9100000021',
    'nikhil@gmail.com',
    'Website',
    2
);
-- 3. Procedure to update lead status
DELIMITER $$

CREATE PROCEDURE UpdateLeadStatus(
    IN p_lead_id INT,
    IN p_new_status VARCHAR(30),
    IN p_changed_by INT
)
BEGIN
    DECLARE v_old_status VARCHAR(30);

    START TRANSACTION;

    SELECT status INTO v_old_status
    FROM leads
    WHERE lead_id = p_lead_id
    FOR UPDATE;

    UPDATE leads
    SET status = p_new_status
    WHERE lead_id = p_lead_id;

    INSERT INTO lead_status_history
        (lead_id, old_status, new_status, changed_by)
    VALUES
        (p_lead_id, v_old_status, p_new_status, p_changed_by);

    COMMIT;
END $$

DELIMITER ;
CALL UpdateLeadStatus(1, 'Contacted', 2);
-- 4. Procedure to assign a lead to an employee
DELIMITER $$

CREATE PROCEDURE AssignLead(
    IN p_lead_id INT,
    IN p_user_id INT
)
BEGIN
    UPDATE leads
    SET assigned_to = p_user_id
    WHERE lead_id = p_lead_id;
END $$

DELIMITER ;
CALL AssignLead(1, 3);
-- 5. Procedure to add an interaction
DELIMITER $$

CREATE PROCEDURE AddInteraction(
    IN p_lead_id INT,
    IN p_user_id INT,
    IN p_type VARCHAR(20),
    IN p_notes TEXT
)
BEGIN
    INSERT INTO interactions
        (lead_id, user_id, interaction_type, notes)
    VALUES
        (p_lead_id, p_user_id, p_type, p_notes);
END $$

DELIMITER ;
CALL AddInteraction(
    1,
    2,
    'Call',
    'Discussed product requirements'
);
-- 6. Procedure to schedule a follow-up
DELIMITER $$

CREATE PROCEDURE ScheduleFollowUp(
    IN p_lead_id INT,
    IN p_user_id INT,
    IN p_due_date DATETIME,
    IN p_notes TEXT
)
BEGIN
    INSERT INTO follow_ups
        (lead_id, assigned_to, due_date, notes)
    VALUES
        (p_lead_id, p_user_id, p_due_date, p_notes);
END $$

DELIMITER ;
CALL ScheduleFollowUp(
    1,
    2,
    '2026-11-05 10:00:00',
    'Discuss pricing'
);
-- 7. Procedure to complete a follow-up
DELIMITER $$

CREATE PROCEDURE CompleteFollowUp(
    IN p_follow_up_id INT
)
BEGIN
    UPDATE follow_ups
    SET status = 'Completed'
    WHERE follow_up_id = p_follow_up_id;
END $$

DELIMITER ;
CALL CompleteFollowUp(1);
-- 8. Procedure to display leads assigned to an employee
DELIMITER $$

CREATE PROCEDURE GetEmployeeLeads(
    IN p_user_id INT
)
BEGIN
    SELECT
        lead_id,
        lead_name,
        source,
        status
    FROM leads
    WHERE assigned_to = p_user_id;
END $$

DELIMITER ;
CALL GetEmployeeLeads(2);
-- 9. Procedure to display pending follow-ups
DELIMITER $$

CREATE PROCEDURE GetPendingFollowUps()
BEGIN
    SELECT
        f.follow_up_id,
        l.lead_name,
        u.user_name,
        f.due_date,
        f.status
    FROM follow_ups f
    INNER JOIN leads l
        ON f.lead_id = l.lead_id
    INNER JOIN users u
        ON f.assigned_to = u.user_id
    WHERE f.status = 'Pending'
    ORDER BY f.due_date;
END $$

DELIMITER ;
CALL GetPendingFollowUps();
-- 10. Procedure to display lead status summary
DELIMITER $$

CREATE PROCEDURE GetLeadStatusSummary()
BEGIN
    SELECT
        status,
        COUNT(*) AS total_leads
    FROM leads
    GROUP BY status;
END $$

DELIMITER ;
CALL GetLeadStatusSummary();
-- Step 2: Verify your stored procedures
SHOW PROCEDURE STATUS
WHERE Db = 'customer_lead_management';
SHOW CREATE PROCEDURE AddCustomer;
SELECT customer_id, customer_name, segment
FROM customers;

SELECT lead_id, lead_name, status, assigned_to
FROM leads;

SELECT history_id, lead_id, old_status, new_status
FROM lead_status_history;

