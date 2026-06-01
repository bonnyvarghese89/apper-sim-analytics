{% macro audit_columns() %}
CURRENT_USER() AS DW_CREATED_BY,
CURRENT_TIMESTAMP() AS DW_CREATED_TS
{% endmacro %}