/* Input parameters */
/* Creating dynamic pivot macro with input values */
{% macro get_pivot_flatten(columns_to_show, pivot_column, aggregate_column, my_table, method_pivot) -%}

/* Distinct list of pivot values */
{%- set my_query -%}
select distinct {{pivot_column}} from {{my_table}} ;
{%- endset -%}

{%- set results = run_query(my_query) -%}

{%- if execute -%}
{%- set items = results.columns[0].values() -%}
{%- endif %}


/* Looping over the pivot values to generate a dynamic script */
select {{columns_to_show}},
{%- for i in items %}
{{method_pivot}}("{{i}}_views") AS "{{i}}_views"
{%- if not loop.last %} , {% endif -%}
{%- endfor %}
from (
        select {{columns_to_show}},
        {%- for i in items %}
        case when {{pivot_column}} = '{{i}}' then {{aggregate_column}} else null end as "{{i}}_views"
        {%- if not loop.last %} , {% endif -%}
        {%- endfor %}
        from {{my_table}} )
group by {{columns_to_show}}

{%- endmacro %}
