CREATE DATABASE Pizza_Sales;
USE Pizza_Sales;

SELECT * FROM order_details;
select* From orders;
SELECT * FROM pizza_types;
SELECT * From pizzas;

-- Basic Queries

-- Total Number of Orders Placed
SELECT COUNT(DISTINCT order_id) AS total_orders FROM orders;

-- Total Revenue Generated from Pizza Sales
SELECT SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;

-- Highest-Priced Pizza
SELECT pt.name AS pizza_name, p.price
FROM pizzas p
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC
LIMIT 5;

-- Most Common Pizza Size Ordered
SELECT p.size, COUNT(od.pizza_id) AS order_count
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY order_count DESC
LIMIT 5;

-- Top 5 Most Ordered Pizza Types
SELECT pt.name AS pizza_type, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity DESC
LIMIT 5;

--  Intermediate Queries

--  Total Quantity of Each Pizza Category Ordered
SELECT pt.category, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_quantity DESC;

-- Distribution of Orders by Hour of the Day
SELECT HOUR(o.time) AS order_hour, COUNT(o.order_id) AS total_orders
FROM orders o
GROUP BY order_hour
ORDER BY order_hour;

-- Category-Wise Distribution of Pizzas
SELECT pt.category, COUNT(od.pizza_id) AS pizza_count
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY pizza_count DESC;

--  Average Number of Pizzas Ordered per Day
SELECT o.date, AVG(od.quantity) AS avg_pizzas_per_day
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.date
ORDER BY o.date;

-- Top 3 Most Ordered Pizza Types Based on Revenue
SELECT pt.name AS pizza_type, SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 3;

-- Advanced Queries
-- Percentage Contribution of Each Pizza Type to Total Revenue
SELECT pt.name AS pizza_type, 
       SUM(od.quantity * p.price) AS revenue,
       (SUM(od.quantity * p.price) / (SELECT SUM(od.quantity * p.price) FROM order_details od JOIN pizzas p ON od.pizza_id = p.pizza_id)) * 100 AS revenue_percentage
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue_percentage DESC;

-- Cumulative Revenue Over 
SELECT o.date, 
       SUM(od.quantity * p.price) AS daily_revenue, 
       SUM(SUM(od.quantity * p.price)) OVER (ORDER BY o.date) AS cumulative_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY o.date
ORDER BY o.date;

--  Top 3 Most Ordered Pizza Types by Revenue for Each Category
SELECT pt.category, pt.name AS pizza_type, SUM(od.quantity * p.price) AS revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category, pt.name
ORDER BY pt.category, revenue DESC
LIMIT 3;

-- Average Order Value (AOV)
SELECT AVG(order_value) AS avg_order_value
FROM (
    SELECT o.order_id, SUM(od.quantity * p.price) AS order_value
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    GROUP BY o.order_id
) AS subquery;

-- Least Ordered Pizzas (Low Demand Items)
SELECT pt.name AS pizza_type, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity ASC
LIMIT 5;










