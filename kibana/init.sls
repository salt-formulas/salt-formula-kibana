
{%- if pillar.kibana is defined %}
include:
{%- if pillar.kibana.server is defined %}
- kibana.server
{%- endif %}
{%- if pillar.kibana.client is defined %}
- kibana.client
{%- endif %}
{%- endif %}
