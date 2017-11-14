{%- from "kibana/map.jinja" import server with context %}
{%- if server.enabled %}

kibana_packages:
  pkg.installed:
    - names: {{ server.pkgs }}

kibana_service:
  service.running:
  - enable: true
  - name: {{ server.service }}
  {%- if grains.get('noservices') %}
  - onlyif: /bin/false
  {%- endif %}
  - watch:
    - file: kibana_config

kibana_config:
  file.managed:
  {%- if server.version == 5 %}
  - name: /etc/kibana/kibana.yml
  {%- endif %}
  {%- if server.version == 4 %}
  - name: /opt/kibana/config/kibana.yml
  {%- endif %}
  - source: salt://kibana/files/kibana.yml
  - template: jinja
  - makedirs: true
  - require:
    - pkg: kibana_packages

{%- endif %}

