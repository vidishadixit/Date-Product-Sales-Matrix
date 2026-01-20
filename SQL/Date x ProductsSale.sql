create database ProductSales

use productsales

select * from products

select * from orders

select * from Calendar

SELECT 
	d.date, 
	p.product_id, 
	COALESCE(SUM(o.quantity), 0) AS total_quantity, 
	COALESCE(SUM(o.revenue), 0) AS total_revenue 
into date_product_sales
FROM 
	calendar d 
CROSS JOIN products p 
LEFT JOIN orders o 
ON o.product_id = p.product_id 
AND o.order_date = d.date 
GROUP BY 
	d.date, 
	p.product_id;


select top 10 * from date_product_sales;