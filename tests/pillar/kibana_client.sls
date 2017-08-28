kibana:
  client:
    enabled: true
    default_index: 'log-*'
    object:
      logs:
        enabled: true
        template: kibana/files/objects/dashboard_logs.json
        type: dashboard
