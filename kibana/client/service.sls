{%- from "kibana/map.jinja" import client with context %}
{%- if client.get('enabled', False) %}

/etc/salt/minion.d/_kibana.conf:
  file.managed:
  - source: salt://kibana/files/_kibana.conf
  - template: jinja
  - user: root
  - group: root

{%- endif %}
