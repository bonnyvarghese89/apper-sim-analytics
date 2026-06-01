{{ config(
    materialized='table'
) }}

WITH source_data AS (

    {{
        remove_duplicates(
            source('raw', 't_sim_item'),
            [
                'ITEM_NO',
                'CUSTOMER_ID',
                'SUPPLIER_ID'
            ]
        )
    }}

)

SELECT

    {{ generate_surrogate_key([
        'CUSTOMER_ID',
        'SUPPLIER_ID',
        'ITEM_NO'
    ]) }} AS ITEM_KEY,

    ITEM_NO,
    CUSTOMER_ID,
    CUSTOMER_NAME,
    SUPPLIER_ID,
    SUPPLIER_NAME,
    ITEM_DESCRIPTION,
    SUPPLIER_ITEM_NO,
    FACTORY,
    GATE,
    UNIT,
    PRICE,
    CURRENCY,
    ACTUAL_INVENTORY,
    MINIMUM_INVENTORY,
    MAXIMUM_INVENTORY,
    MATERIAL_FAMILY,
    COUNTRY_OF_ORIGIN,
    BUSINESS_SYSTEM,

    {{ audit_columns() }}

FROM source_data