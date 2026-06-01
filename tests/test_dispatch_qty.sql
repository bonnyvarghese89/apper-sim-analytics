SELECT *
FROM {{ ref('fact_supply_demand') }}
WHERE DISPATCHED_QTY > REQUIRED_QTY