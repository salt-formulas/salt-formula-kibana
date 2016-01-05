{%- from "kibana/map.jinja" import server with context %}
{%- if server.enabled %}

{%- if server.addrepo is defined and grains['os_family'] == 'Debian' %}

kibana_repo:
  pkgrepo.managed:
    - humanname: Kibana Repository
    - name: deb http://packages.elastic.co/kibana/4.1/debian stable main
    - dist: stable
    - file: /etc/apt/sources.list.d/kibana.list
    - key_url: https://packages.elastic.co/GPG-KEY-elasticsearch

{%- endif %}

kibana_package:
  pkg.installed:
  - name: {{ server.pkgname }}

kibana_service:
  service.running:
  - enable: true
  - name: {{ server.service }}
  - watch:
    - file: /opt/kibana/config/kibana.yml

/usr/share/kibana/config/kibana.yml:
  file.managed:
  - source: salt://kibana/files/kibana.yml
  - template: jinja
  - require:
    - pkg: kibana_package

{%- endif %}

