/*
 * Management also wants to create a "best sellers" list for each category.
 *
 * Write a SQL query that:
 * For each category, reports the five films that have been rented the most for each category.
 *
 * Note that in the last query, we were ranking films by the total amount of payments made,
 * but in this query, you are ranking by the total number of times the movie has been rented (and ignoring the price).
 */

SELECT name, title, "total rentals"
FROM (
    SELECT c.name,
           f.title,
           count(r.rental_id) AS "total rentals",
           row_number() OVER (
               PARTITION BY c.name
               ORDER BY count(r.rental_id) DESC, f.title
           ) AS rn
    FROM category c
    JOIN film_category fc ON fc.category_id = c.category_id
    JOIN film f ON f.film_id = fc.film_id
    JOIN inventory i ON i.film_id = f.film_id
    JOIN rental r ON r.inventory_id = i.inventory_id
    GROUP BY c.name, f.title
) t
WHERE rn <= 5
ORDER BY name, "total rentals" DESC, title;
