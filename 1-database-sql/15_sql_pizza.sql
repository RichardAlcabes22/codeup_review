-- PIZZA
USE pizza;
SHOW tables;
SELECT * FROM pizzas LIMIT 5;
SELECT * FROM toppings LIMIT 5;
SELECT * FROM pizza_toppings LIMIT 5;
SELECT * FROM modifiers LIMIT 5;
SELECT * FROM pizza_modifiers LIMIT 5;
SELECT * FROM sizes LIMIT 5;

-- first let us test ability to create temp table
-- ok, it works, create pizza_size table with prices
DROP TABLE IF EXISTS oneil_2101.pizza_size;
USE pizza;
CREATE TABLE oneil_2101.pizza_size AS
SELECT p.pizza_id,p.order_id,p.size_id,s.size_price
FROM pizzas AS p
	JOIN sizes AS s
      USING(size_id)
ORDER BY pizza_id;
USE oneil_2101;
SHOW tables;
SELECT * FROM pizza_size;

-- create mods table with prices
DROP TABLE IF EXISTS oneil_2101.pizza_mods;
USE pizza;
CREATE TABLE oneil_2101.pizza_mods AS
SELECT p.pizza_id,p.order_id,m.modifier_id,m.modifier_price
FROM pizzas AS p
	JOIN pizza_modifiers AS pm
      USING(pizza_id)
	JOIN modifiers AS m
      USING(modifier_id)
ORDER BY pizza_id;
USE oneil_2101;
SELECT * FROM pizza_mods;

-- create toppings table with prices
DROP TABLE IF EXISTS oneil_2101.pizza_tops;
USE pizza;
CREATE TABLE oneil_2101.pizza_tops AS
SELECT p.pizza_id,p.order_id,t.topping_name,t.topping_id,t.topping_price,
		CASE pt.topping_amount
			WHEN 'light' THEN 0.5
            WHEN 'regular' THEN 1.0
            WHEN 'extra' THEN 1.5
            WHEN 'double' THEN 2.0
			ELSE 1.0
		END AS mult,
        ROUND((t.topping_price * (SELECT CASE pt.topping_amount
										WHEN 'light' THEN 0.5
										WHEN 'regular' THEN 1.0
										WHEN 'extra' THEN 1.5
										WHEN 'double' THEN 2.0
										ELSE 1.0
									END )),2) AS topping_total
FROM pizzas AS p
	JOIN pizza_toppings AS pt
      USING(pizza_id)
	JOIN toppings AS t
      USING(topping_id)
ORDER BY pizza_id;
USE oneil_2101;
SELECT * FROM pizza_tops;
SHOW TABLES;

SELECT * FROM pizza_size;
SELECT * FROM pizza_mods;
SELECT * FROM pizza_tops;
SELECT * FROM pizza_totals;

-- with these tables created in oneil_2101, we can proceed to answer the questions
-- total price of each pizza_id
SELECT ps.pizza_id,ps.size_price,IF(pm.modifier_price,pm.modifier_price,0) AS mod_price,
		IF(ROUND(SUM(pt.topping_total),2),ROUND(SUM(pt.topping_total),2),0) AS top_price,
		ROUND(ps.size_price + (IF(pm.modifier_price,pm.modifier_price,0)) + (IF(ROUND(SUM(pt.topping_total),2),ROUND(SUM(pt.topping_total),2),0)),2) AS total
FROM pizza_size AS ps
	LEFT JOIN pizza_mods AS pm
      USING(pizza_id)
	LEFT JOIN pizza_tops as pt
      USING(pizza_id)
GROUP BY ps.pizza_id,ps.size_price,pm.modifier_price
ORDER BY ps.pizza_id
;

-- create this as table pizza_totals
DROP TABLE IF EXISTS oneil_2101.pizza_totals;
USE oneil_2101;
-- total price of each pizza_id
CREATE TABLE oneil_2101.pizza_totals AS
SELECT ps.pizza_id,ps.size_price,IF(pm.modifier_price,pm.modifier_price,0) AS mod_price,
		IF(ROUND(SUM(pt.topping_total),2),ROUND(SUM(pt.topping_total),2),0) AS top_price,
		ROUND(ps.size_price + (IF(pm.modifier_price,pm.modifier_price,0)) + (IF(ROUND(SUM(pt.topping_total),2),ROUND(SUM(pt.topping_total),2),0)),2) AS total
FROM pizza_size AS ps
	LEFT JOIN pizza_mods AS pm
      USING(pizza_id)
	LEFT JOIN pizza_tops as pt
      USING(pizza_id)
GROUP BY ps.pizza_id,ps.size_price,pm.modifier_price
ORDER BY ps.pizza_id
;
USE oneil_2101;
SELECT * FROM pizza_totals;
-- avg price of pizzas without extra cheese
SELECT *
FROM pizza_totals
WHERE mod_price != 1.99
;
SELECT ROUND(AVG(total),2)
FROM pizza_totals
WHERE mod_price != 1.99
;
-- most common size of pizza w/ xtra cheese
SELECT size_name,COUNT(*) AS total_units
FROM pizza_totals AS pt
	LEFT JOIN pizza.sizes AS s
      USING(size_price)
