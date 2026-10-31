USE customer_lead_management;
-- 1. Trigger to automatically record lead status changes
DELIMITER $$

CREATE TRIGGER trg_lead_status_update
AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO lead_status_history
        (lead_id, old_status, new_status, changed_by)
        VALUES
        (NEW.lead_id, OLD.status, NEW.status,
         NEW.assigned_to);
    END IF;
END $$

DELIMITER ;
UPDATE leads
SET status = 'Contacted'
WHERE lead_id = 1;
SELECT
    history_id,
    lead_id,
    old_status,
    new_status,
    changed_by
FROM lead_status_history
WHERE lead_id = 1
ORDER BY history_id DESC;
-- 2. Trigger to validate customer phone numbers
DELIMITER $$

CREATE TRIGGER trg_validate_customer_phone
BEFORE INSERT ON customers
FOR EACH ROW
BEGIN
    IF NEW.phone IS NOT NULL
       AND NEW.phone NOT REGEXP '^[0-9]{10}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Phone number must contain exactly 10 digits';
    END IF;
END $$

DELIMITER ;
INSERT INTO customers
(customer_name, phone, email, segment)
VALUES
('Test Customer', '12345',
 'testcustomer@example.com', 'Regular');
 -- 3. Trigger to prevent invalid follow-up dates
 DELIMITER $$

CREATE TRIGGER trg_validate_followup_date
BEFORE INSERT ON follow_ups
FOR EACH ROW
BEGIN
    IF NEW.due_date < NOW() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Follow-up date cannot be in the past';
    END IF;
END $$

DELIMITER ;
INSERT INTO follow_ups
(lead_id, assigned_to, due_date, status, notes)
VALUES
(1, 2, '2025-01-01 10:00:00',
 'Pending', 'Test follow-up');
 -- 4. Trigger to record the initial status of a new lead
 DELIMITER $$

CREATE TRIGGER trg_new_lead_history
AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    IF NEW.assigned_to IS NOT NULL THEN
        INSERT INTO lead_status_history
        (lead_id, old_status, new_status, changed_by)
        VALUES
        (NEW.lead_id, NULL, NEW.status,
         NEW.assigned_to);
    END IF;
END $$

DELIMITER ;
INSERT INTO leads
(lead_name, phone, email, source, assigned_to)
VALUES
('Deepak', '9100000031',
 'deepak@example.com', 'Website', 2);
 SELECT
    h.history_id,
    l.lead_name,
    h.old_status,
    h.new_status
FROM lead_status_history h
JOIN leads l
    ON h.lead_id = l.lead_id
WHERE l.email = 'deepak@example.com';
-- 5. Trigger to prevent converting a lead without a customer record
DELIMITER $$

CREATE TRIGGER trg_validate_lead_conversion
BEFORE UPDATE ON leads
FOR EACH ROW
BEGIN
    IF NEW.status = 'Converted'
       AND NEW.customer_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Converted lead must be linked to a customer';
    END IF;
END $$

DELIMITER ;
UPDATE leads
SET status = 'Converted'
WHERE lead_id = 1;
-- 6. Trigger to prevent deleting customers linked to leads
DELIMITER $$

CREATE TRIGGER trg_prevent_customer_delete
BEFORE DELETE ON customers
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM leads
        WHERE customer_id = OLD.customer_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Cannot delete customer linked to a lead';
    END IF;
END $$

DELIMITER ;
DELETE FROM customers
WHERE customer_id = 1;
-- Step 2: Update your existing stored procedure
DROP PROCEDURE IF EXISTS UpdateLeadStatus;

DELIMITER $$

CREATE PROCEDURE UpdateLeadStatus(
    IN p_lead_id INT,
    IN p_new_status VARCHAR(30),
    IN p_changed_by INT
)
BEGIN
    DECLARE v_count INT DEFAULT 0;

    SELECT COUNT(*) INTO v_count
    FROM users
    WHERE user_id = p_changed_by;

    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid employee ID';
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM leads
    WHERE lead_id = p_lead_id;

    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lead does not exist';
    END IF;

    UPDATE leads
    SET status = p_new_status
    WHERE lead_id = p_lead_id;
END $$

DELIMITER ;
-- Step 3: Verify all triggers
SHOW TRIGGERS
FROM customer_lead_management;
SHOW CREATE TRIGGER trg_lead_status_update;
DROP TRIGGER IF EXISTS trg_lead_status_update;
