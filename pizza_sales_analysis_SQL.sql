## Q1: The total number of order place
SELECT
COUNT(order_id) AS total_orders
FROM
orders;
## Q2: The total revenue generated from pizza sales
SELECT ROUND(SUM(order_details.quantity * pizzas.price)) AS total_revenue
FROM
order_details
JOIN
pizzas ON pizzas.pizza_id = order_details.pizza_id;
## Q3: The highest priced pizza.
SELECT
pizza_types.name, pizzas.price
FROM pizzas
JOIN
pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
ORDER BY pizzas.price desc
limit 1;
## Q4: The most common pizza size ordered.
SELECT
 pizzas.size,
 COUNT(order_details.order_details_id) as order_count
FROM
 pizzas
  JOIN
order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC
limit 1;
## Q5: The top 5 most ordered pizza types along their quantities.
SELECT
pizza_types.name, SUM(order_details.quantity) as quantity
FROM
pizza_types
JOIN
pizzas ON pizza_types.pizza_type_id= pizzas.pizza_type_id
JOIN
order_details ON order_details.pizza_id=pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity desc
limit 5;

## Q6: The quantity of each pizza categories ordered.
SELECT
pizza_types.category,
SUM(order_details.quantity) as total_quantity
FROM
pizza_types
JOIN
pizzas ON pizza_types.pizza_type_id= pizzas.pizza_type_id
JOIN
order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY total_quantity DESC;
## Q7: The distribution of orders by hours of the day.
SELECT
HOUR(order_time), COUNT(order_id)
FROM
orders
GROUP BY HOUR(order_time);
## Q8: The category-wise distribution of pizzas.
SELECT
COUNT(name) AS distribution, category
FROM
pizza_types
GROUP BY category;
## Q9: The average number of pizzas ordered per day.	
SELECT
ROUND (AVG(quantity), 0) as average_number_of_pizzas
FROM
(SELECT orders.order_date, SUM(order_details.quantity) AS quantity
FROM
order_details
JOIN orders ON order_details.order_id = orders.order_id GROUP BY orders.order_date) AS order_quantity;
## Q10: Top 3 most ordered pizza type base on revenue.
SELECT
pizza_types.name,
ROUND(SUM(order_details.quantity * pizzas.price),2) as revenue
FROM
order_details
JOIN
pizzas ON pizzas.pizza_id = order_details.pizza_id
JOIN
pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;
-- Q11: The percentage contribution of each pizza type to revenue.	
SELECT pizza_types.category as pizza_type, ROUND((SUM(order_details.quantity * pizzas.price) / (SELECT
    ROUND(SUM(order_details.quantity* pizzas.price), 2) AS tptal_revenue
FROM order_details JOIN pizzas
ON pizzas.pizza_id = order_details.pizza_id)) * 100, 2) as revenue
FROM order_details JOIN pizzas
ON pizzas.pizza_id = order_details.pizza_id
JOIN
pizza_types ON pizza_types.pizza_type_id= pizzas.pizza_type_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;
## Q12: The cumulative revenue generated over time.
select order_date,
sum(revenue) over(order by order_date) as cum_revenue
from
(select orders.order_date,
SUM(order_details.quantity * pizzas.price) as revenue
from order_details join pizzas
on order_details.pizza_id=pizzas.pizza_id
join orders
on orders.order_id=order_details.order_id
group by orders.order_date) as sales;	 
## Q13: The top 3 most ordered pizza type based on revenue for each pizza category.
select name, revenue
from
(select category, name, revenue,
rank() over(partition by category order by revenue desc) as C
from
(SELECT pizza_types.name, pizza_types.category,
ROUND (SUM(order_details.quantity*pizzas.price), 2) AS revenue
FROM order_details JOIN pizzas
ON pizzas.pizza_id = order_details.pizza_id
JOIN pizza_types
ON pizza_types.pizza_type_id= pizzas.pizza_type_id
GROUP BY pizza_types.name,pizza_types.category) as a) as b
where C<=3
limit 3;

