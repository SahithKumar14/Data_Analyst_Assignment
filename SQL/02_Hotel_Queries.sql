-- Q1. For every user get user_id and last booked room_no
SELECT user_id, room_no, booking_date
FROM (
  SELECT user_id, room_no, booking_date,
         ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC) AS rn
  FROM bookings
) t
WHERE rn = 1;

-- Q2. booking_id and total billing amount of every booking created in November, 2021
-- Assumes bill_date is timestamp of commercial line; we compute booking totals by summing quantity * rate
SELECT bc.booking_id,
       SUM(bc.item_quantity * i.item_rate) AS total_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE bc.bill_date >= '2021-11-01'::timestamp
  AND bc.bill_date <  '2021-12-01'::timestamp
GROUP BY bc.booking_id
ORDER BY bc.booking_id;

-- Q3. bill_id and bill amount of all bills raised in October, 2021 having bill amount > 1000
SELECT bc.bill_id,
       SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE bc.bill_date >= '2021-10-01'::timestamp
  AND bc.bill_date <  '2021-11-01'::timestamp
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000
ORDER BY bill_amount DESC;

-- Q4. Determine the most ordered and least ordered item of each month of year 2021
WITH monthly_item_qty AS (
  SELECT date_trunc('month', bc.bill_date) AS month,
         bc.item_id,
         i.item_name,
         SUM(bc.item_quantity) AS total_qty
  FROM booking_commercials bc
  JOIN items i ON bc.item_id = i.item_id
  WHERE bc.bill_date >= '2021-01-01'::timestamp
    AND bc.bill_date <  '2022-01-01'::timestamp
  GROUP BY 1, 2, 3
),
ranked AS (
  SELECT *,
         RANK() OVER (PARTITION BY month ORDER BY total_qty DESC) AS rank_desc,
         RANK() OVER (PARTITION BY month ORDER BY total_qty ASC)  AS rank_asc
  FROM monthly_item_qty
)
SELECT month, item_id, item_name, total_qty,
       CASE WHEN rank_desc = 1 THEN 'most_ordered'
            WHEN rank_asc  = 1 THEN 'least_ordered'
       END AS which
FROM ranked
WHERE rank_desc = 1 OR rank_asc = 1
ORDER BY month, which DESC;

-- Q5. Find the customers with the second highest bill value of each month of year 2021
-- First find bill totals per (bill_id, user, month); then rank by bill_total desc within month
WITH bill_totals AS (
  SELECT bc.bill_id,
         b.user_id,
         date_trunc('month', bc.bill_date) AS month,
         SUM(bc.item_quantity * i.item_rate) AS bill_amount
  FROM booking_commercials bc
  JOIN bookings b ON bc.booking_id = b.booking_id
  JOIN items i ON bc.item_id = i.item_id
  WHERE bc.bill_date >= '2021-01-01'::timestamp
    AND bc.bill_date <  '2022-01-01'::timestamp
  GROUP BY bc.bill_id, b.user_id, month
),
ranked AS (
  SELECT *,
         DENSE_RANK() OVER (PARTITION BY month ORDER BY bill_amount DESC) AS dr
  FROM bill_totals
)
SELECT month, user_id, bill_id, bill_amount
FROM ranked
WHERE dr = 2
ORDER BY month;
