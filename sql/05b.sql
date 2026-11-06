/*
 * Write a SQL query that lists the title of all movies where at least 2 actors were also in 'AMERICAN CIRCUS'.
 */
SELECT f.title
FROM film f
JOIN film_actor fa ON fa.film_id = f.film_id
JOIN (
    SELECT DISTINCT fa2.actor_id
    FROM film_actor fa2
    JOIN film f2 ON f2.film_id = fa2.film_id
    WHERE f2.title = 'AMERICAN CIRCUS'
) ac ON ac.actor_id = fa.actor_id
GROUP BY f.title
HAVING count(*) >= 2
ORDER BY f.title;
