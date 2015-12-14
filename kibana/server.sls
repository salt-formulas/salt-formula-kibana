{%- from "kibana/map.jinja" import server with context %}
{%- if server.enabled %}

kibana_user:
  user.present:
  - name: kibana
  - system: True
  - home: {{ server.dir }}
  - require:
    - file: {{ server.dir }}

kibana_archive:
  archive.extracted:
  - name: {{ server.dir }}
  - source: https://download.elastic.co/kibana/kibana/kibana-4.3.0-linux-x64.tar.gz
  - archive_format: tar.gz
  - if_missing: /opt/kibana/src
  - require:
    - user: kibana_user

/etc/init.d/kibana:
  file.managed:
  - source: salt://kibana/files/kibana.init
  - user: kibana
  - group: kibana
  - mode: 700
  - template: jinja
  - require:
    - archive: kibana_archive
  - watch_in:
    - service: kibana_service

/opt/kibana/src/config/kibana.yml:
  file.managed:
  - source: salt://kibana/files/kibana.yml
  - template: jinja
  - watch_in:
    - service: kibana_service

kibana_service:
  service.running:
  - enable: true
  - name: {{ server.service }}

{%- endif %}