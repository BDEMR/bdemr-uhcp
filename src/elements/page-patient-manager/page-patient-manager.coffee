
Polymer {
  
  is: 'page-patient-manager'

  behaviors: [ 
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
    app.behaviors.commonComputes
    app.behaviors.dbUsing
  ]

  properties:

    selectedSearchViewIndex:
      type: Number
      notify: true
      value: 0

    selectedTabPageIndex:
      type: Number
      notify: true
      value: 0

    searchContextDropdownSelectedIndex: 
      type: Number
      notify: true
      value: 1

    isAdvancedSearchEnabled: 
      type: Boolean
      notify: true
      value: false

    advancedSearchParameters:
      type: Object
      notify: true
      value:
        createdDate:
          enabled: false
          lowerBound: lib.datetime.mkDate lib.datetime.now()
          upperBound: lib.datetime.mkDate lib.datetime.now()
        initialVisitDate:
          enabled: false
          lowerBound: lib.datetime.mkDate lib.datetime.now()
          upperBound: lib.datetime.mkDate lib.datetime.now()
        lastVisitDate:
          enabled: false
          lowerBound: lib.datetime.mkDate lib.datetime.now()
          upperBound: lib.datetime.mkDate lib.datetime.now()
        admissionDate:
          enabled: false
          lowerBound: lib.datetime.mkDate lib.datetime.now()
          upperBound: lib.datetime.mkDate lib.datetime.now()
        handledDate:
          lowerBound: lib.datetime.mkDate lib.datetime.now()
          upperBound: lib.datetime.mkDate lib.datetime.now()

    hasSearchBeenPressed:
      type: Boolean
      notify: true
      value: true


    matchingPatientList:
      type: Array
      notify: true
      value: []

    searchFieldMainInput: 
      type: String
      notify: true
      value: ''
      
    user:
      type: Object
      notify: true
      value: null

    currentDateFilterStartDate:
      type: Number

    currentDateFilterEndDate:
      type: Number

    resultedPatientList:
      type: Array
      notify: true
      value: []

    matchingVisitedPatientLogList:
      type: Array
      notify: true
      value: []

    filteredPatientVisitedPatientLogList:
      type: Array
      notify: true
      value: []

    organizationsIBelongToList:
      type: Array
      value: -> []

    patientListForPendingPccRecords:
      type: Array
      value: -> []


  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]
      # console.log @user

  loadPatientListForPendingPCCRecords: ()->
    list = app.db.find 'existing-patient-log-for-pending-pcc-records'
    @patientListForPendingPccRecords = list
    console.log 'patientListForPendingPccRecords', @patientListForPendingPccRecords

  savePendingPccRecords: (e)->
    el = @locateParentNode e.target, 'PAPER-BUTTON'
    el.opened = false
    repeater = @$$ '#pending-pcc-record-for-existing-patient-repeater'

    index = repeater.indexForElement el
    patient = @patientListForPendingPccRecords[index]

    @_importPatient patient.data.serial, patient.doctorAccessPin, (importedPatientLocalId)=>
      # console.log 'PATIENT', patient
      @_updateLocalPcc patient.data.serial, patient.oldSerial
      @_removeLocalPatient patient.oldSerial, =>
        @loadPatientListForPendingPCCRecords()
      @domHost.showToast 'PCC Record has been saved Successfully!'


  _removeLocalPatient: (oldSerial, cbfn)->
    id = (app.db.find 'existing-patient-log-for-pending-pcc-records', ({oldSerial})-> oldSerial is oldSerial)[0]._id
    app.db.remove 'existing-patient-log-for-pending-pcc-records', id
    console.log 'Deleted 1 from "existing-patient-log-for-pending-pcc-records"'
    cbfn()


  _updateLocalPcc: (newSerial, oldSerial)->
    console.log 'newSerial', newSerial
    pcc = (app.db.find 'pcc-records', ({patientSerial})-> patientSerial is oldSerial)[0]
    pcc.patientSerial = newSerial
    app.db.update 'pcc-records', pcc._id, pcc

  _organizationNavigatedIn: ->

    data = { 
      apiKey: @user.apiKey
    }
    @callApi '/bdemr-organization-list-those-user-belongs-to', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @organizationsIBelongToList = response.data.organizationObjectList

  onPageIndexChange: ()->
    if @selectedSearchViewIndex is 1
      @listAllImportedAndOfflinePatientsPressed()


  ## REGION :: Offline Registered Patient - start ------>

  

  ## REGION :: Offline Registered Patient - end ------>

  navigatedIn: ->

    @organization = @getCurrentOrganization()
    unless @organization
      @domHost.navigateToPage "#/select-organization"
      

    @_loadUser()

    patientList = app.db.find 'patient-list', ({isForOrganizationOnly})-> isForOrganizationOnly is true
    for patient in patientList
      app.db.remove 'patient-list', patient._id

    @_organizationNavigatedIn()

    @loadPatientListForPendingPCCRecords()

    # @domHost.setCurrentPatientsDetails null

    if @domHost.__patientView__oneTimeSearchFilter
      @oneTimeSearchFilter = @domHost.__patientView__oneTimeSearchFilter

    params = @domHost.getPageParams()

    if params['selected']
      @set "selectedSearchViewIndex", parseInt params['selected']
    else
      @set "selectedSearchViewIndex", 0

      
    if params['filter'] and params['filter'] is 'today-only'
      @domHost.modifyCurrentPagePath '#/patient-manager'
      @searchFieldMainInput = ''
      @isAdvancedSearchEnabled = false
      @set 'advancedSearchParameters.createdDate.enabled', true
      @set 'advancedSearchParameters.createdDate.lowerBound', lib.datetime.mkDate lib.datetime.now()
      @set 'advancedSearchParameters.createdDate.upperBound', lib.datetime.mkDate lib.datetime.now()
      @listAllImportedAndOfflinePatientsPressed null
    else if params['filter'] and params['filter'] is 'clear'
      @domHost.modifyCurrentPagePath '#/patient-manager'
      @isAdvancedSearchEnabled = false
      @searchFieldMainInput = ''
      @listAllImportedAndOfflinePatientsPressed null

    else if params['query']
      @searchFieldMainInput = params['query']
      @searchOnlineButtonPressed()
      # @importPatientPressed()

    else if params['unregsiterd']
      @searchFieldMainInput = params['unregsiterd']
      @searchOfflineButtonPressed()

    else
      @listAllImportedAndOfflinePatientsPressed null


    @_listVisitedPatientLog()


  searchButtonPressed: (e)->
    if @searchContextDropdownSelectedIndex is 1
      @_searchOnline()
    else
      @_searchOffline()

  listAllImportedAndOfflinePatientsPressed: (e)->
    @searchFieldMainInput = ''
    @searchContextDropdownSelectedIndex = 0
    @searchButtonPressed null    

  searchOfflineButtonPressed: (e)->
    if @searchFieldMainInput.length is 0
      return @domHost.showModalDialog "Please enter something to search with."
    @searchContextDropdownSelectedIndex = 0
    @searchButtonPressed null    

  searchOnlineButtonPressed: (e)->
    @searchContextDropdownSelectedIndex = 1
    @searchButtonPressed null

  _searchOnline: ->
    @matchingPatientList = []
    # console.log @searchFieldMainInput
    @callApi '/bdemr-patient-search', {searchQuery: @searchFieldMainInput}, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
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
        @matchingPatientList = matchingPatientList
        # console.log @matchingPatientList
  
  _searchOffline: ->
    ## Basic Search
    searchFieldMainInput = @searchFieldMainInput

    if searchFieldMainInput.length is 0  and false
      patientList = app.db.find 'patient-list'
    else
      patientList = app.db.find 'patient-list', ({serial, name, email, phone, nIdOrSsn, hospitalNumber, initialVisitDate, lastVisitDate, admissionDate})=>
  
        if @oneTimeSearchFilter
          condition1 = (''+serial) is ('' + @oneTimeSearchFilter)
          condition2 = false
          condition3 = false
          condition4 = false
          condition5 = false
        else
          condition1 = (name.first.indexOf searchFieldMainInput) > -1
          condition2 = (email.indexOf searchFieldMainInput) > -1
          condition3 = (phone.indexOf searchFieldMainInput) > -1
          condition4 = (serial.indexOf searchFieldMainInput) > -1
          condition5 = try (nIdOrSsn.indexOf searchFieldMainInput) > -1 catch ex then false
          ## NOTE:
          # Found to be commented out on master when shafayet merged
          # his interoperability issues branch. shafayet did not comment 
          # this out.

        isAdvancedSearchPassed = true

        ## Advanced Search
        isAdvancedSearchEnabled = @isAdvancedSearchEnabled
        if isAdvancedSearchEnabled
          if @advancedSearchParameters.initialVisitDate.enabled
            left = new Date @advancedSearchParameters.initialVisitDate.lowerBound
            middle = new Date initialVisitDate
            right = new Date @advancedSearchParameters.initialVisitDate.upperBound
            if left.getTime() <= middle.getTime() <= right.getTime()
              isAdvancedSearchPassed = true
            else
              isAdvancedSearchPassed = false
          else if @advancedSearchParameters.lastVisitDate.enabled
            left = new Date @advancedSearchParameters.lastVisitDate.lowerBound
            middle = new Date lastVisitDate
            right = new Date @advancedSearchParameters.lastVisitDate.upperBound
            if left.getTime() <= middle.getTime() <= right.getTime()
              isAdvancedSearchPassed = true
            else
              isAdvancedSearchPassed = false
          else if @advancedSearchParameters.admissionDate.enabled
            left = new Date @advancedSearchParameters.admissionDate.lowerBound
            middle = new Date admissionDate
            right = new Date @advancedSearchParameters.admissionDate.upperBound
            if left.getTime() <= middle.getTime() <= right.getTime()
              isAdvancedSearchPassed = true
            else
              isAdvancedSearchPassed = false

        return (condition1 or condition2 or condition3 or condition4 or condition5 ) and isAdvancedSearchPassed

    @oneTimeSearchFilter = null

    ## Modify Results
    for patient in patientList
      unless 'flags' of patient
        patient.flags = {
          isImported: false
          isLocalOnly: false
          isOnlineOnly: false
        }
        patient.flags.isLocalOnly = true

    ## Sort Results
    ''

    ## Show results
    @matchingPatientList = patientList


  clearSearchResultsClicked: (e)->
    @matchingPatientList = []

  moreOptionsPressed: (e)->
    @domHost.showModalDialog 'You can search records (instead of patients) by many other options including diseases from the "Record Manager" option from the left menu.'

  newPatientFabPressed: (e)->
    # @domHost.navigateToPage '#/patient-editor/patient:new'
    @domHost.navigateToPage '#/patient-signup'

  newPCCPatient: (e)->
    # @domHost.navigateToPage '#/preconception-record/record:new/patients:new'
    @domHost.navigateToPage '#/patient-signup'

  ## ------------------ import / publish start

  _getPinForLocalPatient: (patientIdentifier)->
    list = app.db.find 'local-patient-pin-code-list', ({patientSerial})=> patientSerial is patientIdentifier
    if list.length is 1
      pin = list[0].pin
      return pin
    else return null

  _savePinForLocalPatient: (pin, patientSerial)->
    patientPinObject = {}
    patientPinObject.organizationId = @organization.idOnServer
    patientPinObject.patientSerial = patientSerial
    patientPinObject.pin = pin

    app.db.upsert 'local-patient-pin-code-list', patientPinObject, ({patientSerial})=> patientPinObject.patientSerial is patientSerial

  _publishPatient: (patient, pin, cbfn)->
    @callApi '/bdemr-patient-publish', {patient: patient, pin: pin}, (err, response)=>
      if response.hasError
        if response.error.message is 'U_PIN_ERR'
          @domHost.showModalInput "Please enter correct patient PIN", "0000", (answer)=>
            if answer
              @_publishPatient patient, answer, cbfn
        else
          @domHost.showModalDialog response.error.message
      else
        if response.data.status is 'success'

          pin = @_getPinForLocalPatient patient.serial

          @_importPatient patient.serial, pin, (importedPatientLocalId)=>
            app.db.remove 'patient-list', patient._id
            @searchContextDropdownSelectedIndex = 0
            @oneTimeSearchFilter = patient.serial
            @searchButtonPressed null
        else
          # console.log response.data
          @domHost.showModalDialog ("Unkown response " + response.data.status)

  publishPatientPressed: (e)->
    el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
    el.opened = false
    repeater = @$$ '#patient-list-repeater'

    index = repeater.indexForElement el
    patient = @matchingPatientList[index]

    @domHost.showModalPrompt "Publishing will overwrite remote changes (if any). Continue?", (answer)=>
      if answer
        @_publishPatient patient, null, (updatedPatient)=>
          # console.log 'publishing completed', updatedPatient

  _importPatient: (serial, pin, cbfn)->
    @callApi '/bdemr-patient-import-new', {serial: serial, pin: pin, doctorName: @user.name, organizationId: @organization.idOnServer}, (err, response)=>
      console.log response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        patientList = response.data

        if patientList.length isnt 1
          return @domHost.showModalDialog 'Unknown error occurred.'
        patient = patientList[0]

        # patientPinObject = {patientSerial: serial, pin: pin}
        @_savePinForLocalPatient pin, patient.serial
        patient.flags = {
          isImported: false
          isLocalOnly: false
          isOnlineOnly: false
        }
        patient.flags.isImported = true

        @removePatientIfAlreadyExist patient.serial
        
        _id = app.db.insert 'patient-list', patient
        cbfn _id

  removePatientIfAlreadyExist: (patientIdentifier)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier

    if list.length is 1
      patient = list[0]
      app.db.remove 'patient-list', patient._id
      return
    else
      return

  importPatientPressed: (e)->
    el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
    el.opened = false
    repeater = @$$ '#patient-list-repeater'

    index = repeater.indexForElement el
    patient = @matchingPatientList[index]

    offlinePin = @_getPinForLocalPatient patient.serial

    if patient.idOnServer
      if offlinePin
        @_importPatient patient.serial, offlinePin, (importedPatientLocalId)=>
          @searchFieldMainInput = ''
          @searchContextDropdownSelectedIndex = 0
          @oneTimeSearchFilter = patient.serial
          @listAllImportedAndOfflinePatientsPressed null
          @goPatientViewPage patient
      else
        @domHost.showModalInput "Please enter patient PIN", "0000", (answer)=>
          if answer
            @_importPatient patient.serial, answer, (importedPatientLocalId)=>
              @searchFieldMainInput = ''
              @searchContextDropdownSelectedIndex = 0
              @oneTimeSearchFilter = patient.serial
              @listAllImportedAndOfflinePatientsPressed null
              savePinOffline = { serial: patient.serial, pin: answer}
              app.db.insert 'offline-patient-pin', savePinOffline
              @goPatientViewPage patient

    else
      @_importPatient patient.serial, null, (importedPatientLocalId)=>
        @searchFieldMainInput = ''
        @searchContextDropdownSelectedIndex = 0
        @oneTimeSearchFilter = patient.serial
        @listAllImportedAndOfflinePatientsPressed null

  goPatientViewPage: (patient)->
    @domHost.setCurrentPatientsDetails patient
    @createdPatientVisitedLog patient
    @domHost.navigateToPage '#/patient-viewer/patient:' + patient.serial + '/selected:5'
    @domHost.selectedPatientPageIndex = 5




  importLatestPatientPressed: (e)->
    el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
    el.opened = false
    repeater = @$$ '#patient-list-repeater'

    index = repeater.indexForElement el
    patient = @matchingPatientList[index]

    @domHost.showModalPrompt "Fetching latest will discard local changes. Continue?", (answer)=>
      if answer
        app.db.remove 'patient-list', patient._id
        @importPatientPressed e

  putInWaitlistTapped: (e)->

    { organization } = e.model

    el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
    el.opened = false
    repeater = @$$ '#patient-list-repeater'

    index = repeater.indexForElement el
    patient = @matchingPatientList[index]

    # console.log patient

    @domHost.navigateToPage "#/organization-manage-waitlist/organization:#{organization.idOnServer}/patient:#{patient.serial}"


    # @domHost.showModalInput "Department/Waitlist/Subwaitlist [optional]", "None", (answer)=>
    #   return unless typeof answer is 'string'
    #   obj = {
    #     apiKey: @user.apiKey
    #     patientSerial: patient.serial
    #     patientNameManuallyEntered: patient.name
    #     details: answer
    #     organizationId: organization.idOnServer
    #   }
    #   @callApi '/bdemr-organization-waitlist-add-entry', obj, (err, response)=>
    #     if response.hasError
    #       @domHost.showModalDialog response.error.message
    #     else
    #       @domHost.showModalDialog response.data


  ## ------------------ import / publish end

  


  viewPatientPressed: (e)->
    el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
    el.opened = false
    repeater = @$$ '#patient-list-repeater'

    index = repeater.indexForElement el
    patient = @matchingPatientList[index]

    console.log 'PATIENT', patient

    @createdPatientVisitedLog patient

    @domHost.setCurrentPatientsDetails patient

    # @domHost.navigateToPage '#/visit-editor/visit:new/patient:' + patient.serial
    @domHost.navigateToPage '#/patient-viewer/patient:' + patient.serial + '/selected:5'
    @domHost.selectedPatientPageIndex = 5

  # editPatientPreconceptionRecord: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#patient-list-repeater'

  #   index = repeater.indexForElement el
  #   patient = @matchingPatientList[index]

  #   @domHost.navigateToPage '#/preconception-record/patients:' + patient.serial


  editPatientPressed: (e)->
    el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
    el.opened = false
    repeater = @$$ '#patient-list-repeater'

    index = repeater.indexForElement el
    patient = @matchingPatientList[index]

    @domHost.navigateToPage  '#/patient-editor/patient:' + patient.serial

  deletePatientPressed: (e)->
    el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
    el.opened = false
    repeater = @$$ '#patient-list-repeater'

    index = repeater.indexForElement el
    patient = @matchingPatientList[index]

    @domHost.showModalPrompt 'Are you sure?', (answer)=>
      if answer is true
        _id = patient._id
        if not _id and _id isnt 0
          _id = patient._tempLocalDbId
        app.db.remove 'patient-list', (_id)
        @searchButtonPressed null

  $or: (a, b)-> a or b

  $log: (obj)->
    # console.log obj


  searchResultFilterByDateClicked: (e)->
    if @resultedPatientList.length is 0
      @resultedPatientList = @matchingPatientList

    @currentDateFilterStartDate = e.detail.startDate
    @currentDateFilterEndDate = e.detail.endDate

    startDate = new Date e.detail.startDate
    endDate = new Date e.detail.endDate
    endDate.setHours 24 + endDate.getHours()
    filterdList = (item for item in @resultedPatientList when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
    @matchingPatientList = filterdList

  searchResultFilterByDateClearButtonClicked: (e)->
    @currentDateFilterStartDate = null
    @currentDateFilterEndDate = null
    @matchingPatientList = @resultedPatientList
    @resultedPatientList = []

  viewPatient: (e)->
    el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
    el.opened = false
    repeater = @$$ '#patient-list-repeater'

    index = repeater.indexForElement el

    patient = @matchingPatientList[index]
    
    @domHost.setCurrentPatientsDetails patient
    @createdPatientVisitedLog patient
    # @domHost.navigateToPage '#/visit-editor/visit:new/patient:' + patient.serial
    @domHost.selectedPatientPageIndex = 5
    @domHost.navigateToPage '#/patient-viewer/patient:' + patient.serial + '/selected:5'


  # Visted Patient Log
  # ================================

  createdPatientVisitedLog: (patient)->

    visitedPatientLogObject = {
      createdByUserSerial: @user.serial
      serial: @generateSerialForVisitedPatientLog()
      patientSerial: patient.serial
      patientName: patient.name
      visitedDateTimeStamp: lib.datetime.now()
      lastModifiedDatetimeStamp: lib.datetime.now()
    }

    app.db.insert 'visited-patient-log', visitedPatientLogObject

  _listVisitedPatientLog: () ->
    list = app.db.find 'visited-patient-log'
    logList = [].concat list
    logList.sort (left, right)->
      return -1 if left.visitedDateTimeStamp > right.visitedDateTimeStamp
      return 1 if left.visitedDateTimeStamp < right.visitedDateTimeStamp
      return 0

    @matchingVisitedPatientLogList = logList

    # console.log @matchingVisitedPatientLogList


  viewPatientPressedFromLog: (e)->
    el = @locateParentNode e.target, 'PAPER-BUTTON'
    el.opened = false
    repeater = @$$ '#visited-patient-log-repeater'

    index = repeater.indexForElement el
    patient = @matchingVisitedPatientLogList[index]

    localPatientList = app.db.find 'patient-list', ({serial})-> serial is patient.patientSerial

    if localPatientList.length is 1
      localPatient = localPatientList[0]

      visitedPatientLogObject = {
        createdByUserSerial: @user.serial
        serial: @generateSerialForVisitedPatientLog()
        patientSerial: patient.patientSerial
        patientName: patient.patientName
        visitedDateTimeStamp: lib.datetime.now()
        lastModifiedDatetimeStamp: lib.datetime.now()
      }

      app.db.insert 'visited-patient-log', visitedPatientLogObject



      @domHost.setCurrentPatientsDetails localPatient

      @domHost.navigateToPage '#/visit-editor/visit:new/patient:' + patient.patientSerial
      

    if localPatientList.length is 0
      @domHost.showModalInput "Please enter patient PIN", "0000", (answer)=>
        if answer
          @_importPatient patient.patientSerial, answer, (importedPatientLocalId)=>
            @searchFieldMainInput = ''
            @searchContextDropdownSelectedIndex = 0
            @oneTimeSearchFilter = patient.patientSerial
            @listAllImportedAndOfflinePatientsPressed null

       @selectedSearchViewIndex = 0


  importPatientPressedFromLog: (e)->
    el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
    el.opened = false
    repeater = @$$ '#visited-patient-log-repeater'

    index = repeater.indexForElement el
    patient = @matchingVisitedPatientLogList[index]

    localPatientList = app.db.find 'patient-list', ({serial})-> serial is patient.patientSerial

    if localPatientList.length is 1
      @domHost.showModalDialog "Already Imported!"


    if localPatientList.length is 0
      @domHost.showModalInput "Please enter patient PIN", "0000", (answer)=>
        if answer
          @_importPatient patient.patientSerial, answer, (importedPatientLocalId)=>
            @searchFieldMainInput = ''
            @searchContextDropdownSelectedIndex = 0
            @oneTimeSearchFilter = patient.patientSerial
            @listAllImportedAndOfflinePatientsPressed null

       @selectedSearchViewIndex = 0


  searchResultFilterByDateClickedForPatientLog: (e)->
    if @filteredPatientVisitedPatientLogList.length is 0
      @filteredPatientVisitedPatientLogList = @matchingVisitedPatientLogList

    @currentDateFilterStartDate = e.detail.startDate
    @currentDateFilterEndDate = e.detail.endDate

    startDate = new Date e.detail.startDate
    endDate = new Date e.detail.endDate
    endDate.setHours 24 + endDate.getHours()
    filterdList = (item for item in @filteredPatientVisitedPatientLogList when (startDate.getTime() <= (new Date item.visitedDateTimeStamp).getTime() <= endDate.getTime()))
    @matchingVisitedPatientLogList = filterdList

  searchResultFilterByDateClearButtonClickedForPatientLog: (e)->
    @currentDateFilterStartDate = null
    @currentDateFilterEndDate = null
    @matchingVisitedPatientLogList = @filteredPatientVisitedPatientLogList
    @filteredVisitedPatientLogList = []


  _isEmptyArray: (data)->
    if data.length is 0
      return true
    else
      return false

}
