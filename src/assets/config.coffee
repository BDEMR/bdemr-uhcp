
window.app = 

  mode: 'development' # can be - 'production' or 'development'

  config:

    clientIdentifier: 'bdemr-uhcp-app'

    clientName: 'uhcp'

    clientVersion: '0.0.0'

    clientPlatform: 'web' # can be - 'web', 'android', 'ios', 'windows', 'osx', 'ubuntu'

    masterApiVersion: '1'

    masterOrganizationId: '5aa352f648d08e132de38932'

    variableConfigs:

      'development':

        serverHost: 'http://localhost:8671'
        serverWsHost: 'ws://localhost:8671'

      'production':

        serverHost: 'https://bdemr.services'
        serverWsHost: 'wss://bdemr.services:443'

  options:

    baseNetworkDelay: 10

app.config.serverHost = app.config.variableConfigs[app.mode].serverHost


