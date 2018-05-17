
Polymer {

  is: 'page-dashboard'

  behaviors: [ 
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.dbUsing
  ]

  properties:
    languageSelectedIndex: 
      type: Number
      value: app.lang.defaultLanguageIndex
      notify: true
      observer: 'languageSelectedIndexChanged'

    daysLeft:
      type: Number
      value: 0

    authorizeToSelectedIndex:
      type: Number
      value: 0

    organizationsIBelongToList:
      type: Array
      value: -> []

    managePatientLinkList:
      type: Array
      value: -> [
        {
          title: 'Create'
          subTitle: 'New Patient'
          info: ''
          imagePath: 'assets/img/partners/uhcp.jpg'
          urlPath: '#/patient-signup'
          accessId: ''
        }
        {
          title: 'FOLLOW UP'
          subTitle: 'Patient'
          info: ''
          imagePath: 'assets/img/partners/uhcp.jpg'
          urlPath: '#/patient-manager/selected:0'
          accessId: ''
        }

        # {
        #   title: 'Create '
        #   subTitle: 'New Patient'
        #   info: ''
        #   imagePath: 'assets/img/partners/badas.jpg'
        #   urlPath: '#/patient-signup'
        #   accessId: ''
        # }
        
        {
          title: 'Patients Log'
          subTitle: 'patient history from'
          info: ''
          imagePath: 'images/icons/ico_history_and_physical.png'
          urlPath: '#/patient-manager/selected:1'
          accessId: ''
        }
      ]

    sortcutList:
      type: Array
      value: -> [
        {
          title: 'Create New Patient'
          info: ''
          icon: 'icons:open-in-new'
          urlPath: '#/patient-signup'
          accessId: ''
        }
        {
          title: 'Patient Manager'
          info: ''
          icon: 'icons:open-in-new'
          urlPath: '#/patient-manager'
          accessId: ''
        }
        {
          title: 'Report Manager'
          info: ''
          icon: 'icons:open-in-new'
          urlPath: '#/reports-manager'
          accessId: ''
        }
        {
          title: 'Chamber Manager'
          icon: 'icons:open-in-new'
          info: ''
          urlPath: '#/chamber-manager'
          accessId: ''
        }
        {
          title: 'Medicine Dispension'
          icon: 'icons:open-in-new'
          info: ''
          urlPath: '#/medicine-dispension'
          accessId: ''
        }
        {
          title: 'Assistant Manager'
          icon: 'icons:open-in-new'
          info: ''
          urlPath: '#/assistant-manager'
          accessId: ''
        }
        {
          title: 'Search Records'
          icon: 'icons:open-in-new'
          info: ''
          urlPath: '#/search-record'
          accessId: ''
        }
        {
          title: 'Invoice Manager'
          icon: 'icons:open-in-new'
          info: ''
          urlPath: '#/invoice-manager'
          accessId: ''
        }
        {
          title: 'Booking and Searvices'
          icon: 'icons:open-in-new'
          info: ''
          urlPath: '#/booking'
          accessId: ''
        }
        {
          title: 'Organization Manager'
          icon: 'icons:open-in-new'
          info: ''
          urlPath: '#/organization-manager'
          accessId: ''
        }
        {
          title: 'Send Notification'
          icon: 'icons:open-in-new'
          info: ''
          urlPath: '#/notification-panel'
          accessId: ''
        }
        {
          title: 'My Wallet'
          icon: 'icons:open-in-new'
          info: ''
          urlPath: '#/wallet'
          accessId: ''
        }
        {
          title: 'Send Feedback'
          icon: 'icons:open-in-new'
          info: ''
          urlPath: '#/send-feedback'
          accessId: ''
        }
        {
          title: 'Settings'
          icon: 'settings'
          info: ''
          urlPath: '#/settings'
          accessId: ''
        }
      ]


  goToUrlForManagePatientList: (e)->
    index = e.model.index
    item = @managePatientLinkList[index]
    window.location = item.urlPath

  goToUrlForShortcutNav: (e)->
    index = e.model.index
    item = @sortcutList[index]
    window.location = item.urlPath


  ready: -> @version = app.config.clientVersion


  _organizationNavigatedIn: () ->
    if localStorage.getItem("authorizedOrganiztionId")
      @authorizedOrganiztionId = localStorage.getItem("authorizedOrganiztionId")
    else
      @authorizedOrganiztionId = @currentOrganization.idOnServer
      localStorage.setItem("authorizedOrganiztionId", @authorizedOrganiztionId)

    data = { 
      apiKey: @user.apiKey
    }

    @callApi '/bdemr-organization-list-those-user-belongs-to', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @organizationsIBelongToList = response.data.organizationObjectList

        for item, index in @organizationsIBelongToList
          if item.idOnServer is @authorizedOrganiztionId
            @set 'authorizeToSelectedIndex', index

        @checkForAuthorizedOrganiztionListFromUserSettings =>
          @_saveSettings()



  _saveSettings: ->
    @settings.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.remove 'settings', item._id for item in app.db.find 'settings'
    app.db.insert 'settings', @settings


  isOrganizationFoundOnAuthorizedOrganiztionList: (org)->
    list = @settings.authorizedOrganiztionList
    for item in list
      if item.idOnServer is org.idOnServer
        return true
    return false


  checkForAuthorizedOrganiztionListFromUserSettings: (cbfn)->
    authorizedOrganiztionList = @settings.authorizedOrganiztionList

    if authorizedOrganiztionList.length > 0
      for item in @organizationsIBelongToList
        if !@isOrganizationFoundOnAuthorizedOrganiztionList item
          object =
            idOnServer: item.idOnServer
            isChecked: false
            name: item.name

          @settings.authorizedOrganiztionList.push object

    else
      for item in @organizationsIBelongToList
        object =
          idOnServer: item.idOnServer
          isChecked: false
          name: item.name

        @settings.authorizedOrganiztionList.push object

    cbfn()




  ## Authorize organization for Records - start
  onCheckAuthorizedOrganization: (e)->
    isChecked = e.target.checked
    index = e.model.index

    if isChecked
      @settings.authorizedOrganiztionList[index].isChecked = isChecked

    else
      @settings.authorizedOrganiztionList[index].isChecked = false


    console.log 'settings', @settings


    @_saveSettings()





  ## Authorize organization for Records - end

  loadSettings: (cbfn)->
    list = app.db.find 'settings', ({serial})=> @user.serial is serial

    if list.length > 0
      @settings = list[0]

    else
     @_makeSettings()

    cbfn()

  _makeSettings: () ->

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
        showUserNameOnPrintPreview: true

      authorizedOrganiztionList: []

    @_saveSettings()


  
  navigatedIn: ->
    
    @currentOrganization = @getCurrentOrganization()
    unless @currentOrganization
      @domHost.navigateToPage "#/select-organization"

    # Sync User Settings if availble or set as default settings. this is required.
    # @domHost._syncUserSettings ()=>
    #   list = app.db.find 'settings', ({serial})=> @user.serial is serial
    #   if list.length is 0
    #     @saveDefaultSettings()

    metrics = @getDashboardMetrics()

    @user = (app.db.find 'user')[0]

    @newPatientCount = metrics.newPatientCount
    @totalPatientCount = metrics.totalPatientCount
    @newRecordCount = metrics.newRecordCount
    @totalRecordCount = metrics.totalRecordCount
    @totalUnpaidInvoiceCount = metrics.totalUnpaidInvoiceCount
    @daysLeft = metrics.daysLeft

    if @daysLeft < 0
      @domHost.navigateToPage '#/activate'

    @loadSettings =>
      @_organizationNavigatedIn()


  languageSelectedIndexChanged: ->
    value = @supportedLanguageList[@languageSelectedIndex]
    @setActiveLanguage value

  $getString1: (daysLeft, LANG)->
    if LANG is 'en-us'
      return "Your license for UHCP App will <br>expire in #{daysLeft} days."
    else if LANG is 'bn-bd'
      daysLeft = @$TRANSLATE_NUMBER daysLeft, LANG
      return "আপনার UHCP App এর লাইসেন্স বাতিল <br>হতে #{daysLeft} দিন বাকি আছে।"
    else
      return "TRANSLATION_FAILED"

  viewNewPatientsTapped: (e)->
    @domHost.navigateToPage '#/patient-manager/filter:today-only'

  viewNewRecordsTapped: (e)->
    @domHost.navigateToPage '#/record-manager/filter:today-only'

  viewAllRecordsTapped: (e)->
    @domHost.navigateToPage '#/record-manager/filter:clear'

  viewAllPatientsTapped: (e)->
    @domHost.navigateToPage '#/patient-manager/filter:clear'

  viewUnpaidInvoicesTapped: (e)->
    @domHost.navigateToPage '#/invoices/unpaid-only'

  purchaseAnaesMonTapped: (e)->
    window.open 'https://my.bdemr.com/#/apps/anaesmon/purchase'

  renewAnaesMonTapped: (e)->
    @domHost.navigateToPage '#/activate'

}
