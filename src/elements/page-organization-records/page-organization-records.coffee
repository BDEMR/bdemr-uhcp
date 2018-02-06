
Polymer {

  is: 'page-organization-records'

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

    isOrganizationValid: 
      type: Boolean
      notify: true
      value: false

    organization:
      type: Object
      notify: true
      value: null

    recordAuthorizationList:
      type: Array
      value: -> []

    searchFilterOrganizationIndex:
      type: Number
      value: -> 0

  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  _loadOrganization: (idOnServer, cbfn)->
    data = { 
      apiKey: @user.apiKey
      idList: [ idOnServer ]
    }
    @callApi '/bdemr-organization-list-organizations-by-ids', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        unless response.data.matchingOrganizationList.length is 1
          @domHost.showModalDialog "Invalid Organization"
          return
        @set 'organization', response.data.matchingOrganizationList[0]
        @set 'isOrganizationValid', true
        cbfn()

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  _notifyInvalidOrganization: ->
    @isOrganizationValid = false
    @domHost.showModalDialog 'Invalid Organization Provided'

  _listAuthorizedRecords: ->
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      filters: null
    }
    @callApi '/bdemr-organization-list-authorized-records', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @recordAuthorizationList = response.data.recordAuthorizationList
        console.log @recordAuthorizationList

  _loadAccessibleOrganizationList: ->
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
    }
    @callApi '/bdemr-organization-list-accessible-organizations', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @searchFilterAccessibleOrganizationList = null
        @searchFilterAccessibleOrganizationList = [].concat [ { name: 'All', _id: 'All' } ], response.data.accessibleOrganizationList
        console.log @searchFilterAccessibleOrganizationList

  navigatedIn: ->
    # currentOrganization = @getCurrentOrganization()
    # unless currentOrganization
    #   @domHost.navigateToPage "#/select-organization"
      
    @_loadUser()
    
    params = @domHost.getPageParams()
    unless params['organization']
      @_notifyInvalidOrganization()
      return

    @_loadOrganization params['organization'], =>
      @_listAuthorizedRecords()
      @_loadAccessibleOrganizationList()
    
  navigatedOut: ->
    @organization = null
    @isOrganizationValid = false
    @authorizedRecordList = []

  searchButtonTapped: (e)->

    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      filters: {
        searchFilterNameOfDoctor: @searchFilterNameOfDoctor or null
        searchFilterStartDate: @searchFilterStartDate or null
        searchFilterEndDate: @searchFilterEndDate or null
        searchFilterOrganizationId: @searchFilterAccessibleOrganizationList[@searchFilterOrganizationIndex]._id
      }
    }
    @callApi '/bdemr-organization-list-authorized-records', data, (err, response)=>
      console.log 'bdemr-organization-list-authorized-records', response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @recordAuthorizationList = response.data.recordAuthorizationList

  $in: (value, list)-> 
    value in list

  openPccRecordAuthorization: (e)->
    { recordAuthorization } = e.model
    console.log 'recordAuthorization', recordAuthorization
    data = { 
      apiKey: @user.apiKey
      recordAuthorizationId: recordAuthorization._id
    }
    @callApi '/bdemr-organization-import-authorized-record', data, (err, response)=>
      console.log response
      if response.hasError
        @domHost.showModalDialog response.error.message
        return
      else
        # @recordAuthorizationList = response.data.recordAuthorizationList
        
        { recordObject } = response.data
   
        url = "#/preview-preconception-record/record:#{recordObject.serial}"


        app.db.upsert 'pcc-records', recordObject, ({serial})=> recordObject.serial is serial

        @domHost.navigateToPage url

  openRecordAuthorization: (e)->
    { recordAuthorization } = e.model
    console.log 'recordAuthorization', recordAuthorization
    data = { 
      apiKey: @user.apiKey
      recordAuthorizationId: recordAuthorization._id
    }
    @callApi '/bdemr-organization-import-authorized-record', data, (err, response)=>
      console.log response
      if response.hasError
        @domHost.showModalDialog response.error.message
        return
      else
        # @recordAuthorizationList = response.data.recordAuthorizationList

        { recordTypeObject, visitObject } = response.data

        clientVisitDb = 'doctor-visit'

        clientPatientDb = 'patient-list'
   
        typeMap = 
          'Prescription': {  clientDb: 'visit-prescription', url : "#/print-record/visit:#{visitObject.serial}/patient:#{visitObject.patientSerial}/prescription:#{recordTypeObject.serial}" }
          'Test Advised': { clientDb: 'visit-advised-test', url : "#/print-test-adviced/visit:#{visitObject.serial}/patient:#{visitObject.patientSerial}/test-adviced:#{recordTypeObject.serial}" }
          'History & Physical': { clientDb: 'history-and-physical-record', url : "#/print-history-and-physical-record/visit:#{visitObject.serial}/patient:#{visitObject.patientSerial}/record:#{recordTypeObject.serial}" }
          'PCC': { clientDb: 'pcc-records', url : "#/preview-preconception-record/record:#{recordTypeObject.serial}" }
        unless recordAuthorization.recordType of typeMap
          @domHost.showModalDialog "This type of record can not be opened"
          return

        { clientDb, url } = typeMap[recordAuthorization.recordType]

        data = { 
          apiKey: @user.apiKey
          serial: visitObject.patientSerial
          givenPin: 'DISREGARD-ME'
          pin: 'DISREGARD-ME' ## NOTE: for backward compatibility.
          organizationId: @organization.idOnServer
        }
        @callApi '/bdemr-patient-import-new', data, (err, response)=>

          console.log response
          if response.hasError
            @domHost.showModalDialog response.error.message
            return
          else
            patientObject = response.data[0]

            recordTypeObject.isForOrganizationOnly = true
            visitObject.isForOrganizationOnly = true
            patientObject.isForOrganizationOnly = true

            console.log recordTypeObject, patientObject, visitObject, clientDb, url

            app.db.upsert clientPatientDb, patientObject, ({serial})=> patientObject.serial is serial
            app.db.upsert clientVisitDb, visitObject, ({serial})=> visitObject.serial is serial
            app.db.upsert clientDb, recordTypeObject, ({serial})=> recordTypeObject.serial is serial

            @domHost.navigateToPage url



            
            
            
        
        
}
