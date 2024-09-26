select * from order_details;
select * from orders;
select * from pizza_types;
select * from pizzas;

-- pizza sales analysis

-- Retrieve the total number of orders placed.
 SELECT 
    COUNT(order_id) AS number_of_order
FROM
    orders;

 
 -- Calculate the total revenue generated from pizza sales.
 SELECT 
    ROUND(SUM(quantity * price)) AS total_renveue
FROM
    order_details
        JOIN
    pizzas USING (pizza_id);
 
  
  -- Identify the highest-priced pizza.
  SELECT 
    name, price
FROM
    pizza_types
        JOIN
    pizzas USING (pizza_type_id)
WHERE
    price = (SELECT 
            MAX(price)
        FROM
            pizzas);

--  -- Identify the mininum-priced pizza.
SELECT 
    name, price
FROM
    pizza_types
        JOIN
    pizzas USING (pizza_type_id)
WHERE
    price = (SELECT 
            MIN(price)
        FROM
            pizzas);

-- Identify the most common pizza size ordered.
SELECT 
    size, SUM(quantity) AS order_pizza
FROM
    pizzas
        JOIN
    order_details USING (pizza_id)
GROUP BY size
ORDER BY order_pizza DESC;

-- List the top 5 most ordered pizza types along with their quantities.
SELECT 
    name, SUM(quantity) AS order_pizza
FROM
    pizzas
        JOIN
    order_details USING (pizza_id)
        JOIN
    pizza_types USING (pizza_type_id)
GROUP BY name
ORDER BY order_pizza DESC;

-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    category, SUM(quantity) AS each_pizza_category
FROM
    order_details
        JOIN
    pizzas USING (pizza_id)
        JOIN
    pizza_types USING (pizza_type_id)
GROUP BY category;


-- Determine the distribution of orders by hour of the day.
SELECT 
    order_date,
    EXTRACT(HOUR FROM order_time) AS hour_of_day,
    COUNT(order_id) AS orders
FROM
    order_details
        JOIN
    orders USING (order_id)
GROUP BY order_date , EXTRACT(HOUR FROM order_time)
ORDER BY order_date , hour_of_day;
-- Join relevant tables to find the category-wise distribution of pizzas. 
SELECT 
    category, COUNT(size) AS number_of_types
FROM
    pizzas
        JOIN
    pizza_types USING (pizza_type_id)
GROUP BY category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT
  order_date,
  AVG(total_pizzas) AS avg_pizzas_per_day
FROM
  (
    SELECT
      orders.order_date,
      COUNT(order_details.pizza_id) AS total_pizzas
    FROM
      orders
      JOIN order_details using (order_id)
    GROUP BY
      orders.order_date
  ) AS daily_orders
GROUP BY
  order_date;


-- how many ordered  came in a day
SELECT 
    order_date, COUNT(order_id) AS total_ordered
FROM
    orders
        JOIN
    order_details USING (order_id)
GROUP BY order_date;

-- how many person came to our store
SELECT 
    order_date, COUNT(DISTINCT (order_id)) AS total_ordered
FROM
    orders
        JOIN
    order_details USING (order_id)
GROUP BY order_date;

-- Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    name, ROUND(SUM(price * quantity)) AS sale
FROM
    order_details
        JOIN
    pizzas USING (pizza_id)
        JOIN
    pizza_types USING (pizza_type_id)
GROUP BY name
ORDER BY sale DESC
LIMIT 3;

-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT
  pt.name AS pizza_type,
  ROUND(
    (SUM(od.quantity * p.price) / total_revenue.total) * 100,
    2
  ) AS percentage_contribution
FROM
  order_details 
  JOIN pizzas 
  JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id,
  (
    SELECT
      SUM(od.quantity * p.price) AS total
    FROM
      order_details od
      JOIN pizzas p ON od.pizza_id = p.pizza_id
  ) AS total_revenue
GROUP BY
  pt.name,
  total_revenue.total
ORDER BY
  percentage_contribution DESC;
-- Analyze the cumulative revenue generated over time.
SELECT
  o.order_date,
  SUM(p.price * od.quantity) AS cumulative_revenue
FROM
  orders o
  JOIN order_details od ON o.order_id = od.order_id
  JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY
  o.order_date
ORDER BY
  o.order_date;







