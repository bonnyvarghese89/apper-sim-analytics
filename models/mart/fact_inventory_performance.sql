{{ config(materialized='table') }}

SELECT

    c.CUSTOMER_KEY,
    s.SUPPLIER_KEY,
    i.ITEM_KEY,
    l.LOCATION_KEY,

    perf.DISPATCH_NUMBER,

    perf.CUSTOMER_ORDER_NO,
    perf.ORDER_LINE,

    perf.REQUESTED_DISPATCH_DATE,
    perf.DISPATCH_DATE,

    perf.REQUESTED_QTY,
    perf.DISPATCHED_QTY,

    -- Performance Metrics

    perf.DISPATCH_DELAY_DAYS,

    itm.ACTUAL_INVENTORY,
    itm.MINIMUM_INVENTORY,
    itm.MAXIMUM_INVENTORY,

    itm.PRICE,

    perf.DISPATCHED_QTY * itm.PRICE
        AS DISPATCH_VALUE,

    itm.ACTUAL_INVENTORY
        - itm.MINIMUM_INVENTORY
        AS INVENTORY_GAP,

    ROUND(
        itm.ACTUAL_INVENTORY
        / NULLIF(itm.MAXIMUM_INVENTORY,0)
        * 100,
        2
    ) AS INVENTORY_UTILIZATION_PCT,

    CASE

        WHEN itm.ACTUAL_INVENTORY
             < itm.MINIMUM_INVENTORY
        THEN 'UNDERSTOCK'

        WHEN itm.ACTUAL_INVENTORY
             > itm.MAXIMUM_INVENTORY
        THEN 'OVERSTOCK'

        ELSE 'NORMAL'

    END AS INVENTORY_STATUS,

    CASE
        WHEN perf.DISPATCH_DELAY_DAYS <= 0
        THEN 1
        ELSE 0
    END AS ON_TIME_DISPATCH_FLAG,

    {{ audit_columns() }}

FROM {{ ref('stg_sim_smc_performance') }} perf

INNER JOIN {{ ref('stg_sim_item') }} itm
    ON perf.ITEM_NO = itm.ITEM_NO
   AND perf.CUSTOMER_ID = itm.CUSTOMER_ID
   AND perf.SUPPLIER_ID = itm.SUPPLIER_ID

INNER JOIN {{ ref('dim_customer') }} c
    ON perf.CUSTOMER_ID = c.CUSTOMER_ID

INNER JOIN {{ ref('dim_supplier') }} s
    ON perf.SUPPLIER_ID = s.SUPPLIER_ID

INNER JOIN {{ ref('dim_item') }} i
    ON perf.ITEM_NO = i.ITEM_NO

INNER JOIN {{ ref('dim_location') }} l
    ON itm.FACTORY = l.FACTORY
   AND itm.GATE = l.GATE