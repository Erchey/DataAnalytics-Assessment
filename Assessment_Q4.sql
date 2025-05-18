WITH account_tenure AS (
    SELECT 
        s.owner_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        DATEDIFF(CURRENT_DATE, MIN(s.created_on)) / 30 AS tenure_months,
        COUNT(s.confirmed_amount) AS total_transactions,
        AVG(s.confirmed_amount * 0.001) AS avg_profit_per_transaction
    FROM savings_savingsaccount s
    JOIN users_customuser u ON s.owner_id = u.id
    WHERE s.confirmed_amount > 0
    GROUP BY s.owner_id
)
SELECT owner_id,
    name,
    ROUND(tenure_months) AS tenure_months,
    total_transactions,
    CAST((total_transactions / tenure_months) * 12 * avg_profit_per_transaction AS DECIMAL(20, 2)) AS estimated_clv
    FROM account_tenure
    ORDER BY estimated_clv DESC