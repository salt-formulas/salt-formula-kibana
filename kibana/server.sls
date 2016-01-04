{%- from "kibana/map.jinja" import server with context %}
{%- if server.enabled %}

kibana_archive:
  archive.extracted:
  - name: /opt/
  - source: https://download.elastic.co/kibana/kibana/kibana-4.3.0-linux-x64.tar.gz
  - source_hash: md5=423232a17f451841c1ff63cc5f77b9fc
  - archive_format: tar
  - tar_options: v
  - if_missing: /opt/kibana-4.3.0-linux-x64

kibana_symlink:
  file.symlink:
  - name: /opt/kibana
  - target: /opt/kibana-4.3.0-linux-x64

kibana_user:
  user.present:
  - name: kibana
  - system: True
  - home: {{ server.dir }}
  - require:
    - archive: kibana_archive

kibana_own:
  cmd.run:
  - name: chown kibana:kibana /opt/kibana-4.3.0-linux-x64 -R

/etc/init.d/kibana:
  file.managed:
  - source: salt://kibana/files/kibana.init
  - user: kibana
  - group: kibana
  - mode: 700
  - template: jinja
  - require:
    - user: kibana_user
  - watch_in:
    - service: kibana_service

/opt/kibana/config/kibana.yml:
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