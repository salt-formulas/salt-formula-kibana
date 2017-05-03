{%- from "kibana/map.jinja" import server with context %}
{%- if server.enabled %}

kibana_package:
  pkg.installed:
    - name: {{ server.pkgname }}

{%- if not grains.get('noservices', False) %}

kibana_service:
  service.running:
  - enable: true
  - name: {{ server.service }}
  - watch:
    - file: {{ server.configpath }}

{%- endif %}

{{ server.configpath }}:
  file.managed:
  - source: salt://kibana/files/kibana.yml
  - template: jinja
  - makedirs: true
  - require:
    - pkg: kibana_package

{%- endif %}

