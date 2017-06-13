{%- from "kibana/map.jinja" import server with context %}
{%- if server.enabled %}

kibana_package:
  pkg.installed:
    - name: {{ server.pkgname }}

kibana_service:
  service.running:
  - enable: true
  - name: {{ server.service }}
  {%- if grains.get('noservices') %}
  - onlyif: /bin/false
  {%- endif %}
  - watch:
    - file: {{ server.configpath }}

{{ server.configpath }}:
  file.managed:
  - source: salt://kibana/files/kibana.yml
  - template: jinja
  - makedirs: true
  - require:
    - pkg: kibana_package

{%- endif %}

