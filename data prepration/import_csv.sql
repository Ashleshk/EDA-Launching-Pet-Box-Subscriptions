LOAD DATA LOCAL INFILE  
'/Users/hyoeungracepark/Desktop/pet_sales/data/pet_sales.csv'
INTO TABLE datacamp.pet_sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(`product_id`,`product_category` , `sales`, `price`, `vendor_id`, 
`pet_size`, `pet_type`, `rating`, `re_buy`);
