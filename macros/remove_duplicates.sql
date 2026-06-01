{% macro remove_duplicates(
        relation,
        business_keys,
        order_column='LAND_TS'
    ) %}

{% set cols = adapter.get_columns_in_relation(relation) %}

WITH trimmed AS (

    SELECT

    {% for col in cols %}

        {% set dtype = col.data_type | upper %}

        {% if 'VARCHAR' in dtype
           or 'TEXT' in dtype
           or 'STRING' in dtype %}

            NULLIF(TRIM({{ col.name }}), '') AS {{ col.name }}

        {% else %}

            {{ col.name }}

        {% endif %}

        {% if not loop.last %},{% endif %}

    {% endfor %}

    FROM {{ relation }}

),

ranked AS (

    SELECT
        *,
        ROW_NUMBER() OVER (

            PARTITION BY

            {% for key in business_keys %}
                {{ key }}
                {% if not loop.last %},{% endif %}
            {% endfor %}

            ORDER BY {{ order_column }} DESC

        ) AS RN

    FROM trimmed

)

SELECT
    *
FROM ranked
WHERE RN = 1

{% endmacro %}