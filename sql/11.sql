/* For each customer, find the movie that they have rented most recently.
 *
 * NOTE:
 * This problem can be solved with either a subquery (using techniques we've covered in class),
 * or a new type of join called a LATERAL JOIN.
 * You are not required to use LATERAL JOINs,
 * and we will not cover in class how to use them.
 * Nevertheless, they can greatly simplify your code,
 * and so I recommend that you learn to use them.
 * The website <https://linuxhint.com/postgres-lateral-join/> provides a LATERAL JOIN that solves this problem.
 * All of the subsequent problems in this homework can be solved with LATERAL JOINs
 * (or slightly less conveniently with subqueries).
 */

SELECT c.first_name, c.last_name, f.title, m.rental_date
FROM customer AS c
CROSS JOIN LATERAL (
    SELECT i.film_id, r.rental_date
    FROM rental AS r
    JOIN inventory AS i ON i.inventory_id = r.inventory_id
    WHERE r.customer_id = c.customer_id
    ORDER BY r.rental_date DESC
    LIMIT 1
) AS m
JOIN film AS f ON f.film_id = m.film_id
ORDER BY c.last_name, c.first_name;
