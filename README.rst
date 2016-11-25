
======
Kibana
======

Kibana is an open source (Apache Licensed), browser based analytics and search interface to Logstash and other timestamped data sets stored in ElasticSearch. With those in place Kibana is a snap to setup and start using (seriously). Kibana strives to be easy to get started with, while also being flexible and powerful

Sample pillar
=============

.. code-block:: yaml

    kibana:
      server:
        addrepo: true
        enabled: true
        bind:
          address: 0.0.0.0
          port: 5601
        database:
          engine: elasticsearch
          host: localhost
          port: 9200

Or without adding elasticsearch kibana repository, but with modified path to config file

.. code-block:: yaml

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


Client setup
------------

Client with host and port (Kibana use Elasticsearch to store its data):

.. code-block:: yaml

    kibana:
      client:
        enabled: true
        server:
          host: elasticsearch.host
          port: 9200

Client where you download a Kibana object that is stored in the directory
*files/*:

.. code-block:: yaml

    kibana:
      client:
        enabled: true
        server:
          host: elasticsearch.host
          port: 9200
        object:
          logs:
            enabled: true
            name: Logs
            template: kibana/files/objects/dashboard_logs.json
            type: 'dashboard'

Read more
=========

* https://github.com/elasticsearch/kibana/blob/master/src/config.js
