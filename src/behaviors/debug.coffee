
# 🏻🏼🏽🏾🏿

app.behaviors.debug = 

  debugInfo: (args...)->
    name = ('🏻 '+@nodeName).toLowerCase()
    args.unshift name
    lib.debug.apply null, args

  debug: (args...)->
    name = ('🏿 '+@nodeName).toLowerCase()
    args.unshift name
    lib.debug.apply null, args

    console.log 'hello'

  # created: ->
  #   @debugInfo 'created'

  # ready: ->
  #   @debugInfo 'ready'

  # attached: ->
  #   @debugInfo 'attached'

  # detached: ->
  #   @debugInfo 'detached'

