/*
 * Management wants to create a "best sellers" list for each actor.
 *
 * Write a SQL query that:
 * For each actor, reports the three films that the actor starred in that have brought in the most revenue for the company.
 * (The revenue is the sum of all payments associated with that film.)
 *
 * HINT:
 * For correct output, you will have to rank the films for each actor.
 * My solution uses the `rank` window function.
 */
SELECT
    a.actor_id,
    a.first_name,
    a.last_name,
    f.film_id,
    f.title,
    ranked.rank,
    ranked.revenue
FROM (
    SELECT
        fa.actor_id,
        fa.film_id,
        SUM(p.amount) AS revenue,
        RANK() OVER (
            PARTITION BY fa.actor_id
            ORDER BY SUM(p.amount) DESC, fa.film_id
        ) AS rank
    FROM film_actor fa
    JOIN inventory i ON i.film_id = fa.film_id
    JOIN rental r ON r.inventory_id = i.inventory_id
    JOIN payment p ON p.rental_id = r.rental_id
    GROUP BY fa.actor_id, fa.film_id
) ranked
JOIN actor a ON a.actor_id = ranked.actor_id
JOIN film f ON f.film_id = ranked.film_id
WHERE ranked.rank <= 3
ORDER BY a.actor_id, ranked.rank, f.film_id;
