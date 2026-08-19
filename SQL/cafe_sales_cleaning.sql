
-- CAFE SALES DATA CLEANING SCRIPT (MySQL)
-- Dataset: 10,000 Cafe Transactions

CREATE TABLE IF NOT EXISTS cafe_sales_staging LIKE cafe_sales_raw;

INSERT INTO cafe_sales_staging
SELECT * FROM cafe_sales_raw;

CREATE TABLE cafe_sales_cleaned AS
WITH DuplicateCTE AS (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY transaction_id, transaction_date, item, quantity, price_per_unit, payment_method, location
               ORDER BY transaction_id
           ) AS row_num
    FROM cafe_sales_staging
)
SELECT transaction_id, transaction_date, item, quantity, price_per_unit, total_spent, payment_method, location
FROM DuplicateCTE
WHERE row_num = 1;

UPDATE cafe_sales_cleaned
SET 
    item = NULLIF(TRIM(item), 'UNKNOWN'),
    payment_method = NULLIF(TRIM(payment_method), 'UNKNOWN'),
    location = NULLIF(TRIM(location), 'UNKNOWN'),
    price_per_unit = CASE WHEN TRIM(price_per_unit) IN ('ERROR', '', 'NULL') THEN NULL ELSE price_per_unit END,
    total_spent = CASE WHEN TRIM(total_spent) IN ('ERROR', '', 'NULL') THEN NULL ELSE total_spent END;

UPDATE cafe_sales_cleaned
SET 
    item = TRIM(item),
    payment_method = TRIM(payment_method),
    location = TRIM(location);

UPDATE cafe_sales_cleaned
SET transaction_date = STR_TO_DATE(transaction_date, '%Y-%m-%d')
WHERE STR_TO_DATE(transaction_date, '%Y-%m-%d') IS NOT NULL;

ALTER TABLE cafe_sales_cleaned
    MODIFY COLUMN transaction_date DATE,
    MODIFY COLUMN quantity INT,
    MODIFY COLUMN price_per_unit DECIMAL(10,2),
    MODIFY COLUMN total_spent DECIMAL(10,2);

UPDATE cafe_sales_cleaned
SET total_spent = quantity * price_per_unit
WHERE total_spent IS NULL 
  AND quantity IS NOT NULL 
  AND price_per_unit IS NOT NULL;

UPDATE cafe_sales_cleaned
SET price_per_unit = total_spent / quantity
WHERE price_per_unit IS NULL 
  AND total_spent IS NOT NULL 
  AND quantity IS NOT NULL 
  AND quantity > 0;

UPDATE cafe_sales_cleaned c
JOIN (
    SELECT item, AVG(price_per_unit) AS avg_price
    FROM cafe_sales_cleaned
    WHERE price_per_unit IS NOT NULL
    GROUP BY item
) avg_prices ON c.item = avg_prices.item
SET c.price_per_unit = ROUND(avg_prices.avg_price, 2),
    c.total_spent = ROUND(c.quantity * avg_prices.avg_price, 2)
WHERE c.price_per_unit IS NULL 
  AND c.quantity IS NOT NULL;


-- STEP 6: FINAL DATA INTEGRITY CHECK
DELETE FROM cafe_sales_cleaned
WHERE transaction_id IS NULL;

SELECT 
    COUNT(*) AS total_rows,
    SUM(total_spent) AS total_revenue,
    AVG(total_spent) AS avg_order_value,
    COUNT(DISTINCT location) AS active_locations
FROM cafe_sales_cleaned;
