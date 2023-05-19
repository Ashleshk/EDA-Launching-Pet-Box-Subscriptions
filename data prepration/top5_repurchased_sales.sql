-- Specific product ID's for each pet type
(SELECT CONCAT(UPPER(LEFT(pet_type, 1)), RIGHT(pet_type, LENGTH(pet_type)-1)) AS pet_type, product_category, product_id, price, rating, sales, re_buy
FROM datacamp.pet_sales 
WHERE pet_type = 'bird'
		AND product_category IN ("Equipment", "Snack", "Food")
        AND price < 40
ORDER BY pet_type, sales DESC
LIMIT 7)
UNION
(SELECT CONCAT(UPPER(LEFT(pet_type, 1)), RIGHT(pet_type, LENGTH(pet_type)-1)) AS pet_type, product_category, product_id, price, rating, sales, re_buy
FROM datacamp.pet_sales 
WHERE pet_type = 'cat' AND price < 50
		AND product_category IN ('Equipment', 'Clothes', 'Food', 'Housing', 'Snack')
ORDER BY pet_type, sales DESC
LIMIT 10)
UNION
(SELECT CONCAT(UPPER(LEFT(pet_type, 1)), RIGHT(pet_type, LENGTH(pet_type)-1)) AS pet_type, product_category, product_id, price, rating, sales, re_buy
FROM datacamp.pet_sales 
WHERE pet_type = 'dog' AND price < 100
		AND product_category IN ('Equipment', 'Medicine', 'Bedding', 'Snack')
ORDER BY pet_type, sales DESC
LIMIT 10)
UNION
(SELECT CONCAT(UPPER(LEFT(pet_type, 1)), RIGHT(pet_type, LENGTH(pet_type)-1)) AS pet_type, product_category, product_id, price, rating, sales, re_buy
FROM datacamp.pet_sales 
WHERE pet_type = 'fish' AND price < 40
		AND product_category IN ('Medicine', 'Supplements', 'Snack')
ORDER BY pet_type, sales DESC
LIMIT 7);


-- TOP 5 repurchased products, for each product category of each pet type
-- Not filtering price or product category
SELECT *
FROM (SELECT pet_type, 
	dense_rank() over(partition by pet_type order by sales desc) as 'rank',
    product_id, product_category, sales, price, rating, re_buy
FROM datacamp.pet_sales 
WHERE re_buy = 1
ORDER BY pet_type, sales desc) AS t1
WHERE t1.rank <= 5