
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


Read more
=========

* https://github.com/elasticsearch/kibana/blob/master/src/config.js
