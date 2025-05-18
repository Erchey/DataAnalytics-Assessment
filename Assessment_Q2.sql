WITH monthly_transactions AS (
    SELECT 
        s.owner_id,
        DATE_FORMAT(s.created_on, '%Y-%m') AS month,
        COUNT(*) AS transaction_count
    FROM savings_savingsaccount s
    GROUP BY s.owner_id, DATE_FORMAT(s.created_on, '%Y-%m')
),
customer_avg_transactions AS (
    SELECT 
        owner_id,
        AVG(transaction_count) AS avg_transaction_count,
        CASE WHEN AVG(transaction_count) >= 10 THEN 'High Frequency'
             WHEN AVG(transaction_count) BETWEEN 3 AND 9 THEN 'Medium Frequency'
             ELSE 'Low Frequency' END AS frequency_category
    FROM monthly_transactions
    GROUP BY owner_id
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transaction_count), 1) AS avg_transactions_per_month
FROM customer_avg_transactions
GROUP BY frequency_category
ORDER BY 
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        ELSE 3
    END;
