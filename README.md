# DataAnalytics-Assessment

This repository contains SQL solutions for the Data Analytics Assessment by Cowrywise. Each SQL file corresponds to a specific question outlined in the assessment, and is named accordingly.

---

## Per-Question Explanations

### 1. High-Value Customers with Multiple Products

- **Techniques Used**: `JOIN`, `COUNT`, `SUM`, `GROUP BY`.

- **Approach**: This query calculates the total number of savings and investment records per user and combines the deposit amounts into a single `total_deposits` column. Only users with both savings and investment records are included.

The query is structured into three key parts using Common Table Expressions (CTEs):

**`savings_customers`**: Filters users who have created valid (non-deleted) savings plans by checking is_regular_savings = 1, grouping them by owner_id, and counting the distinct plan IDs.

**`investment_customers`**: Filters users who have created valid investment plans (is_a_fund = 1), grouping and counting them similarly.

**customer_deposits:** Aggregates confirmed savings deposits (confirmed_amount) from the savings_savingsaccount table per user.

**Final Query**
In the final query, users are:

- Joined across all three CTEs to ensure only users with both savings and investment plans are included.
- Mapped with their full names for readability.
- Filtered to only include users who have made actual deposits (total_deposits > 0).
- Sorted in descending order of their total deposits.

---

### 2. Transaction Frequency Analysis

- **Techniques Used**:

- Time-based grouping using `DATE_FORMAT`
- Multi-level aggregation using CTEs
- Conditional classification with `CASE`
- Custom ordering of categories in output

- **Approach**: This solution uses two Common Table Expressions (CTEs) to break down the problem:

**`monthly_transactions`**

- Extracts the transaction month (`YYYY-MM`) from `created_on`.
- Groups by customer and month to compute the total number of transactions per month per customer.

**`customer_avg_transactions`**

- Aggregates to find the **average monthly transaction count per customer**.
- Uses a `CASE` statement to assign a frequency category based on this average.

**Final Output**

- Groups by `frequency_category`.
- Counts the number of customers in each category.
- Calculates the average transactions per month (rounded to one decimal place) as shown in the example.
- Uses a `CASE` statement to order the results

---

### 3. Account Inactivity Alert

- **Techniques Used**

- Date comparison with `DATEDIFF`
- Aggregation using `MAX`
- Logical filtering of plan types
- Date formatting for readable output

- **Approach**: The solution uses a CTE (`last_transaction_dates`) followed by a filtered final query:

**`last_transaction_dates` CTE**

- Joins `savings_savingsaccount` with `plans_plan` to link transactions with plan details.
- Filters for:
  - Only **confirmed transactions** (`s.confirmed_amount > 0`)
  - Only **savings and investments** (`is_deleted = 0` and either `is_regular_savings = 1` or `is_a_fund = 1`)
- Groups by `owner_id` and `plan_id` to find the **latest transaction date per plan** using `MAX(created_on)`.

**Final Output**

- Computes the **inactivity period** in days using `DATEDIFF(CURRENT_DATE, last_transaction_date)`.
- Filters to include only those plans **inactive for over 365 days**.
- Formats the last transaction date using `DATE_FORMAT` for clarity as shown in the example.
- Sorts results in descending order of inactivity.

---

### 4. Customer Lifetime Value (CLV) Estimation

- **Techniques Used**

- `DATEDIFF` and `MIN()` to calculate tenure
- `AVG()` to compute average profit
- Use of `CAST` and `ROUND` for formatting

- **Approach**: The solution uses a Common Table Expression (CTE) to calculate intermediate metrics for each customer, followed by a final computation of estimated CLV.

**`account_tenure` CTE**

- Joins `savings_savingsaccount` with `users_customuser` to get customer names.
- Filters for transactions with `confirmed_amount > 0`.
- Calculates:
  - `tenure_months`: Total duration (in months) since the customer’s first transaction.
  - `total_transactions`: Count of all confirmed transactions.
  - `avg_profit_per_transaction`: Average profit assuming **0.1% (0.001)** of the transaction amount.

**Final CLV Computation**

- CLV is estimated using the formula:  
  **`(total_transactions / tenure_months) * 12 * avg_profit_per_transaction`**  
  This projects average yearly profit, assuming the customer continues at the same rate.
