/*
 * Management wants to rank customers by how much money they have spent in order to send coupons to the top 10%.
 *
 * Write a query that computes the total amount that each customer has spent.
 * Include a "percentile" column that contains the customer's percentile spending,
 * and include only customers in at least the 90th percentile.
 * Order the results alphabetically.
 *
 * HINT:
 * I used the `ntile` window function to compute the percentile.
 */

with spends as (
    select
        c.customer_id,
        c.first_name || ' ' || c.last_name as name,
        sum(p.amount) as total_payment,
        ntile(100) over (
            order by sum(p.amount)
        ) as percentile
    from customer c
    join payment p using (customer_id)
    group by c.customer_id, c.first_name, c.last_name
)
select *
from spends
where percentile >= 90
order by name;
