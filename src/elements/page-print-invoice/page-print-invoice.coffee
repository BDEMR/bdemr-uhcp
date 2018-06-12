
Polymer {

  is: 'page-print-invoice'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.pageLike
    app.behaviors.translating
    app.behaviors.apiCalling
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

    loadingCounter:
      type: Number
      notify: true
      value: -> 0

  ## SETTINGS ======================================================================================

  navigatedIn: ->

    @_loadUser()

    params = @domHost.getPageParams()

    unless params['invoice']
      @_notifyInvalidVisit()
      return

    # @_loadVisit(params['visit'])

    @_loadInvoice params['invoice'], ()=>
      console.log @invoice
      @_loadPatient(params['patient'])


    @set 'settings', @_getSettings()

  
  _getSettings: ->
    list = app.db.find 'settings', ({serial})-> serial is 'only'
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
    if list.length
      @set 'patient', list[0]
    else if patientIdentifier is @invoice.patientSerial
      @set 'patient', @invoice.patientInfo
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

  _loadInvoice: (invoiceIdentifier, cbfn)->
    @loadingCounter++
    list = app.db.find 'visit-invoice', ({serial})-> serial is invoiceIdentifier
    if list.length is 1
      @set 'invoice', list[0]
      @loadingCounter--
      return cbfn()
    else
      data = {
        apiKey: @user.apiKey
        invoiceSerial: invoiceIdentifier
      }
      @callApi 'uhcp--get-single-invoice', data, (err, response)=>
        @loadingCounter--
        if response.hasError
          @domHost.showModalDialog response.error.message
        else
          @set 'invoice', response.data[0]
          return cbfn()
    

    

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

  _computeAge: (dateString)->
    return "" unless dateString
    today = new Date()
    birthDate = new Date dateString
    age = today.getFullYear() - birthDate.getFullYear()
    m = today.getMonth() - birthDate.getMonth()

    if m < 0 || (m == 0 && today.getDate() < birthDate.getDate())
      age--
    
    return age

  _formatDateTime: (dateTime)->
    lib.datetime.format((new Date dateTime), 'mmm d, yyyy')

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

  $calculateRemaining: (billed = 0, amtReceived = 0)-> (parseInt billed) - (parseInt amtReceived)


}
