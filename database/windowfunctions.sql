USE customer_lead_management;
-- 1. ROW_NUMBER() — Number all leads
SELECT
    ROW_NUMBER() OVER (ORDER BY lead_id) AS row_num,
    lead_id,
    lead_name,
    status
FROM leads;
-- 2. ROW_NUMBER() with PARTITION BY
SELECT
    lead_id,
    lead_name,
    status,
    ROW_NUMBER() OVER (
        PARTITION BY status
        ORDER BY lead_id
    ) AS row_num
FROM leads;
-- 3. RANK() — Rank employees by assigned leads
SELECT
    user_name,
    total_leads,
    RANK() OVER (
        ORDER BY total_leads DESC
    ) AS employee_rank
FROM (
    SELECT
        u.user_id,
        u.user_name,
        COUNT(l.lead_id) AS total_leads
    FROM users u
    LEFT JOIN leads l
        ON u.user_id = l.assigned_to
    GROUP BY u.user_id, u.user_name
) AS employee_counts;
-- 4. DENSE_RANK() — Rank employees without gaps
SELECT
    user_name,
    total_leads,
    DENSE_RANK() OVER (
        ORDER BY total_leads DESC
    ) AS employee_rank
FROM (
    SELECT
        u.user_id,
        u.user_name,
        COUNT(l.lead_id) AS total_leads
    FROM users u
    LEFT JOIN leads l
        ON u.user_id = l.assigned_to
    GROUP BY u.user_id, u.user_name
) AS employee_counts;
-- 5. NTILE() — Divide leads into four groups
SELECT
    lead_id,
    lead_name,
    created_at,
    NTILE(4) OVER (
        ORDER BY created_at, lead_id
    ) AS lead_group
FROM leads;
-- 6. COUNT() OVER() — Total leads in every row
SELECT
    lead_id,
    lead_name,
    status,
    COUNT(*) OVER () AS total_leads
FROM leads;
-- 7. COUNT() with PARTITION BY
SELECT
    lead_id,
    lead_name,
    status,
    COUNT(*) OVER (
        PARTITION BY status
    ) AS status_count
FROM leads;
-- 8. COUNT() OVER() — Employee-wise lead count
SELECT
    lead_id,
    lead_name,
    assigned_to,
    COUNT(*) OVER (
        PARTITION BY assigned_to
    ) AS employee_lead_count
FROM leads;
-- 9. SUM() OVER() — Running total of leads
SELECT
    lead_id,
    lead_name,
    created_at,
    SUM(1) OVER (
        ORDER BY created_at, lead_id
        ROWS BETWEEN UNBOUNDED PRECEDING
                 AND CURRENT ROW
    ) AS running_total
FROM leads;
-- 10. SUM() OVER() — Running total of customer registrations
SELECT
    customer_id,
    customer_name,
    created_at,
    SUM(1) OVER (
        ORDER BY created_at, customer_id
        ROWS BETWEEN UNBOUNDED PRECEDING
                 AND CURRENT ROW
    ) AS running_customers
FROM customers;
-- 11. LAG() — Previous lead registration
SELECT
    lead_id,
    lead_name,
    created_at,
    LAG(lead_name) OVER (
        ORDER BY created_at, lead_id
    ) AS previous_lead
FROM leads;
-- 12. LEAD() — Next lead registration
SELECT
    lead_id,
    lead_name,
    created_at,
    LEAD(lead_name) OVER (
        ORDER BY created_at, lead_id
    ) AS next_lead
FROM leads;
-- 13. FIRST_VALUE() — First registered lead by status
SELECT
    lead_id,
    lead_name,
    status,
    FIRST_VALUE(lead_name) OVER (
        PARTITION BY status
        ORDER BY created_at, lead_id
    ) AS first_lead
FROM leads;
-- 14. LAST_VALUE() — Last registered lead by status
SELECT
    lead_id,
    lead_name,
    status,
    LAST_VALUE(lead_name) OVER (
        PARTITION BY status
        ORDER BY created_at, lead_id
        ROWS BETWEEN UNBOUNDED PRECEDING
                 AND UNBOUNDED FOLLOWING
    ) AS last_lead
FROM leads;
-- 15. Find the first lead assigned to each employee
WITH ranked_leads AS (
    SELECT
        lead_id,
        lead_name,
        assigned_to,
        created_at,
        ROW_NUMBER() OVER (
            PARTITION BY assigned_to
            ORDER BY created_at, lead_id
        ) AS rn
    FROM leads
)
SELECT
    lead_id,
    lead_name,
    assigned_to,
    created_at
FROM ranked_leads
WHERE rn = 1;
-- 16. Find the latest interaction for each lead
WITH ranked_interactions AS (
    SELECT
        interaction_id,
        lead_id,
        interaction_type,
        interaction_date,
        ROW_NUMBER() OVER (
            PARTITION BY lead_id
            ORDER BY interaction_date DESC,
                     interaction_id DESC
        ) AS rn
    FROM interactions
)
SELECT
    interaction_id,
    lead_id,
    interaction_type,
    interaction_date
FROM ranked_interactions
WHERE rn = 1;
-- 17. Find the latest status-history record for each lead
WITH ranked_history AS (
    SELECT
        history_id,
        lead_id,
        old_status,
        new_status,
        changed_at,
        ROW_NUMBER() OVER (
            PARTITION BY lead_id
            ORDER BY changed_at DESC,
                     history_id DESC
        ) AS rn
    FROM lead_status_history
)
SELECT
    history_id,
    lead_id,
    old_status,
    new_status,
    changed_at
FROM ranked_history
WHERE rn = 1;
-- 18. Find the top 3 employees with the most leads
WITH employee_counts AS (
    SELECT
        u.user_id,
        u.user_name,
        COUNT(l.lead_id) AS total_leads
    FROM users u
    LEFT JOIN leads l
        ON u.user_id = l.assigned_to
    GROUP BY u.user_id, u.user_name
),
ranked_employees AS (
    SELECT
        user_name,
        total_leads,
        DENSE_RANK() OVER (
            ORDER BY total_leads DESC
        ) AS employee_rank
    FROM employee_counts
)
SELECT *
FROM ranked_employees
WHERE employee_rank <= 3;
-- 19. Find the second follow-up for each lead
WITH ranked_followups AS (
    SELECT
        follow_up_id,
        lead_id,
        due_date,
        status,
        ROW_NUMBER() OVER (
            PARTITION BY lead_id
            ORDER BY due_date, follow_up_id
        ) AS rn
    FROM follow_ups
)
SELECT
    follow_up_id,
    lead_id,
    due_date,
    status
FROM ranked_followups
WHERE rn = 2;
-- 20. Monthly lead registrations with cumulative totals
WITH monthly_leads AS (
    SELECT
        DATE_FORMAT(created_at, '%Y-%m') AS month,
        COUNT(*) AS total_leads
    FROM leads
    GROUP BY DATE_FORMAT(created_at, '%Y-%m')
)
SELECT
    month,
    total_leads,
    SUM(total_leads) OVER (
        ORDER BY month
        ROWS BETWEEN UNBOUNDED PRECEDING
                 AND CURRENT ROW
    ) AS cumulative_leads
FROM monthly_leads
ORDER BY month;