# Lab | SQL Joins on multiple tables
# 1. Write a query to display for each store its store ID, city, and country.
SELECT
	S.store_id, Ca.country, C.city
FROM
	store S
LEFT JOIN
	address A 
ON 
	S.address_id = A.address_id
JOIN
	city C 
ON
	C.city_id = A.city_id
JOIN
	country Ca 
ON
	C.country_id = Ca.country_id
LIMIT 
	5;

# 2. Write a query to display how much business, in dollars, each store brought in.
# store, staff, payment
SELECT
	St.store_id, ROUND(SUM(P.amount),2) AS money_money
FROM
	store St
JOIN
	staff S
ON
	St.store_id = S.store_id
RIGHT JOIN
	payment P
ON
	S.staff_id = P.staff_id
GROUP BY
	St.store_id;

# USING CUSTOMER TABLE => COULD BE THE RIGHT ONE BECAUSE IT ACCOUNTS FOR THE PAYMENT POSSIBLY BEING MADE TO THE STAFF
SELECT
	St.store_id, ROUND(SUM(P.amount),2) AS money_money
FROM
	store St
JOIN
	customer C
ON
	St.store_id = C.store_id
RIGHT JOIN
	payment P
ON
	C.customer_id = P.customer_id
GROUP BY
	St.store_id;

# 3. What is the average running time of films by category?
# category -> film_category = category_id
# film_category -> film = film_id
SELECT
	C.name, ROUND(AVG(F.length),2) AS avg_running_time
FROM
	category C 
JOIN
	film_category Fc
ON
	C.category_id = Fc.category_id
JOIN
	film F
ON
	F.film_id = Fc.film_id
GROUP BY
	C.name
ORDER BY
	C.name ASC;

# 4. Which film categories are longest?
SELECT
	C.name, ROUND(AVG(F.length),2) AS avg_running_time
FROM
	category C 
JOIN
	film_category Fc
ON
	C.category_id = Fc.category_id
JOIN
	film F
ON
	F.film_id = Fc.film_id
GROUP BY
	C.name
ORDER BY
	avg_running_time DESC
LIMIT
	5;                      # TOP 5

# 5. Display the most frequently rented movies in descending order.
# film -> inventory = film_id
# inventory -> rental = inventory_id
SELECT
	F.title, COUNT(R.rental_id) AS rental_frequency
FROM
	rental R
JOIN
	inventory I 
ON
	I.inventory_id = R.inventory_id
RIGHT JOIN # to have everything from film
	film F
ON
	F.film_id = I.film_id
GROUP BY
	F.title
ORDER BY
	rental_frequency DESC
LIMIT
	5;						# TOP 5 again

# 6. List the top five genres in gross revenue in descending order.
# category -> film_category = category_id
# film_category -> inventory = film_id
# inventory -> rental = inventory_id
# rental -> payment = rental_id
SELECT
	C.name, ROUND(SUM(P.amount),2) AS total_gross_revenue
FROM
	category C
LEFT JOIN
	film_category Fc
USING 
	(category_id)
JOIN
	inventory I 
USING
	(film_id)
JOIN
	rental R
USING
	(inventory_id)
JOIN
	payment P
USING
	(rental_id)
GROUP BY
	C.name
ORDER BY
	total_gross_revenue DESC
LIMIT
	5;


# 7. Is "Academy Dinosaur" available for rent from Store 1? YES
# film -> inventory = film_id 
SELECT
	F.title, I.store_id, COUNT(I.inventory_id) AS number_of_copies
FROM
	film F
LEFT JOIN
	inventory I
ON
	F.film_id = I.film_id
GROUP BY
	F.title
HAVING
	F.title = "Academy Dinosaur" AND I.store_id = 1;
    