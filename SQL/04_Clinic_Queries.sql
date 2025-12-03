
-- Q1. Find the revenue from each sales channel in a given year (example: 2021)
SELECT sales_channel, SUM(amount) AS revenue
FROM clinic_sales
WHERE EXTRACT(YEAR FROM datetime) = 2021
GROUP BY sales_channel
ORDER BY revenue DESC;

-- Q2. Top 10 most valuable customers for a given year (by total spent)
SELECT uid, c.name, SUM(amount) AS total_spent
FROM clinic_sales s
JOIN customer c ON s.uid = c.uid
WHERE EXTRACT(YEAR FROM s.datetime) = 2021
GROUP BY uid, c.name
ORDER BY total_spent DESC
LIMIT 10;

-- Q3. Month wise revenue, expense, profit, status for a given year (2021)
WITH revenue_month AS (
  SELECT date_trunc('month', datetime) AS month,
         SUM(amount) AS revenue
  FROM clinic_sales
  WHERE EXTRACT(YEAR FROM datetime) = 2021
  GROUP BY 1
),
expense_month AS (
  SELECT date_trunc('month', datetime) AS month,
         SUM(amount) AS expense
  FROM expenses
  WHERE EXTRACT(YEAR FROM datetime) = 2021
  GROUP BY 1
)
SELECT COALESCE(r.month, e.month) AS month,
       COALESCE(r.revenue, 0) AS revenue,
       COALESCE(e.expense, 0) AS expense,
       COALESCE(r.revenue,0) - COALESCE(e.expense,0) AS profit,
       CASE WHEN COALESCE(r.revenue,0) - COALESCE(e.expense,0) > 0 THEN 'profitable'
            ELSE 'not-profitable' END AS status
FROM revenue_month r
FULL OUTER JOIN expense_month e ON r.month = e.month
ORDER BY month;

-- Q4. For each city find the most profitable clinic for a given month (params: year=2021, month='2021-09-01')
-- Example for September 2021:
WITH clinic_profit AS (
  SELECT c.cid, c.city,
         SUM(COALESCE(s.amount,0)) AS revenue,
         SUM(COALESCE(exp.amount,0)) AS expense,
         SUM(COALESCE(s.amount,0)) - SUM(COALESCE(exp.amount,0)) AS profit
  FROM clinics c
  LEFT JOIN clinic_sales s
    ON c.cid = s.cid
    AND date_trunc('month', s.datetime) = date_trunc('month', TIMESTAMP '2021-09-01')
  LEFT JOIN expenses exp
    ON c.cid = exp.cid
    AND date_trunc('month', exp.datetime) = date_trunc('month', TIMESTAMP '2021-09-01')
  GROUP BY c.cid, c.city
)
SELECT city, cid, profit
FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY city ORDER BY profit DESC) as rn
  FROM clinic_profit
) t
WHERE rn = 1
ORDER BY city;

-- Q5. For each state find the second least profitable clinic for a given month
WITH clinic_profit AS (
  SELECT c.cid, c.state,
         SUM(COALESCE(s.amount,0)) AS revenue,
         SUM(COALESCE(exp.amount,0)) AS expense,
         SUM(COALESCE(s.amount,0)) - SUM(COALESCE(exp.amount,0)) AS profit
  FROM clinics c
  LEFT JOIN clinic_sales s
    ON c.cid = s.cid
    AND date_trunc('month', s.datetime) = date_trunc('month', TIMESTAMP '2021-09-01')
  LEFT JOIN expenses exp
    ON c.cid = exp.cid
    AND date_trunc('month', exp.datetime) = date_trunc('month', TIMESTAMP '2021-09-01')
  GROUP BY c.cid, c.state
)
SELECT state, cid, profit
FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY state ORDER BY profit ASC) as rn
  FROM clinic_profit
) t
WHERE rn = 2
ORDER BY state;
