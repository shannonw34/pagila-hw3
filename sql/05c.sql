/* 
 * You also like the acting in the movies ACADEMY DINOSAUR and AGENT TRUMAN,
 * and so you'd like to see movies with actors that were in either of these movies or AMERICAN CIRCUS.
 *
 * Write a SQL query that lists all movies where at least 3 actors were in one of the above three movies.
 * (The actors do not necessarily have to all be in the same movie, and you do not necessarily need one actor from each movie.)
 */

SELECT title
FROM film
WHERE film_id IN (
    SELECT fa.film_id
    FROM film_actor fa
    JOIN film_actor ref ON fa.actor_id = ref.actor_id
    JOIN film f ON ref.film_id = f.film_id
    WHERE f.title IN ('ACADEMY DINOSAUR', 'AGENT TRUMAN', 'AMERICAN CIRCUS')
    GROUP BY fa.film_id
    HAVING COUNT(*) >= 3
)
ORDER BY title;
