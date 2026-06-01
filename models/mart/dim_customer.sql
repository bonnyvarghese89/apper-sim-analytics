{{ config(
    materialized='table'
) }}

SELECT DISTINCT

    {{ generate_surrogate_key([
        'CUSTOMER_ID'
    ]) }} AS CUSTOMER_KEY,

    CUSTOMER_ID,
    CUSTOMER_NAME,

    {{ audit_columns() }}

FROM {{ ref('stg_sim_item') }}