
Polymer {

  is: 'page-visit-editor'

  $toJson: (object)->
    JSON.stringify object

  $isNumber: (object)->
    typeof object is 'number'

  $listMissingKeys: (object, handledKeyList)->
    missingKeyList = []
    for key of object
      unless key in handledKeyList
        missingKeyList.push key
    return missingKeyList

  behaviors: [
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.pageLike
    app.behaviors.translating
    app.behaviors.apiCalling
    app.behaviors.local.loadPriceListMixin
  ]

  properties:

    user: Object

    patient: Object

    visit: 
      type: Object
      notify: true

    organization: Object

    walletBalance:
      type: Number
      value: -1

    patientOrganizationWallet:
      type: Object
      value: null
    
    printPrescriptionOnly:
      type: Boolean
      notify: true
      value: true

    isThatNewVisit:
      type: Boolean
      notify: true
      value: true


    visitHeaderTitleList:
      type: Array
      notify: false
      value: [
        'UHCP Complete Visit',
        'UHCP Discharge Note',
      ]

    visitHeaderTitleSelectedIndex:
      type: Number
      notify: false
      value: 0


    isVisitValid:
      type: Boolean
      notify: false
      value: false

    selectedVisitPageIndex:
      type: Number
      notify: false
      value: false

    isNoteValid:
      type: Boolean
      notify: false
      value: false

    isInvoiceValid:
      type: Boolean
      notify: false
      value: false

    isTestAdvisedValid:
      type: Boolean
      notify: false
      value: false


    isPatientValid:
      type: Boolean
      notify: false
      value: false

    isFullVisitValid:
      type: Boolean
      notify: false
      value: false

    doctorInstitutionList:
      type: Array
      notify: true
      value: []

    doctorSpecialityList:
      type: Array
      notify: true
      value: []

    doctorInstitutionSelectedIndex:
      type: Number
      notify: true
      value: 0

    doctorSpecialitySelectedIndex:
      type: Number
      notify: true
      value: 0

    hasTestResults:
      type: Boolean
      notify: true
      value: false

    
    #####################################################################
    # Full Visit Preview - start
    #####################################################################
    settings:
      type: Object
      notify: true

    ## VIEW - HistoryAndPhysicalRecord - start
    record:
      type: Object
      notify: true
      value: null

    recordDatabaseCollectionName:
      type: String
      value: null

    recordPartName:
      type: String
      value: null

    recordPartData:
      type: Object
      value: null

    recordPartDef:
      type: Object
      value: null

    recordPartTitle:
      type: String
      value: null

    recordPartHtmlContent:
      type: String
      value: null

    shouldRender:
      type: Boolean
      value: false

    delayRendering:
      type: Boolean
      value: false
    
    
    #####################################################################
    # Full Visit Preview - end
    #####################################################################


  ready: ->

    params = @domHost.getPageParams()

    unless params['visit']
      @_notifyInvalidVisit()
      return
    
    @_loadOrganization()
    @_loadUser()
    @_loadPatient(params['patient'])

    # load Wallets
    @_loadVariousWallets => null

    # Set SelectedVisitPageIndex
    if params['selected']
      @selectedVisitPageIndex = params['selected']
    else
      @selectedVisitPageIndex = 0

    @_loadPriceList @organization.idOnServer, ()=> console.log 'Price List Loaded'

    if params['visit'] is 'new'
      @_makeNewVisit()
    else
      @_loadVisit params['visit']
      @domHost.setSelectedVisitSerial params['visit']


    
  _loadOrganization: ->
    organization = @getCurrentOrganization()
    unless organization
      @domHost.navigateToPage "#/select-organization"
      return
    @set 'organization', organization

  _loadUser:(cbfn)->
    list = app.db.find 'user'
    if list.length is 1
      @user = list[0]
      @_getEmploymentList @user
      @_getSpecializationList @user

    else
      @domHost.showModalDialog 'Invalid User!'


  _getEmploymentList: (user)->
    if user.employmentDetailsList.length > 0
      for employmentDetails in user.employmentDetailsList
        @push 'doctorInstitutionList', employmentDetails.institutionName
    else
      @doctorInstitutionList = []

  _getSpecializationList: (user)->
    if user.specializationList.length > 0
      for specializationDetails in user.specializationList
        @push 'doctorSpecialityList', specializationDetails.specializationTitle
    else
      @doctorSpecialityList = []


  $getFullName:(data)->
    if typeof data is "object"
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

    else return data

  
  _loadPatient: (patientIdentifier)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier
    if list.length is 1
      @isPatientValid = true
      @set 'patient', list[0]
      # console.log 'PATIENT:', @patient
    else
      @_notifyInvalidPatient()

  $findCreator: (creatorSerial)-> 'me'


  printFullVisitPressed: (e)->
    params = @domHost.getPageParams()
    # console.log @visit

    @domHost.navigateToPage '#/page-print-full-visit/patient:' + @patient.serial + '/visit:' + @visit.serial + '/record:' + @visit.historyAndPhysicalRecordSerial + '/prescription:' + @prescription.serial + '/test-adviced:' + @visit.advisedTestSerial + '/doctor-note:' + @visit.doctorNotesSerial + '/next-visit:' + @visit.nextVisitSerial + '/patient-stay:' + @visit.patientStaySerial + '/diagnosis:' + @visit.diagnosisSerial



  printPrescriptionPressed: (e)->
    params = @domHost.getPageParams()
    # console.log @visit

    if params['prescription'] != 'new'
      @domHost.navigateToPage '#/print-record/prescription:' + @prescription.serial + '/patient:' + @patient.serial

  $findCreator: (creatorSerial)-> 'me'

  _institutionSelectedIndexChanged: ()->
    return if @doctorInstitutionSelectedIndex is null
    item = @doctorInstitutionList[@doctorInstitutionSelectedIndex]
    @visit.hospitalName = item

  _specialitySelectedIndexChanged: ()->
    return if @doctorSpecialitySelectedIndex is null
    item = @doctorSpecialityList[@doctorSpecialitySelectedIndex]
    @visit.doctorSpeciality = item


  _makeNewVisit: ()->
    visit =
      serial: null
      idOnServer: null
      source: 'local'
      createdDatetimeStamp: lib.datetime.now()
      lastModifiedDatetimeStamp: 0
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      doctorsPrivateNote: ''
      patientSerial: @patient.serial
      recordType: 'doctor-visit'
      doctorName: @user.name
      hospitalName: null
      doctorSpeciality: null
      prescriptionSerial: null
      doctorNotesSerial: null
      nextVisitSerial: null
      advisedTestSerial: null
      patientStaySerial: null
      invoiceSerial: null
      historyAndPhysicalRecordSerial: null
      diagnosisSerial: null
      identifiedSymptomsSerial: null
      examinationSerial: null
      referralSerial: null
      recordTitle: 'Complete Visit'
      vitalSerial: {
        bp: null
        hr: null
        bmi: null
        rr: null
        spo2: null
        temp: null
      }
      testResults: {
        serial: null
        name: null
        attachmentSerialList: []
      }

    @isVisitValid = true
    @isThatNewVisit = true

    @set 'visit', visit


  _saveVisit: ()->
    params = @domHost.getPageParams()

    if params['visit'] is 'new'
      @isThatNewVisit = false
      @visit.serial = @generateSerialForVisit()
      @domHost.modifyCurrentPagePath '#/visit-editor/visit:' + @visit.serial + '/patient:' + @patient.serial
      @visit.lastModifiedDatetimeStamp = lib.datetime.now()
      app.db.upsert 'doctor-visit', @visit, ({serial})=> @visit.serial is serial
      @domHost.setSelectedVisitSerial @visit.serial

    # UHCP dont charge patient for Visit
    # if @visit.isPaidUp
    #   fn()
    # else
    #   this._chargePatient @patient.idOnServer, 5, 'Payment BDEMR Doctor Generic', (err)=>
    #     @visit.isPaidUp = true
    #     if (err)
    #       @domHost.showModalDialog("Unable to charge the patient. #{err.message}")
    #       return
    #     fn()



  _notifyInvalidPatient: ->
    @isPatientValid = false
    @domHost.showModalDialog 'Invalid Patient Provided'

  _notifyInvalidVisit: ->
    @isVisitValid = false
    # @domHost.showModalDialog 'Invalid Visit Provided'

  _loadVisit: (visitIdentifier, cbfn)->
    list = app.db.find 'doctor-visit', ({serial})-> serial is visitIdentifier
    if list.length is 1
      @isVisitValid = true
      @visit = list[0]
    else
      @_notifyInvalidVisit()
      return


  getExaminationValueList: (list)->
    string = ''
    unless list.length is 0
      for item in list
        if item.checked
          string = string + item.value + ", "
        else
          string = string + ""
      return "(" + string + ")"
    return ""


  _loadVariousWallets: ->
    @_loadPatientWallet @patient.idOnServer, ()=>
      # console.log 'PATIENT-WALLET:',@patientWalletBalance
      @_loadPatientOrganizationWallet @organization.idOnServer, @patient.idOnServer, (patientOrganizationWallet)=>
        unless patientOrganizationWallet
          this.domHost.set('patientOrganizationWalletIndoorBalance', 0)
          this.domHost.set('patientOrganizationWalletOutdoorBalance', 0)
          return
        this.domHost.set('patientOrganizationWalletIndoorBalance', patientOrganizationWallet.indoorBalance)
        this.domHost.set('patientOrganizationWalletOutdoorBalance', patientOrganizationWallet.outdoorBalance)
        # console.log 'PATIENT-ORGANIZATION-WALLET', patientOrganizationWallet
        @set 'patientOrganizationWallet', patientOrganizationWallet


  onVitalIndexChange: ()->
    console.log @selectedVitalIndex
  # psedo lifecycle callback
    
  

  navigatedOut: ->
    @visit = {}
    @patient = {}
    @doctorNotes = {}
    @patientStay = {}
    @isVisitValid = false
    @isPatientValid = false
    @isNoteValid = false
    @isPatientStayValid = false
    @isInvoiceValid = false
    
    @doctorInstitutionList = []
    @doctorSpecialityList = []

    ## Prescription
    @prescription = {}
    @isPrescriptionValid = false

    @matchingPrescribedMedicineList = []
    @matchingCurrentMedicineList = []
    @matchingFavoriteMedicineList = []

    @medicine = {}

    @isMedicineValid = false

    ## Advised Test
    @isTestAdvisedValid = false
    @testAdvisedObject = {}
    @matchingFavoriteInvestigationList = []
    @investigationDataList = []

    ##Examination
    @addedExaminationList = []
    
    ## patient stay
    @selectedView = 0
    @patientStay = null
    @patientStayObject = null
    @organizationsIBelongToList = []
    @selectedOrganizationIndex = null
    @selectedDepartmentIndex = null
    @selectedUnitIndex = null
    @selectedWardIndex = null
    @seatList = []
    @patientDischarged = false

    ## Visit Details :: View - HistoryAndPhysical
    @shouldRender = false

    @historyAndPhysicalRecord = {}



  ## --- Patient Specific Sync - Start

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

  historyAndPhysicalSyncCheckboxChanged: (e)->

    params = @domHost.getPageParams()

    if params['patient']
      patientIdentifier = params['patient'] 

    if e.target.checked
      @_updatePatientSerialSyncByCollection 'history-and-physical-record', patientIdentifier, true
     
    else
      @_updatePatientSerialSyncByCollection 'history-and-physical-record', patientIdentifier, false
        
  ## --- Patient Specific Sync - End


  prescriptionAvailableToPatientCheckBoxChanged: (e)->
    if @prescription
      if e.target.checked
        @prescription.availableToPatient = true
        @_saveVisitPrescription()
      else
        @prescription.availableToPatient = false
        @_saveVisitPrescription()

  testAdvisedAvailableToPatientCheckBoxChanged: (e)->
    if @testAdvised
      if e.target.checked
        @testAdvised.availableToPatient = true
        @_saveVisitTestAdvised()
      else
        @testAdvised.availableToPatient = false
        @_saveVisitTestAdvised()

}
