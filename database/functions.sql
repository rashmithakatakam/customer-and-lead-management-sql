USE customer_lead_management;
-- 1.Function to count total customers
DELIMITER $$

CREATE FUNCTION GetTotalCustomers()
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM customers;

    RETURN total;
END $$

DELIMITER ;
SELECT GetTotalCustomers() AS total_customers;
-- 2. Function to count total leads
DELIMITER $$

CREATE FUNCTION GetTotalLeads()
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM leads;

    RETURN total;
END $$

DELIMITER ;
SELECT GetTotalLeads() AS total_leads;
-- 3. Function to count converted leads
DELIMITER $$

CREATE FUNCTION GetConvertedLeads()
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM leads
    WHERE status = 'Converted';

    RETURN total;
END $$

DELIMITER ;
SELECT GetConvertedLeads() AS converted_leads;
-- 4. Function to calculate lead conversion rate
DELIMITER $$

CREATE FUNCTION GetConversionRate()
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE total_leads INT;
    DECLARE converted_leads INT;
    DECLARE conversion_rate DECIMAL(5,2);

    SELECT COUNT(*) INTO total_leads
    FROM leads;

    SELECT COUNT(*) INTO converted_leads
    FROM leads
    WHERE status = 'Converted';

    IF total_leads = 0 THEN
        SET conversion_rate = 0;
    ELSE
        SET conversion_rate =
            (converted_leads * 100.0) / total_leads;
    END IF;

    RETURN conversion_rate;
END $$

DELIMITER ;
SELECT GetConversionRate() AS conversion_percentage;
-- 5. Function to count pending follow-ups
DELIMITER $$

CREATE FUNCTION GetPendingFollowUpsCount()
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM follow_ups
    WHERE status = 'Pending';

    RETURN total;
END $$

DELIMITER ;
SELECT GetPendingFollowUpsCount() AS pending_followups;
-- 6. Function to count leads assigned to an employee
DELIMITER $$

CREATE FUNCTION GetEmployeeLeadCount(
    p_user_id INT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM leads
    WHERE assigned_to = p_user_id;

    RETURN total;
END $$

DELIMITER ;

SELECT GetEmployeeLeadCount(2) AS assigned_leads;
-- 7. Function to count interactions for a lead
DELIMITER $$

CREATE FUNCTION GetLeadInteractionCount(
    p_lead_id INT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM interactions
    WHERE lead_id = p_lead_id;

    RETURN total;
END $$

DELIMITER ;
SELECT GetLeadInteractionCount(1) AS total_interactions;
-- 8. Function to get the current status of a lead
DELIMITER $$

CREATE FUNCTION GetLeadStatus(
    p_lead_id INT
)
RETURNS VARCHAR(30)
READS SQL DATA
BEGIN
    DECLARE lead_status VARCHAR(30);

    SELECT MAX(status) INTO lead_status
    FROM leads
    WHERE lead_id = p_lead_id;

    RETURN lead_status;
END $$

DELIMITER ;
SELECT GetLeadStatus(1) AS current_status;
-- 9. Function to count Premium customers
DELIMITER $$

CREATE FUNCTION GetPremiumCustomerCount()
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM customers
    WHERE segment = 'Premium';

    RETURN total;
END $$

DELIMITER ;
SELECT GetPremiumCustomerCount() AS premium_customers;
-- 10. Function to count overdue follow-ups
DELIMITER $$

CREATE FUNCTION GetOverdueFollowUpsCount()
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM follow_ups
    WHERE status = 'Pending'
      AND due_date < NOW();

    RETURN total;
END $$

DELIMITER ;
SELECT GetOverdueFollowUpsCount() AS overdue_followups;
-- Step 2: Test all stored functions
SELECT GetTotalCustomers() AS total_customers;

SELECT GetTotalLeads() AS total_leads;

SELECT GetConvertedLeads() AS converted_leads;

SELECT GetConversionRate() AS conversion_rate;

SELECT GetPendingFollowUpsCount() AS pending_followups;

SELECT GetEmployeeLeadCount(2) AS employee_leads;

SELECT GetLeadInteractionCount(1) AS lead_interactions;

SELECT GetLeadStatus(1) AS lead_status;

SELECT GetPremiumCustomerCount() AS premium_customers;

SELECT GetOverdueFollowUpsCount() AS overdue_followups;
-- Step 3: Verify the functions in MySQL Workbench
SHOW FUNCTION STATUS
WHERE Db = 'customer_lead_management';
SHOW CREATE FUNCTION GetConversionRate;

