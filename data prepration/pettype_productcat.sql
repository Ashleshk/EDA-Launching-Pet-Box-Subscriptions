WITH no_buy AS (SELECT pet_type, product_category, COUNT(re_buy) AS count_no_repurchase 
    FROM datacamp.pet_sales WHERE re_buy = 0 GROUP BY pet_type, product_category)

SELECT p.pet_type,
	p.product_category,
	COUNT(re_buy) AS count_repurchase,
    count_no_repurchase,
    COUNT(re_buy) + count_no_repurchase AS grand_total
FROM datacamp.pet_sales AS p
JOIN no_buy AS n
ON p.pet_type = n.pet_type AND p.product_category = n.product_category
WHERE re_buy = 1
GROUP BY pet_type, product_category
ORDER BY pet_type, count_repurchase DESC;


SELECT pet_type, product_category, re_buy, COUNT(*) AS count
FROM datacamp.pet_sales
WHERE (pet_type = 'bird' AND price <= 40) OR (pet_type = 'fish' AND price <= 40) OR
	(pet_type = 'cat' AND price <= 150) OR (pet_type = 'dog' AND price <= 150)
GROUP BY pet_type, product_category, re_buy
ORDER BY pet_type, count DESC;




SELECT *
FROM (SELECT pet_type, product_category, SUM(sales) AS total_sales,
		dense_rank() over(partition by pet_type order by SUM(sales) desc) AS 'rank'
FROM datacamp.pet_sales
WHERE ((pet_type = 'bird' AND price <= 40) OR (pet_type = 'fish' AND price <= 40) OR
	(pet_type = 'cat' AND price <= 150) OR (pet_type = 'dog' AND price <= 150)) AND re_buy = 1
GROUP BY pet_type, product_category
ORDER BY pet_type, total_sales DESC) AS t1
WHERE t1.rank <= 5;