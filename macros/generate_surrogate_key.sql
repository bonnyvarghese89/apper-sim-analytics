{% macro generate_surrogate_key(columns) %}

MD5(

    CONCAT_WS('|'

    {% for column in columns %}
        ,COALESCE(CAST({{ column }} AS VARCHAR),'')
    {% endfor %}

    )

)

{% endmacro %}