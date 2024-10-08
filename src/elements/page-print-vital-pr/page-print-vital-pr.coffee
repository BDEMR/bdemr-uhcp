

Polymer {

  is: 'page-print-vital-pr'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
  ]
  properties:
    isPatientValid: 
      type: Boolean
      notify: false
      value: true

    user:
      type: Object
      notify: true
      value: null

    patient:
      type: Object
      notify: true
      value: null

    matchingVitalPulseRateList:
      type: Array
      notify: true
      value: []

    settings:
      type: Object
      notify: true

  ## SETTINGS ======================================================================================

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
    list = app.db.find 'settings'
    if list.length is 0
      settings = @_makeSettings()
    else
      settings = list[0]
    return settings

 

  # Helper
  # ================================

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  $findCreator: (creatorSerial)-> 'me'

  _isEmptyString: (data)->
    if data == null || data == 'undefined' || data == ''
      return true
    else
      return false

  _isEmptyArray: (data)->
    if data.length is 0
      return true
    else
      return false

  _computeTotalDaysCount: (endDate, startDate)->
      return 'As Needed' unless endDate
      oneDay = 1000*60*60*24;
      startDate = new Date startDate
      diffMs = endDate - startDate
      return Math.round(diffMs / oneDay)

  printButtonPressed: (e)->
    window.print()
    
  _sortByDate: (a, b)->
    if a.date < b.date
      return 1
    if a.date > b.date
      return -1

  _returnSerial: (index)->
    index+1

  getDoctorSpeciality: () ->
    unless @user.specializationList.length is 0
      return @user.specializationList[0].specializationTitle

  _loadPatient: (patientIdentifier)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier
    if list.length is 1
      @isPatientValid = true
      @patient = list[0]
    else
      @_notifyInvalidPatient()

  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  _notifyInvalidPatient: ->
    @isPatientValid = false
    @showModal 'Invalid Patient Provided'


  navigatedIn: ->

    params = @domHost.getPageParams()

    @_loadUser()
    @set 'selectedVitalPage', 0
   
    
    if params['patient']
      @_loadPatient params['patient']
    else
      @_notifyInvalidPatient()

   
    @_listVitalPulseRate(params['patient'])
    
    @settings = @_getSettings()      

  navigatedOut: ->
    @patient = null
    @isPatientValid = false
    
   
    
    @matchingVitalPulseRateList = []
    
    @patient = null

 
  # Vital - Pulse Rate
  # ================================

  _listVitalPulseRate: (patientIdentifier) ->
    vitalPulseRateList = app.db.find 'patient-vitals-pulse-rate', ({patientSerial})=> @patient.serial is patientSerial

    vitalList = [].concat vitalPulseRateList
    vitalList.sort (left, right)->
      return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
      return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
      return 0

    for vital in vitalList
      vital.flags = 
        isLocalOnly: true

    @matchingVitalPulseRateList = vitalList

    params = @domHost.getPageParams()

    if params['startDate'] isnt 'null' and params['startDate'] isnt 'undefined' and params['endDate'] isnt 'null' and params['endDate'] isnt 'undefined'
      startDate = new Date params['startDate']
      endDate = new Date params['endDate']

      endDate.setHours 24 + endDate.getHours()
      filterdBPList = (item for item in @matchingVitalPulseRateList when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
      @matchingVitalPulseRateList = filterdBPList

  # === Vital - Pulse Rate [END] ===



  ready: ()->


}
