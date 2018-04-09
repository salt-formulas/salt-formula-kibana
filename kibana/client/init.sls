{%- from "kibana/map.jinja" import client with context %}
{%- if client.get('enabled', False) %}

{%- set kibana_version = salt['pkg.version']('kibana') %}
{%- if kibana_version is defined %}
kibana_object_config:
  kibana_object.present:
  - kibana_content:
      defaultIndex: {{ client.get('default_index', {}) }}
  - name: {{ kibana_version }}
  - kibana_type: 'config'

{%- for object_name, object in client.get('object', {}).iteritems() %}
kibana_object_{{ object_name }}:
  {%- if object.get('enabled', False) %}
  {%- if object.content is defined %}
  kibana_object.present:
  - kibana_content: {{ object.content|json }}
  {%- else %}
  {% import_json object.template as content %}
  kibana_object.present:
  - kibana_content: {{ content|json }}
  {%- endif %}
  {%- else %}
  kibana_object.absent:
  {%- endif %}
  - name: {{ object.id|default(object_name) }}
  - kibana_type: {{ object.type }}
{%- endfor %}

{%- endif %}
{%- endif %}
