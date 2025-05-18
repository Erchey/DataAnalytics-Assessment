WITH last_transaction_dates AS (
    SELECT DISTINCT p.owner_id,
        p.id AS plan_id,
        p.description AS plan_name,
        MAX(p.created_on) AS last_transaction_date
    FROM savings_savingsaccount s
    LEFT JOIN plans_plan p ON p.id = s.plan_id
    WHERE s.confirmed_amount > 0
    AND p.is_deleted = 0 AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)
    GROUP BY p.owner_id, p.id
)
SELECT l.plan_id, 
       l.owner_id,
       l.plan_name AS type,
       DATE_FORMAT(l.last_transaction_date, '%Y-%m-%d') AS last_transaction_date,
       DATEDIFF(CURRENT_DATE, l.last_transaction_date) AS inactivity_days
FROM last_transaction_dates l
WHERE 
    DATEDIFF(CURRENT_DATE, l.last_transaction_date) > 365
ORDER BY inactivity_days DESC
