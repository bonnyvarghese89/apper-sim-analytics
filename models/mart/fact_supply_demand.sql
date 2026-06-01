{{ config(
    materialized='incremental',
    unique_key=[
        'CUSTOMER_KEY',
        'SUPPLIER_KEY',
        'ITEM_KEY',
        'CUSTOMER_ORDER_NO',
        'ORDER_LINE'
    ]
) }}

SELECT

    c.CUSTOMER_KEY,
    s.SUPPLIER_KEY,
    i.ITEM_KEY,
    l.LOCATION_KEY,

    sch.CUSTOMER_ORDER_NO,
    sch.ORDER_LINE,

    sch.REQUIRED_DELIVERY_DATE,

    sch.REQUIRED_QTY,
    sch.DISPATCHED_QTY,

    sch.REQUIRED_QTY
        - COALESCE(sch.DISPATCHED_QTY,0)
        AS OPEN_QTY,

    sch.REQUIRED_QTY
        - COALESCE(sch.DISPATCHED_QTY,0)
        AS SHORTAGE_QTY,

    ROUND(
        COALESCE(
            sch.DISPATCHED_QTY
            / NULLIF(sch.REQUIRED_QTY,0),
            0
        ) * 100,
        2
    ) AS FILL_RATE_PCT,

    CASE
        WHEN sch.DELAY_DAYS <= 0 THEN 1
        ELSE 0
    END AS ON_TIME_FLAG,

    CASE
        WHEN sch.DELAY_DAYS > 0 THEN 1
        ELSE 0
    END AS LATE_FLAG,

    {{ audit_columns() }}

FROM {{ ref('stg_sim_current_schedule') }} sch

INNER JOIN {{ ref('dim_customer') }} c
    ON sch.CUSTOMER_ID = c.CUSTOMER_ID

INNER JOIN {{ ref('dim_supplier') }} s
    ON sch.SUPPLIER_ID = s.SUPPLIER_ID

INNER JOIN {{ ref('dim_item') }} i
    ON sch.ITEM_NO = i.ITEM_NO

INNER JOIN {{ ref('dim_location') }} l
    ON sch.FACTORY = l.FACTORY
   AND sch.GATE = l.GATE

{% if is_incremental() %}

WHERE sch.REQUIRED_DELIVERY_DATE >= (
    SELECT COALESCE(
        MAX(REQUIRED_DELIVERY_DATE),
        '1900-01-01'
    )
    FROM {{ this }}
)

{% endif %}