DROP DATABASE IF EXISTS `datacamp`;
CREATE DATABASE `datacamp`; 
USE `datacamp`;

SET NAMES utf8 ;
SET character_set_client = utf8mb4 ;

CREATE TABLE `pet_sales` (
  `product_id` varchar(50) DEFAULT NULL,
  `product_category` varchar(50) DEFAULT NULL,
  `sales` varchar(50) DEFAULT NULL,
  `price` decimal(5,2) DEFAULT NULL,
  `vendor_id` varchar(50) DEFAULT NULL,
  `pet_size` varchar(50) DEFAULT NULL,
  `pet_type` varchar(50) DEFAULT NULL,
  `rating` int(11) DEFAULT NULL,
  `re_buy` int(11) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
