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
