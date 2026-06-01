{{ config(
    materialized='table'
) }}

SELECT DISTINCT

    {{ generate_surrogate_key([
        'FACTORY',
        'GATE'
    ]) }} AS LOCATION_KEY,

    FACTORY,
    GATE,

    {{ audit_columns() }}

FROM {{ ref('stg_sim_item') }}