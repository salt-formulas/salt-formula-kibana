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
    {%- if object.get('enabled', False) %}
      {%- set pillar_content = object.get("content", {}) %}
      {%- if object.template is defined %}
        {%- import_json object.template as content %}
      {%- else %}
        {%- set content = {} %}
      {%- endif %}
      {%- do salt['defaults.merge'](content, pillar_content) %}
kibana_object_{{ object_name }}:
  kibana_object.present:
  - kibana_content: {{ content | json }}
  - name: {{ object.id | default(object_name) }}
  - kibana_type: {{ object.type }}
    {%- else %}

kibana_object_{{ object_name }}:
  kibana_object.absent:
  - name: {{ object.id | default(object_name) }}
  - kibana_type: {{ object.type }}
    {%- endif %}

  {%- endfor %}
  {%- endif %}
{%- endif %}
