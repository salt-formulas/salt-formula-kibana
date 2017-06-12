kibana:
  client:
    enabled: true
    object:
      all:
        id: 4.6.4
        enabled: true
        template: kibana/files/objects/config.json
        type: config
      logs:
        enabled: true
        template: kibana/files/objects/dashboard_logs.json
        type: dashboard
