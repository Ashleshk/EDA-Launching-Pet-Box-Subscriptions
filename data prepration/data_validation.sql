-- Checking binary values
SELECT re_buy, COUNT(*) AS count
FROM datacamp.pet_sales
GROUP BY re_buy;

-- Max, min, mode, average of rating
SELECT MAX(rating) AS max_rating,
	MIN(rating) AS min_rating,
    (SELECT rating 
    FROM datacamp.pet_sales 
    GROUP BY rating 
    ORDER BY COUNT(*) DESC LIMIT 1) AS mode_rating,
    AVG(rating) AS avg_rating
FROM datacamp.pet_sales;

-- Should only have: dog, cat, fish, bird
SELECT pet_type, COUNT(*) AS count
FROM datacamp.pet_sales
GROUP BY pet_type;
-- Remove hamster and rabbit from dataset
# should remove 46 rows
DELETE FROM datacamp.pet_sales WHERE pet_type = 'hamster' OR pet_type = 'rabbit';

-- 5 size categories
SELECT pet_size, COUNT(*) AS count
FROM datacamp.pet_sales
GROUP BY pet_size;

-- Price of products
-- Might want to check this with visualization
SELECT pet_type, product_category, 
	MAX(price) AS max_price,
	MIN(price) AS min_price,
    AVG(price) AS avg_price
FROM datacamp.pet_sales
GROUP BY pet_type, product_category
ORDER BY pet_type;

-- Sales from last year
-- First, remove dollar signs and commas and convert to numeric type
UPDATE datacamp.pet_sales
SET sales = REPLACE(REPLACE(sales, "$", ""), ",", "");
ALTER TABLE datacamp.pet_sales MODIFY sales NUMERIC;

-- See max and min sales
-- Also check with plot
SELECT product_category,
	MAX(sales) AS max_sales,
	MIN(sales) AS min_sales
FROM datacamp.pet_sales
GROUP BY product_category;

-- Number of product categories
 

-- Number of unique product_id's and vendor_id's
-- Seems like primary keys
SELECT COUNT(DISTINCT product_id) AS count_productid,
	COUNT(DISTINCT vendor_id) AS count_vendorid
FROM datacamp.pet_sales;

-- Remove "VC_" in front of vendor_id's
UPDATE datacamp.pet_sales SET vendor_id = REPLACE(vendor_id, 'VC_', "");
