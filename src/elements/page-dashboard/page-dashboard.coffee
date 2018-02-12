
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

    managePatientLinkList:
      type: Array
      value: -> [
        {
          title: 'Create'
          subTitle: 'New Patient'
          info: ''
          imagePath: 'assets/img/partners/badas_logo.png'
          urlPath: '#/patient-signup'
          accessId: ''
        }
        {
          title: 'FOLLOW UP'
          subTitle: 'Patient'
          info: ''
          imagePath: 'assets/img/partners/badas_logo.png'
          urlPath: '#/patient-manager/selected:0'
          accessId: ''
        }

        {
          title: 'Create '
          subTitle: 'New Patient'
          info: ''
          imagePath: 'assets/img/partners/badas.jpg'
          urlPath: '#/patient-signup'
          accessId: ''
        }
        
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
  
  navigatedIn: ->
    
    currentOrganization = @getCurrentOrganization()
    unless currentOrganization
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


  languageSelectedIndexChanged: ->
    value = @supportedLanguageList[@languageSelectedIndex]
    @setActiveLanguage value

  $getString1: (daysLeft, LANG)->
    if LANG is 'en-us'
      return "Your license for Doctor App will <br>expire in #{daysLeft} days."
    else if LANG is 'bn-bd'
      daysLeft = @$TRANSLATE_NUMBER daysLeft, LANG
      return "আপনার Doctor App এর লাইসেন্স বাতিল <br>হতে #{daysLeft} দিন বাকি আছে।"
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
