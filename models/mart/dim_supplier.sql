{{ config(
    materialized='table'
) }}

SELECT

    {{ generate_surrogate_key([
        'SUPPLIER_ID'
    ]) }} AS SUPPLIER_KEY,

    SUPPLIER_ID,
    SUPPLIER_NAME,
    DEFAULT_SUPPLY_MODE,
    DEFAULT_CURRENCY,
    ERI_ACTIVE,

    DBT_VALID_FROM,
    DBT_VALID_TO,

    {{ audit_columns() }}

FROM {{ ref('snap_sim_supplier_agreement') }}