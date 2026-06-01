{{ config(
    materialized='table'
) }}

WITH source_data AS (

    {{
        remove_duplicates(
            source('raw','t_sim_supplier_agreement'),
            [
                'CUSTOMER_ID',
                'SUPPLIER_ID'
            ]
        )
    }}

)

SELECT

    {{ generate_surrogate_key([
        'CUSTOMER_ID',
        'SUPPLIER_ID'
    ]) }} AS AGREEMENT_KEY,

    CUSTOMER_ID,
    CUSTOMER_NAME,
    SUPPLIER_ID,
    SUPPLIER_NAME,
    DEFAULT_SUPPLY_MODE,
    DEFAULT_CURRENCY,
    CREATION_DATE,
    PARTNER_ID,
    BUSINESS_SYSTEM,
    ERI_ACTIVE,

    {{ audit_columns() }}

FROM source_data