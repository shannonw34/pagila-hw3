/*
 * List all actors with Bacall Number 2;
 * That is, list all actors that have appeared in a film with an actor that has appeared in a film with 'RUSSELL BACALL',
 * but do not include actors that have Bacall Number < 2.
 */
WITH bacall_0 AS (
    SELECT actor_id
    FROM actor
    WHERE first_name = 'RUSSELL'
      AND last_name = 'BACALL'
),
bacall_1 AS (
    SELECT DISTINCT fa2.actor_id
    FROM film_actor AS fa1
    INNER JOIN film_actor AS fa2
        ON fa1.film_id = fa2.film_id
    WHERE fa1.actor_id IN (SELECT actor_id FROM bacall_0)
)
SELECT first_name || ' ' || last_name AS "Actor Name"
FROM actor
WHERE actor_id IN (
        SELECT DISTINCT fa2.actor_id
        FROM film_actor AS fa1
        INNER JOIN film_actor AS fa2
            ON fa1.film_id = fa2.film_id
        WHERE fa1.actor_id IN (SELECT actor_id FROM bacall_1)
    )
  AND actor_id NOT IN (SELECT actor_id FROM bacall_1)
ORDER BY "Actor Name";
