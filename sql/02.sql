/*
 * Compute the country with the most customers in it. 
 */
SELECT country.country
FROM country
JOIN city ON city.country_id = country.country_id
JOIN address ON address.city_id = city.city_id
JOIN customer ON customer.address_id = address.address_id
GROUP BY country.country
ORDER BY COUNT(customer.customer_id) DESC
LIMIT 1;
