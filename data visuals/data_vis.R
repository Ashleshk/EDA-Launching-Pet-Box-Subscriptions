library(tidyverse)
library(knitr)
library(kableExtra)
library(magick)


### Loading some datasets ###
pet_df <- read.csv("data/pet_sales_cleaned.csv")
pet_count <- read.csv("data/pet_product_count.csv")
table1 <- read.csv("data/table1.csv")
table2 <- read.csv("data/table2.csv")
table3 <- read.csv("data/table3.csv", row.names = NULL) %>% 
  mutate(X = case_when(
    X == "Sum of sales" ~ "Sum of sales",
    X == "Count of re_buy" ~ "Count of repurchase",
    X == "Total Sum of sales" ~ "Total Sum of sales",
    X == "Total Count of re_buy" ~ "Total Count of repurchase",
    TRUE ~ " "
  ))
table5 <- read.csv("data/table5.csv")

### Manipulating data ###
# Original data
pet_df <- pet_df %>% mutate(price_scaled = price - mean(price),
                            rating_scaled = rating - mean(rating),
                            sales_scaled = sales - mean(sales),
                            number_sold_yr = round(sales/price, 0),
                            number_sold_m = round((sales/price)/12, 0))

pet_df_filtered <- pet_df %>% 
  filter((pet_type == 'bird' & price <= 40) |
           (pet_type == 'cat' & price <= 150)|
           (pet_type == 'dog' & price <= 150) |
           (pet_type == 'fish' & price <= 40))

write.csv(pet_df_filtered, "data/pet_df_filtered.csv")

# Table 3
table3 <- table3[-c(1, 2, 5, 8, 11),]
row.names(table3) <- NULL
table3 <- rename(table3, c('pet_type' = X, 
                           'No' = Column.Labels, 
                           "Yes" = X.1, 
                           'grand_total' = X.2))


# Table 4
intercept = c(0.48, 1.04, 1.18, 1.92)
price_scaled = c("1.00", "1.00", "1.00", "1.00")
rating_scaled = c(0.91, 0.97, 0.86, 1.82)
sales_scaled = c("1.00", "1.00", "1.00", "1.00")
pet_size_xs = c(0.46, 0.78, 1.27, "0.00")
pet_size_l = c(1.56, 0.89, 0.69, 0.06)
pet_size_m = c(1.28, 0.88, 1.24, 0.93)
pet_size_s = c(2.85, 0.85, 0.68, 0.38)
pvals <- c(0.47, 0.58, 0.53, 0.88, 0.61, 0.75, 0.81, 0.43,
           "0.90", 0.18, 0.44, 0.91, 0.56, 0.79, 0.71, "0.70",
           0.61, 0.14, "<0.001", "0.90", 0.59, 0.39, 0.62, 0.28,
           0.54, 0.89, 0.06, 0.21, 0.99, 0.12, 0.96, 0.38)

birds_OR <- c(intercept[1], price_scaled[1], rating_scaled[1], 
              sales_scaled[1], pet_size_xs[1], pet_size_l[1],
              pet_size_m[1], pet_size_s[1])
cats_OR <- c(intercept[2], price_scaled[2], rating_scaled[2], 
             sales_scaled[2], pet_size_xs[2], pet_size_l[2],
             pet_size_m[2], pet_size_s[2])
dogs_OR <- c(intercept[3], price_scaled[3], rating_scaled[3], 
             sales_scaled[3], pet_size_xs[3], pet_size_l[3],
             pet_size_m[3], pet_size_s[3])
fish_OR <- c(intercept[4], price_scaled[4], rating_scaled[4], 
             sales_scaled[4], pet_size_xs[4], pet_size_l[4],
             pet_size_m[4], pet_size_s[4])
mod_results <- data.frame(predictors = 
                            c(rep(c("Intercept", 'Price scaled', 'Rating scaled',
                                    'Sales scaled', 'Pet size - extra small',
                                    'Pet size - large', 'Pet size - medium',
                                    'Pet size - small'), 4)),
                          odds_ratio = c(birds_OR, cats_OR, dogs_OR, fish_OR),
                          p_values = pvals)

### Tables ###
## Table 1 ##
table1 %>% kable(col.names = c("", "Count of Repurchase", "Sum of Sales"),
                 caption = 
                   "Table 1: Count and Sales of Products",
                 booktabs = T) %>% 
  kable_styling(latex_options = "HOLD_position") %>% 
  save_kable("data_vis/table1.png", zoom = 1.5)


