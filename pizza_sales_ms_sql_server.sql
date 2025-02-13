-- Retrieve the total number of orders placed.
select count(order_id)
from orders;

-- Calculate the total revenue generated from pizza sales.
select  round(sum(od.quantity*p.price ),2) as Total_revenue
from order_details od 
join pizzas p on od.pizza_id = p.pizza_id;

-- Identify the highest-priced pizza.
select top 1 pt.name as Pizzas_Name,(p.price) as Highest_Price
from pizzas p
join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
order by price desc;


-- Identify the most common pizza size ordered.
SELECT top 1 p.size, COUNT(od.order_details_id) AS count_order
FROM pizzas p
JOIN order_details od ON p.pizza_id = od.pizza_id
group by size
ORDER BY count_order DESC
; 

-- List the top 5 most ordered pizza types along with their quantities.
SELECT top 5 sum(od.quantity) as quantity ,pt.name as Name
from pizza_types pt
join pizzas on pt.pizza_type_id = pizzas.pizza_type_id
join order_details od on od.pizza_id = pizzas.pizza_id
group by Name 
order by quantity desc
;

-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT pt.category as category, sum(od.quantity) as quantity 
from pizza_types pt
join pizzas on pt.pizza_type_id = pizzas.pizza_type_id
join order_details od on od.pizza_id = pizzas.pizza_id
group by category
order by quantity desc;

-- Determine the distribution of orders by hour of the day.
select datepart (hour, order_time) as Distribution ,count(order_id)as per_day
from orders
group by datepart (hour, order_time);

-- Join relevant tables to find the category-wise distribution of pizzas.
select pt.category ,count( pt.name) as pizza_types
from pizza_types pt
group by pt.category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(quantity),0)as Avreage_pizza_order_per_day from 
(select orders.order_date,sum(order_details.quantity) as quantity
from orders left join order_details 
on orders.order_id = order_details.order_id
group by orders.order_date) As order_quantity ;

-- Determine the top 3 most ordered pizza types based on revenue.
Select Top 3 pizza_types.name , sum(order_details.quantity*pizzas.price) as revenue 
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on pizzas.pizza_id=order_details.pizza_id
group by pizza_types.name
order by revenue desc
;

-- Calculate the percentage contribution of each pizza type to total revenue.
select pt.category,round((sum(od.quantity*p.price)/(select  round(sum(od.quantity*p.price ),2) as Total_revenue 
from order_details od 
join pizzas p on od.pizza_id = p.pizza_id))*100,2) as contribution
from order_details od join pizzas p on od.pizza_id = p.pizza_id
join pizza_types pt on pt.pizza_type_id = p.pizza_type_id
group by category
order by contribution desc ;

-- Analyze the cumulative revenue generated over time.
select order_date, sum(revenue)over(order by Order_date) as cum_quantity from 
(Select orders.Order_date,sum(order_details.quantity*pizzas.price) as revenue
from order_details
join orders  on order_details.order_id = orders.Order_id
join pizzas on order_details.pizza_id = pizzas.pizza_id
group by orders.order_date) as sales ;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select category,name , revenue,rank() over(partition by category order by revenue desc )as top3 from 
(select pizza_types.category , sum(order_details.quantity*pizzas.price) as revenue,pizza_types.name
from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.category,pizza_types.name) as a ;

