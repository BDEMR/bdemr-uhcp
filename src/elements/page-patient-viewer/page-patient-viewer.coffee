dataURItoBlob = (dataURI) ->
  byteString = atob(dataURI.split(',')[1])
  mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]
  ab = new ArrayBuffer(byteString.length)
  ia = new Uint8Array(ab)
  i = 0
  while i < byteString.length
    ia[i] = byteString.charCodeAt(i)
    i++
  blob = new Blob([ ab ], type: mimeString)
  blob

Polymer {

  is: 'page-patient-viewer'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
    __SOURAV_MIXIN_graphMixin
  ]

  properties:

    selectedOldVisitRecordPage:
      type: Number
      notify: true
      value: 0

    selectedSubViewIndex:
      type: Number
      notify: true
      value: 0

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


    doctorCommentMessage:
      type: Object
      notify: true
      value: {}


    matchingVisitList:
      type: Array
      notify: true
      value: []

    modifiedVisitList:
      type: Array
      notify: true
      value: []

    matchingCurrentMedicineList:
      type: Array
      notify: true
      value: []

    matchingOldMedicineList:
      type: Array
      notify: true
      value: []

    matchingVitalBloodPressureList:
      type: Array
      notify: true
      value: []

    matchingVitalPulseRateList:
      type: Array
      notify: true
      value: []

    matchingVitalBMIList:
      type: Array
      notify: true
      value: []

    matchingVitalRespiratoryRateList:
      type: Array
      notify: true
      value: []

    matchingVitalSpO2List:
      type: Array
      notify: true
      value: []

    matchingVitalTemperatureList:
      type: Array
      notify: true
      value: []

    matchingCommentHistoryList:
      type: Array
      notify: true
      value: []

    matchingTestBloodSugarList:
      type: Array
      notify: true
      value: []

    matchingOtherTestList:
      type: Array
      notify: true
      value: []

    matchingPatientCommentList:
      type: Array
      notify: true
      value: []

    matchingDoctorCommentList:
      type: Array
      notify: true
      value: []

    attachmentList:
      type: Array
      notify: false
      value: -> []

    newAttachment:
      type: Object
      notify: false
      value: null

    localDataUriDb:
      type: Object
      value: null

    maximumImageSizeAllowedInBytes: 
      type: Number
      value: 10 * 1000 * 1000

    maximumLocalDataUriDbSizeInChars: 
      type: Number
      value: 2 * 1000 * 1000

    localDataUsedPercentage:
      type: Number
      value: 0

    currentDateFilterStartDate:
      type: Number

    currentDateFilterEndDate:
      type: Number

    isDownloading:
      type: Boolean
      value: false
    
    isUploading:
      type: Boolean
      value: false

    toAuthorizeIndex:
      type: Number
      value: null

    toAuthorizePccIndex:
      type: Number
      value: null

    toAuthorizeNdrIndex:
      type: Number
      value: null

    organizationsIBelongToList:
      type: Array
      value: -> []

    authorizeToSelectedIndex:
      type: Number
      value: null

    confirmedDiagnosisList:
      type: Array
      value: []

    activityLogs:
      type: Array
      value: -> []

    matchingNextVisitList:
      type: Array
      notify: true
      value: []

    visitDiagnosis:
      type: Array
      notify: true
      value: []

    matchingPccRecordList:
      type: Array
      notify: true
      value: -> []

    matchingNdrRecordList:
      type: Array
      notify: true
      value: -> []

    sickReasonSelectedIndex:
      type: Number
      value: -> 0
    
    leaveData:
      type: Object
      value: -> {}
    
    sickReasonList: 
      type: Array
      value: [
        'Sick'
        'Personal'
        'Injury'
        'Others'
      ]

    leaveData:
      type: Object
      value: -> {data: []}

    monthList:
      type: Array
      value: -> [
        'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'
      ]

    selectedLeaveView:
      type: Number
      value: -> 0

    viewLeaveDetails:
      type: Array
      value: -> []

  # Helper
  # ================================

  arrowBackButtonPressed: (e)->
    @domHost.setSelectedVisitSerial 'new'
    @domHost.navigateToPage '#/patient-manager'

  $findCreator: (creatorSerial)-> 'me'

  _isEmptyString: (data)->
    if data == null || data == 'undefined' || data == ''
      return true
    else
      return false

  _compareFn: (left, op, right)->
    if (op=='<')
      return left < right
    if (op=='>')
      return left > right
    if (op=='==')
      return left == right
    if (op=='>=')
      return left >= right
    if (op=='<=')
      return left <= right
  

  _isEmptyArray: (data)->
    if data.length is 0
      return true
    else
      return false

  _computeTotalDaysCount: (endDate, startDate)->
    return (@$TRANSLATE("As Needed", @LANG)) unless endDate
    oneDay = 1000*60*60*24;
    startDate = new Date startDate
    diffMs = endDate - startDate
    x =  Math.round(diffMs / oneDay)
    return @$TRANSLATE_NUMBER(x, @LANG)

  _computeAge: (dateString)->
    today = new Date()
    birthDate = new Date dateString
    age = today.getFullYear() - birthDate.getFullYear()
    m = today.getMonth() - birthDate.getMonth()

    if m < 0 || (m == 0 && today.getDate() < birthDate.getDate())
      age--
    
    return age

  

  _sortByDate: (a, b)->
    if a.date < b.date
      return 1
    if a.date > b.date
      return -1

  _formatDateTime: (dateTime)->
    lib.datetime.format((new Date dateTime), 'mmm d, yyyy h:MMTT')

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
      return
    else
      @_notifyInvalidPatient()


  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]
      # console.log @user

  _notifyInvalidPatient: ->
    @isPatientValid = false
    @domHost.showModalDialog 'Invalid Patient Provided'


  searchGalleryTapped: (e)->
    data = { 
      apiKey: @user.apiKey
      searchString: @fileSearchString
      userId: @user.idOnServer
      patientId: @patient.serial
    }
    @callApi '/bdemr-patient-file-search', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @matchingFileList = response.data.matchingFileList

  deleteConfirmDiagnosis: (e)->
    el = @locateParentNode e.target, 'PAPER-ICON-BUTTON'
    el.opened = false
    repeater = @$$ '#confirmed-diagnosis-list-repeater'

    index = repeater.indexForElement el

    diagnosis = @confirmedDiagnosisList[index]
    @domHost.showModalPrompt 'Are you sure?', (answer)=>
      if answer is true
        id = (app.db.find 'visit-diagnosis', ({serial})-> serial is diagnosis.serial)[0]._id
        app.db.remove 'visit-diagnosis', id
        app.db.insert 'visit-diagnosis--deleted', { serial: diagnosis.serial }
        @domHost.showToast 'Confirmed Diagnosis Deleted!'
        @_listConfirmedDiagnosis @patient.serial

  _checkFileDataURI: (dataURI)->
    if dataURI is ''
      return 'assets/no-preview.png'
    else
      return dataURI

  goPatientEditPage: ()->
    @domHost.navigateToPage '#/patient-editor/patient:' + @patient.serial

  goPreconceptionRecordEditPage: ()->
    @domHost.navigateToPage '#/preconception-record/patients:' + @patient.serial

  goToPreconceptionRecordPreviewPage: ()->
    @domHost.navigateToPage '#/preview-preconception-record/patients:' + @patient.serial


  loadPatientPccRecords: (patientIdentifier) ->
    list = app.db.find 'pcc-records', ({patientSerial}) -> patientSerial is patientIdentifier

    if list.length > 0
      list.sort (left, right)->
        return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
        return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
        return 0

    @matchingPccRecordList = list

    @checkIfPatientHaveDiabeticsOrNot()

  loadPatientNdrRecords: (patientIdentifier) ->
    list = app.db.find 'ndr-records', ({patientSerial}) -> patientSerial is patientIdentifier

    if list.length > 0
      list.sort (left, right)->
        return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
        return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
        return 0

    @matchingNdrRecordList = list

  checkIfPatientHaveDiabeticsOrNot: ()->
    possibleDMStringList = ['Known Diabetes', 'DM', 'KNOWN DIABETES']
    if @matchingPccRecordList.length > 0
      for item in @matchingPccRecordList
        for string in possibleDMStringList
          if item.clinical?.pregnancyInfo?.glycemicStatus? is string
            localStorage.setItem("currentPatientGlycemicStatus", string)
            return
    else return

  _callBDEMRPatientDetailsUpdateApi: (patient) ->
    data =
      patient: patient
      apiKey: @user.apiKey
    @callApi '/bdemr-patient-details-update', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @domHost.showToast 'Patient Updated!'

  formatDate: (d)->
    # get the month
    month = d.getMonth()
    # get the day
    # convert day to string
    day = d.getDate().toString()
    # get the year
    year = d.getFullYear()
    
    # pull the last two digits of the year
    year = year.toString().substr(-2)
    
    # increment month by 1 since it is 0 indexed
    # converts month to a string
    month = (month + 1).toString()

    # if month is 1-9 pad right with a 0 for two digits
    if (month.length is 1)
      month = "0" + month
 

    # if day is between 1-9 pad right with a 0 for two digits
    if (day.length is 1)
      day = "0" + day
      

    # return the string "MMddyy"
    return day + month +  + year

  generateRandomString : ( randomStringLength ) ->
    randomString = ''
    characterList = []
    for item in [0..25]
      characterList.push String.fromCharCode( 'a'.charCodeAt() + item )
    for item in [0..25]
      characterList.push String.fromCharCode( 'A'.charCodeAt() + item )
    for item in [0..9]
      characterList.push String.fromCharCode( '0'.charCodeAt() + item )

    len = characterList.length
    for item in [ 1..randomStringLength ]
      idx = ( Math.floor ( Math.random() * 10000363 ) ) % 10000019
      idx %= len
      randomString += characterList[ idx ]

    return randomString

  generateRandomNumericString : ( randomStringLength ) ->
    randomString = ''
    characterList = []
    for item in [0..9]
      characterList.push String.fromCharCode( '0'.charCodeAt() + item )

    len = characterList.length
    for item in [ 1..randomStringLength ]
      idx = ( Math.floor ( Math.random() * 10000363 ) ) % 10000019
      idx %= len
      randomString += characterList[ idx ]

    return randomString

  generatedRecordSpecificRandomPatientId: (recordTypeIdentifier)->
    string = @generateRandomString 6
    number = @generateRandomNumericString 4
    ms = lib.datetime.now()
    d = new Date()
    date = @formatDate d

    id = string + "-" +  date + "-" + recordTypeIdentifier + "-" + number

    return id


  checkForRecordSpecificPatientId: (recordTypeIdentifier, cbfn)->
    recordSpecificIdList = []

    patientIdExist = false

    if ((typeof @patient.recordSpecificPatientIdList is 'undefined') or (@patient.recordSpecificPatientIdList is null))
      @patient.recordSpecificPatientIdList = []
    else
      recordSpecificIdList = @patient.recordSpecificPatientIdList

    if recordSpecificIdList.length > 0
      for item in recordSpecificIdList
        if item.recordType is recordTypeIdentifier
          patientIdExist = true
          break
        else
          patientIdExist = false

    if !patientIdExist
      object = {
        recordType: recordTypeIdentifier
        patientId: @generatedRecordSpecificRandomPatientId recordTypeIdentifier
      }

      @patient.recordSpecificPatientIdList.push object

      app.db.upsert 'patient-list', @patient, ({serial})=> @patient.serial is serial

      @_callBDEMRPatientDetailsUpdateApi @patient

    cbfn()

  viewPccRecord: (e)->
    index = e.model.index
    record = @matchingPccRecordList[index]
    @domHost.navigateToPage "#/preview-preconception-record/record:" + record.serial

  editPccRecord: (e)->
    index = e.model.index
    record = @matchingPccRecordList[index]
    @domHost.navigateToPage "#/preconception-record/record:" + record.serial + "/patients:" + record.patientSerial

  getPatientIdForRecordType: (recordTypeIdentifier, list)->
    if typeof list is 'undefined'
      return null
    
    else
      if list.length > 0
        for item in list
          if item.recordType is recordTypeIdentifier
            return item.patientId
            break
          else 
            return null
      else
        return null


  addNewPccRecord: ()->
    @checkForRecordSpecificPatientId 'PC', =>
      @domHost.navigateToPage "#/preconception-record/record:new" + "/patients:" + @patient.serial


  editNdrRecord: (e)->
    index = e.model.index
    record = @matchingNdrRecordList[index]
    @domHost.navigateToPage "#/ndr/record:" + record.serial + "/patient:" + record.patientSerial

  addNewNdrRecord: ()->
    @checkForRecordSpecificPatientId 'NR', =>
      @domHost.navigateToPage "#/ndr/record:new" + "/patient:" + @patient.serial

  editPatientBtnPressed: ()->
    @domHost.navigateToPage "#/patient-editor/patient:" + @patient.serial

  navigatedIn: ->
    currentOrganization = @getCurrentOrganization()
    unless currentOrganization
      @domHost.navigateToPage "#/select-organization"

    params = @domHost.getPageParams()

    @_loadUser()
    @set 'selectedMedicinePage', 0
    @set 'selectedVitalPage', 0
    @set 'selectedTestPage', 0
    @set 'selectedNextVisitPage', 0
    @set 'selectedCommentPage', 0
    @set 'matchingVisitList', []
    @set 'modifiedVisitList', []

    if params['selected']
      index = params['selected']
      index = parseInt index
      
      @set "selectedSubViewIndex", (index - 1)
    
    if params['patient']
      @_loadPatient params['patient']
    else
      @_notifyInvalidPatient()

    if @isPatientValid
      @_listVisits()

    @_getActivityLogs()
    
    @_organizationNavigatedIn()

    @_listConfirmedDiagnosis params['patient']
    @_listCurrentMedications params['patient']
    @_listOldMedications params['patient']
    @_listVitalBloodPressure params['patient']
    @_listVitalPulseRate params['patient']
    @_listVitalBMI params['patient']
    @_listVitalRespiratoryRate params['patient']
    @_listVitalSpO2 params['patient']
    @_listVitalTemperature params['patient']
    @_listTestBloodSugar params['patient']
    @_listOtherTest params['patient']
    @_listDoctorComment params['patient']
    @_listPatientComment params['patient']

    @_loadPatientNextVisit params['patient']

    @loadPatientPccRecords params['patient']
    @loadPatientNdrRecords params['patient']

    @_makeDoctorComment()

    @_openLocalDataUriDb()
    @_makeBlankAttachment()
    # @_loadAttachmentList(params['patient'])
    @_updateSpaceCalculation()

    # @_updatePatientSerialForSync params['patient']

    @_loadDiagnosisNameList()

    # @showGraphPressed()

    @_loadLeaveData @patient.serial

      

  navigatedOut: ->
    @patient = null
    @isPatientValid = false
    
    @matchingVisitList = []
    @modifiedVisitList = []
    @matchingCurrentMedicineList = []
    @matchingOldMedicineList = []
    @matchingVitalBloodPressureList = []
    @matchingVitalPulseRateList = []
    @matchingVitalBMIList = []
    @matchingVitalRespiratoryRateList = []
    @matchingVitalSpO2List = []
    @matchingVitalTemperatureList = []

    @matchingPatientCommentList = []
    @matchingDoctorCommentList = []

    @matchingTestBloodSugarList = []
    @matchingOtherTestList = []
    @patient = null

  
  # Visits [START]
  # ================================

  _listVisits: ->

    visitlist = app.db.find 'doctor-visit', ({patientSerial})=> @patient.serial is patientSerial
    recordList = app.db.find 'anaesmon-record', ({patientSerial})=> @patient.serial is patientSerial
    # console.log 'recordList', recordList
    finalList = [].concat visitlist, recordList

    finalList.sort (left, right)->
      return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
      return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
      return 0

    modifiedList = []

    for visit in finalList
      recordList = [
        {
          visitSerial: visit.serial
          recordSerial: visit.prescriptionSerial
          recordType: 'Prescription'
          hideAuthorizeButton: false
        }
        {
          visitSerial: visit.serial
          recordSerial: visit.advisedTestSerial
          recordType: 'Test Advised'
          hideAuthorizeButton: false
        }
        {
          visitSerial: visit.serial
          recordSerial: visit.historyAndPhysicalRecordSerial
          recordType: 'History & Physical'
          hideAuthorizeButton: false
        }
        {
          visitSerial: visit.serial
          recordSerial: visit.diagnosisSerial
          recordType: 'Diagnosis'
          hideAuthorizeButton: true
        }
        {
          visitSerial: visit.serial
          recordSerial: visit.doctorNotesSerial
          recordType: 'Doctor Notes'
          hideAuthorizeButton: true
        }
        {
          visitSerial: visit.serial
          recordSerial: visit.identifiedSymptomsSerial
          recordType: 'Symptoms'
          hideAuthorizeButton: true
        }
        {
          visitSerial: visit.serial
          recordSerial: visit.invoiceSerial
          recordType: 'Invoice'
          hideAuthorizeButton: true
        }
        
      ]



      visit.recordList = recordList
      modifiedList.push visit

      # console.log 'modifiedList', modifiedList

    @matchingVisitList = modifiedList


  _makeVisitRecordForReportType: (visitObject, visitRecordTypeName, visitRecordTypeSerial, visitHasTestResult, visitTestResultName) ->
    # console.log visitObject
    unless visitObject.recordType is "anaesmon-record"
      if visitObject.testResults.attachmentSerialList.length > 0
        getAttachmentSerialList = visitObject.testResults.attachmentSerialList
      else
        getAttachmentSerialList = []
   
    modifiedVisitObject = {
      serial: visitObject.serial
      createdDatetimeStamp: visitObject.createdDatetimeStamp
      hospitalName: visitObject.hospitalName
      doctorName: visitObject.doctorName
      doctorSpeciality: visitObject.doctorSpeciality
      recordTypeSerial: visitRecordTypeSerial
      recordTypeName: visitRecordTypeName
      attachmentSerialList: getAttachmentSerialList
      hasTestResult: visitHasTestResult
      testResultName: visitTestResultName
    }

    return modifiedVisitObject


  _loadPatientNextVisit: (patientIdentifier)->
    list = app.db.find 'visit-next-visit', ({patientSerial})-> patientSerial is patientIdentifier
    
    nextVisitList = [].concat list
    nextVisitList.sort (left, right)->
      return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
      return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
      return 0

    @matchingNextVisitList = nextVisitList

  viewVisitRecord: (e)->

    el = @locateParentNode e.target, 'PAPER-ITEM'
    el.opened = false
    repeater = @$$ '#visit-list-repeater'

    index = repeater.indexForElement el
    visit = @matchingVisitList[index]

    visit = @matchingVisitList[index]

    if visit.recordTypeName is 'Test Results'
      if visit.testResults.serial
        @domHost.navigateToPage '#/print-test-result/visit:' + visit.serial + '/patient:' + @patient.serial + '/test-results:' + visit.testResults.serial
        return
      
    else if visit.recordTypeName is 'Invoice'
      @domHost.navigateToPage '#/print-invoice/visit:' + visit.serial + '/patient:' + @patient.serial + '/invoice:' + visit.recordTypeSerial
      return

    else
      @domHost.setSelectedVisitSerial visit.serial
      @domHost.selectedPatientPageIndex = 0
      @domHost.navigateToPage '#/visit-editor/visit:' + visit.serial + '/patient:' + @patient.serial
      return

  

  _checkRecordTitle: (data)->
    if data.testResults?.serial is null
      if data.recordTitle is undefined or data.recordTitle is null or data.recordTitle is ''
        return 'Complete Visit'

      else
        return data.recordTitle
    else
      return data.testResults?.name



  visitReportCopyBtnPressed: (e)->
    # @domHost.showToast 'Work in Progress!'

    el = @locateParentNode e.target, 'PAPER-ITEM'
    el.opened = false
    repeater = @$$ '#visit-list-repeater'

    index = repeater.indexForElement el
    visit = @matchingVisitList[index]

    if visit.recordTypeName is "History & Physical"
      # console.log visit
      @domHost.navigateToPage '#/visit-editor/visit:' + visit.serial + '/patient:' + @patient.serial + '/record:' + visit.recordTypeSerial
      return

    else
      @domHost.showToast "Something Wrong, contact ADMIN"

  viewTestResultsAttachemntsBtnPressed: (e)->
    el = @locateParentNode e.target, 'PAPER-BUTTON'
    el.opened = false
    repeater = @$$ '#visit-list-repeater'

    index = repeater.indexForElement el
    visit = @matchingVisitList[index]

    @domHost.navigateToPage '#/attachement-preview/test-result:' + visit.testResults.serial

  # Event for Anaesmon Record Preview
  preopPreviewButtonClicked: (e)->
    el = @locateParentNode e.target, 'PAPER-ITEM'
    repeater = @$$ '#visit-list-repeater'
    index = repeater.indexForElement el
    visit = @matchingVisitList[index]
    @domHost.navigateToPage '#/print-anaesmon-record/part:preop-assessment/record:' + visit.serial
  postopPreviewButtonClicked: (e)->
    el = @locateParentNode e.target, 'PAPER-ITEM'
    repeater = @$$ '#visit-list-repeater'
    index = repeater.indexForElement el
    visit = @matchingVisitList[index]
    @domHost.navigateToPage '#/print-anaesmon-record/part:postop-assessment/record:' + visit.serial
  opAnaesthesiaPreviewButtonClicked: (e)->
    el = @locateParentNode e.target, 'PAPER-ITEM'
    repeater = @$$ '#visit-list-repeater'
    index = repeater.indexForElement el
    visit = @matchingVisitList[index]
    @domHost.navigateToPage '#/print-anaesmon-record/part:op-anaesthesia/record:' + visit.serial
  opSurgeryPreviewButtonClicked: (e)->
    el = @locateParentNode e.target, 'PAPER-ITEM'
    repeater = @$$ '#visit-list-repeater'
    index = repeater.indexForElement el
    visit = @matchingVisitList[index]
    @domHost.navigateToPage '#/print-anaesmon-record/part:op-surgery/record:' + visit.serial
  
  # ----------------------------------------------------------------------
  # Event End


  createNewVisitPressed: (e)->
    @domHost.navigateToPage  '#/visit-editor/visit:new/patient:' + @patient.serial

  selectedVisitTypeVisitButtonPressed: (e)->
    el = @locateParentNode e.target, 'PAPER-ITEM'
    el.opened = false
    repeater = @$$ '#visit-list-repeater'

    index = repeater.indexForElement el
    visit = @matchingVisitList[index]

    @domHost.navigateToPage '#/visit-editor/patient:' + @patient.serial + '/visit:' + visit.serial + '/selected:5'

  printCurrentMedicinePressed: (e)->
    @domHost.navigateToPage  '#/print-current-medicine/patient:' + @patient.serial

  printOldMedicinePressed: (e)->
    @domHost.navigateToPage  '#/print-old-medicine/patient:' + @patient.serial

  printBothMedicinePressed: (e)->
    @domHost.navigateToPage  '#/print-both-medicine/patient:' + @patient.serial

  printVitalBPPressed: (e)->
    @domHost.navigateToPage  '#/print-vital-bp/patient:' + @patient.serial  + '/startDate:' + @currentDateFilterStartDate + '/endDate:' + @currentDateFilterEndDate

  printVitalPRPressed: (e)->
    @domHost.navigateToPage  '#/print-vital-pr/patient:' + @patient.serial  + '/startDate:' + @currentDateFilterStartDate + '/endDate:' + @currentDateFilterEndDate

  printVitalBMIPressed: (e)->
    @domHost.navigateToPage  '#/print-vital-bmi/patient:' + @patient.serial  + '/startDate:' + @currentDateFilterStartDate + '/endDate:' + @currentDateFilterEndDate

  printVitalRRPressed: (e)->
    @domHost.navigateToPage  '#/print-vital-rr/patient:' + @patient.serial  + '/startDate:' + @currentDateFilterStartDate + '/endDate:' + @currentDateFilterEndDate

  printVitalSpo2Pressed: (e)->
    @domHost.navigateToPage  '#/print-vital-spo2/patient:' + @patient.serial  + '/startDate:' + @currentDateFilterStartDate + '/endDate:' + @currentDateFilterEndDate

  printVitalTempPressed: (e)->
    @domHost.navigateToPage  '#/print-vital-temp/patient:' + @patient.serial  + '/startDate:' + @currentDateFilterStartDate + '/endDate:' + @currentDateFilterEndDate

  printTestBloodSugarPressed: (e)->
    @domHost.navigateToPage  '#/print-blood-sugar/patient:' + @patient.serial  + '/startDate:' + @currentDateFilterStartDate + '/endDate:' + @currentDateFilterEndDate

  printTestOtherPressed: (e)->
    @domHost.navigateToPage  '#/print-other-test/patient:' + @patient.serial  + '/startDate:' + @currentDateFilterStartDate + '/endDate:' + @currentDateFilterEndDate


  viewVisitPressed: (e)->
    el = @locateParentNode e.target, 'PAPER-BUTTON'
    el.opened = false
    repeater = @$$ '#visit-list-repeater'

    index = repeater.indexForElement el
    visit = @matchingVisitList[index]

    @domHost.setSelectedVisitSerial visit.serial
    @domHost.selectedPatientPageIndex = 0
    
    @domHost.navigateToPage '#/visit-editor/patient:' + @patient.serial + '/visit:' + visit.serial 

  duplicateVisitPressed: (e)->
    el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
    el.opened = false
    repeater = @$$ '#visit-list-repeater'

    index = repeater.indexForElement el
    visit = @matchingVisitList[index]

    @domHost.showModalDialog 'TODO'

  deleteVisitPressed: (e)->
    el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
    el.opened = false
    repeater = @$$ '#visit-list-repeater'

    index = repeater.indexForElement el
    visit = @matchingVisitList[index]
    @domHost.showModalPrompt 'Are you sure?', (answer)=>
      if answer is true
        app.db.remove 'doctor-visit', visit._id
        @_listVisits()

  visitCustomSearchClicked: (e)->
    startDate = new Date e.detail.startDate
    startDate.setHours 0,0,1
    endDate = new Date e.detail.endDate
    endDate.setHours 23,59,59
    filterdList = (item for item in @matchingVisitList when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
    @matchingVisitList = filterdList
  
  visitSearchClearButtonClicked: (e)->
    @_listVisits()

  computeVisitFilter: (searchString)->
    if !searchString
      return null
    else
      return (item)->
        searchString = searchString.toLowerCase()
        hospital = if item.hospitalName then item.hospitalName.toLowerCase() else ''
        nameOfDoctor = if item.doctorName then item.doctorName.toLowerCase() else ''
        specialty = if item.doctorSpeciality then item.doctorSpeciality.toLowerCase() else ''
        recordTitle = if item.recordTitle then item.recordTitle.toLowerCase() else ''

        regex = new RegExp "\\b#{searchString}", 'gi'
        if ((hospital.search regex) isnt -1) or ((nameOfDoctor.search regex) isnt -1) or ((specialty.search regex) isnt -1)or ((recordTitle.search regex) isnt -1)
          return true

  # === Visit [END] ===

  # Diagnosis - [START]
  # ================================

  _loadDiagnosisNameList: ->
    @domHost.getStaticData 'diagnosisList', (list)=>
      @diagnosisDataList = ({text: item.name, alt: ''} for item in list)

  _sortByImportantDiagnosis: (a, b)->
    if a.markedAsImportant < b.markedAsImportant
      return 1
    if a.markedAsImportant > b.markedAsImportant
      return -1
  
  _listConfirmedDiagnosis: (patientIdentifier)->
    record = app.db.find 'history-and-physical-record', ({patientSerial})->
      if patientSerial is patientIdentifier
        return true

    confirmedDiagnosisList = []
    
    for item in record
      confirmedDiagnosis = lib.util.findDeepValue 'Confirmed Diagnosis', item
      if confirmedDiagnosis
        checkedValueList = lib.util.findDeepValue 'virtualChildMap', confirmedDiagnosis
        if checkedValueList
          for own key, value of checkedValueList
            diagnosis = {
              createdDatetimeStamp: item.createdDatetimeStamp
              diagnosis: key.split("_")[1]
            }
            confirmedDiagnosisList.push diagnosis
        

    visitDiagnosis = app.db.find 'visit-diagnosis', ({patientSerial})=> patientSerial is patientIdentifier
    diagnosisList = [].concat confirmedDiagnosisList, visitDiagnosis
    
    @set 'confirmedDiagnosisList', diagnosisList
    
  newDiagnosisButtonClicked: ()->
    @$$('#newDiagnosisInputModal').toggle()

  
  diagnosisModalConfirm: (e) ->
    if e.detail.confirmed
      if @confirmedDiagnosisModalValue
        diagnosis = {
          serial: @generateSerialForDiagnosis()
          createdDatetimeStamp: lib.datetime.now()
          lastModifiedDatetimeStamp: lib.datetime.now()
          createdByUserSerial: @user.serial
          patientSerial: @patient.serial
          doctorName: @$getFullName @user.name
          doctorSpeciality: @getDoctorSpeciality()
          diagnosis: @confirmedDiagnosisModalValue
        }
        @push "confirmedDiagnosisList", diagnosis
        array = @confirmedDiagnosisList
        @confirmedDiagnosisList = []
        @confirmedDiagnosisList = array
        app.db.upsert "visit-diagnosis", diagnosis, ({serial})-> serial is serial
        @confirmedDiagnosisModalValue = ""
  
  # === Diagnosis [END] ===

  # Activity Log Start 
  # ================================

  _getActivityLogs: ->
    activityLogs = app.db.find 'activity', ({data})=> @patient.serial is data.patientSerial
    @set 'activityLogs', activityLogs

  # ================================
  # Acivity Log Ends



  # Medication - Current [START]
  # ================================

  _listCurrentMedications: (patientIdentifier) ->
    currentMedicineList = app.db.find 'patient-medications', ({patientSerial, data})->
      # if patientSerial is patientIdentifier and data.status is 'continue'
      if patientSerial is patientIdentifier
        if data.hasOwnProperty "status"
          if data.status is 'continue'
            return true

    # console.log currentMedicineList

    medicineList = [].concat currentMedicineList
    medicineList.sort (left, right)->
      return -1 if left.createdDatetimeStamp < right.createdDatetimeStamp
      return 1 if left.createdDatetimeStamp > right.createdDatetimeStamp
      return 0

    for medicine in medicineList
      medicine.flags = 
        isLocalOnly: true

    @matchingCurrentMedicineList = medicineList


  # === Medication - Current [END] ===



  # Medication - Old [START]
  # ================================

  _listOldMedications: (patientIdentifier) ->
    oldMedicineList = app.db.find 'patient-medications', ({patientSerial, data})->
      # if patientSerial is patientIdentifier and data.status is 'stopped'
      if patientSerial is patientIdentifier
        if data.hasOwnProperty "status"
          if data.status is 'stopped'
            return true
       

    medicineList = [].concat oldMedicineList
    medicineList.sort (left, right)->
      return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
      return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
      return 0

    for medicine in medicineList
      medicine.flags = 
        isLocalOnly: true

    @matchingOldMedicineList = medicineList

  # === Medication - Old [END] ===


  # Vitals
  # ================================

  vitalTabChanges: ->
    @showGraphPressed()

  _addVitalsButtonClicked: ->
    @domHost.navigateToPage '#/patient-vitals-editor/patient:' + @patient.serial


  # Vital - Blood Pressure [START]
  # ================================

  _listVitalBloodPressure: (patientIdentifier) ->
    vitalBloodPressureList = app.db.find 'patient-vitals-blood-pressure', ({patientSerial})=> @patient.serial is patientSerial

    vitalList = [].concat vitalBloodPressureList
    vitalList.sort (left, right)->
      return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
      return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
      return 0

    @matchingVitalBloodPressureList = vitalList

  addBloodPressureItemClicked: ->
    @domHost.navigateToPage '#/vital-blood-pressure/patient:' + @patient.serial + '/vital:new'

  # editBloodPressureItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-blood-pressure-list-repeater'

  #   index = repeater.indexForElement el
  #   vital = @matchingVitalBloodPressureList[index]

  #   @domHost.navigateToPage '#/vital-blood-pressure/patient:' + @patient.serial + '/vital:' + vital.serial

  # deleteBloodPressureItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-blood-pressure-list-repeater'
  #   params = @domHost.getPageParams()

  #   index = e.model.index
  #   vital = @matchingVitalBloodPressureList[index]

  #   @domHost.showModalPrompt 'Are you sure?', (answer)=>
  #     if answer is true
  #       id = (app.db.find 'patient-vitals-blood-pressure', ({serial})-> serial is vital.serial)[0]._id
  #       app.db.remove 'patient-vitals-blood-pressure', id
  #       app.db.insert 'patient-vitals-blood-pressure--deleted', { serial: vital.serial }
  #       @domHost.showToast 'Vital Deleted!'
  #       @_listVitalBloodPressure(params['patient'])

  _saveBloodPressure: (data)->
    app.db.upsert 'patient-vitals-blood-pressure', data, ({serial})=> data.serial is serial

  flagAsErrorBloodPressureItemClicked: (e)->
    el = @locateParentNode e.target, 'PAPER-ITEM'
    el.opened = false
    repeater = @$$ '#vital-blood-pressure-list-repeater'

    index = repeater.indexForElement el
    vital = @matchingVitalBloodPressureList[index]

    vital.data.flags =
      flagAsError: true

    @_saveBloodPressure(vital)

    @_listVitalBloodPressure(@patient.serial)

    @domHost.showToast "Flagged Successfully!"

    # Activity LOG for BLOOD PRESSURE FLAG
    @domHost.addActivityLog 'blood-pressure', 'flagAsError', vital
    



  bloodPressureCustomSearchClicked: (e)->
    @currentDateFilterStartDate = e.detail.startDate
    @currentDateFilterEndDate = e.detail.endDate

    startDate = new Date e.detail.startDate
    startDate.setHours 0,0,1
    endDate = new Date e.detail.endDate
    endDate.setHours 23,59,59
    filterdBPList = (item for item in @matchingVitalBloodPressureList when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
    @matchingVitalBloodPressureList = filterdBPList
    @showGraphPressed()
  
  bloodPressureSearchClearButtonClicked: (e)->
    @currentDateFilterStartDate = null
    @currentDateFilterEndDate = null

    params = @domHost.getPageParams()
    @_listVitalBloodPressure(params['patient'])
    @showGraphPressed()


  # === Vital - Blood Pressure [END] ===


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


  addPulseRateItemClicked: ->
    @domHost.navigateToPage '#/vital-pulse-rate/patient:' + @patient.serial + '/vital:new'

  # editPulseRateItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-pulse-rate-list-repeater'

  #   index = repeater.indexForElement el
  #   vital = @matchingVitalPulseRateList[index]

  #   @domHost.navigateToPage '#/vital-pulse-rate/patient:' + @patient.serial + '/vital:' + vital.serial

  # deletePulseRateItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-pulse-rate-list-repeater'
  #   params = @domHost.getPageParams()

  #   index = e.model.index
  #   vital = @matchingVitalPulseRateList[index]

  #   @domHost.showModalPrompt 'Are you sure?', (answer)=>
  #     if answer is true
  #       id = (app.db.find 'patient-vitals-pulse-rate', ({serial})-> serial is vital.serial)[0]._id
  #       app.db.remove 'patient-vitals-pulse-rate', id
  #       app.db.insert 'patient-vitals-pulse-rate--deleted', { serial: vital.serial }
  #       @domHost.showToast 'Vital Deleted!'
  #       @_listVitalPulseRate(params['patient'])

  _savePulseRate: (data)->
    app.db.upsert 'patient-vitals-pulse-rate', data, ({serial})=> data.serial is serial

    # console.log app.db.find 'patient-vitals-pulse-rate', ({serial})=> data.serial is serial

  flagAsErrorPulseRateItemClicked: (e)->
    el = @locateParentNode e.target, 'PAPER-ITEM'
    el.opened = false
    repeater = @$$ '#vital-pulse-rate-list-repeater'

    index = repeater.indexForElement el
    vital = @matchingVitalPulseRateList[index]

    vital.data.flags =
      flagAsError: true

    @_savePulseRate(vital)

    @_listVitalPulseRate(@patient.serial)

    @domHost.showToast "Flagged Successfully!"

    

  pulseRateCustomSearchClicked: (e)->
    @currentDateFilterStartDate = e.detail.startDate
    @currentDateFilterEndDate = e.detail.endDate

    startDate = new Date e.detail.startDate
    startDate.setHours 0,0,1
    endDate = new Date e.detail.endDate
    endDate.setHours 23,59,59
    filterdList = (item for item in @matchingVitalPulseRateList when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
    @matchingVitalPulseRateList = filterdList
    @showGraphPressed()
  
  pulseRateSearchClearButtonClicked: (e)->
    @currentDateFilterStartDate = null
    @currentDateFilterEndDate = null

    params = @domHost.getPageParams()
    @_listVitalPulseRate(params['patient'])
    @showGraphPressed()

  # === Vital - Pulse Rate [END] ===



  # Vital - BMI [START]
  # ================================

  _listVitalBMI: (patientIdentifier) ->
    vitalBMIList = app.db.find 'patient-vitals-bmi', ({patientSerial})=> @patient.serial is patientSerial

    vitalList = [].concat vitalBMIList
    vitalList.sort (left, right)->
      return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
      return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
      return 0

    for vital in vitalList
      vital.flags = 
        isLocalOnly: true

    @matchingVitalBMIList = vitalList

  addBMIItemClicked: ->
    @domHost.navigateToPage '#/vital-bmi/patient:' + @patient.serial + '/vital:new'

  # editBMIItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-bmi-list-repeater'

  #   index = repeater.indexForElement el
  #   vital = @matchingVitalBMIList[index]

  #   @domHost.navigateToPage '#/vital-bmi/patient:' + @patient.serial + '/vital:' + vital.serial

  # deleteBMIItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-pulse-rate-list-repeater'
  #   params = @domHost.getPageParams()

  #   index = e.model.index
  #   vital = @matchingVitalBMIList[index]

  #   @domHost.showModalPrompt 'Are you sure?', (answer)=>
  #     if answer is true
  #       id = (app.db.find 'patient-vitals-bmi', ({serial})-> serial is vital.serial)[0]._id
  #       app.db.remove 'patient-vitals-bmi', id
  #       app.db.insert 'patient-vitals-bmi--deleted', { serial: vital.serial }
  #       @domHost.showToast 'Vital Deleted!'
  #       @_listVitalBMI(params['patient'])

  _calculateBMIVerdict: (result)->
    if result is 0 or not result
      return 'Pending'
    else if result < 18.5
      return 'Underweight'
    else if 18.5 <= result < 24.9
      return 'Normal'
    else if 25 <= result < 29.9
      return 'Overweight'
    else
      return 'Obese'

  isHeightCmOrM: (unit)-> 
    return true unless unit is 'ft/inch'
  isHeightFtInch: (unit)->
    return true if unit is 'ft/inch'


  BMICustomSearchClicked: (e)->
    @currentDateFilterStartDate = e.detail.startDate
    @currentDateFilterEndDate = e.detail.endDate

    startDate = new Date e.detail.startDate
    startDate.setHours 0,0,1
    endDate = new Date e.detail.endDate
    endDate.setHours 23,59,59
    filterdList = (item for item in @matchingVitalBMIList when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
    @matchingVitalBMIList = filterdList
    @showGraphPressed()
  
  BMISearchClearButtonClicked: (e)->
    @currentDateFilterStartDate = null
    @currentDateFilterEndDate = null

    params = @domHost.getPageParams()
    @_listVitalBMI(params['patient'])
    @showGraphPressed()


  _saveBMI: (data)->
    app.db.upsert 'patient-vitals-bmi', data, ({serial})=> data.serial is serial

  flagAsErrorBMIItemClicked: (e)->
    el = @locateParentNode e.target, 'PAPER-ITEM'
    el.opened = false
    repeater = @$$ '#vital-bmi-list-repeater'

    index = repeater.indexForElement el
    vital = @matchingVitalBMIList[index]

    vital.data.flags =
      flagAsError: true

    @_saveBMI(vital)

    @_listVitalBMI(@patient.serial)

    @domHost.showToast "Flagged Successfully!"

  # === Vital - BMI [END] ===



  # Vital - Respiratory Rate [START]
  # ================================
  _listVitalRespiratoryRate: (patientIdentifier) ->
    vitalRespiratoryRateList = app.db.find 'patient-vitals-respiratory-rate', ({patientSerial})=> @patient.serial is patientSerial

    vitalList = [].concat vitalRespiratoryRateList
    vitalList.sort (left, right)->
      return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
      return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
      return 0

    for vital in vitalList
      vital.flags = 
        isLocalOnly: true

    @matchingVitalRespiratoryRateList = vitalList


  addRespiratoryRateItemClicked: ->
    @domHost.navigateToPage '#/vital-respiratory-rate/patient:' + @patient.serial + '/vital:new'

  # editRespiratoryRateItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-respiratory-rate-list-repeater'

  #   index = repeater.indexForElement el
  #   vital = @matchingVitalRespiratoryRateList[index]

  #   @domHost.navigateToPage '#/vital-respiratory-rate/patient:' + @patient.serial + '/vital:' + vital.serial

  # deleteRespiratoryRateItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-respiratory-rate-list-repeater'
  #   params = @domHost.getPageParams()

  #   index = e.model.index
  #   vital = @matchingVitalRespiratoryRateList[index]

  #   @domHost.showModalPrompt 'Are you sure?', (answer)=>
  #     if answer is true
  #       id = (app.db.find 'patient-vitals-respiratory-rate', ({serial})-> serial is vital.serial)[0]._id
  #       app.db.remove 'patient-vitals-respiratory-rate', id
  #       app.db.insert 'patient-vitals-respiratory-rate--deleted', { serial: vital.serial }
  #       @domHost.showToast 'Vital Deleted!'
  #       @_listVitalRespiratoryRate(params['patient'])

  _saveRR: (data)->
    app.db.upsert 'patient-vitals-respiratory-rate', data, ({serial})=> data.serial is serial

  flagAsErrorRRItemClicked: (e)->
    el = @locateParentNode e.target, 'PAPER-ITEM'
    el.opened = false
    repeater = @$$ '#vital-respiratory-rate-list-repeater'

    index = repeater.indexForElement el
    vital = @matchingVitalRespiratoryRateList[index]

    vital.data.flags =
      flagAsError: true

    @_saveRR(vital)

    @_listVitalRespiratoryRate(@patient.serial)

    @domHost.showToast "Flagged Successfully!"

  respiratoryRateCustomSearchClicked: (e)->
    @currentDateFilterStartDate = e.detail.startDate
    @currentDateFilterEndDate = e.detail.endDate

    startDate = new Date e.detail.startDate
    startDate.setHours 0,0,1
    endDate = new Date e.detail.endDate
    endDate.setHours 23,59,59
    filterdList = (item for item in @matchingVitalRespiratoryRateList when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
    @matchingVitalRespiratoryRateList = filterdList
    @showGraphPressed()
  
  respiratoryRateSearchClearButtonClicked: (e)->
    @currentDateFilterStartDate = null
    @currentDateFilterEndDate = null

    params = @domHost.getPageParams()
    @_listVitalRespiratoryRate(params['patient'])
    @showGraphPressed()

  # === Vital - Respirator Rate [END] ===



  # Vital - SpO2
  # ================================

  _listVitalSpO2: (patientIdentifier) ->
    vitalSpO2List = app.db.find 'patient-vitals-spo2', ({patientSerial})=> @patient.serial is patientSerial

    vitalList = [].concat vitalSpO2List
    vitalList.sort (left, right)->
      return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
      return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
      return 0

    for vital in vitalList
      vital.flags = 
        isLocalOnly: true

    @matchingVitalSpO2List = vitalList

    # console.log @matchingVitalSpO2List

  addSpO2ItemClicked: ->
    @domHost.navigateToPage '#/vital-spo2/patient:' + @patient.serial + '/vital:new'

  # editSpO2ItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-spo2-list-repeater'

  #   index = repeater.indexForElement el
  #   vital = @matchingVitalSpO2List[index]

  #   @domHost.navigateToPage '#/vital-spo2/patient:' + @patient.serial + '/vital:' + vital.serial

  # deleteSpO2ItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-spo2-list-repeater'
  #   params = @domHost.getPageParams()

  #   index = e.model.index
  #   vital = @matchingVitalSpO2List[index]

  #   @domHost.showModalPrompt 'Are you sure?', (answer)=>
  #     if answer is true
  #       id = (app.db.find 'patient-vitals-spo2', ({serial})-> serial is vital.serial)[0]._id
  #       app.db.remove 'patient-vitals-spo2', id
  #       app.db.insert 'patient-vitals-spo2--deleted', { serial: vital.serial }
  #       @domHost.showToast 'Vital Deleted!'
  #       @_listVitalSpO2(params['patient'])


  _saveSpO2: (data)->
    app.db.upsert 'patient-vitals-spo2', data, ({serial})=> data.serial is serial

  flagAsErrorSpO2ItemClicked: (e)->
    el = @locateParentNode e.target, 'PAPER-ITEM'
    el.opened = false
    repeater = @$$ '#vital-spo2-list-repeater'

    index = repeater.indexForElement el
    vital = @matchingVitalSpO2List[index]

    vital.data.flags =
      flagAsError: true

    @_saveSpO2(vital)

    @_listVitalSpO2(@patient.serial)

    @domHost.showToast "Flagged Successfully!"

  spO2CustomSearchClicked: (e)->
    @currentDateFilterStartDate = e.detail.startDate
    @currentDateFilterEndDate = e.detail.endDate

    startDate = new Date e.detail.startDate
    startDate.setHours 0,0,1
    endDate = new Date e.detail.endDate
    endDate.setHours 23,59,59
    filterdList = (item for item in @matchingVitalSpO2List when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
    @matchingVitalSpO2List = filterdList
    @showGraphPressed()
  
  spO2SearchClearButtonClicked: (e)->
    @currentDateFilterStartDate = null
    @currentDateFilterEndDate = null

    params = @domHost.getPageParams()
    @_listVitalSpO2(params['patient'])
    @showGraphPressed()

  # === Vital - SpO2 [END] ===



  # Vital - Temperature [START]
  # ================================

  _listVitalTemperature: (patientIdentifier) ->
    vitalTemperatureList = app.db.find 'patient-vitals-temperature', ({patientSerial})=> @patient.serial is patientSerial

    vitalList = [].concat vitalTemperatureList
    vitalList.sort (left, right)->
      return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
      return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
      return 0

    for vital in vitalList
      vital.flags = 
        isLocalOnly: true

    @matchingVitalTemperatureList = vitalList

  addTemperatureItemClicked: ->
    @domHost.navigateToPage '#/vital-temperature/patient:' + @patient.serial + '/vital:new'

  # editTemperatureItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-temperature-list-repeater'

  #   index = repeater.indexForElement el
  #   vital = @matchingVitalTemperatureList[index]

  #   @domHost.navigateToPage '#/vital-temperature/patient:' + @patient.serial + '/vital:' + vital.serial

  # deleteTemperatureItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-temperature-list-repeater'
  #   params = @domHost.getPageParams()

  #   index = e.model.index
  #   vital = @matchingVitalTemperatureList[index]

  #   @domHost.showModalPrompt 'Are you sure?', (answer)=>
  #     if answer is true
  #       id = (app.db.find 'patient-vitals-temperature', ({serial})-> serial is vital.serial)[0]._id
  #       app.db.remove 'patient-vitals-temperature', id
  #       app.db.insert 'patient-vitals-temperature--deleted', { serial: vital.serial }
  #       @domHost.showToast 'Vital Deleted!'
  #       @_listVitalTemperature(params['patient'])

  _saveTemp: (data)->
    app.db.upsert 'patient-vitals-temperature', data, ({serial})=> data.serial is serial

  flagAsErrorTempItemClicked: (e)->
    el = @locateParentNode e.target, 'PAPER-ITEM'
    el.opened = false
    repeater = @$$ '#vital-temperature-list-repeater'

    index = repeater.indexForElement el
    vital = @matchingVitalTemperatureList[index]

    vital.data.flags =
      flagAsError: true

    @_saveTemp(vital)

    @_listVitalTemperature(@patient.serial)

    @domHost.showToast "Flagged Successfully!"

  temperatureCustomSearchClicked: (e)->
    @currentDateFilterStartDate = e.detail.startDate
    @currentDateFilterEndDate = e.detail.endDate

    startDate = new Date e.detail.startDate
    startDate.setHours 0,0,1
    endDate = new Date e.detail.endDate
    endDate.setHours 23,59,59
    filterdList = (item for item in @matchingVitalTemperatureList when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
    @matchingVitalTemperatureList = filterdList
    @showGraphPressed()
  
  temperatureSearchClearButtonClicked: (e)->
    @currentDateFilterStartDate = null
    @currentDateFilterEndDate = null

    params = @domHost.getPageParams()
    @_listVitalTemperature(params['patient'])
    @showGraphPressed()

  # === Vital - Temperature [END] ===


  # Test - Blood Sugar [START]
  # ================================

  _listTestBloodSugar: (patientIdentifier) ->
    testBloodSugarList = app.db.find 'patient-test-blood-sugar', ({patientSerial})=> @patient.serial is patientSerial
    testList = [].concat testBloodSugarList
    testList.sort (left, right)->
      return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
      return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
      return 0

    for test in testList
      test.flags = 
        isLocalOnly: true

    @matchingTestBloodSugarList = testList

  addBloodSugarItemClicked: ->
    @domHost.navigateToPage '#/test-blood-sugar/patient:' + @patient.serial + '/test:new'

  editBloodSugarItemClicked: (e)->
    el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
    el.opened = false
    repeater = @$$ '#test-blood-sugar-list-repeater'

    index = repeater.indexForElement el
    test = @matchingTestBloodSugarList[index]

    @domHost.navigateToPage '#/test-blood-sugar/patient:' + @patient.serial + '/test:' + test.serial

  deleteBloodSugarItemClicked: (e)->
    el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
    el.opened = false
    repeater = @$$ '#test-blood-sugar-list-repeater'
    params = @domHost.getPageParams()

    index = e.model.index
    test = @matchingTestBloodSugarList[index]

    @domHost.showModalPrompt 'Are you sure?', (answer)=>
      if answer is true
        id = (app.db.find 'patient-test-blood-sugar', ({serial})-> serial is test.serial)[0]._id
        app.db.remove 'patient-test-blood-sugar', id
        app.db.insert 'patient-test-blood-sugar--deleted', { serial: test.serial }
        @domHost.showToast 'Test Deleted!'
        @_listTestBloodSugar(params['patient'])

  bloodSugarCustomSearchClicked: (e)->
    @currentDateFilterStartDate = e.detail.startDate
    @currentDateFilterEndDate = e.detail.endDate

    startDate = new Date e.detail.startDate
    startDate.setHours 0,0,1
    endDate = new Date e.detail.endDate
    endDate.setHours 23,59,59
    filterdList = (item for item in @matchingTestBloodSugarList when (startDate.getTime() <= (new Date item.data.date).getTime() <= endDate.getTime()))
    @matchingTestBloodSugarList = filterdList
    @showGraphPressed()
  
  bloodSugarSearchClearButtonClicked: (e)->
    @currentDateFilterStartDate = null
    @currentDateFilterEndDate = null

    params = @domHost.getPageParams()
    @_listTestBloodSugar(params['patient'])
    @showGraphPressed()

  searchBloodSugar: (e)->
    searchString = e.target.value
    unless searchString
      params = @domHost.getPageParams()
      @_listTestBloodSugar(params['patient'])
      @showGraphPressed()
    regex = new RegExp "\\b#{searchString}", "gi"
    filteredList = (item for item in @matchingTestBloodSugarList when regex.test(item.data.type))
    @set 'matchingTestBloodSugarList', filteredList
    @showGraphPressed()
  
  # Test - Other Test
  # ================================

  _listOtherTest: (patientIdentifier) ->
    list = app.db.find 'patient-test-other', ({patientSerial})=> patientSerial is patientIdentifier

    # console.log 'other test', list
    list.sort (left, right)->
      return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
      return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
      return 0

    @matchingOtherTestList = list

  addOtherTestItemClicked: ->
    @domHost.navigateToPage '#/other-test/patient:' + @patient.serial + '/test:new'

  editOtherTestItemClicked: (e)->
    el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
    el.opened = false
    repeater = @$$ '#other-test-list-repeater'

    index = repeater.indexForElement el
    test = @matchingOtherTestList[index]

    @domHost.navigateToPage '#/other-test/patient:' + @patient.serial + '/test:' + test.serial

  deleteOtherTestItemClicked: (e)->
    el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
    el.opened = false
    repeater = @$$ '#other-test-list-repeater'
    params = @domHost.getPageParams()

    index = e.model.index
    test = @matchingOtherTestList[index]

    @domHost.showModalPrompt 'Are you sure?', (answer)=>
      if answer is true
        id = (app.db.find 'patient-test-other', ({serial})-> serial is test.serial)[0]._id
        app.db.remove 'patient-test-other', id
        app.db.insert 'patient-test-other--deleted', { serial: test.serial }
        @domHost.showToast 'Test Deleted!'
        @_listOtherTest(params['patient'])

  otherTestCustomSearchClicked: (e)->
    @currentDateFilterStartDate = e.detail.startDate
    @currentDateFilterEndDate = e.detail.endDate

    startDate = new Date e.detail.startDate
    startDate.setHours 0,0,1
    endDate = new Date e.detail.endDate
    endDate.setHours 23,59,59
    filterdList = (item for item in @matchingOtherTestList when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
    @matchingOtherTestList = filterdList
  
  
  otherTestsSearchClearButtonClicked: ()->
    @currentDateFilterStartDate = null
    @currentDateFilterEndDate = null

    params = @domHost.getPageParams()
    @_listOtherTest(params['patient'])


  computeOtherTestFilter: (otherTestSearchString)->
    if !otherTestSearchString
      return null
    else
      return (item)->
        searchString = otherTestSearchString.toLowerCase()
        name = if item.name then item.name.toLowerCase() else ''
        institution = if item.institution then item.institution.toLowerCase() else ''

        regex = new RegExp "\\b#{searchString}", 'gi'
        if ((name.search regex) isnt -1) or ((institution.search regex) isnt -1)
          return true

  # === Test - Other Test [END] ===


  # Comment - Patient [START]
  # ================================

  _listPatientComment: (patientIdentifier) ->
    patientCommentList = app.db.find 'comment-patient', ({patientSerial})=> patientIdentifier is patientSerial
    commentList = [].concat patientCommentList
    commentList.sort (left, right)->
      return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
      return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
      return 0

    @matchingPatientCommentList = commentList

  # === Comment - Patient [END] ===


  # Comment - Doctor [START]
  # ================================

  _listDoctorComment: (patientIdentifier) ->
    doctorCommentList = app.db.find 'comment-doctor', ({patientSerial})=> patientSerial is patientIdentifier
    commentList = [].concat doctorCommentList

    commentList.sort (left, right)->
      return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
      return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
      return 0

    @matchingDoctorCommentList = commentList

    # console.log @matchingDoctorCommentList

  _makeDoctorComment:() ->
    @doctorCommentMessage =
      serial: null
      createdDatetimeStamp: 0
      lastModifiedDatetimeStamp: 0
      lastSyncedDatetimeStamp: 0
      patientSerial: @patient.serial
      doctorSerial: @user.serial
      doctorName: @$getFullName @user.name
      doctorSpeciality: @getDoctorSpeciality()
      data:
        message: ''
      

  _saveDoctorCommentMessage: (data)->
    app.db.upsert 'comment-doctor', data, ({serial})=> data.serial is serial


  addCommentButtonClicked: (e) ->
    this._chargePatient this.patient.idOnServer, 5, 'Payment BDEMR Doctor Generic', (err)=>
      if (err)
        @domHost.showModalDialog("Unable to charge the patient. #{err.message}")
        return
      # console.log 'doctorCommentMessage', @doctorCommentMessage
      @doctorCommentMessage.serial = @generateSerialForCommentMessage 'DCT'
      @doctorCommentMessage.createdDatetimeStamp = lib.datetime.now()
      @_saveDoctorCommentMessage @doctorCommentMessage
      @domHost.showToast 'Comment Added!'
      @_makeDoctorComment()
      @_listDoctorComment(@patient.serial)


  deleteUserCommentItemClicked: (e)->

    index = e.model.index
    comment = @matchingDoctorCommentList[index]

    @domHost.showModalPrompt 'Are you sure?', (answer)=>
      if answer is true
        id = (app.db.find 'comment-doctor', ({serial})-> serial is comment.serial)[0]._id

        app.db.remove 'comment-doctor', id

        @domHost.showToast 'Comment Deleted!'
        @_listDoctorComment(@patient.serial)


  # === Comment - Doctor [END] ===

  toggleDemography: ()->
    elm = @$$ '#collapseDemography'
    elm.toggle()

  toggleConfirmedDiagnosis: ()->
    elm = @$$ '#collapseConfirmedDiagnosis'
    elm.toggle()

  toggleMedicine: () ->
    elm = @$$ '#collapseMedicine'
    elm.toggle()

  toggleVitals: () ->
    elm = @$$ '#collapseVitals'
    elm.toggle()

  toggleVitals: () ->
    elm = @$$ '#collapseVitals'
    elm.toggle()

  toggleVisits: () ->
    elm = @$$ '#collapseVisits'
    elm.toggle()

  toggleTestResults: () ->
    elm = @$$ '#collapseTestResults'
    elm.toggle()

  toggleComments: () ->
    elm = @$$ '#collapseComments'
    elm.toggle()

  toggleGallery: () ->
    elm = @$$ '#collapseGallery'
    elm.toggle()

  toggleActivityLog: () ->
    elm = @$$ '#collapseActivityLog'
    elm.toggle()


  _updatePatientSerialListByCollectionName: (collectionNameIdentifier)->
    collectionObject = 
      collectionName: collectionNameIdentifier
      patientSerialList: @_getPatientSerialListFromPatientList()

    list = app.db.find 'filterd-patient-serial-list-for-sync', ({collectionName})-> collectionName is collectionNameIdentifier
    if list.length is 1
      app.db.upsert 'filterd-patient-serial-list-for-sync', collectionObject, ({_id})=> list[0]._id is _id
    else
      app.db.insert 'filterd-patient-serial-list-for-sync', collectionObject


  _getPatientSerialListFromPatientList:()->
    list = app.db.find 'patient-list'
    modifiedList = []
    for item in list
      object = {}
      object.patientSerial = item.serial
      object.isSync = true
      modifiedList.push object
    return modifiedList

  _updatePatientSerialSyncByCollection: (collectionNameIdentifier, patientIdentifier, isSync)->

    list = app.db.find 'filterd-patient-serial-list-for-sync', ({collectionName})-> collectionName is collectionNameIdentifier
    if list.length is 1
      itemObject = list[0]
      # console.log 'itemObject', itemObject
      newItemObject = {}
      for item, index in itemObject.patientSerialList
        if item.patientSerial is patientIdentifier
          itemObject.patientSerialList[index].isSync = isSync
          app.db.upsert 'filterd-patient-serial-list-for-sync', itemObject, ({_id})=> itemObject._id is _id
          return true


  vitalsSyncCheckboxChanged: (e)->
    params = @domHost.getPageParams()

    if params['patient']
      patientIdentifier = params['patient'] 

    if e.target.checked
      @_updatePatientSerialSyncByCollection 'patient-vitals-blood-pressure', patientIdentifier, true
      @_updatePatientSerialSyncByCollection 'patient-vitals-pulse-rate', patientIdentifier, true
      @_updatePatientSerialSyncByCollection 'patient-vitals-respiratory-rate', patientIdentifier, true
      @_updatePatientSerialSyncByCollection 'patient-vitals-spo2', patientIdentifier, true
      @_updatePatientSerialSyncByCollection 'patient-vitals-temperature', patientIdentifier, true
      @_updatePatientSerialSyncByCollection 'patient-vitals-bmi', patientIdentifier, true

    else
      @_updatePatientSerialSyncByCollection 'patient-vitals-blood-pressure', patientIdentifier, false
      @_updatePatientSerialSyncByCollection 'patient-vitals-pulse-rate', patientIdentifier, false
      @_updatePatientSerialSyncByCollection 'patient-vitals-respiratory-rate', patientIdentifier, false
      @_updatePatientSerialSyncByCollection 'patient-vitals-spo2', patientIdentifier, false
      @_updatePatientSerialSyncByCollection 'patient-vitals-temperature', patientIdentifier, false
      @_updatePatientSerialSyncByCollection 'patient-vitals-bmi', patientIdentifier, false

  testSyncCheckboxChanged: (e)->
    params = @domHost.getPageParams()

    if params['patient']
      patientIdentifier = params['patient'] 

    if e.target.checked
      @_updatePatientSerialSyncByCollection 'patient-test-blood-sugar', patientIdentifier, true
      @_updatePatientSerialSyncByCollection 'patient-test-other', patientIdentifier, true

    else
      @_updatePatientSerialSyncByCollection 'patient-test-blood-sugar', patientIdentifier, false
      @_updatePatientSerialSyncByCollection 'patient-test-other', patientIdentifier, false

  doctorPateintNotesSyncCheckboxChanged: (e)->
    params = @domHost.getPageParams()

    if params['patient']
      patientIdentifier = params['patient'] 

    if e.target.checked
      @_updatePatientSerialSyncByCollection 'comment-patient', patientIdentifier, true
      @_updatePatientSerialSyncByCollection 'comment-doctor', patientIdentifier, true

    else
      @_updatePatientSerialSyncByCollection 'comment-patient', patientIdentifier, false
      @_updatePatientSerialSyncByCollection 'comment-doctor', patientIdentifier, false

  patientGallerySyncCheckboxChanged: (e)->
    params = @domHost.getPageParams()

    if params['patient']
      patientIdentifier = params['patient'] 

    if e.target.checked
      @_updatePatientSerialSyncByCollection 'patient-gallery--online-attachment', patientIdentifier, true
     
    else
      @_updatePatientSerialSyncByCollection 'patient-gallery--online-attachment', patientIdentifier, false

  activityLogSyncCheckboxChanged: (e)->
    params = @domHost.getPageParams()

    if params['patient']
      patientIdentifier = params['patient'] 

    if e.target.checked
      @_updatePatientSerialSyncByCollection 'patient-gallery--online-attachment', patientIdentifier, true
     
    else
      @_updatePatientSerialSyncByCollection 'patient-gallery--online-attachment', patientIdentifier, false



  # Gallary [START]
  # ================================

  _updateSpaceCalculation: ->
    if @localDataUriDb
      taken = @localDataUriDb.computeTotalSpaceTaken()
      used = 1 - ((@maximumLocalDataUriDbSizeInChars - taken) / @maximumLocalDataUriDbSizeInChars)
      @localDataUsedPercentage = Math.floor ((used) * 100)

  _openLocalDataUriDb: ->

    localDataUriDb = new lib.DatabaseEngine {
      name: 'local-data-uri-db'
      storageEngine: lib.localStorage
      serializationEngine: lib.json
      config:
        commitDelay: 0
    }

    localDataUriDb.initializeDatabase { removeExisting: false }

    localDataUriDb.defineCollection {
      name: 'local-attachment'
    }

    @localDataUriDb = localDataUriDb

    sessionDataUriDb = new lib.DatabaseEngine {
      name: 'session-data-uri-db'
      storageEngine: lib.tabStorage
      serializationEngine: lib.json
      config:
        commitDelay: 0
    }

    sessionDataUriDb.initializeDatabase { removeExisting: false }

    sessionDataUriDb.defineCollection {
      name: 'local-attachment'
    }

    @sessionDataUriDb = sessionDataUriDb

  
  
  _makeBlankAttachment: ->
    @set 'newAttachment', {
      title: ''
      description: ''
      dataUri: ''
      originalName: null 
      originalType: null
      sizeInBytes: 0
      sizeInChars: 0
      isImage: false
      isLoaded: false
      progress: 0
    }

  _loadAttachmentList: (patientIdentifier)->
    console.log 'attachmentList', @attachmentList
    # unless 'attachmentList' of @record.content.attachment
    #   @record.content.attachment.attachmentList = []
    
    localAttachmentList = app.db.find 'patient-gallery--local-attachment', ({patientSerial})-> patientSerial is patientIdentifier
    @set 'attachmentList', localAttachmentList

    onlineAttachmentList = app.db.find 'patient-gallery--online-attachment', ({patientSerial})-> patientSerial is patientIdentifier
    if onlineAttachmentList.length
      @set 'isDownloading', true
    lib.util.iterate onlineAttachmentList, (next, index, item)=>
      @callApi 'bdemr/get-uploaded-file', {attachmentId: item.data.attachmentId}, (err, response)=>
        if response.hasError
          @domHost.showModalDialog response.error.message
        else
          @push 'attachmentList', response.data
          next()
    .finally =>
      @set 'isDownloading', false


    

  _saveAttachment: (attachment)->
    app.db.upsert 'patient-gallery--local-attachment', attachment, ({serial})=> attachment.serial is serial
  

    

  $toMega: (value)-> (Math.ceil ((value / 1000 / 1000) * 100)) / 100

  $getImageSrc: (attachment)->
    if attachment.mainStorage is 'local'
      list = @localDataUriDb.find 'local-attachment', ({attachmentSerial})-> attachmentSerial is attachment.serial
      if list.length > 0
        return list[0].dataUri
      else
        return 'assets/not-found.png'
    else if attachment.mainStorage is 'server'
      return attachment.dataURI
    else if attachment.mainStorage is 'session'
      list = @sessionDataUriDb.find 'local-attachment', ({attachmentSerial})-> attachmentSerial is attachment.serial
      if list.length > 0
        return list[0].dataUri
      else
        return 'assets/not-found.png'


  fileInputChanged: (e)->
    reader = new FileReader
    file = e.target.files[0]

    if file.size > @maximumImageSizeAllowedInBytes
      @domHost.showModalDialog "Please provide a file less than #{Math.floor(@maximumImageSizeAllowedInBytes / 1000 / 1000)}mb in size."
      return

    reader.readAsDataURL file

    reader.onprogress = (e)=>
      @set 'newAttachment.progress', ((e.loaded / e.total) * 100)

    reader.onload = =>
      dataUri = reader.result
      @set 'newAttachment.isImage', file.type.indexOf('image/') > -1

      @set 'newAttachment.sizeInBytes', file.size
      @set 'newAttachment.title', file.name
      @set 'newAttachment.dataUri', dataUri
      @set 'newAttachment.originalType',  file.type
      @set 'newAttachment.originalName', file.name
      @set 'newAttachment.sizeInChars', dataUri.length
      
      @set 'newAttachment.isLoaded', true

  _prepareAtachment: ->
    { 
      title
      description
      dataUri
      isImage
      originalName
      originalType
      sizeInBytes
      sizeInChars
    } = @newAttachment

    attachment = {
      serial: @generateSerialForAttachmentBlob()
      attSyncSerial: @generateSerialForAttachmentSync()
      lastModifiedDatetimeStamp: lib.datetime.now()
      mainStorage: null # could be 'server' or 'local' or 'session'
      title
      description
      # dataUri
      isImage
      originalName
      originalType
      sizeInBytes
      sizeInChars
    }

    return attachment

  uploadPressed: (e)->
    attachment = @_prepareAtachment()

    if attachment.originalType.indexOf('image') is 0
      amount = 5
    else
      amount = 20

    # this._chargePatient this.patient.idOnServer, amount, 'Payment BDEMR Doctor Generic', (err)=>
    #   if (err)
    #     @domHost.showModalDialog("Unable to charge the patient. #{err.message}")
    #     return

    attachment.mainStorage = 'server'
    attachment.apiKey = (app.db.find 'user')[0].apiKey
    attachment.dataURI = @newAttachment.dataUri
    @set 'isUploading', true
    @callApi 'bdemr/file-uploader', attachment, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        attachment._id = response.data.attachmentId
        @push 'attachmentList', attachment
        # following syncable object signature
        onlineAttachment = 
          serial: attachment.attSyncSerial
          createdDatetimeStamp: 0
          lastModifiedDatetimeStamp: attachment.lastModifiedDatetimeStamp
          lastSyncedDatetimeStamp: 0
          patientSerial: @patient.serial
          data:
            attachmentId: response.data.attachmentId
        # Saving the attachment ref
        app.db.upsert 'patient-gallery--online-attachment', onlineAttachment, ({serial})=> serial is attachment.serial
        @set 'isUploading', false
        # TODO - Sync the refs with server when upload complete
        # Temporary Fix
        @domHost._syncOnlyPatientGallery ()=>
          @_makeBlankAttachment()


  saveLocallyPressed: (e)->
    attachment = @_prepareAtachment()
    attachment.mainStorage = 'local' 

    uploadData = {
      attachmentSerial: attachment.serial
      dataUri: @newAttachment.dataUri
    }

    currentSize = @localDataUriDb.computeTotalSpaceTaken()
    maxSize = @maximumLocalDataUriDbSizeInChars
    sizeLeft = maxSize - currentSize
    sizeNeededForThisAttachment = (JSON.stringify uploadData).length

    if sizeLeft < sizeNeededForThisAttachment
      extraNeeded = sizeNeededForThisAttachment - sizeLeft
      message = "Sorry. Can not save image. Your browser needs #{@$toMega(extraNeeded)}MB additional storage."
      @domHost.showModalDialog message
    else
      @localDataUriDb.insert 'local-attachment', uploadData
      @push 'attachmentList', attachment
      @_saveAttachment attachment
      @_makeBlankAttachment()
      @_updateSpaceCalculation()
  
  keepUntilBrowserClosedPressed: (e)->
    attachment = @_prepareAtachment()
    attachment.mainStorage = 'session' 

    uploadData = {
      attachmentSerial: attachment.serial
      dataUri: @newAttachment.dataUri
    }

    currentSize = @sessionDataUriDb.computeTotalSpaceTaken()
    maxSize = 50 * 1000 * 1000
    sizeLeft = maxSize - currentSize
    
    sizeNeededForThisAttachment = (JSON.stringify uploadData).length

    if sizeLeft < sizeNeededForThisAttachment
      extraNeeded = sizeNeededForThisAttachment - sizeLeft
      message = "Sorry. Can not save image. Your browser needs #{@$toMega(extraNeeded)}MB additional storage."
      @domHost.showModalDialog message
    else
      try
        @sessionDataUriDb.insert 'local-attachment', uploadData  
        @push 'attachmentList', attachment
        @_makeBlankAttachment()
      catch e
        message = "Sorry. Can not save image. Your browser do not have enough memory."
        @domHost.showModalDialog message

  deletePressed: (e)->
    { attachmentIndex, attachment } = e.model
    if attachment.mainStorage is 'local'
      attachmentData = (@localDataUriDb.find 'local-attachment', ({attachmentSerial})-> attachmentSerial is attachment.serial)
      if attachmentData.length > 0
        @localDataUriDb.remove 'local-attachment', attachmentData[0]._id
      app.db.remove 'patient-gallery--local-attachment', attachment._id
      @splice 'attachmentList', attachmentIndex, 1
      @_updateSpaceCalculation()
    else if attachment.mainStorage is 'session'
      attachmentData = (@sessionDataUriDb.find 'local-attachment', ({attachmentSerial})-> attachmentSerial is attachment.serial)
      if attachmentData.length > 0
        @sessionDataUriDb.remove 'local-attachment', attachmentData[0]._id
      app.db.remove 'patient-gallery--local-attachment', attachment._id
      @splice 'attachmentList', attachmentIndex, 1
    else
      @callApi 'bdemr/delete-uploaded-file', {attachmentId: attachment._id}, (err, response)=>
        if response.hasError
          @domHost.showModalDialog response.error.message
        else
          attachmentData = (app.db.find 'patient-gallery--online-attachment', ({serial})-> serial is attachment.attSyncSerial)
          if attachmentData.length > 0
            app.db.remove 'patient-gallery--online-attachment', attachmentData[0]._id
            @splice 'attachmentList', attachmentIndex, 1
            app.db.insert 'patient-gallery--online-attachment--deleted', { serial: attachmentData[0].serial }


  downloadPressed: (e)->
    attachment = e.model.attachment
    src = @$getImageSrc attachment

    if (src.indexOf 'data:') is 0
      blob = dataURItoBlob src
      objectURL = window.URL.createObjectURL blob, { type: attachment.originalType }
    else
      objectURL = src

    identifier = attachment.originalName
    a = window.document.createElement 'a'
    a.href = objectURL
    a.target = '_blank'
    a.download = identifier
    document.body.appendChild a
    a.click()
    document.body.removeChild a


  fileItemClicked: (e)->
    index = e.model.fileIndex
    file = @matchingFileList[index]

    data = { 
      apiKey: @user.apiKey
      userId: @user.idOnServer
      fileIdentifier: file.fileNameOnServer
    }

    @callApi '/bdemr-patient-file-download', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        objectURL = response.data.file.data

        identifier = response.data.file.originalName
        a = window.document.createElement 'a'
        a.href = objectURL
        a.target = '_blank'
        a.download = identifier
        document.body.appendChild a
        a.click()
        document.body.removeChild a

  # === Gallary [END] ===

  _getClassForFlaggedAsError: (data)->
    if data is true
      return 'danger'
    else return ''

  ready: ()->

  # === Organization [START] ===

  authorizeToSelected: (e)->
    return if @authorizeToSelectedIndex is null

    @authorizeTo = @organizationsIBelongToList[@authorizeToSelectedIndex]

    { idOnServer: organizationId } = @authorizeTo

    { recordSerial, visitSerial, recordType, pccType } = @toAuthorize

    @toAuthorizeIndex = null
    @toAuthorizePccIndex = null
    @authorizeToSelectedIndex = null
    
    typeMap = 
      'Prescription': { serverDb: 'bdemr--visit-prescription', clientDb: '' }
      'Test Advised': { serverDb: 'bdemr--visit-advised-test', clientDb: '' }
      'History & Physical': { serverDb: 'history-and-physical-record', clientDb: '' }
      'PCC': { serverDb: 'bdemr--pcc-records', clientDb: '' }


    unless recordType of typeMap
      @domHost.showModalDialog "This type of record can not be authorized!"
      return

    { serverDb } = typeMap[recordType]



    data = { 
      apiKey: @user.apiKey
      visitSerial
      recordSerial
      recordType
      serverDb
      organizationId
      masterType: 'doctor-app'
    }

    

    if data.recordType is 'PCC'
      data.masterType = 'pcc-records'
      data.pccType = pccType

    

    @callApi '/bdemr-organization-authorize-particular-type-of-record', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @domHost.showModalDialog "Organization is successfully authorized."

  _organizationNavigatedIn: ->
    data = { 
      apiKey: @user.apiKey
    }
    @callApi '/bdemr-organization-list-those-user-belongs-to', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @organizationsIBelongToList = response.data.organizationObjectList

  authorizeRecordPressed: (e)->
    el = @locateParentNode e.target, 'PAPER-ITEM'
    repeater = @$$ '#visit-list-repeater'
    index = repeater.indexForElement el
    recordIndex = e.model.recordIndex

    visit = @matchingVisitList[index]
    record = visit.recordList[recordIndex]

    { visitSerial, recordSerial, recordType } = record

    @toAuthorize = { visitSerial, recordSerial, recordType }
    @toAuthorizeIndex = recordIndex

  authorizePccRecord: (e)->
    el = @locateParentNode e.target, 'PAPER-ITEM'
    repeater = @$$ '#pcc-record-list'
    index = repeater.indexForElement el
    record = @matchingPccRecordList[index]

    @toAuthorize = {
      recordSerial: record.serial
      visitSerial: 'none'
      recordType: 'PCC'
      pccType: record.visitReason.type
      
    }

    @toAuthorizePccIndex = index


  deleteRecordFromSelectedVisit: (e)->
    @domHost.showToast 'This Feature is Under construction!'


  # === Organization [END] ===

  # LEAVE INFO
  # =====================================================

  _loadLeaveData: (employeeIdentifier)->
    leaveData = (app.db.find 'employee-leave-data', ({patientSerial})=> patientSerial is employeeIdentifier)
    if leaveData.length
      @set 'leaveData', leaveData[0]
      # @_getLeaveCountByMonthYear(@leaveData.data)
    else
      @set 'leaveData', @_makeLeaveData()
  
  _makeLeaveData: ->
    return {
      serial: @generateSerialForEmployeeLeaveData()
      createdDatetimeStamp: lib.datetime.now()
      lastModifiedDatetimeStamp: null
      createdByUserSerial: @user.serial
      patientSerial: @patient.serial
      data: []
    }
  
  leaveInfoAddedButtonClicked: (e)->
    leaveFromDate = (new Date @leaveFromDate).getTime()
    leaveToDate = (new Date @leaveToDate).getTime()

    @push 'leaveData.data', {
      startDate: leaveFromDate
      endDate: leaveToDate
      reason: @sickReasonList[@sickReasonSelectedIndex]
    }
    
    app.db.upsert 'employee-leave-data', @leaveData, ({serial})=> serial is @leaveData.serial

    @leaveFromDate = ""
    @leaveToDate = ""
    @sickReasonSelectedIndex = 0

  
  calculateLeaveLength: (from, to)->
    return (to - from)/(24*60*60*1000)

  getMonthYearString: (fromDate)->
    year = (new Date fromDate).getFullYear()
    month = @monthList[(new Date fromDate).getMonth()]
    return "#{month} #{year}"

  _getMonthYearByISO: (fromDate)->
    year = (new Date fromDate).getFullYear()
    month = (new Date fromDate).getMonth() + 1
    return "#{year}-#{month}-01"
  
  getLeaveCountByMonthYear: (data)->
    map = {}
    for item in data
      leaveLength = @calculateLeaveLength(item.startDate, item.endDate)
      yearMonth = @_getMonthYearByISO(item.startDate)
      if (yearMonth of map)
        map[yearMonth] += leaveLength
      else
        map[yearMonth] = leaveLength

    counter = []
    for own key, value of map
      counter.push {monthYear: key, leaveCount: value}

    return counter

  getLeaveCountByYear: (data)->
    map = {}
    for item in data
      leaveLength = @calculateLeaveLength(item.startDate, item.endDate)
      year = (new Date item.startDate).getFullYear()
      if (year of map)
        map[year] += leaveLength
      else
        map[year] = leaveLength

    counter = []
    for own key, value of map
      counter.push {year: key, leaveCount: value}

    return counter
      

  deleteLeaveInfoClicked: (e)->
    index = e.model.index
    @domHost.showModalPrompt 'Are you sure to Delete', (done)=>
      if done
        @splice 'leaveData.data', index, 1
        app.db.upsert 'employee-leave-data', @leaveData, ({serial})=> serial is @leaveData.serial
  

}
