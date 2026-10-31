USE customer_lead_management;
-- 1. START TRANSACTION and COMMIT
START TRANSACTION;

INSERT INTO customers
(customer_name, phone, email, segment)
VALUES
('Rohit Sharma', '9000000041',
 'rohit@example.com', 'Premium');

COMMIT;
SELECT customer_id, customer_name, segment
FROM customers
WHERE email = 'rohit@example.com';
-- 2. START TRANSACTION and ROLLBACK
START TRANSACTION;

UPDATE customers
SET segment = 'Premium'
WHERE customer_id = 2;

SELECT customer_id, customer_name, segment
FROM customers
WHERE customer_id = 2;

ROLLBACK;
SELECT customer_id, customer_name, segment
FROM customers
WHERE customer_id = 2;
-- 3. SAVEPOINT
START TRANSACTION;

UPDATE leads
SET source = 'Website'
WHERE lead_id = 1;

SAVEPOINT sp1;

UPDATE leads
SET source = 'Referral'
WHERE lead_id = 2;

ROLLBACK TO SAVEPOINT sp1;

COMMIT;
SELECT lead_id, lead_name, source
FROM leads
WHERE lead_id IN (1, 2);
-- 4. Transaction to convert a lead into a customer
DELIMITER $$

CREATE PROCEDURE ConvertLeadToCustomer(
    IN p_lead_id INT
)
BEGIN
    DECLARE v_customer_id INT;
    DECLARE v_name VARCHAR(100);
    DECLARE v_phone VARCHAR(15);
    DECLARE v_email VARCHAR(100);
    DECLARE v_status VARCHAR(20);
    DECLARE v_existing_customer_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT
        lead_name,
        phone,
        email,
        status,
        customer_id
    INTO
        v_name,
        v_phone,
        v_email,
        v_status,
        v_existing_customer_id
    FROM leads
    WHERE lead_id = p_lead_id
    FOR UPDATE;

    IF v_name IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lead does not exist';
    END IF;

    IF v_status = 'Converted'
       OR v_existing_customer_id IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lead already linked or converted';
    END IF;

    INSERT INTO customers
        (customer_name, phone, email, segment)
    VALUES
        (v_name, v_phone, v_email, 'Regular');

    SET v_customer_id = LAST_INSERT_ID();

    UPDATE leads
    SET customer_id = v_customer_id,
        status = 'Converted'
    WHERE lead_id = p_lead_id;

    COMMIT;
END $$

DELIMITER ;
CALL ConvertLeadToCustomer(1);
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
WHERE l.lead_id = 1;
-- 5. Transaction to update multiple follow-ups
START TRANSACTION;

UPDATE follow_ups
SET status = 'Completed'
WHERE follow_up_id = 1;

UPDATE follow_ups
SET status = 'Completed'
WHERE follow_up_id = 3;

COMMIT;
SELECT follow_up_id, lead_id, status
FROM follow_ups
WHERE follow_up_id IN (1, 3);
-- 6. Transaction to cancel an update
START TRANSACTION;

UPDATE follow_ups
SET status = 'Cancelled'
WHERE follow_up_id = 7;

SELECT follow_up_id, status
FROM follow_ups
WHERE follow_up_id = 7;

ROLLBACK;
SELECT follow_up_id, status
FROM follow_ups
WHERE follow_up_id = 7;