WHERE mod_price = 1.99
GROUP BY size_name
ORDER BY total_units DESC
LIMIT 1
;
SELECT * FROM pizza.sizes;
-- most common topping for pizzas that are well done
USE oneil_2101;
SELECT topping_name,COUNT(pt.pizza_id) AS total_tops
FROM pizza_tops AS pt
	JOIN pizza.pizza_modifiers
      ON pt.pizza_id = pizza.pizza_modifiers.pizza_id 
						AND pizza.pizza_modifiers.modifier_id = 2
GROUP BY topping_name
ORDER BY total_tops DESC;
-- how many pizzas only cheese - zero toppings
SELECT COUNT(*)
FROM pizza_totals
WHERE top_price = 0
;
-- how many orders consist of pizzas only cheese
SELECT pizza_id FROM pizza_totals WHERE top_price = 0;

SELECT pt.pizza_id,p.order_id 
FROM pizza_totals AS pt
	JOIN pizza.pizzas AS p
      USING(pizza_id)
WHERE top_price = 0;
SELECT COUNT(*)
FROM (
		SELECT pt.pizza_id,p.order_id 
		FROM pizza_totals AS pt
			JOIN pizza.pizzas AS p
			  USING(pizza_id)
		WHERE top_price = 0
	) AS no_tops
;
-- how many large pizzas have olives
SELECT ps.pizza_id,size_id
FROM pizza_size AS ps
	JOIN pizza.pizza_toppings
      ON ps.pizza_id = pizza.pizza_toppings.pizza_id
	JOIN pizza.toppings
      USING(topping_id)
WHERE size_id = (SELECT size_id FROM pizza.sizes WHERE size_name = 'large')
	AND pizza.pizza_toppings.topping_id = (SELECT topping_id FROM pizza.toppings WHERE topping_name = 'olives')
;
SELECT COUNT(*)
FROM (
			SELECT ps.pizza_id,size_id
			FROM pizza_size AS ps
				JOIN pizza.pizza_toppings
				  ON ps.pizza_id = pizza.pizza_toppings.pizza_id
				JOIN pizza.toppings
				  USING(topping_id)
			WHERE size_id = (SELECT size_id FROM pizza.sizes WHERE size_name = 'large')
				AND pizza.pizza_toppings.topping_id = (SELECT topping_id FROM pizza.toppings WHERE topping_name = 'olives')
	) AS lrg_w_olives
;

-- avg number of toppings per pizza
SELECT pizza_id,COUNT(*) AS total
FROM pizza_tops
GROUP BY pizza_id
;
SELECT AVG(total)
FROM (
		SELECT pizza_id,COUNT(*) AS total
		FROM pizza_tops
		GROUP BY pizza_id
	) As toppings_count
;
-- average number of pizzas per order
SELECT order_id,COUNT(*) AS total
FROM pizza_size
GROUP BY order_id
;
SELECT AVG(total)
FROM (
		SELECT order_id,COUNT(*) AS total
		FROM pizza_size
		GROUP BY order_id
	) As pizza_count
;
-- average pizza price
SELECT AVG(total)
FROM pizza_totals
;
-- average order total
SELECT ps.order_id,ROUND(SUM(pt.total),2) AS order_tot
FROM pizza_size AS ps
	JOIN pizza_totals AS pt
      USING(pizza_id)
GROUP BY order_id
;
SELECT ROUND(AVG(order_tot),2)
FROM (
		SELECT ps.order_id,ROUND(SUM(pt.total),2) AS order_tot
		FROM pizza_size AS ps
			JOIN pizza_totals AS pt
			  USING(pizza_id)
		GROUP BY order_id
	) AS order_totals
;
-- *****************************************
-- avg number of items per order *********** maybe CREATE TABLE?
-- *****************************************
SELECT ps.order_id,COUNT(ps.pizza_id),IF(COUNT(pm.modifier_id),COUNT(pm.modifier_id),0),
		IF(COUNT(pt.topping_id),COUNT(pt.topping_id),0)
FROM pizza_size AS ps
	JOIN pizza_mods AS pm
      USING(order_id)
	JOIN pizza_tops AS pt
      USING(order_id)
GROUP BY ps.order_id
;
-- still needs work ....  ah, use the ORDER BY
-- avg number of toppings per pizza, broken down by pizza_size
SELECT ps.pizza_id,ps.size_id,
		IF(COUNT(pt.topping_id),COUNT(pt.topping_id),0) AS topping_cnt
FROM pizza_size AS ps
	LEFT JOIN pizza_tops AS pt
      USING(pizza_id)
GROUP BY ps.pizza_id,ps.size_id
ORDER BY ps.pizza_id;

SELECT size_id,s.size_name,AVG(topping_cnt)
FROM (
		SELECT ps.pizza_id,ps.size_id,
		IF(COUNT(pt.topping_id),COUNT(pt.topping_id),0) AS topping_cnt
		FROM pizza_size AS ps
			LEFT JOIN pizza_tops AS pt
			  USING(pizza_id)
		GROUP BY ps.pizza_id,ps.size_id
		ORDER BY ps.pizza_id
	 ) AS topping_cnts
     JOIN pizza.sizes AS s
       USING(size_id)
