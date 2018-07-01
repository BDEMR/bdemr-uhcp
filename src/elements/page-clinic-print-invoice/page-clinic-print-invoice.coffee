
Polymer {

  is: 'page-clinic-print-invoice'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.pageLike
    app.behaviors.translating
  ]

  properties:

    isVisitValid: 
      type: Boolean
      notify: false
      value: false

    isPatientValid:
      type: Boolean
      notify: false
      value: false      

    user:
      type: Object
      notify: true
      value: null

    patient:
      type: Object
      notify: true
      value: null

    invoice:
      type: Object
      notify: true
      value: null

    settings:
      type: Object
      notify: true


  ## SETTINGS ======================================================================================

  navigatedIn: ->

    @_loadUser()

    params = @domHost.getPageParams()

    unless params['invoice']
      @_notifyInvalidVisit()
      return

    unless params['patient']
      @_notifyInvalidPatient()
      return
    else
      @_loadPatient(params['patient'])

    @_loadVisit(params['visit'])

    @_loadInvoice(params['invoice'])

    @set 'settings', @_getSettings()
  
  _makeSettings: ->
    settings = 
      serial: 'only'
      isSyncEnabled: false
      printDecoration: 
        leftSideLine1: 'My Institution'
        leftSideLine2: 'My Institution Address'
        leftSideLine3: 'My Institution Contact'
        rightSideLine1: 'My Name'
        rightSideLine2: 'My Degrees'
        rightSideLine3: 'My Contact'
        footerLine: 'A simple message on the bottom'
        logoDataUri: null
      billingTargetEmailAddress: ''
      nsqipTargetEmailAddress: ''
      monetaryUnit: 'BDT'

  _getSettings: ->
    list = app.db.find 'settings', ({serial})-> serial is 'only'
    if list.length is 0
      settings = @_makeSettings()
    else
      settings = list[0]
    return settings
  
  _loadUser:()->
    userList = app.db.find 'user'
    # console.log userList
    if userList.length is 1
      @user = userList[0]


  getFullName:(data)->
    honorifics = ''
    first = ''
    last = ''
    middle = ''

    if data.honorifics  
      honorifics = data.honorifics + ". "
    if data.first
      first = data.first
    if data.middle
      middle = " " + data.middle
    if data.last
      last = " " + data.last
      
    return honorifics + first + middle + last 

  _loadPatient: (patientIdentifier)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier
    if list.length is 1
      @isPatientValid = true
      @patient = list[0]
    else
      @_notifyInvalidPatient()

  $of: (a, b)->
    unless b of a
      a[b] = null
    return a[b]

  _loadVisit: (visitIdentifier)->
    list = app.db.find 'doctor-visit', ({serial})-> serial is visitIdentifier
    if list.length is 1
      @isVisitValid = true
      @visit = list[0]
    else
      @_notifyInvalidVisit()
      return false

  _loadInvoice: (invoiceIdentifier)->
    list = app.db.find 'visit-invoice', ({serial})-> serial is invoiceIdentifier
    if list.length is 1
      @set 'invoice', list[0]
      return true
    else
      @_notifyInvalidInvoice()
      return false

  _notifyInvalidInvoice: ->
    @domHost.showModalDialog 'Invalid Invoice Provided'


  printButtonPressed: (e)->
    window.print()

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  _notifyInvalidPatient: ->
    @isPatientValid = false
    @domHost.showModalDialog 'Invalid Patient Provided'

  _notifyInvalidVisit: ->
    @isVisitValid = false
    @domHost.showModalDialog 'Invalid Visit Provided'


  _isEmpty: (data)->
    if data is 0
      return true
    else
      return false

  _isEmptyArray: (data)->
    if data.length is 0
      return true
    else
      return false

  _isEmptyString: (data)->
    if data is null or data is '' or data is 'undefined'
      return true
    else
      return false

  _computeTotalDaysCount: (endDateTimeStamp, startDateTimeStamp)->
    oneDay = 1000*60*60*24;
    diffMs = endDateTimeStamp - startDateTimeStamp
    return Math.round(diffMs/oneDay); 

  _returnSerial: (index)->
    index+1

  navigatedOut: ->
    @patient = {}
    @invoice = {}
    @isVisitValid = false
    @isPatientValid = false

  _formatDateTime: (dateTime)->
    lib.datetime.format(dateTime, 'mmm d, yyyy h:MMTT')

  _formatDate: (dateTime)->
    lib.datetime.format(dateTime, 'mmm d, yyyy')

  
  $fromListOrCustom: (list, index, custom)->
    if index is list.length - 1
      return custom
    else
      return list[index]

  possiblePaymentStatusses:
    notBilled: 'Not Billed'
    unpaid: 'Unpaid'
    partiallyPaid: 'Partially Paid'
    fullyPaid: 'Fully Paid'

  $toReadbleStatus: (status)-> @possiblePaymentStatusses[status]

  $calculateRemaining: (feePaidAmount, feeBilledAmount)->
    return (parseInt feeBilledAmount) - (parseInt feePaidAmount)


}
