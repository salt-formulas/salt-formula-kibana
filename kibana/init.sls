
{%- if pillar.kibana is defined %}
{%- if pillar.kibana.server is defined %}
include:
- kibana.server
{%- endif %}
{%- endif %}
