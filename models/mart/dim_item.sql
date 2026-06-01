{{ config(
    materialized='table'
) }}

SELECT

    ITEM_KEY,

    ITEM_NO,
    ITEM_DESCRIPTION,
    SUPPLIER_ITEM_NO,
    UNIT,
    MATERIAL_FAMILY,
    COUNTRY_OF_ORIGIN,
    PRICE,

    DBT_VALID_FROM,
    DBT_VALID_TO,

    {{ audit_columns() }}

FROM {{ ref('snap_sim_item') }}