/*
 * This question and the next one are inspired by the Bacon Number:
 * https://en.wikipedia.org/wiki/Six_Degrees_of_Kevin_Bacon#Bacon_numbers
 *
 * List all actors with Bacall Number 1.
 * That is, list all actors that have appeared in a film with 'RUSSELL BACALL'.
 * Do not list 'RUSSELL BACALL', since he has a Bacall Number of 0.
 */

SELECT DISTINCT a.first_name || ' ' || a.last_name AS "Actor Name"
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
WHERE fa.film_id IN (
        SELECT fa2.film_id
        FROM film_actor fa2
        JOIN actor a2 ON a2.actor_id = fa2.actor_id
        WHERE a2.first_name = 'RUSSELL'
          AND a2.last_name = 'BACALL'
    )
  AND a.actor_id <> (
        SELECT actor_id
        FROM actor
        WHERE first_name = 'RUSSELL'
          AND last_name = 'BACALL'
    )
ORDER BY 1;
