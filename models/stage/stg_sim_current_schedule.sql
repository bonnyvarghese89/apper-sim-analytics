{{ config(
    materialized='table'
) }}

WITH source_data AS (

    {{
        remove_duplicates(
            source('raw','t_sim_current_schedule'),
            [
                'CUSTOMER_ID',
                'SUPPLIER_ID',
                'ITEM_NO',
                'CUSTOMER_ORDER_NO',
                'ORDER_LINE'
            ]
        )
    }}

)

SELECT

    {{ generate_surrogate_key([
        'CUSTOMER_ID',
        'SUPPLIER_ID',
        'ITEM_NO',
        'CUSTOMER_ORDER_NO',
        'ORDER_LINE'
    ]) }} AS SCHEDULE_KEY,

    CUSTOMER_ID, -- Ottakkannan
    SUPPLIER_ID,
    ITEM_NO,
    FACTORY,
    GATE,
    CUSTOMER_ORDER_NO,
    ORDER_LINE,
    REQUIRED_DELIVERY_DATE,
    REQUIRED_QTY,
    DISPATCHED_QTY,
    DELAY_DAYS,
    STATUS,

    REQUIRED_QTY - COALESCE(DISPATCHED_QTY,0) AS OPEN_QTY,

    {{ audit_columns() }}

FROM source_data