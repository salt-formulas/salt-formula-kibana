kibana:
  client:
    enabled: true
    default_index: 'log-*'
    object:
      logs:
        enabled: true
        template: kibana/files/objects/dashboard_logs.json
        type: dashboard
      logs-directly:
        enabled: true
        type: dashboard
        content:
          title: "Logs"
          hits: 0
          description: "Test dashboard"
