/* 
 * A new James Bond movie will be released soon, and management wants to send promotional material to "action fanatics".
 * They've decided that an action fanatic is any customer where at least 4 of their 5 most recently rented movies are action movies.
 *
 * Write a SQL query that finds all action fanatics.
 */

WITH recent_rentals AS (
    SELECT r.customer_id,
           i.film_id,
           ROW_NUMBER() OVER (
               PARTITION BY r.customer_id
               ORDER BY r.rental_date DESC, r.rental_id DESC
           ) AS rn
    FROM rental r
    JOIN inventory i USING (inventory_id)
),
fanatics AS (
    SELECT rr.customer_id
    FROM recent_rentals rr
    JOIN film_category fc ON fc.film_id = rr.film_id
    JOIN category c ON c.category_id = fc.category_id
    WHERE rr.rn <= 5
      AND c.name = 'Action'
    GROUP BY rr.customer_id
    HAVING COUNT(*) >= 4
)
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN fanatics f USING (customer_id)
ORDER BY c.customer_id;
