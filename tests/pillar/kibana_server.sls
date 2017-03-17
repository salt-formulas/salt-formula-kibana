kibana:
  server:
    configpath: /usr/share/kibana/config/kibana.yml
    enabled: true
    bind:
      address: 0.0.0.0
      port: 5601
    database:
      engine: elasticsearch
      host: localhost
      port: 9200
linux:
  system:
    enabled: true
    repo:
      kibana:
        source: 'deb http://packages.elastic.co/kibana/4.1/debian stable main'
        key_id: 46095ACC8548582C1A2699A9D27D666CD88E42B4
        key_server: hkp://p80.pool.sks-keyservers.net:80
