
Polymer {

  is: 'page-organization-manage-patient'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
  ]

  properties:

    user:
      type: Object
      notify: true
      value: null

    matchingPatientList:
      type: Array
      value: -> []

    indoorBalance:
      type: Number
      value: 0

    outdoorBalance:
      type: Number
      value: 25000

    selectedPatient:
      type: Object
      value: -> null

  $add: (a, b)-> parseInt(a) + parseInt(b)

  navigatedIn: ->
    @_loadUser()
  
  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  _notifyInvalidOrganization: ->
    @isOrganizationValid = false
    @domHost.showModalDialog 'Invalid Organization Provided'

  searchOnlineButtonPressed: (e)->
    @searchContextDropdownSelectedIndex = 1
    @searchButtonPressed()

  onlineSearchEnterKeyPressed: (e)->
    if e.keyCode is 13
      return unless @searchFieldMainInput
      @_searchOnline @searchFieldMainInput

  _searchOnline: (searchQuery)->
    return unless searchQuery
    @callApi '/bdemr-patient-search', {apiKey: @user.apiKey, searchQuery: searchQuery}, (err, response)=>
      if response.hasError
        @domHost.showToast response.error.message
      else if response.data.length is 0
        @domHost.showToast 'No Patient Found with that Search'
        @searchFieldMainInput = ""
      else
        matchingPatientList = response.data
        for patient in matchingPatientList
          patient.flags = {
            isImported: false
            isLocalOnly: false
            isOnlineOnly: false
          }
          localPatientList = app.db.find 'patient-list', ({serial})-> serial is patient.serial
          if localPatientList.length is 0
            patient.flags.isOnlineOnly = true
          else
            patient.flags.isImported = true
            patient._tempLocalDbId = localPatientList[0]._id
        
        matchingPatientList.forEach (item)=>
          item.name = @$getFullName item.name
          return item

        userSuggestionArray = (item for item in matchingPatientList)
        # Populating Suggestion Array for Autocomplete
        @$$("#userSearch").suggestions userSuggestionArray

  userSelected: (e)->
    patient = e.detail.option
    @set 'selectedPatient', patient
    @updatePatientCurrentBalanceView()
    @searchFieldMainInput = ""
    
  updatePatientCurrentBalanceView: ->
    @getPatientServiceBalance @selectedPatient.idOnServer, (balaneInfo)=>
      patientCurrentServiceValue = balaneInfo or {}
      modifiedPatient = Object.assign @selectedPatient, patientCurrentServiceValue
      @set 'selectedPatient', {}
      @set 'selectedPatient', modifiedPatient
  
  addFundsToPatientButtonPressed: (e)->
    unless @selectedPatient
      @domHost.showToast 'Please search and select a patient to add funds'
      return
    @addServiceValueToPatient @selectedPatient
  
  
  getPatientServiceBalance: (patientId, cbfn)->
    data = {
      patientId
      apiKey: @user.apiKey
    }
    @callApi '/bdemr-uhcp--get-patient-service-value', data, (err, response)=>
      if response.hasError
        @domHost.showToast response.error.message
      else
        cbfn response.data
  
  addServiceValueToPatient: (patient)->
    data = { 
      apiKey: @user.apiKey
      targetUserId: patient.idOnServer
      outdoorBalance: parseInt(@outdoorBalance)
      indoorBalance: parseInt(@indoorBalance)
    }
    @callApi '/bdemr-uhcp--add-service-value-to-patient', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @domHost.showToast 'Value Added Successfully'
        @updatePatientCurrentBalanceView()
  
  removePatientPressed: (e)->
    data = { 
      apiKey: @user.apiKey
      patientId: @selectedPatient.idOnServer
    }
    @callApi '/bdemr-uhcp--remove-patient-from-service', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @set 'selectedPatient', {}

  viewPatientExpenseHistoryPressed: (e)->
    patient = @selectedPatient
    text = ["Outdoor Expenses:"]
    for expense in patient.outdoorTransactionHistory
      text.push (expense.notes + " - " + expense.amountInBdt + " BDT - " + @$mkDate(expense.createDatetimeStamp))
    text.push ''
    text.push "Indoor Expenses:"
    for expense in patient.indoorTransactionHistory
      text.push (expense.notes + " - " + expense.amountInBdt + " BDT - " + @$mkDate(expense.createDatetimeStamp))
    @domHost.showModalDialog text

  navigatedOut: ->
    @organization = null
    @isOrganizationValid = false

}
