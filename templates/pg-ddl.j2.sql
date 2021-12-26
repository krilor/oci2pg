{%- for resource in resources.keys() %}
-- {{ resource }}

CREATE TABLE IF NOT EXISTS {{ resource }} (
{%- for attribute, type in resources[resource].items() | sort %}
  {{ attribute }} {{ convert_type(type) }}{{ ' PRIMARY KEY' if attribute == 'id' else '' }}{{ ',' if not loop.last else '' }} -- {{ type }}
{%- endfor %}
);
{% endfor %}