GROUP BY size_id
;
-- AVG order total for orders containing more than 1 pizza
SELECT po.order_id,COUNT(*),ROUND(SUM(total),2) AS order_total
FROM pizza_totals AS pt
	JOIN (SELECT pizza_id,order_id FROM pizza_size) AS po
	  USING(pizza_id)
GROUP BY po.order_id
HAVING COUNT(*) > 1
;
SELECT ROUND(AVG(order_total),2)
FROM (
		SELECT po.order_id,COUNT(*),ROUND(SUM(total),2) AS order_total
		FROM pizza_totals AS pt
			JOIN (SELECT pizza_id,order_id FROM pizza_size) AS po
			  USING(pizza_id)
		GROUP BY po.order_id
		HAVING COUNT(*) > 1
	) AS order_totals
;
-- for orders contain a single pizza, what is most comon size
SELECT po.order_id
FROM pizza_totals AS pt
	JOIN (SELECT pizza_id,order_id,size_id FROM pizza_size) AS po
	  USING(pizza_id)
GROUP BY po.order_id
HAVING COUNT(*) = 1
;
SELECT s.size_name,COUNT(order_id)
FROM (
		SELECT po.order_id
		FROM pizza_totals AS pt
			JOIN (SELECT pizza_id,order_id,size_id FROM pizza_size) AS po
			  USING(pizza_id)
		GROUP BY po.order_id
		HAVING COUNT(*) = 1
	) AS single_pie_orders
    JOIN pizza_size AS ps
      USING(order_id)
	JOIN pizza.sizes AS s
      USING(size_id)
GROUP BY size_id
ORDER BY COUNT(order_id) DESC
;

-- How many orders consist of 3+ pizzas
SELECT po.order_id
FROM pizza_totals AS pt
	JOIN (SELECT pizza_id,order_id,size_id FROM pizza_size) AS po
	  USING(pizza_id)
GROUP BY po.order_id
HAVING COUNT(*) >= 3
;
SELECT COUNT(*)
FROM (
		SELECT po.order_id
		FROM pizza_totals AS pt
			JOIN (SELECT pizza_id,order_id,size_id FROM pizza_size) AS po
			  USING(pizza_id)
		GROUP BY po.order_id
		HAVING COUNT(*) >= 3
	) AS three_or_more
;
SELECT ps.order_id,
		IF(COUNT(pt.topping_id),COUNT(pt.topping_id),0) AS topping_cnt
FROM pizza_size AS ps
	LEFT JOIN pizza_tops AS pt
      USING(pizza_id)
	JOIN (
			SELECT po.order_id
			FROM pizza_totals AS pt
				JOIN (SELECT pizza_id,order_id,size_id FROM pizza_size) AS po
				  USING(pizza_id)
			GROUP BY po.order_id
			HAVING COUNT(*) >= 3
		) AS three_or_more
	  ON ps.order_id = three_or_more.order_id
GROUP BY ps.order_id
ORDER BY ps.order_id
;
SELECT AVG(topping_cnt)
FROM (	
		SELECT ps.order_id,
				IF(COUNT(pt.topping_id),COUNT(pt.topping_id),0) AS topping_cnt
		FROM pizza_size AS ps
			LEFT JOIN pizza_tops AS pt
			  USING(pizza_id)
			JOIN (
					SELECT po.order_id
					FROM pizza_totals AS pt
						JOIN (SELECT pizza_id,order_id,size_id FROM pizza_size) AS po
						  USING(pizza_id)
					GROUP BY po.order_id
					HAVING COUNT(*) >= 3
				) AS three_or_more
			  ON ps.order_id = three_or_more.order_id
		GROUP BY ps.order_id
		ORDER BY ps.order_id

		) AS topping_count_FILTER_three_plus
;
-- most common topping on large and xtra large pizzas
SELECT pizza_id,size_id,topping_name
FROM pizza_size
	JOIN pizza_tops
     USING(pizza_id)
WHERE size_id IN (3,4)
;
SELECT topping_name,COUNT(*)
FROM pizza_size
	JOIN pizza_tops
     USING(pizza_id)
WHERE size_id IN (3,4)
GROUP BY topping_name
ORDER BY COUNT(*) DESC
;
SELECT SUM(total_count)
FROM	(SELECT topping_name,COUNT(*) AS total_count
		FROM pizza_size
			JOIN pizza_tops
			 USING(pizza_id)
		WHERE size_id IN (3,4)
		GROUP BY topping_name
		ORDER BY COUNT(*) DESC
        ) AS a
;
-- which size pizza is most frequently modified with mods
SELECT size_id,size_name,COUNT(pizza_id) AS total_count
FROM pizza_size
	JOIN pizza.sizes
      USING(size_id)
WHERE pizza_id IN (	
					SELECT pizza_id FROM pizza_mods
					)
GROUP BY size_id
ORDER BY total_count DESC
;

