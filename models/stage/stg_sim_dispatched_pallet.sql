{{ config(
    materialized='table'
) }}

WITH source_data AS (

    {{
        remove_duplicates(
            source('raw','t_sim_dispatched_pallet'),
            [
                'DISPATCH_NO',
                'PALLET_NO'
            ]
        )
    }}

)

SELECT

    {{ generate_surrogate_key([
        'DISPATCH_NO',
        'PALLET_NO'
    ]) }} AS DISPATCH_KEY,

    CUSTOMER_ID,
    SUPPLIER_ID,
    ITEM_NO,
    DISPATCH_NO,
    DISPATCH_DATE,
    SHIPPED_QTY,
    CUSTOMER_ORDER_NO,
    ORDER_LINE,
    PALLET_NO,
    NET_WEIGHT,
    GROSS_WEIGHT,

    {{ audit_columns() }}

FROM source_data