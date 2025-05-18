WITH savings_customers AS (
    SELECT DISTINCT p.owner_id, COUNT(DISTINCT p.id) AS savings_count
    FROM plans_plan p
    WHERE p.amount > 0 
    AND p.is_deleted = 0
    AND p.is_regular_savings = 1
    GROUP BY p.owner_id
),

investment_customers AS (
    SELECT DISTINCT p.owner_id, COUNT(DISTINCT p.id) AS investment_count
    FROM plans_plan p
    WHERE p.amount > 0 
    AND p.is_deleted = 0  
    AND p.is_a_fund = 1
    GROUP BY p.owner_id
),

customer_deposits AS (
    SELECT 
        s.owner_id AS owner_id,
        CAST(SUM(s.confirmed_amount) AS DECIMAL(20, 2))AS total_deposits
    FROM savings_savingsaccount s
    GROUP BY s.owner_id
)
SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    sc.savings_count,
    ic.investment_count,
    cd.total_deposits
FROM users_customuser u
JOIN savings_customers sc ON u.id = sc.owner_id
JOIN investment_customers ic ON u.id = ic.owner_id
LEFT JOIN customer_deposits cd ON u.id = cd.owner_id
WHERE cd.total_deposits > 0
ORDER BY cd.total_deposits DESC;