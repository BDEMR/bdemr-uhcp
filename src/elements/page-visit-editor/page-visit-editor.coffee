
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
    app.behaviors.local.patientStayMixin
    app.behaviors.local.loadPriceListMixin
    app.behaviors.local.invoiceMixin
  ]

  properties:

    comboBoxSymptomsInputValue:
      type: String
      notify: true
      value: null

    walletBalance:
      type: Number
      value: -1

    patientOrganizationWallet:
      type: Object
      value: null
    
    organization:
      type: Object
      notify: true
      value: null

    selectedMedicinePage:
      type: Number
      notify: false
      value: 0

    printPrescriptionOnly:
      type: Boolean
      notify: true
      value: true


    isBPAdded:
      type: Boolean
      notify: true
      value: false

    isHRAdded:
      type: Boolean
      notify: true
      value: false

    isBMIAdded:
      type: Boolean
      notify: true
      value: false

    isSpO2Added:
      type: Boolean
      notify: true
      value: false

    isRRAdded:
      type: Boolean
      notify: true
      value: false

    isTempAdded:
      type: Boolean
      notify: true
      value: false

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

    isPrescriptionValid:
      type: Boolean
      notify: false
      value: false

    isNoteValid:
      type: Boolean
      notify: false
      value: false

    isNextVisitValid:
      type: Boolean
      notify: true
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

    user:
      type: Object
      notify: true
      value: null

    patient:
      type: Object
      notify: true
      value: null

    visit:
      type: Object
      notify: true
      value: null

    doctorNotes:
      type: Object
      notify: true
      value: null

    doctorNotesMessage:
      type: String
      notify: true
      value: ''

    nextVisit:
      type: Object
      notify: true
      value: null

    testAdvised:
      type: Object
      notify: true
      value: null
    

    matchingPrescribedMedicineList:
      type: Array
      notify: true
      value: []

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

    computedEndDate:
      type: String
      computed: '_showComputedEndDate(duplicateMedicineEditablePart.endDateTimeStamp)'      

    ## historyAndPhysicalRecord - start
    historyAndPhysicalRecord:
      type: Object
      notify: true
      value: null

    matchingRecordList:
      type: Object
      notify: true
      value: null

    ## historyAndPhysicalRecord - end

    ## diagnosis - start
    diagnosis:
      type: Object
      notify: true
      value: null

    isDiagnosisValid:
      type: Boolean
      value: false

    diagnosisListArray:
      type: Array
      notify: true
      value: []

    selectedDiagnosisListArray:
      type: Array
      notify: true
      value: []

    ## diagnosis - end

    #####################################################################
    ### Prescription - start
    #####################################################################
    

    #####################################################################
    ### Prescription - end
    #####################################################################

    #####################################################################
    ### Symptoms - start
    #####################################################################
    symptomsDataList:
      type: Array
      notify: true
      value: []

    addedIdentifiedSymptomsList:
      type: Array
      notify: true
      value: []

    customSymptomsObject:
      type: Object
      notify: true
      value: {}
    #####################################################################
    ### Symptoms - end
    #####################################################################

    #####################################################################
    ### Examination - start
    #####################################################################
    examinationDataList:
      type: Array
      notify: true
      value: []

    addedExaminationList:
      type: Array
      notify: true
      value: []

    addedExaminationList2:
      type: Array
      notify: true
      value: ()-> []

    examinationObject:
      type: Object
      notify: true
      value: {}



    #####################################################################
    ### Examination - end
    #####################################################################



    #####################################################################
    ### Test Advised - start
    #####################################################################

    



    #####################################################################
    ### Test Advised - end
    #####################################################################

    #####################################################################
    ### Vitals - start
    #####################################################################

    

    #####################################################################
    # Vitals - end
    #####################################################################

    #####################################################################
    # Next Visit - start
    #####################################################################


    priorityTypeList:
      type: Array
      value: [
        'As Necessary'
        'Others'
      ]

    nextVisitDurationTypeList:
      type: Array
      value: [
        '0 Day'
        '1 Day'
        '2 Days'
        '3 Days'
        '4 Days'
        '5 Days'
        '6 Days'
        '7 Days'
        '8 Days'
        '9 Days'
        '10 Days'
        '11 Days'
        '12 Days'
        '13 Days'
        '14 Days'
        '15 Days'
        '1 Week'
        '2 Weeks'
        '3 Weeks'
        '4 Weeks'
        '1 month'
        '2 months'
        '3 months'
        '4 months'
        '5 months'
        '6 months'
        '7 months'
        '8 months'
        '9 months'
        '11 month'
        '1 year'
        '2 years'
        '3 years'
        'Custom'
      ]

    nextVisitDurationTypeSelectedIndex:
      type: Number
      notify: true
      value: 0

    nextVisitPriorityTypeSelectedIndex:
      type: Number
      notify: true
      value: 0

    computedNextVisitDate:
      type: String
      notify: true
      computed: '_showComputedNextVisitDate(nextVisit.nextVisitDateTimeStamp)'

    isCustomDateTypeSelected:
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

    patient:
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


  observers : [
    '_computeQuantityPerPrescription(medicine.dose, medicine.timesPerInterval, intervalInDays, medicine.endDateTimeStamp, medicine.startDateTimeStamp)'
    '_computeIntervalInHours(medicine.timesPerInterval, intervalInDays)'
    
  ]


  # Util Functions - start
  $of: (a, b)->
    unless b of a
      a[b] = null
    return a[b]

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

  _compareFn: (left, op, right) ->
    # lib.util.delay 5, ()=>
    if op is '<'
      return left < right
    if op is '>'
      return left > right
    if op is '=='
      return left == right
    if op is '>='
      return left >= right
    if op is '<='
      return left <= right
    if op is '!='
      return left != right

  _sortByDate: (a, b)->
    if a.lastModifiedDatetimeStamp < b.lastModifiedDatetimeStamp
      return 1
    if a.lastModifiedDatetimeStamp > b.lastModifiedDatetimeStamp
      return -1

  _computeTotalDaysCount: (endDate, startDate)->
    return (@$TRANSLATE 'As Needed', @LANG) unless endDate
    oneDay = 1000*60*60*24;
    startDate = new Date startDate
    endDate = new Date endDate
    diffMs = endDate - startDate
    return @$TRANSLATE (Math.round(diffMs / oneDay)), @LANG

  _returnSerial: (index)->
    index+1

  _computeAge: (dateString)->
    today = new Date()
    birthDate = new Date dateString
    age = today.getFullYear() - birthDate.getFullYear()
    m = today.getMonth() - birthDate.getMonth()

    if m < 0 || (m == 0 && today.getDate() < birthDate.getDate())
      age--

    return age
  # Util Functions - end
    


  _loadUser:(cbfn)->
    list = app.db.find 'user'
    console.log 'USER: ', list[0]
    if list.length is 1
      @user = list[0]
      @_getEmploymentList @user
      @_getSpecializationList @user

    else
      @domHost.showModalDialog 'Invalid User!'

    cbfn()

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

  getDoctorSpeciality: () ->
    unless @user.specializationList.length is 0
      return @user.specializationList[0].specializationTitle
    return 'not provided yet'

  _makeNewNextVisit: ()->
    @nextVisit =
      serial: null
      lastModifiedDatetimeStamp: 0
      createdDatetimeStamp: 0
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      visitSerial: @visit.serial
      patientSerial: @patient.serial
      doctorName: @$getFullName @user.name
      doctorSpeciality: @getDoctorSpeciality()
      data:
        nextVisitDateTimestamp: null
        priorityType: 'As Necessary'

    @isNextVisitValid = true

  _makeNewNote: ()->
    @doctorNotes =
      serial: null
      lastModifiedDatetimeStamp: 0
      createdDatetimeStamp: 0
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: null
      visitSerial: null
      patientSerial: @patient.serial
      doctorName: @user.name
      doctorSpeciality: @getDoctorSpeciality()
      data:
        messageList: []

    # console.log 'doctorNotes', @doctorNotes

    @isNoteValid = true

  _loadPatient: (patientIdentifier, cbfn)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier
    if list.length is 1
      @isPatientValid = true
      @patient = list[0]
      console.log 'PATIENT:', @patient
    else
      @_notifyInvalidPatient()

    cbfn()


  #####################################################################
  ### Prescription - start
  #####################################################################

  


  ## REGION: doseGuideline - End

  #####################################################################
  ### Prescription - end
  #####################################################################

  #####################################################################
  ### Stymptoms - start
  #####################################################################

  ## Make New Symptoms Object
  _makeNewIdentifiedSymptomsObject: ()->
    @identifiedSymptomsObject =
      serial: null
      lastModifiedDatetimeStamp: 0
      createdDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      visitSerial: null
      patientSerial: @patient.serial
      doctorName: @user.name
      doctorSpeciality: @getDoctorSpeciality()
      data:
        symptomsList: []
      availableToPatient: true

    # console.log @identifiedSymptomsObject
      
    @isIdentifiedSymptomsValid = true
      

  # _makeCustomSymptomsObject : ()->
  #   @customSymptomsObject
  #     serial: @generateSerialForCustomSymptoms
  #     lastModifiedDatetimeStamp: lib.datetime.now()
  #     createdDatetimeStamp: lib.datetime.now()
  #     lastSyncedDatetimeStamp: 0
  #     createdByUserSerial: @user.serial
  #     data:
  #       name: ''


  ## Load Symptoms Data
  _loadIdentifiedSymptoms: (symptomsIdentifier)->

    list = app.db.find 'visit-identified-symptoms', ({serial})-> serial is symptomsIdentifier
    if list.length is 1
      @isIdentifiedSymptomsValid = true
      @identifiedSymptomsObject = list[0]
      console.log 'SYMPTOMS: ', @identifiedSymptomsObject
      @addedIdentifiedSymptomsList = list[0].data.symptomsList
      
      return true
    else
      @_notifyInvalidIdentifeidSymptoms()
      return false

  _loadSymptomsListFromSystem: (userIdentifier)->
    @set 'symptomsDataList', []
    @domHost.getStaticData 'symptomsList', (symptomsList)=>
      # console.log symptomsList

      unless symptomsList.length is 0
        for item in symptomsList
          unless item.name is ''
            object = {}
            object.label = item.name
            object.value = item    
            @push "symptomsDataList", object

      # get all custom symptoms
      customSymptomslist = app.db.find 'custom-symptoms-list', ({createdByUserSerial})=> userIdentifier is createdByUserSerial
      # console.log customInvestigationlist
      
      # pushed all custom symptoms on master investigatin list
      unless customSymptomslist.length is 0
        for item in customSymptomslist

          customObject = {}
          customObject.label = item.data.name
          customObject.value = item.data.name

          # console.log investigation

          @push "symptomsDataList", customObject

      @symptomsDataList.sort (left, right)->
        return -1 if left.label < right.label
        return 1 if left.label > right.label
        return 0

      # console.log @symptomsDataList


  ## User Added Custom Symptoms
  saveUserAddedCustomSymptoms: (symptomName)->

    object =
      serial: @generateSerialForCustomSymptoms
      lastModifiedDatetimeStamp: lib.datetime.now()
      createdDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      data:
        name: symptomName

    app.db.insert 'custom-symptoms-list', object
    
  _duplicationSymptomsCheck: (symptomName)->
    for item in @symptomsDataList
      if item.label is symptomName
        return true
  
  _notifyInvalidIdentifeidSymptoms: ->
    @isIdentifiedSymptomsValid = false
    @domHost.showModalDialog 'Invalid Stymptoms Provided'

  ## Added Identified Symtoms
  _selectedAddedIdentifiedSymtomsDeleteBtnPressed: (e) ->
    index = e.model.index
    @splice('addedIdentifiedSymptomsList', index, 1)

    # todo :: delete object from db if addedIdentifiedSymptomsList length is 0
    identifiedSymtomsSerial = @identifiedSymptomsObject.serial
    if @addedIdentifiedSymptomsList.length is 0
      list = app.db.find 'visit-identified-symptoms', ({serial})-> serial is identifiedSymtomsSerial
      # console.log list
      id = list[ 0 ]._id
      app.db.remove 'visit-identified-symptoms', id
      app.db.insert 'visit-identified-symptoms--deleted', { serial: @identifiedSymptomsObject.serial }
      @visit.identifiedSymptomsSerial = null
      @_saveVisit()
      @domHost.showToast 'Deleted Successfully!'

    else
      @saveIdentifiedSymptoms()
      @domHost.showToast 'Deleted Successfully!'


  comboBoxKeyUpSymptomsValueChanged: (e)->
    unless @comboBoxSymptomsInputValue is ''

      if e.which is 13 # ENTER/RETURN

        # console.log @comboBoxSymptomsInputValue

        if typeof @comboBoxSymptomsInputValue is 'object'
          # Push on Added Identified Symptoms List
          @push 'addedIdentifiedSymptomsList', {name: @comboBoxSymptomsInputValue.name}

        else
          # Push on Added Identified Symptoms List
          @push 'addedIdentifiedSymptomsList', {name: @comboBoxSymptomsInputValue}

          unless @_duplicationSymptomsCheck @comboBoxSymptomsInputValue
            # Save User added custom Symptoms
            @saveUserAddedCustomSymptoms @comboBoxSymptomsInputValue

          # Push Custom Symptoms Name on Master Symptoms List
          @push "symptomsDataList", { label: @comboBoxSymptomsInputValue, value: @comboBoxSymptomsInputValue }

          # Load Symptoms Data

        

        # Save Identified Symptoms
        @saveIdentifiedSymptoms()




  addSymptoms:() ->
    unless @comboBoxSymptomsInputValue is ''

      if typeof @comboBoxSymptomsInputValue is 'object'
        # Push on Added Identified Symptoms List
        @push 'addedIdentifiedSymptomsList', {name: @comboBoxSymptomsInputValue.name}

      else
        # Push on Added Identified Symptoms List
        @push 'addedIdentifiedSymptomsList', {name: @comboBoxSymptomsInputValue}

        unless @_duplicationSymptomsCheck @comboBoxSymptomsInputValue
          # Save User added custom Symptoms
          @saveUserAddedCustomSymptoms @comboBoxSymptomsInputValue

        # Push Custom Symptoms Name on Master Symptoms List
        @push "symptomsDataList", { label: @comboBoxSymptomsInputValue, value: @comboBoxSymptomsInputValue }


        # Load Symptoms Data

      

      # Save Identified Symptoms
      @saveIdentifiedSymptoms()


  saveIdentifiedSymptoms: ()->
    # console.log @identifiedSymptomsObject
    unless @addedIdentifiedSymptomsList.length is 0
      @identifiedSymptomsObject.data.symptomsList = @addedIdentifiedSymptomsList

      if @visit.identifiedSymptomsSerial is null
        @identifiedSymptomsObject.serial = @generateSerialForIdentifiedSymptoms()

        ## updated current visit object
        @visit.identifiedSymptomsSerial = @identifiedSymptomsObject.serial
        @_saveVisit()

        @identifiedSymptomsObject.visitSerial = @visit.serial
     
      # Updated Identified Symptoms List
      @identifiedSymptomsObject.lastModifiedDatetimeStamp = lib.datetime.now()
      app.db.upsert 'visit-identified-symptoms', @identifiedSymptomsObject, ({serial})=> @identifiedSymptomsObject.serial is serial
      
      @set 'comboBoxSymptomsInputValue', ''
      @domHost.showToast 'Symptoms Added.'


  #####################################################################
  ### Stymptoms - end
  #####################################################################

  #####################################################################
  ### Examination - start
  #####################################################################


  _loadExaminationList: (userIdentifier)->
  
    @domHost.getStaticData 'examinationList', (examinationList)=>
      for object in examinationList
        unless object.name is ''
          
          unless typeof object.examinationValueList is 'undefined'
            unless object.examinationValueList.length is 0

              if object.examinationValueList.length > 1
                groupExamination = {}
                groupExamination.label = object.name
                groupExamination.value = object
                @push "examinationDataList", groupExamination

                for item in object.examinationValueList
                  if typeof item.name is 'string'

                    # push every examination object
                    examination = {}
                    examination.label = item.name
                    examination.value = {
                      name: item.name
                      examinationValueList: [
                        {
                          value: item.name
                        }
                      ]

                    }
                      
                    @push "examinationDataList", examination
                    

              else
                singleExamination = {}
                singleExamination.label = object.name
                singleExamination.value = object    
                @push "examinationDataList", singleExamination

      # get all custom examination
      customExaminationlist = app.db.find 'custom-examination-list', ({createdByUserSerial})=> userIdentifier is createdByUserSerial
      # console.log customInvestigationlist
      
      # pushed all custom symptoms on master investigatin list
      unless customExaminationlist.length is 0
        for item in customExaminationlist

          customObject = {}
          customObject.label = item.data.name
          customObject.value = item.data

          # console.log investigation

          @push "examinationList", customObject

      # console.log 'examinationDataList', @examinationDataList


  ## Make New Examination Object
  _makeNewExaminationObject: ()->
    @examinationObject =
      serial: null
      lastModifiedDatetimeStamp: 0
      createdDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      visitSerial: null
      patientSerial: @patient.serial
      doctorName: @user.name
      doctorSpeciality: @getDoctorSpeciality()
      data:
        examinationValueList: []
      availableToPatient: true

    # console.log @identifiedSymptomsObject
      
    @isExaminationValid = true
      

  ## Load Examination Data
  _loadExamination: (examinationIdentifier)->

    list = app.db.find 'visit-examination', ({serial})-> serial is examinationIdentifier
    if list.length is 1
      @isExaminationValid = true
      @examinationObject = list[0]
      console.log 'EXAMINATION: ', @examinationObject
      @addedExaminationList = list[0].data.examinationValueList
      
      return true
    else
      @_notifyInvalidExamination()
      return false
  
  _notifyInvalidExamination: ->
    @isExaminationValid = false
    @domHost.showModalDialog 'Invalid Examination Provided'

  ## User Added Custom Examination
  saveUserAddedCustomExamination: (examinationName)->

    object =
      serial: @generateSerialForCustomExamination
      lastModifiedDatetimeStamp: lib.datetime.now()
      createdDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      data:
        name: examinationName
        examinationValueList: []

    app.db.insert 'custom-examination-list', object
    @_addToInvoice object.data.name @visit.serial

  removeExaminationMember: (e)->
    el = @locateParentNode e.target, 'PAPER-ICON-BUTTON'
    el.opened = false
    repeater = @$$ '#added-examination-list-repeater'
    index = repeater.indexForElement el
    memberIndex = e.model.index
    
    string = 'addedExaminationList.' + index + '.examinationValueList'
    @splice string, memberIndex, 1
    # Save Examination
    @saveExamination()

  checkExaminationMember: (e)->
    addedExaminationList = @addedExaminationList
    @set 'addedExaminationList', addedExaminationList

    # Save Examination
    @saveExamination()

      


  ## Added Examination
  _selectedAddedExaminationDeleteBtnPressed: (e) ->
    index = e.model.index
    @splice('addedExaminationList', index, 1)

    # todo :: delete object from db if addedExaminationList length is 0
    examinationSerial = @examinationObject.serial
    if @addedExaminationList.length is 0
      list = app.db.find 'visit-examination', ({serial})-> serial is examinationSerial
      # console.log list
      id = list[ 0 ]._id
      app.db.remove 'visit-examination', id
      app.db.insert 'visit-examination--deleted', { serial: examinationSerial }
      @visit.examinationSerial = null
      @_saveVisit()
      @domHost.showToast 'Deleted Successfully!'

    else
      @saveExamination()
      @domHost.showToast 'Deleted Successfully!'


  comboBoxKeyUpExaminationValueChanged: (e)->
    unless @comboBoxExaminationInputValue is ''

      if e.which is 13 # ENTER/RETURN

        if typeof @comboBoxExaminationInputValue is 'object'
          modifiedList = []

          unless @comboBoxExaminationInputValue.examinationValueList is 0
            for item, index in @comboBoxExaminationInputValue.examinationValueList
              object = {}
              object.value = item.value
              object.checked = false
              modifiedList.push object

            modifiedObject =
              name: @comboBoxExaminationInputValue.name
              examinationValueList: modifiedList

            console.log 'modifiedObject', modifiedObject

            # Push on Added Examination List
            @unshift 'addedExaminationList', modifiedObject

        else
          object =
            name: @comboBoxExaminationInputValue
            examinationValueList: []
          # Push on Added Examination List
          @unshift 'addedExaminationList', object      

        # Save Examination
        @saveExamination()

  openDialogForExaminationMember: (e)->
    @customExaminationValue = ''
    el = @locateParentNode e.target, 'PAPER-ICON-BUTTON'
    el.opened = false
    repeater = @$$ '#added-examination-list-repeater'
    @ARBITARY_INDEX = repeater.indexForElement el
    @$$('#dialogExaminationMemberValue').toggle()


  addExaminationMember: ()->
    # console.log 'addedExaminationList', @addedExaminationList
    object = 
      value: @customExaminationValue
      checked: true
    # console.log @ARBITARY_INDEX
    string = "addedExaminationList." + @ARBITARY_INDEX + '.examinationValueList'
    @push string, object

    # Save Examination
    @saveExamination()

    @$$('#dialogExaminationMemberValue').close()



  addExamination:() ->
    unless @comboBoxExaminationInputValue is ''
      if typeof @comboBoxExaminationInputValue is 'object'
        modifiedList = []

        unless @comboBoxExaminationInputValue.examinationValueList is 0
          for item, index in @comboBoxExaminationInputValue.examinationValueList
            object = {}
            object.index = index
            object.value = item.value
            object.checked = false
            modifiedList.push object

          modifiedObject =
            name: @comboBoxExaminationInputValue.name
            examinationValueList: modifiedList

          # console.log 'modifiedObject', modifiedObject

          # Push on Added Examination List

          @unshift 'addedExaminationList', modifiedObject

          @_addToInvoice modifiedObject.name, @visit.serial



      else
        object =
          name: @comboBoxExaminationInputValue
          examinationValueList: []
        # Push on Added Examination List
        @unshift 'addedExaminationList', object

      console.log 'addedExaminationList', @addedExaminationList

      # Save Examination
      @saveExamination()


  filterExaminationList: (examinationList)->
    modifiedAddedExaminationList = []

    for object in examinationList
      unless object.examinationValueList is 0
        modifiedValueList = []
        for item in object.examinationValueList
          if item.checked
            modifiedValueList.push item

        modifiedObject =
          name: object.name
          examinationValueList: modifiedValueList

      modifiedAddedExaminationList.push modifiedObject

    return modifiedAddedExaminationList



  saveExamination: ()->
    # console.log 'addedExaminationList:', @addedExaminationList
    # console.log "@filterExaminationList:", @filterExaminationList @addedExaminationList

    unless @addedExaminationList.length is 0
      @examinationObject.data.examinationValueList = @filterExaminationList @addedExaminationList
      
      if @visit.examinationSerial is null
        @examinationObject.serial = @generateSerialForExamination()

        ## updated current visit object
        @visit.examinationSerial = @examinationObject.serial
        @_saveVisit()

        @examinationObject.visitSerial = @visit.serial
     
      @examinationObject.lastModifiedDatetimeStamp = lib.datetime.now()
      app.db.upsert 'visit-examination', @examinationObject, ({serial})=> @examinationObject.serial is serial

      @set 'comboBoxExaminationInputValue', ''
      @domHost.showToast 'Examination Updated!'


  #####################################################################
  ### Examination - end
  #####################################################################


  #####################################################################
  ### Test Advised - start
  #####################################################################
  
    #####################################################################
  ### Test Advised - end
  #####################################################################

  #####################################################################
  ### Vitals - start
  #####################################################################

  #####################################################################
  ### Vitals - end
  #####################################################################


  #####################################################################
  ### Next Visit - start
  #####################################################################

  _showComputedNextVisitDate: (date)->
    return null if @nextVisitDurationTypeSelectedIndex is 0
    return lib.datetime.mkDate date, 'dd-mmm-yyyy'


  _nextVisitDurationTypeSelectedIndexChanged: ->

    console.log 'nextVisit', @nextVisit
    
    getDurationValue = @nextVisitDurationTypeList[@nextVisitDurationTypeSelectedIndex]
    getDurationValue = getDurationValue.toLowerCase()

    if getDurationValue.search('day') isnt -1
      days = parseInt getDurationValue
      @_setNextVisitDateTimestamp days

    else if getDurationValue.search('week') isnt -1
      weeks = parseInt(getDurationValue.substr 0, 1)
      days = weeks * 7
      @_setNextVisitDateTimestamp days

    else if getDurationValue.search('month') isnt -1
      # Note: 1 month = 30days 
      months = parseInt(getDurationValue.substr 0, 1)
      days = months * 30
      @_setNextVisitDateTimestamp days

    else if getDurationValue.search('year') isnt -1
      # Note: 1 year = 365days 
      years = parseInt(getDurationValue.substr 0, 1)
      days = years * 365
      @_setNextVisitDateTimestamp days

    else if getDurationValue.search('custom') isnt -1
      @isCustomDateTypeSelected  = true


  _setNextVisitDateTimestamp:(days)->
    getCurrentDateTimestamp = lib.datetime.now()
    nextVisitDateTimestamp = getCurrentDateTimestamp + (days * 24 * 60 * 60 * 1000)
    @nextVisit.data.nextVisitDateTimestamp = nextVisitDateTimestamp

  _nextVisitPriorityTypeSelectedIndexChanged: ->

    # console.log @priorityTypeList[@nextVisitPriorityTypeSelectedIndex]
    @nextVisit.data.priorityType = @priorityTypeList[@nextVisitPriorityTypeSelectedIndex]

  _saveNextVisit: (data)->
    data.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'visit-next-visit', data, ({serial})=> data.serial is serial


    
  _addNextVisitPressed: ()->
    unless @nextVisit.data.nextVisitDateTimestamp is 0
      @nextVisit.serial = @generateSerialForNextVisit()
      @nextVisit.createdDatetimeStamp = lib.datetime.now()
      if @visit.nextVisitSerial is null
        @visit.nextVisitSerial = @nextVisit.serial
        @_saveVisit()


      @nextVisit.data.priorityType = @priorityValue
      @_saveNextVisit @nextVisit
      @_loadNextVisit @nextVisit.serial
      @domHost.showToast 'Next Visit Saved!'


  #####################################################################
  ### Next Visit - end
  #####################################################################

  #####################################################################
  ### Note - start
  #####################################################################
  _saveNote: (data)->
    data.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'visit-note', data, ({serial})=> data.serial is serial

    # console.log app.db.find 'visit-note'
    

  _addNotePressed: ()->
    unless @doctorNotesMessage is ''
      @push 'doctorNotes.data.messageList', @doctorNotesMessage

      if @doctorNotes.serial is null
        @doctorNotes.createdDatetimeStamp = lib.datetime.now()
        @doctorNotes.serial = @generateSerialForNote()
      if @visit.doctorNotesSerial is null
        @visit.doctorNotesSerial = @doctorNotes.serial
        @_saveVisit()
    
      @_saveNote @doctorNotes
      @doctorNotesMessage = ''
      @_loadVisitNote @doctorNotes.serial
      @domHost.showToast 'Note Saved.'

  #####################################################################
  ### Note - end
  #####################################################################

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


  _makeNewVisit: (cbfn)->
    @visit =
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

    cbfn()


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
      console.log "VISIT: ", @visit
    else
      @_notifyInvalidVisit()
      return

    cbfn()
     

  _loadVitalsForVisit: (vitalIdentifier, vitalType)->

    if vitalType is 'Blood Pressure'
      @loadIdentifiedVitalData vitalIdentifier, vitalType, 'patient-vitals-blood-pressure'
      @isBPAdded = true

    else if vitalType is 'Heart Rate'
      @loadIdentifiedVitalData vitalIdentifier, vitalType, 'patient-vitals-pulse-rate'
      @isHRAdded = true

    else if vitalType is 'BMI'
      @loadIdentifiedVitalData vitalIdentifier, vitalType, 'patient-vitals-bmi'
      @isBMIAdded = true

    else if vitalType is 'Respirtory Rate'
      @loadIdentifiedVitalData vitalIdentifier, vitalType, 'patient-vitals-respiratory-rate'
      @isRRAdded = true

    else if vitalType is 'Spo2'
      @loadIdentifiedVitalData vitalIdentifier, vitalType, 'patient-vitals-spo2'
      @isSpO2Added = true

    else if vitalType is 'Temperature'
      @loadIdentifiedVitalData vitalIdentifier, vitalType, 'patient-vitals-temperature'
      @isTempAdded = true
  
  loadIdentifiedVitalData: (vitalIdentifier, vitalType, collectionName) ->
    list = app.db.find collectionName, ({serial})=> serial is vitalIdentifier

    if list.length is 1
      vitalData = list[0]
      console.log vitalType, ': ', vitalData
      @_addToVitalList vitalData, vitalType
      return true
    else
      return false

  _formatDateTime: (dateTime)->
    lib.datetime.format((new Date dateTime), 'mmm d, yyyy h:MMTT')



  _loadVisitPrescription: (prescriptionSerial)->
    list = app.db.find 'visit-prescription', ({serial})-> serial is prescriptionSerial
    if list.length is 1
      @isPrescriptionValid = true
      @isFullVisitValid = true
      @prescription = list[0]
      @_listPrescribedMedications @prescription.serial
      # console.log "PrescriptionObj:",  @prescription
      return true
    else
      @isPrescriptionValid = false
      return false



  _loadVisitNote: (doctorNotesSerialIdentifier)->

    list = app.db.find 'visit-note', ({serial})-> serial is doctorNotesSerialIdentifier
    if list.length is 1
      @isNoteValid = true
      @isFullVisitValid = true
      @doctorNotes = list[0]
      console.log 'NOTES: ', @doctorNotes
      return true
    else
      @isNoteValid = false
      return false

  
  _loadNextVisit: (nextVisitSerial)->
    list = app.db.find 'visit-next-visit', ({serial})-> serial is nextVisitSerial

    if list.length is 1
      @isNextVisitValid = true
      @isFullVisitValid = true
      @nextVisit = list[0]
      console.log "NEXT VISIT: ", @nextVisit
      return true
    else
      @isNextVisitValid = false
      return false





  _checkForTestResults: (data)->
    if data.hasTestResults
      list = app.db.find 'patient-test-results', ({serial})-> serial is data.testResultsSerial
      if list.length is 1
        return true
      return false

    return false

  



  _loadInvoice: (invoiceIndentifier)->
    list = app.db.find 'visit-invoice', ({serial})-> serial is invoiceIndentifier

    if list.length is 1
      @isInvoiceValid = true
      @set 'invoice', list[0]
      console.log 'Invoice:', @invoice
      @isInvoiceValid = true
    else
      @isInvoiceValid = false
      return false


  _onDoctorNoteDeletedButtonPressed: (e)->

    index = e.model.index
    @domHost.showModalPrompt 'Are you sure?', (answer)=>
      if answer is true
        @splice 'doctorNotes.data.messageList', index, 1
        app.db.upsert 'visit-note', @doctorNotes, ({serial})=> @doctorNotes.serial is serial



  


  #####################################################################
  # Full Visit Preview - start
  #####################################################################
  _headerTitleListIndexChanged: ()->
    if @visit.serial
      @visit.recordTitle = ''
      @set 'visit.recordTitle', @visitHeaderTitleList[@visitHeaderTitleSelectedIndex]
      @_saveVisit()
  ## Settings - start

  _makeSettings: ->
    @settings =
      createdByUserSerial: @user.serial
      lastModifiedDatetimeStamp: 0
      createdDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: null
      serial: @user.serial
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
      otherSettings:
        patientSignUpDefaultPassword: '123456'

  _getSettings: ->
    list = app.db.find 'settings'
    if list.length is 0
      settings = @_makeSettings()
    else
      settings = list[0]
    # console.log settings
    return settings

  ## Settings - end

  ## VIEW :: HistoryAndPhysical - start
  _getRecord: (recordIdentifier, desiredRecordType)->
    list = app.db.find desiredRecordType, ({serial})-> serial is recordIdentifier
    if list.length is 1
      return list[0]
    else
      return null

  ## NOTE - PRINT ======================================================================================
  # The code below is unavoidably messy looking due to the various requirements in the data 
  # definition. If the namespace is not polluted then we will not have any serious consequences
  # when it comes to performance.

  generateHtmlContent: (def, data)->
    html = @handle_type def, data.data
    html = @filterHtmlContent html
    return html

  filterHtmlContent: (html)->
    html = html.replace /@VALUE@/g, ''
    return html

  printOutStyleSheet: ->
    """
    <style>
      
      .default-category {
        /* font-size: 20px; 
        font-weight: bold; */
        text-align: center; 
      }
      .default-collection {
        /* font-size: 16px; 
        font-weight: bold; */
      }
      .default-group {
        /* text-decoration: overline; */
      }
      .default-card {
        /* text-decoration: underline; */
      }
      span {
        font-size: 14px;
      }
      .unprocessed {
        color: red;
      }
    </style>
    """

  handle_children: (def, data)->
    html = ''
    # console.log data
    if 'childMap' of data and 'childList' of def and def.childList isnt null
      for child, childIndex in def.childList
        if child.key of data.childMap
          childHtml = @handle_type child, data.childMap[child.key]
          if childHtml and not (childHtml in [ ';', ':;', ': ;' ])
            childHtml = @sanitizeOutput childHtml
            html += childHtml
    else
      console.log 'end-case'
    return html

  handle_type: (def, data)->
    # console.log def.key, @listPrintDirectives def
    def.print = {} unless 'print' of def
    if def.type is 'systemRoot'
      @flattenStyle def
      return @type_systemRoot def, data
    else if def.type is 'category'
      def.print.boldLabel = true unless 'boldLabel' of def.print
      def.print.fontSize = 18 unless 'fontSize' of def.print
      @flattenStyle def
      return @type_category def, data
    else if def.type is 'collection'
      def.print.boldLabel = true unless 'boldLabel' of def.print
      def.print.fontSize = 16 unless 'fontSize' of def.print
      @flattenStyle def
      return @type_collection def, data
    else if def.type is 'group'
      def.print.passThrough = true unless 'passThrough' of def.print
      def.print.fontSize = 14 unless 'fontSize' of def.print
      @flattenStyle def
      return @type_group def, data
    else if def.type is 'card'
      def.print.boldLabel = true unless 'boldLabel' of def.print
      def.print.fontSize = 14 unless 'fontSize' of def.print
      @flattenStyle def
      return @type_card def, data
    else if def.type is 'checkbox'
      @flattenStyle def
      return @type_checkbox def, data
    else if def.type is 'toggleableContainer'
      @flattenStyle def
      return @type_toggleableContainer def, data
    else if def.type is 'label'
      @flattenStyle def
      return @type_label def, data
    else if def.type is 'autocomplete'
      if 'selectionType' of def and def.selectionType is 'label'
        def.print.separatorString = ", " unless 'separatorString' of def.print
      @flattenStyle def
      return @type_autocomplete def, data
    else if def.type is 'container'
      @flattenStyle def
      return @type_container def, data
    else if def.type is 'checkList'
      def.print.separatorString = ", " unless 'separatorString' of def.print
      @flattenStyle def
      return @type_checkList def, data
    else if def.type is 'radioList'
      def.print.separatorString = ", " unless 'separatorString' of def.print
      @flattenStyle def
      return @type_radioList def, data
    else if def.type is 'input'
      @flattenStyle def
      return @type_input def, data
    else if def.type is 'singleSelectDropdown'
      @flattenStyle def
      return @type_singleSelectDropdown def, data
    else if def.type is 'incrementalCounter'
      @flattenStyle def
      return @type_incrementalCounter def, data
    else
      return '<span class="unprocessed">UNPROCESSED ' + def.type + ' - ' + def.key + '</span>'


  flattenStyle: (def)->
    if 'passThrough' of def.print
      unless 'hideLabel' of def.print
        def.print.hideLabel = true
      unless 'noColonAfterThis' of def.print
        def.print.noColonAfterThis = true
      unless 'noSemicolonAfterThis' of def.print
        def.print.noSemicolonAfterThis = false
      # delete def.print['passThrough']
    if 'newLineBeforeThis' of def.print
      if typeof def.print.newLineBeforeThis is 'boolean'
        def.print.newLineBeforeThis = (if def.print.newLineBeforeThis is true then 1 else 0)
      else
        def.print.newLineBeforeThis = parseInt def.print.newLineBeforeThis
    if 'newLineAfterThis' of def.print
      if typeof def.print.newLineAfterThis is 'boolean'
        def.print.newLineAfterThis = (if def.print.newLineAfterThis is true then 1 else 0)
      else
        def.print.newLineAfterThis = parseInt def.print.newLineAfterThis
    if 'newLineAfterThisAndChildren' of def.print
      if typeof def.print.newLineAfterThisAndChildren is 'boolean'
        def.print.newLineAfterThisAndChildren = (if def.print.newLineAfterThisAndChildren is true then 1 else 0)
      else
        def.print.newLineAfterThisAndChildren = parseInt def.print.newLineAfterThisAndChildren
    if 'newLineAfterEachValue' of def.print
      if typeof def.print.newLineAfterEachValue is 'boolean'
        def.print.newLineAfterEachValue = (if def.print.newLineAfterEachValue is true then 1 else 0)
      else
        def.print.newLineAfterEachValue = parseInt def.print.newLineAfterEachValue

  sanitizeOutput: (content)->
    for i in [0..2]
      content = content.replace /\;;/g, ';'
      content = content.replace /\;;/g, ';'
      content = content.replace /\; ;/g, ';'
      content = content.replace /\: ;/g, ';'
      content = content.replace /\: :/g, ':'
      content = content.replace /\, ;/g, ';'
      content = content.replace /\; ,/g, ';'
      content = content.replace /\,;/g, ';'

      content = content.replace /<\/span style=""><\/span>/g, ''
      content = content.replace /<\/span>;<\/span>/g, '<\/span><\/span>'
      content = content.replace /<\/span>; <\/span>/g, '<\/span><\/span>'
      content = content.replace /<\/span> ,<\/span>/g, '<\/span><\/span>'

    return content


  ###
    REGION - VARIOUS TYPES
  ###

  _computeElementStyle: (def)->
    style = ''
    if def.print.fontSize
      style += "font-size: #{def.print.fontSize}px;"
    if def.print.hide
      style += "display: none;"
    return style

  _computeTitleOrLabelStyle: (def)->
    style = ''
    if def.print.boldLabel
      style += "font-weight: bold;"
    return style

  type_systemRoot: (def, data)->
    content = (@handle_children def, data)
    return @printOutStyleSheet() + content

  type_category: (def, data)->
    content = @handle_children def, data
    return '' if content.length is 0
    style = @_computeTitleOrLabelStyle def
    title = """<span style="#{style}">#{def.label}</span>"""
    style = @_computeElementStyle def
    html = """<div class="default-category" style="#{style}">#{title}</div>#{content}"""
    return html

  type_collection: (def, data)->
    return '' if (Object.keys data.childMap).length is 0
    if def.defaultGroup and not data.isDefaultGroupDismissed
      content = @handle_type def.defaultGroup, data.childMap[def.defaultGroup.key]
    else
      content = @handle_children def, data
    style = @_computeTitleOrLabelStyle def
    title = """<br><span style="#{style}">#{def.label}</span><br>"""
    style = @_computeElementStyle def
    html = """<span class="default-collection" style="#{style}">#{title}</span>: #{content}<br>"""
    return html

  type_group: (def, data)->
    content = @handle_children def, data
    style = @_computeTitleOrLabelStyle def
    title = """<span style="#{style}">#{def.label}</span>"""
    if def.print.passThrough
      html = """#{content};"""
    else
      style = @_computeElementStyle def
      html = """<span class="default-group" style="#{style}">#{title}</span>: #{content}; """
    return html

  _makePrintableContent: (label, content, value, def, data)->
    return '' if content.length is 0 and value.length is 0 and def.type isnt 'label'
    print = def.print

    # console.log label, print

    labelHtml = ''
    contentHtml = ''
    valueHtml = ''

    return '' if print.hide

    if label.length > 0
      unless print.hideLabel
        style = ''
        if print.boldLabel
          style += 'font-weight: bold;'
        if print.fontSize
          style += "font-size:#{print.fontSize}px;"
        labelHtml = """<span style="#{style}">#{label}</span>"""

    if value.length > 0
      unless print.hideValue
        style = ''
        if print.boldValue
          style += 'font-weight: bold;'
        if print.fontSize
          style += "font-size:#{print.fontSize}px;"
        valueHtml = """<span style="#{style}">#{value}</span>"""    

    if content.length > 0
      unless print.hideChildren
        style = ''
        if print.boldChildren
          style += 'font-weight: bold;'
        contentHtml = """<span style="#{style}">#{content}</span>"""

    if (labelHtml + contentHtml + valueHtml).length is 0
      return ''

    if 'newLineBeforeThis' of print
      for i in [0...print.newLineBeforeThis]
        labelHtml = '<br>' + labelHtml

    if 'newLineAfterThis' of print
      for i in [0...print.newLineAfterThis]
        labelHtml = labelHtml + '<br>'

    colon = (if ('noColonAfterThis' of print and print.noColonAfterThis) or labelHtml.length is 0 then '' else ': ')
    semicolon = (if 'noSemicolonAfterThis' of print and print.noSemicolonAfterThis then '' else '; ')
    html = labelHtml + colon + contentHtml + valueHtml + semicolon

    if 'newLineAfterThisAndChildren' of print
      for i in [0...print.newLineAfterThisAndChildren]
        html = html + '<br>'

    return html


  type_card: (def, data)->
    content = (@handle_children def, data)
    label = def.label
    value = null
    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data
    
  type_checkbox: (def, data)->
    content = null
    label = null

    if data.isChecked
      value = def.label
    else
      value = ''

    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_label: (def, data)->
    content = null
    label = data.label or def.label or def.defaultLabel
    value = null
    
    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_toggleableContainer: (def, data)->
    return '' unless data.isChecked

    content = @handle_children def, data
    label = def.label
    value = null

    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_container: (def, data)->
    content = @handle_children def, data
    label = data.label or def.defaultLabel
    value = null

    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_checkList: (def, data)->
    print = def.print

    stringList = []
    for item in data.checkedValueList
      stringList.push item

    separatorString = print.separatorString
    if 'newLineAfterEachValue' of print
      for i in [0...print.newLineAfterEachValue]
        separatorString += '<br>'

    value = stringList.join separatorString 

    label = null
    content = null

    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_radioList: (def, data)->
    value = data.selectedValue
    label = null
    content = null

    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_singleSelectDropdown: (def, data)->
    value = def.possibleValueList[data.selectedIndex]
    label = null
    content = null

    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_input: (def, data)->
    content = data.value

    if def.unitDetails
      unit = def.unitDetails.unitList[data.selectedUnitIndex]
      # content += ' ' + unit.name

    value = content
    label = def.label
    content = null

    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_autocomplete: (def, data)->
    print = def.print

    if def.selectionType is 'label'

      stringList = []
      for key, value of data.virtualChildMap
        title = key.split '_'
        title.pop()
        title.shift()
        title = title.join '_'
        stringList.push title

      separatorString = print.separatorString
      if 'newLineAfterEachValue' of print
        for i in [0...print.newLineAfterEachValue]
          separatorString += '<br>'

      value = stringList.join separatorString 

      label = def.label
      content = null

      return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

    else
      content = ''
      for key, value of data.virtualChildMap
        title = key.split '_'
        title.pop()
        title.shift()
        title = title.join '_'

        virtualContainer = 
          type: 'container'
          defaultLabel: title
          key: key
          childList: def.childListForEachContainer

        childContent = (@handle_type virtualContainer, value) + ', '
        content += childContent

      value = null
      label = def.label

      return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_incrementalCounter: (def, data)->
    content = ''
    for key, value of data.virtualChildMap
      title = key.replace 'item', ''
      serial = parseInt title

      virtualContainer = 
        type: 'container'
        defaultLabel: (try def.unit.singular catch ex then 'unit') + ' #' + (serial + 1)
        key: key
        childList: def.childListForEachContainer

      content += (@handle_type virtualContainer, value) + ';'

      value = null
      label = def.label
      return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  ###
    REGION - PRINT RELATED CHECKS
  ###

  should_boldLabel: (def)->
    'print' of def and 'boldLabel' of def.print and def.print.boldLabel

  should_passThrough: (def)->
    'print' of def and 'passThrough' of def.print and def.print.passThrough

  should_newLineBeforeThis: (def)->
    'print' of def and 'newLineBeforeThis' of def.print and def.print.newLineBeforeThis

  inject_passThrough_special_card: (def, data)->
    if def.key is def.label and def.key in [ "Details", 'Default' ]
      def.print = {} unless def.print
      def.print.passThrough = true

  inject_passThrough_special_group: (def, data)->
    if def.key is def.label and def.key in [ "List", 'Default' ]
      def.print = {} unless def.print
      def.print.passThrough = true

  __debug_print: (def, handledDirectiveList)->
    all = if 'print' of def then Object.keys(def.print) else []
    left = lib.array.minus all, handledDirectiveList
    if left.length > 0
      console.log 'UNHANDLED print directives', def, left

  ## VIEW :: HistoryAndPhysical - end
  checkForPrintPreviewType: ()->
    
    if @visit.historyAndPhysicalRecordSerial
      return false
    if @visit.identifiedSymptomsSerial
      return false
    else if @visit.examinationSerial
      return false
    else if @visit.vitalSerial.bp
      return false
    else if @visit.vitalSerial.hr
      return false
    else if @visit.vitalSerial.bmi
      return false
    else if @visit.vitalSerial.rr
      return false
    else if @visit.vitalSerial.spo2
      return false
    else if @visit.vitalSerial.temp
      return false
    else if @visit.advisedTestSerial
      return false
    else if @visit.diagnosisSerial
      return false
    else if @visit.doctorNotesSerial
      return false
    else if @visit.nextVisitSerial
      return false
    else
      return true


  printButtonPressed: (e)->
 
    @set 'addedExaminationList2', []

    @printPrescriptionOnly = @checkForPrintPreviewType()
    
    # hack for addedExamination List not updated on print preview
    lib.util.delay 200, ()=>
      @set 'addedExaminationList2', @addedExaminationList
      lib.util.delay 200, ()=>
        console.log 'addedExaminationList2', @addedExaminationList2
        window.print()

  saveVisitSettings: ()->
    @recordTitleValueChanged()
    @$$('#dialogVisitSettings').close()


  _getRecordSerial: (data)->
    if typeof data is 'undefined'
      return 'new'
    else if data is 'new'
      return data
    else return data




  #####################################################################
  # Full Visit Preview - end
  #####################################################################

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

  loadMedicineList: ()->
    @domHost.getStaticData 'pccMedicineList', (medicineCompositionList)=>
      @medicineCompositionList = medicineCompositionList
      @_loadDefaultMedicineCompositionList()


  _checkUserAccess: (accessId)->

    if accessId is 'none'
      return true
    else
      if @organization

        if @organization.isCurrentUserAnAdmin
          return true
        else if @organization.isCurrentUserAMember
          if @organization.userActiveRole
            privilegeList = @organization.userActiveRole.privilegeList
            unless privilegeList.length is 0
              for privilege in privilegeList
                if privilege.serial is accessId
                  return true
          else
            return true

          return false
        else
          return false

      else
        # @navigateToPage "#/select-organization"
        return true

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

  editPatientBtnPressed: ()->
    @domHost.navigateToPage "#/patient-editor/patient:" + @patient.serial
    
  navigatedIn: ->

    @domHost.selectedPatientPageIndex = 0

    @organization = @getCurrentOrganization()
    unless @organization
      @domHost.navigateToPage "#/select-organization"

 
    # Load User
    @_loadUser =>
      params = @domHost.getPageParams()

      # Load Settings Data
      @settings = @_getSettings()
      console.log "SETTINGS:", @settings

      # Load Patient
      unless params['patient']
        @_notifyInvalidPatient()
        return
      else
        @_loadPatient params['patient'], =>

          # load Wallets
          @_loadVariousWallets => null

          # Set SelectedVisitPageIndex
          if params['selected']
           @selectedVisitPageIndex = params['selected']
          else
            @selectedVisitPageIndex = 0

          # Reset Properties - History and Physical
          @historyAndPhysicalRecord = {}

          # Reset Properties - Prescription
          @_resetMedicineForm()
          @_makeDuplicateMedicineEditablePart()
          @matchingPrescribedMedicineList = []

          # Reset Properties - Symptoms
          @addedIdentifiedSymptomsList = []
          @comboBoxSymptomsInputValue = ''

          # Reset Properties - Examination
          @comboBoxExaminationInputValue = ''


          # Reset Properties - Vitals
          tempUnitSelectedIndex = parseInt (lib.localStorage.getItem 'lastSelectedTempUnit')
          if tempUnitSelectedIndex 
            @tempUnitSelectedIndex = tempUnitSelectedIndex
          else
            @tempUnitSelectedIndex = 0

          @addedVitalList = []


          # Reset Properties - Test Advised
          @investigationDataList = []
          @addedInvestigationList = []
          @comboBoxInvestigationInputValue = ''


          # Preloaded Data - Prescription
          @loadMedicineList()
          @_listFavoriteMedicine @user.serial
          @_listCurrentMedications params['patient']

          # Preloaded Data - Symptoms
          @_loadSymptomsListFromSystem @user.serial

          # Preloaded Data - Examination
          @_loadExaminationList @user.serial

          
          # Preloaded Data - Test Advised
          @_loadInvestigationList @user.serial
          @_loadUserAddedInstitutionList @user.serial

          # Preloaded Data - Diagnosis
          @loadDiagnosisListData()
          

          ## Load Visit Record
          unless params['visit']
            @_notifyInvalidVisit()
            return

          @_loadPriceList @organization.idOnServer, ()=> console.log 'Price List Loaded'

          if params['visit'] is 'new'
            @_makeNewVisit =>
              @_makeNewPrescription()
              @_makeNewIdentifiedSymptomsObject()
              @_makeNewExaminationObject()

              @_makeBloodPressure()
              @_makePulseRate()
              @_makeBmi()
              @_makeRespiratoryRate()
              @_makeOxygenSaturation()
              @_makeTemperature()

              @_makeNewTestAdvisedObject()
              @_makeNewDiagnosis()
              @_makeNewNote()
              @_makeNewNextVisit()
              @invoice = {}
              @_loadOrganizationsIBelongTo()
              @_makeNewPatientStay()

          else
            @_loadVisit params['visit'], =>
              @domHost.setSelectedVisitSerial params['visit']
              ## Visit - HistoryAndPhysical - start
              if @visit.hasOwnProperty('historyAndPhysicalRecordSerial')
                if @visit.historyAndPhysicalRecordSerial
                  @historyAndPhysical_navigatedIn()

                  @set 'recordPartName', 'history-and-physical-record'

                  @recordDatabaseCollectionName = 'history-and-physical-record'

                  @record = @_getRecord @visit.historyAndPhysicalRecordSerial, @recordDatabaseCollectionName

                  @recordPartData = @record

                  @recordPartTitle = 'History and Physical Record'

                  @domHost.getStaticData 'dynamicElementDefinitionPreoperativeAssessment', (def)=>
                    
                    @recordPartDef = def

                    @recordPartHtmlContent = @generateHtmlContent @recordPartDef, @recordPartData

                    # console.log @recordPartHtmlContent

                    unless @delayRendering
                      
                      @shouldRender = true
                else
                  @historyAndPhysicalRecord = {}
              else
                @visit.historyAndPhysicalRecordSerial = null
                @historyAndPhysicalRecord = {}
              ## Visit - HistoryAndPhysical - end

              ## Visit - Prescription - start
              if @visit.hasOwnProperty('prescriptionSerial')
                if @visit.prescriptionSerial
                  @_loadPrescription @visit.prescriptionSerial
                else
                  @_makeNewPrescription()
              else
                @visit.prescriptionSerial = null
                @_makeNewPrescription()

              # hack medicine object timesPerInterval
              @medicine.timesPerInterval = 1

              # showGuidelineDisclaimer = lib.localStorage.getItem 'showGuidelineDisclaimer'
              # if showGuidelineDisclaimer is null
              #   @set 'showGuidelineDisclaimer', true
              # else
              #   @set 'showGuidelineDisclaimer', showGuidelineDisclaimer

              ## Visit - Prescription - end

              ## Visit - Symptoms - start
              if @visit.hasOwnProperty('identifiedSymptomsSerial')
                if @visit.identifiedSymptomsSerial
                  @_loadIdentifiedSymptoms @visit.identifiedSymptomsSerial
                else
                  @_makeNewIdentifiedSymptomsObject()
              else
                @visit.identifiedSymptomsSerial = null
                @_makeNewIdentifiedSymptomsObject()
              ## Visit - Symptoms - end

              ## Visit - Examination - start
              if @visit.hasOwnProperty('examinationSerial')
                if @visit.examinationSerial
                  @_loadExamination @visit.examinationSerial
                else
                  @_makeNewExaminationObject()
                  
              else
                @visit.examinationSerial = null
                @_makeNewExaminationObject()

              ## Visit - Examination - end

              ## Visit - Vitals - start
              
              if @visit.hasOwnProperty 'vitalSerial'

                if @visit.vitalSerial.bp
                   @_loadVitalsForVisit @visit.vitalSerial.bp, 'Blood Pressure'
                else
                  @_makeBloodPressure()

                if @visit.vitalSerial.hr
                  @_loadVitalsForVisit @visit.vitalSerial.hr, 'Heart Rate'
                else
                  @_makePulseRate()

                if @visit.vitalSerial.bmi
                  @_loadVitalsForVisit @visit.vitalSerial.bmi, 'BMI'
                else
                  @_makeBmi()

                if @visit.vitalSerial.rr
                  @_loadVitalsForVisit @visit.vitalSerial.rr, 'Respirtory Rate'
                else
                  @_makeRespiratoryRate()

                if @visit.vitalSerial.spo2
                  @_loadVitalsForVisit @visit.vitalSerial.spo2, 'Spo2'
                else
                  @_makeOxygenSaturation()

                if @visit.vitalSerial.temp
                  @_loadVitalsForVisit @visit.vitalSerial.temp, 'Temperature'
                else
                  @_makeTemperature()

              else
                @_makeBloodPressure()
                @_makePulseRate()
                @_makeBmi()
                @_makeRespiratoryRate()
                @_makeOxygenSaturation()
                @_makeTemperature()

                @visit.vitalSerial =
                  bp: null
                  hr: null
                  bmi: null
                  rr: null
                  spo2: null
                  temp: null
        
              ## Visit - Vitals - end


              ## Visit - Test Advised - start
              if @visit.hasOwnProperty('advisedTestSerial')
                if @visit.advisedTestSerial
                  @_loadAdvisedTest @visit.advisedTestSerial
                else
                  @_makeNewTestAdvisedObject()
              else
                @visit.advisedTestSerial = null
                @_makeNewTestAdvisedObject()
                  
              ## Visit - Test Advised - start

              ## Visit - Diagnosis - start
              if @visit.hasOwnProperty('diagnosisSerial')
                if @visit.diagnosisSerial
                  @_loadDiagnosis @visit.diagnosisSerial
                else
                  @_makeNewDiagnosis()
              else
                @visit.diagnosisSerial = null
                @_makeNewDiagnosis()
              ## Visit - Diagnosis - end

              ## Visit - Referral - start
              if @visit.hasOwnProperty('referralSerial')
                if @visit.referralSerial
                  @_loadReferral @visit.referralSerial
                else
                  @_makeNewReferral()
              else
                @visit.referralSerial = null
                @_makeNewReferral()
              ## Visit - Referral - end

              ## Visit - Notes - start
              if @visit.hasOwnProperty('doctorNotesSerial')
                if @visit.doctorNotesSerial
                  @_loadVisitNote @visit.doctorNotesSerial
                else
                  @_makeNewNote()
              else
                @visit.doctorNotesSerial = null
                @_makeNewNote()

              ## Visit - Next Visit - start
              if @visit.hasOwnProperty('nextVisitSerial')
                if @visit.nextVisitSerial
                  @_loadNextVisit @visit.nextVisitSerial
                else
                  @_makeNewNextVisit()
              else
                @visit.nextVisitSerial = null
                @_makeNewNextVisit() is null

              ## Visit - Next Visit - end

              ## Visit - Patient Stay - start
              @_loadOrganizationsIBelongTo()

              if @visit.hasOwnProperty('patientStaySerial')
                if @visit.patientStaySerial
                  @_loadVisitPatientStay @visit.patientStaySerial
                else
                  @_makeNewPatientStay()
              else
                @visit.patientStaySerial = null
                @_makeNewPatientStay() is null
              
              ## Visit - Patient Stay - end

              ## Visit - Invoice - start
              if @visit.hasOwnProperty('invoiceSerial')
                if @visit.invoiceSerial
                  @_loadInvoice @visit.invoiceSerial
                else
                  @invoice = {}
              else
                @visit.invoiceSerial = null
                @invoice = {}
              ## Visit - Invoice - end

          


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



  ## ------------------------------- History and physical - start

  historyAndPhysical_navigatedIn: ->
    @_loadHistoryAndPhysicalRecord()
    @_loadRecordInClipboard()

  historyAndPhysicalRecordCreate: (e)->
    params = @domHost.getPageParams()
    if params['visit'] is 'new'
      @_saveVisit()
    # console.log @visit.serial
    @historyAndPhysicalRecord = {
      lastModifiedDatetimeStamp: lib.datetime.now()
      createdDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      serial: @generateSerialForHistoryAndPhysical()
      patientSerial: @patient.serial
      visitSerial: @visit.serial
      availableToPatient: true
    }

    @visit.historyAndPhysicalRecordSerial = @historyAndPhysicalRecord.serial
    @visit.lastModifiedDatetimeStamp = lib.datetime.now()

    # updated visit object for History and Physical
    app.db.upsert 'doctor-visit', @visit, ({serial})=> @visit.serial is serial


    @_saveHistoryAndPhysicalRecord()
    @_loadHistoryAndPhysicalRecord()
    @domHost.navigateToPage '#/record-history-and-physical/record:' + @historyAndPhysicalRecord.serial
    window.location.reload()


  _loadRecordInClipboard: ->
    recordInClipboard = sessionStorage.getItem 'HISTORY-AND-PHYSICAL-IN-CLIPBOARD'
    if recordInClipboard
      recordInClipboard = JSON.parse recordInClipboard
    @recordInClipboard = recordInClipboard

  historyAndPhysicalRecordCopy: (e)->
    record = @historyAndPhysicalRecord
    # console.log record

    sessionStorage.setItem 'HISTORY-AND-PHYSICAL-IN-CLIPBOARD', JSON.stringify record
    @domHost.showModalDialog "This record has been copied to clipboard"
    @_loadRecordInClipboard()

  pasteRecordPressed: (e)->
    params = @domHost.getPageParams()
    if params['visit'] is 'new'
      @_saveVisit()

    @recordInClipboard.patientSerial = @patient.serial
    @recordInClipboard.visitSerial = @visit.serial
    @recordInClipboard.lastChangedDatetimeStamp = lib.datetime.now()
    @recordInClipboard.serial = @generateSerialForRecord()

    @visit.historyAndPhysicalRecordSerial = @recordInClipboard.serial
    @historyAndPhysicalRecord = @recordInClipboard


    # updated visit object for History and Physical
    app.db.upsert 'doctor-visit', @visit, ({serial})=> @visit.serial is serial

    @_saveHistoryAndPhysicalRecord()
    @_loadHistoryAndPhysicalRecord()

    @recordInClipboard = null
    sessionStorage.removeItem 'HISTORY-AND-PHYSICAL-IN-CLIPBOARD'

    @domHost.showModalDialog "Successfully Imported. Reloading Interface."

    @domHost.navigateToPage '#/record-history-and-physical/record:' + @historyAndPhysicalRecord.serial
    window.location.reload()


    

  _updateVisitForHistoryAndPhysicalRecord: (historyAndPhysicalRecordIdentifier)->


  historyAndPhysicalRecordPrint: (e)->
    @domHost.navigateToPage '#/print-history-and-physical-record/record:' + @historyAndPhysicalRecord.serial

  historyAndPhysicalRecordEdit: (e)->
    @domHost.navigateToPage '#/record-history-and-physical/record:' + @historyAndPhysicalRecord.serial

  historyAndPhysicalRecordRemove: (e)->
    @domHost.showModalPrompt 'Are you sure?', (answer)=>
      if answer
        app.db.remove 'history-and-physical-record', @historyAndPhysicalRecord._id
        @_loadHistoryAndPhysicalRecord()

  _loadHistoryAndPhysicalRecord: ->
    currentVisitSerial = @visit.serial
    list = app.db.find 'history-and-physical-record', ({visitSerial})=> visitSerial is currentVisitSerial
    if list.length is 1
      @set 'historyAndPhysicalRecord', list[0]
    else
      @set 'historyAndPhysicalRecord', null

    console.log '_loadHistoryAndPhysicalRecord', @historyAndPhysicalRecord

  _saveVisitPrescription:->
    app.db.upsert 'visit-prescription', @prescription, ({serial})=> @prescription.serial is serial
    @domHost.showToast 'Record Saved'

  _saveVisitTestAdvised:->
    app.db.upsert 'visit-advised-test', @testAdvised, ({serial})=> @testAdvised.serial is serial
    @domHost.showToast 'Record Saved'


  _saveHistoryAndPhysicalRecord:->
    app.db.upsert 'history-and-physical-record', @historyAndPhysicalRecord, ({serial})=> @historyAndPhysicalRecord.serial is serial
    @domHost.showToast 'Record Saved'


  ## ------------------------------- History and physical - end

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


  historyAndPhysicalAvailableToPatientCheckBoxChanged: (e)->
    if @historyAndPhysicalRecord
      if e.target.checked
        @historyAndPhysicalRecord.availableToPatient = true
        @_saveHistoryAndPhysicalRecord()
      else
        @historyAndPhysicalRecord.availableToPatient = false
        @_saveHistoryAndPhysicalRecord()


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


  ## diagnosis - start
  _loadDiagnosis: (diagnosisSerialIdentifier)->
    lib.util.delay 5, ()=>
      list = app.db.find 'diagnosis-record', ({serial})-> serial is diagnosisSerialIdentifier
      
      if list.length is 1
        @isDiagnosisValid = true
        @isFullVisitValid = true
        @diagnosis = list[0]
        console.log 'DIAGNOSIS:', @diagnosis
        return true
      else
        @isDiagnosisValid = false
        return false

  _makeNewDiagnosis: ()->
    @diagnosis =
      serial: null
      lastModifiedDatetimeStamp: lib.datetime.now()
      createdDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      visitSerial: null
      patientSerial: @patient.serial
      doctorName: @visit.doctorName
      doctorSpeciality: @visit.doctorSpeciality 
      data:
        diagnosisList: []

  _saveDiagnosis: ()->

    unless @visit.serial isnt null
      @_saveVisit()
      # @visit.serial = @generateSerialForVisit()
      @diagnosis.visitSerial = @visit.serial
      
    
    unless @diagnosis.serial isnt null
      @diagnosis.serial = @generateSerialForDiagnosis()
      @visit.diagnosisSerial = @diagnosis.serial
      @diagnosis.visitSerial = @visit.serial
      @_saveVisit()
        
    console.log 'visit', @visit
    console.log 'diagnosis', @diagnosis

    @diagnosis.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'diagnosis-record', @diagnosis, ({serial})=> @diagnosis.serial is serial

    @comboBoxDiagnosisInputValue = ''


  loadDiagnosisListData: ()->
  
    @domHost.getStaticData 'diagnosisList', (diagnosisList)=>
      list = ({label: item.name, value: item.name} for item in diagnosisList when item.name)
      @set 'diagnosisListArray', list
      
      # @diagnosisListArray.sort (left, right)->
      #   return -1 if left.label < right.label
      #   return 1 if left.label > right.label
      #   return 0

      # @push 'diagnosisListArray', {label: 'hello', value: 'hello'}

      # console.log 'diagnosisList', diagnosisList

  comboBoxKeyUpRecordTitleValueChanged: (e)->
    if @visit.recordTitle isnt '' or @visit.recordTitle isnt null
      if e.which is 13 # ENTER/RETURN
        @_saveVisit()

  recordTitleValueChanged: ()->
    if @visit.recordTitle isnt '' or @visit.recordTitle isnt null
      @_saveVisit()


  openVisitSettingsDialog: (e)->
    @$$('#dialogVisitSettings').toggle()



  comboBoxKeyUpDiagnosisValueChanged: (e)->
    # console.log @comboBoxDiagnosisInputValue

    unless @comboBoxDiagnosisInputValue is ''

      if e.which is 13 # ENTER/RETURN
        diagnosis = ''
        if typeof @comboBoxDiagnosisInputValue is 'object'
          diagnosis = @comboBoxDiagnosisInputValue.name
        else
          diagnosis = @comboBoxDiagnosisInputValue

        @push 'diagnosis.data.diagnosisList', { name: diagnosis }
        @_saveDiagnosis()
        @domHost.showToast 'Diagnosis Added!'
        @comboBoxDiagnosisInputValue = ''

  addDiagnosis: ()->
    unless @comboBoxDiagnosisInputValue is ''
      diagnosis = ''
      if typeof @comboBoxDiagnosisInputValue is 'object'
        diagnosis = @comboBoxDiagnosisInputValue.name
      else
        diagnosis = @comboBoxDiagnosisInputValue

      @push 'diagnosis.data.diagnosisList', { name: diagnosis }
      @_saveDiagnosis()
      @_addToInvoice diagnosis, @visit.serial
      @domHost.showToast 'Diagnosis Added!'
      @comboBoxDiagnosisInputValue = ''
       




  _deleteSelectedDiagnosisButtonPressed: (e)->
    index = e.model.index
    @splice 'diagnosis.data.diagnosisList', index, 1
    @_saveDiagnosis()
    @domHost.showToast 'Diagnosis Deleted!'


  

  ## diagnosis - end



  # INVOICE START 
  # ================================================================
  
  # Invoice END
  # ================================
    
  # ===============================
  # ADD REFERRAL
  # By @taufiq
  # ===============================

  

  # ADD REFFERAL END
  # ==================================================
}
