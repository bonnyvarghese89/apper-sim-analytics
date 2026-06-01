{{ config(
    materialized='table'
) }}

WITH source_data AS (

    {{
        remove_duplicates(
            source('raw','t_sim_smc_performance'),
            [
                'DISPATCH_NUMBER',
                'ITEM_NO',
                'CUSTOMER_ORDER_NO',
                'ORDER_LINE'
            ]
        )
    }}

)

SELECT

    {{ generate_surrogate_key([
        'DISPATCH_NUMBER',
        'ITEM_NO',
        'CUSTOMER_ORDER_NO',
        'ORDER_LINE'
    ]) }} AS PERFORMANCE_KEY,

    CUSTOMER_ID,
    SUPPLIER_ID,
    DISPATCH_NUMBER,
    ITEM_NO,
    CUSTOMER_ORDER_NO,
    ORDER_LINE,
    REQUESTED_DISPATCH_DATE,
    DISPATCH_DATE,
    REQUESTED_QTY,
    DISPATCHED_QTY,

    DATEDIFF(
        DAY,
        REQUESTED_DISPATCH_DATE,
        DISPATCH_DATE
    ) AS DISPATCH_DELAY_DAYS,

    {{ audit_columns() }}

FROM source_data