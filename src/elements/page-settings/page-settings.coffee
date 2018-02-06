
Polymer {

  is: 'page-settings'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.translating
    app.behaviors.pageLike
  ]

  properties:
    user:
      type: Object
      notify: true
    settings:
      type: Object
      notify: true
    languageSelectedIndex: 
      type: Number
      value: app.lang.defaultLanguageIndex
      notify: true
      observer: 'languageSelectedIndexChanged'
    maximumLogoImageSizeAllowedInBytes:
      type: Number
      value: 1000 * 1000

  languageSelectedIndexChanged: ->
    value = @supportedLanguageList[@languageSelectedIndex]
    # console.log value
    @setActiveLanguage value

  _saveSettings: ->
    @settings.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.remove 'settings', item._id for item in app.db.find 'settings'
    app.db.insert 'settings', @settings

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  saveButtonPressed: (e)->
    console.log @settings
    @_saveSettings()
    @domHost.showToast 'Settings Saved!'
    # @arrowBackButtonPressed()

  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  _makeSettings: ->
    @settings =
      createdByUserSerial: @user.serial
      lastModifiedDatetimeStamp: 0
      createdDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: null
      serial: @user.serial
      printDecoration:
        headerLine: ''
        leftSideLine1: ''
        leftSideLine2: ''
        leftSideLine3: ''
        rightSideLine1: ''
        rightSideLine2: ''
        rightSideLine3: ''
        footerLine: ''
        logoDataUri: null
      billingTargetEmailAddress: ''
      nsqipTargetEmailAddress: ''
      monetaryUnit: 'BDT'
      otherSettings:
        patientSignUpDefaultPassword: '123456'
      flags:
        showFooterLine: true

  showFooterLine:(e)->
    value = e.target.checked

    if typeof @settings.flags is 'undefined'
      object =
        showFooterLine: value
      @settings.flags = object
    else
      @settings.flags.showFooterLine = value

    console.log @settings

  navigatedIn: ->
    @_loadUser()

    list = app.db.find 'settings', ({serial})=> @user.serial is serial

    if list.length is 1
      @settings = list[0]
    else
      @_makeSettings()


  navigatedOut: ->
    null

  fileInputChanged: (e)->
    reader = new FileReader
    file = e.target.files[0]

    if file.size > @maximumLogoImageSizeAllowedInBytes
      @domHost.showModalDialog 'Please provide a file less than 1mb in size.'
      return

    reader.readAsDataURL file
    reader.onload = =>
      dataUri = reader.result
      @set 'settings.printDecoration.logoDataUri', dataUri

  fileInputChanged2: (e)->
    reader = new FileReader
    file = e.target.files[0]

    if file.size > @maximumLogoImageSizeAllowedInBytes
      @domHost.showModalDialog 'Please provide a file less than 1mb in size.'
      return

    reader.readAsDataURL file
    reader.onload = =>
      dataUri = reader.result
      @set 'settings.printDecoration.signatureDataUri', dataUri

}