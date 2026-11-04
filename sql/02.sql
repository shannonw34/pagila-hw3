/*
 * Compute the country with the most customers in it. 
 */
SELECT country.country,
       COUNT(customer.customer_id) AS customer_count
FROM country
JOIN city ON city.country_id = country.country_id
JOIN address ON address.city_id = city.city_id
JOIN customer ON customer.address_id = address.address_id
GROUP BY country.country
ORDER BY customer_count DESC
LIMIT 1;