## Table 2 ##
table2 %>% mutate(pet_type = rep("", nrow(table2))) %>% 
  select(-c(rank)) %>% 
  kable(col.names = c("Pet type", "Product Category", "Total Sales"),
        caption = "Table 2: Top 5 Repurchased Product Categories with High Sales for each Pet Type",
        booktabs = T) %>% 
  pack_rows("Bird", 1, 4) %>% 
  pack_rows("Cat", 5, 9) %>% 
  pack_rows("Dog", 10, 14) %>% 
  pack_rows("Fish", 15, 18) %>% 
  kable_styling(latex_options = "HOLD_position") %>% 
  save_kable("data_vis/table2.png", zoom = 1.5)


## Table 3 ##
table3 %>% kable(col.names = c("Aggregated data", "No", "Yes", "Grand Total"),
                 caption = "Table 3: Count and Sales of Products for each Pet Type", booktabs = T) %>% 
  add_header_above(c("Pet type" = 1, "Repurchased" = 2, " ")) %>% 
  pack_rows("Bird", 1, 2) %>%
  pack_rows("Cat", 3, 4) %>% 
  pack_rows("Dog", 5, 6) %>% 
  pack_rows("Fish", 7, 8) %>% 
  pack_rows("All pets", 9, 10) %>% 
  kable_styling(latex_options = "HOLD_position") %>% 
  save_kable("data_vis/table3.png", zoom = 1.5)


## Table 4 ## 
mod_results %>% kable(col.names = c("Predictors", "Odds ratio", "P-values"), 
                      caption = "Table 4: Logistic Regression Results",
                      booktabs = T) %>% 
  pack_rows("Bird", 1, 8) %>% 
  pack_rows("Cat", 9, 16) %>% 
  pack_rows("Dog", 17, 24) %>% 
  pack_rows("Fish", 25, 32) %>% 
  kable_styling(latex_options = "HOLD_position") %>% 
  save_kable("data_vis/table4.png", zoom = 1.5)


# Table 5
table5 %>% select(-c(pet_type, re_buy)) %>% 
  kable(col.names = c("Pet type, Product Category", "Product ID",
                      "Price", "Rating", "Sales"),
        caption = "Table 5: List of Products",
        booktabs = T) %>% 
  pack_rows("Bird", 1, 5) %>% 
  pack_rows("Cat", 6, 15) %>% 
  pack_rows("Dog", 16, 25) %>% 
  pack_rows("Fish", 26, 30) %>% 
  kable_styling(latex_options = "HOLD_position") %>% 
  save_kable("data_vis/table5.png", zoom = 1.5)





### Figures ###
## Figure 1 ##
fig1 <- pet_count %>%
  ggplot(aes(x = product_category, y = count, 
             fill = as.factor(re_buy))) + 
  geom_bar(position = 'dodge', stat = 'identity') +
  scale_fill_brewer(palette = "Set1", 
                    name = "Repurchased",
                    labels = c("No", "Yes")) +
  labs(x = "Pet type", y = "Count", 
       caption = "Figure 1 \n Number of products that were/were not repurchased \n for different product categories, by different types of pets.") +
  facet_wrap(~pet_type, labeller = as_labeller(c(`bird` = "Bird",
                                                 `cat` = "Cat",
                                                 `dog` = "Dog",
                                                 `fish` = "Fish"))) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.75, hjust = 1))
ggsave("data_vis/fig1.png")


## Figure 2
fig2 <- pet_df_filtered %>% group_by(pet_type, product_category, re_buy) %>% 
  summarize(sum_sales = sum(sales)) %>% 
  ggplot(aes(x = product_category, sum_sales, fill = as.factor(re_buy))) +
  geom_bar(stat= 'identity', position = 'dodge') +
  facet_wrap(~pet_type, labeller = as_labeller(c(`bird` = "Bird",
                                                 `cat` = "Cat",
                                                 `dog` = "Dog",
                                                 `fish` = "Fish"))) +
  scale_fill_brewer(name = "Repurchased", labels = c("No", "Yes"), palette = "Set1") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.75, hjust = 1)) +
  labs(x = "Product Category", y = "Sum of Sales from Last Year ($)",
       caption = "Figure 2 \n Sales of products that were/were not repurchased \n for different product categories, by different types of pets.")

ggsave("data_vis/fig2.png")


## Figure 3
fig3 <- pet_df_filtered %>% 
  ggplot(aes(x = product_category, y = price, fill = product_category)) +
  geom_boxplot() + 
  facet_wrap(~pet_type, labeller = as_labeller(c(`bird` = "Bird",
                                                 `cat` = "Cat",
                                                 `dog` = "Dog",
                                                 `fish` = "Fish"))) + 
  scale_fill_brewer(palette = "Spectral") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.75, hjust = 1),
        legend.position = "none") +
  labs(x = "Product Category", y = "Price",
       caption = "Figure 3
                  Range of product price for each product category of pet types.") 

ggsave("data_vis/fig3.png")


