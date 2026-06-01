{% snapshot snap_sim_item %}

{{
    config(
        target_schema='MART',
        unique_key='ITEM_KEY',
        strategy='check',
        check_cols=[
            'ITEM_DESCRIPTION',
            'PRICE',
            'MINIMUM_INVENTORY',
            'MAXIMUM_INVENTORY'
        ]
    )
}}

SELECT *
FROM {{ ref('stg_sim_item') }}

{% endsnapshot %}