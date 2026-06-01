{% snapshot snap_sim_supplier_agreement %}

{{
    config(
        target_schema='MART',
        unique_key='AGREEMENT_KEY',
        strategy='check',
        check_cols=[
            'DEFAULT_SUPPLY_MODE',
            'DEFAULT_CURRENCY',
            'ERI_ACTIVE'
        ]
    )
}}

SELECT *
FROM {{ ref('stg_sim_supplier_agreement') }}

{% endsnapshot %}