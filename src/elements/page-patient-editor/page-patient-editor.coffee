
Polymer {

  is: 'page-patient-editor'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
  ]

  properties:

    EDIT_MODE_ON:
      type: Boolean
      notify: true
      value: false

    showPhysicalActivity:
      type: String
      notify: true
      value: 'no'

    user:
      type: Object
      notify: true
      value: null

    isPatientValid: 
      type: Boolean
      notify: true
      value: false

    patient:
      type: Object
      notify: true
      value: null

    patientSignupData:
      type: Object
      notify: true
      value: null

    patientAddress:
      type: Object
      notify: true
      value: null

    settings:
      type: Object
      notify: true
      value: null

    selectedPatientInfoPage:
      type: Number
      notify: true
      value: 0

    sexSelectedIndex:
      type: Number
      value: 0

    genderList:
      type: Array
      value: -> ['Male', 'Female', 'Other']

    divisionIndex:
      type: Number
      value: -1
      notify: true

    districtIndex:
      type: Number
      value: -1
      notify: true

    districtList:
      type: Array
      value: -> []
      notify: true

    divisionList:
      type: Array
      value: -> [
        {
            divisionName: "Barisal"
            districtList: [
                "Barguna",
                "Barisal",
                "Bhola",
                "Jhalokati",
                "Patuakhal",
                "Pirojpur"
            ]
        }
        {
            divisionName: "Chittagong"
            districtList: [
                "Bandarban",
                "Brahmanbaria",
                "Chandpur",
                "Chittagong",
                "Comilla",
                "Cox's Bazar",
                "Feni",
                "Khagrachhari",
                "Lakshmipur",
                "Noakhali",
                "Rangamati"
            ]
        }
        {
            divisionName: "Dhaka"
            districtList: [
                "Dhaka",
                "Faridpur",
                "Gazipur",
                "Gopalganj",
                "Kishoreganj",
                "Madaripur",
                "Manikganj",
                "Munshiganj",
                "Narayanganj",
                "Narsingdi",
                "Rajbari",
                "Shariatpur",
                "Tangail "
            ]
        }
        {
            divisionName: "Khulna"
            districtList: [
                "Bagerhat",
                "Chuadanga",
                "Jessore",
                "Jhenaidah",
                "Khulna",
                "Kushtia",
                "Magura",
                "Meherpur",
                "Narail",
                "Satkhira"
            ]
        }
        {
            divisionName: "Mymensingh"
            districtList: [
                "Jamalpur",
                "Mymensingh",
                "Netrakona",
                "Sherpur"
            ]
        }
        {
            divisionName: "Rajshahi"
            districtList: [
                "Bogra",
                "Joypurhat",
                "Naogaon",
                "Natore",
                "Nawabganj",
                "Pabna",
                "Rajshahi",
                "Sirajganj"
            ]
        }
        {
            divisionName: "Rangpur"
            districtList: [
                "Dinajpur",
                "Gaibandha",
                "Kurigram",
                "Lalmonirhat",
                "Nilphamari",
                "Panchagarh",
                "Rangpur",
                "Thakurgaon"
            ]
        }
        {
            divisionName: "Sylhet"
            districtList: [
                "Habiganj",
                "Moulvibazar",
                "Sunamganj",
                "Sylhet"
            ]
        }
      ]

    organization:
      type: Object
      notify: true
      value: null

    policy:
      type: Object
      value: -> {}

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

  _showComputedWestHipRatio: (waist, hip)->
    console.log waist, hip
    return waist / hip

  _returnSerial: (index)->
    index+1

  _isEmpty: (data)-> 
    if data is 0
      return true
    else
      return false


  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  saveButtonPressed: (e)->
    # params = @domHost.getPageParams()

    # if @patient.serial is null or params['patient'] is 'new'
    #   @patient.serial = @generateSerialForPatient()

    @patient.name = @$makeNameObject @patient.name

    @patient.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'patient-list', @patient, ({serial})=> @patient.serial is serial



    @_callBDEMRPatientDetailsUpdateApi @patient, =>
      @domHost.showToast 'Patient Details Updated!'
      # @domHost.__patientView__oneTimeSearchFilter = @patient.serial
      @arrowBackButtonPressed()

  $findCreator: (creatorSerial)-> 'me'

  _computeAge: (dateString)->
    today = new Date()
    birthDate = new Date dateString
    age = today.getFullYear() - birthDate.getFullYear()
    m = today.getMonth() - birthDate.getMonth()

    if m < 0 || (m == 0 && today.getDate() < birthDate.getDate())
      age--

    return age

  _makeDiabeticRecord: ->
    diabeticRecord =

      visitType: null
      diabeticsInfo:
        patientBookSerial: null
        dmStatus: null
        typeOfDiabetics: null
        diabeticsDuration: null

      clinicalInfoList: [

        {
          type: 'height'
          name: 'Height'
          value: null
          unit: 'cm'
          inputType: 'number'
        }
        {
          type: 'weight'
          name: 'Weight'
          value: null
          unit: 'kg'
          inputType: 'number'
        }
        {
          type: 'bmi'
          name: 'BMI'
          value: null
          unit: 'km/m2'
          inputType: 'number'
        }
        {
          type: 'waist'
          name: 'Waist'
          value: 0
          unit: 'cm'
          inputType: 'number'
        }
        {
          type: 'hip'
          name: 'Hip'
          value: 0
          unit: 'cm'
          inputType: 'number'
        }
        {
          type: 'waist-hip-ratio'
          name: 'Waist Hip Ratio'
          value: 0
          unit: ''
          inputType: 'number'
        }

        {
          type: 'sbp'
          name: 'SBP'
          value: null
          unit: 'mmHg'
          inputType: 'number'
        }
        {
          type: 'dbp'
          name: 'DBP'
          value: null
          unit: 'mmHg'
          inputType: 'number'
        }
      ]

      laboratoryTestList: [
        {
          name: 'hbA1c'
          value: null
          unit: '%'
          isSelected: ''
          costType: 'free'
          inputType: 'number'
          isCustomTest: false
        }
        {
          name: 'FPG'
          value: null
          unit: 'mmol'
          isSelected:  ''
          costType: 'free'
          inputType: 'number'
          isCustomTest: false
        }
        {
          name: '2hPG'
          value: null
          unit: 'mmol'
          isSelected:  ''
          costType: 'free'
          inputType: 'number'
          isCustomTest: false
        }
        {
          name: 'Post Meal'
          value: null
          unit: 'mmol'
          isSelected:  ''
          costType: 'free'
          inputType: 'number'
          isCustomTest: false
        }
        {
          name: 'Urine Acetone'
          value: null
          unit: '+'
          isSelected:  ''
          costType: 'free'
          inputType: 'number'
          isCustomTest: false
        }
        {
          name: 'Urine Albumine'
          value: null
          unit: ''
          isSelected:  ''
          costType: 'free'
          inputType: 'number'
          isCustomTest: false
        }
        {
          name: 'S. Creatinine'
          value: null
          unit: 'mg/dl'
          isSelected:  ''
          costType: 'free'
          inputType: 'number'
          isCustomTest: false
        }
        {
          name: 'SGPT'
          value: null
          unit: 'Units per liter'
          isSelected:  ''
          costType: 'free'
          inputType: 'number'
          isCustomTest: false
        }
        {
          name: 'HB'
          value: null
          unit: '%'
          isSelected:  ''
          costType: 'free'
          inputType: 'number'
          isCustomTest: false
        }
        {
          name: 'ECG'
          value: null
          unit: ''
          type: ''
          isSelected:  ''
          costType: 'free'
          inputType: 'mixed'
          isCustomTest: false
        }
        {
          name: 'CHOL'
          value: null
          unit: 'mg/dl'
          isSelected:  ''
          costType: 'free'
          inputType: 'number'
          isCustomTest: false
        }
        {
          name: 'LDL-C'
          value: null
          unit: 'mg/dl'
          isSelected:  ''
          costType: 'free'
          inputType: 'number'
          isCustomTest: false
        }
        {
          name: 'HDL-C'
          value: null
          unit: 'mg/dl'
          isSelected:  ''
          costType: 'free'
          inputType: 'number'
          isCustomTest: false
        }
        {
          name: 'Triglycerides'
          value: null
          unit: 'mg/dl'
          isSelected:  ''
          costType: 'free'
          inputType: 'number'
          isCustomTest: false
        }
      ]

      complicationList: [
        {
          name: 'Heart Disease'
          isSelected: false
        }
        {
          name: 'HHNS'
          isSelected: false
        }
        {
          name: 'Stroke'
          isSelected: false
        }
        {
          name: 'Foot Complication'
          isSelected: false
        }
        {
          name: 'Nuropathy'
          isSelected: false
        }
        {
          name: 'PVD'
          isSelected: false
        }
        {
          name: 'Retinopathy'
          isSelected: false
        }
        {
          name: 'Skin Disease'
          isSelected: false
        }
        {
          name: 'CKD'
          isSelected: false
        }
        {
          name: 'Gastro Complication'
          isSelected: false
        }
        {
          name: 'DKA'
          isSelected: false
        }
        {
          name: 'Hypoglycemia'
          isSelected: false
        }
        {
          name: 'HTN (Hypertension)'
          isSelected: false
        }
        {
          name: 'Lipid Disorder'
          isSelected: false
        }
      ]

      physicalActivityList: []

      medicalInfo:
        drugAddictionList: [
          {
            type: 'Cigarette'
            isYes: ''
            amount: ''
          }
          {
            type: 'Bidi'
            isYes: ''
            amount: ''
          }
          {
            type: 'Chewing Tobacco'
            isYes: ''
            amount: ''
          }
          {
            type: 'Tobacco Powder'
            isYes: ''
            amount: ''
          }
          {
            type: 'Betal Leaf/Betal Nut (Shupari)'
            isYes: ''
            amount: ''
          }
          {
            type: 'Alcohol'
            isYes: ''
            amount: ''
          }
          {
            type: 'Others'
            isYes: ''
            amount: ''
          }
        ]

        dietaryHistoryList: []

        typeOfCookingOilList: [
          {
            type: 'Soyebean oil'
            isYes: ''
            amount: ''
            unit: 'Litres'
            duration: 'Month'
          }
          {
            type: 'Mustard oil'
            isYes: ''
            amount: ''
            unit: 'Litres'
            duration: 'Month'
          }
          {
            type: 'Palm oil'
            isYes: ''
            amount: ''
            unit: 'Litres'
            duration: 'Month'
          }
          {
            type: 'Olive oil'
            isYes: ''
            amount: ''
            unit: 'Litres'
            duration: 'Month'
          }
          {
            type: 'Rice bran oil'
            isYes: ''
            amount: ''
            unit: 'Litres'
            duration: 'Month'
          }
          {
            type: 'Other'
            isYes: ''
            amount: ''
            unit: 'Litres'
            duration: 'Month'
          }
        ]

        historyOfDeseaseList: [
          {
            diseaseName: 'Diabetes'
            value: ''
          }
          {
            diseaseName: 'Pregnancy diabetes'
            value: ''
          }
          {
            diseaseName: 'Hypertension'
            value: ''
          }
          {
            diseaseName: 'Heart disease'
            value: ''
          }
          {
            diseaseName: 'Asthma'
            value: ''
          }
          {
            diseaseName: 'Tuberculosis'
            value: ''
          }
          {
            diseaseName: 'Mental disorder'
            value: ''
          }
          {
            diseaseName: 'Abortion'
            value: ''
          }
          {
            diseaseName: 'Preeclampsia'
            value: ''
          }
          {
            diseaseName: 'Eclampsia'
            value: ''
          }
          {
            diseaseName: 'Still-Birth'
            value: ''
          }
          {
            diseaseName: 'Macrosomia (Large Baby >4kg)'
            value: ''
          }
          {
            diseaseName: 'LBW (Small Baby <2.5kg)'
            value: ''
          }
          {
            diseaseName: 'Pre-term ( less than 37 weeks )'
            value: ''
          }
          {
            diseaseName: 'IUD'
            value: ''
          }
        ]

        historyOfMedicationList: [
          {
            name: 'On Insulin'
            value: ''
            type: ''
            typeOfDevice: ''
            forVisitReasonIdList: []
          }
          {
            name: 'OADs'
            value: ''
            type: ''
            forVisitReasonIdList: ['002', '003', '005']
            
          }
          {
            name: 'Anti HTN'
            value: ''
            type: ''
            forVisitReasonIdList: []
          }
          {
            name: 'Anti lipids'
            value: ''
            type: ''
            forVisitReasonIdList: []
          }
          {
            name: 'Cardiac Medication'
            value: ''
            type: ''
            forVisitReasonIdList: []
          }
        ]

        familyHistoryList: [
          {
            disease: 'Diabetes'
            value: ''
          }
          {
            disease: 'Hypertension'
            value: ''
          }
          {
            disease: 'Coronary Artery Disease'
            value: ''
          }
          {
            disease: 'Cerebro-Vascular Disease'
            value: ''
          }
        ]

      currentTreatment:
        typeOfTreatment: ''
        ogld:
          ogldUsage: 'no'
          ogldDrugList: [
            {
              ogldDrugName: ''
              drugDosage: ''
            }
          ]
      insulin:
        insulinUsage: 'no'
        insulinType: ''
        insulinTherapyList: [
          {
            therapyType: 'Basal'
            drugName: ''
            preListedDrugPath: 'basalDrugList'
            dosageList: [
              {
                time: 'Morning'
                value: ''
                unit: 'unit'
              }
              {
                time: 'Noon'
                value: ''
                unit: 'unit'
              }
              {
                time: 'Night'
                value: ''
                unit: 'unit'
              }
            ]
          }
          {
            therapyType: 'Bolus'
            drugName: ''
            preListedDrugPath: 'bolusDrugList'
            dosageList: [
              {
                time: 'Morning'
                value: ''
                unit: 'unit'
              }
              {
                time: 'Noon'
                value: ''
                unit: 'unit'
              }
              {
                time: 'Night'
                value: ''
                unit: 'unit'
              }
            ]
          }
          {
            therapyType: 'Premix'
            drugName: ''
            preListedDrugPath: 'premixDrugList'
            dosageList: [
              {
                time: 'Morning'
                value: ''
                unit: 'unit'
              }
              {
                time: 'Noon'
                value: ''
                unit: 'unit'
              }
              {
                time: 'Night'
                value: ''
                unit: 'unit'
              }
            ]
          }
          {
            therapyType: 'Other'
            drugName: ''
            preListedDrugPath: 'otherInsulinDrugList'
            dosageList: [
              {
                time: 'Morning'
                value: ''
                unit: 'unit'
              }
              {
                time: 'Noon'
                value: ''
                unit: 'unit'
              }
              {
                time: 'Night'
                value: ''
                unit: 'unit'
              }
            ]
          }
        ]

      otherMedicationList:  [
        {
          name: 'Anti HTN'
          isYes: ''
          medicineList: [
            {
              name: ''
              dose: ''
              unit: ''
            }
          ]
        }
        {
          name: 'Anti lipids'
          isYes: ''
          medicineList: [
            {
              name: ''
              dose: ''
              unit: ''
            }
          ]
        }
        {
          name: 'Aspirin'
          isYes: ''
          medicineList: [
            {
              name: ''
              dose: ''
              unit: ''
            }
          ]
        }
        {
          name: 'Anti-obesity'
          isYes: ''
          medicineList: [
            {
              name: ''
              dose: ''
              unit: ''
            }
          ]
        }
      ]
        

  _makePatientSignUp: ->

    @patient =
      name: ''
      password: '123456'
      email: ''
      phone: ''
      additionalPhoneNumber: null
      dateOfBirth: lib.datetime.mkDate lib.datetime.now()
      effectiveRegion: 'Bangladesh'
      doctorAccessPin: '0000'
      nationalIdCardNumber: null

      addressList: [
        {
          addressTitle: 'Personal'
          addressType: 'personal'
          flat: null
          floor: null
          plot: null
          block: null
          road: null
          village: null
          addressUnion: null
          subdistrictName: null
          addressDistrict: null
          addressPostalOrZipCode: null
          addressCityOrTown: null
          addressDivision: null
          addressAreaName: null
          addressLine1: null
          addressLine2: null
          stateOrProvince: null
          addressCountry: "Bangladesh"
        }
      ]
      
      gender: ''
      bloodGroup: ''
      allergy: ''

      expenditure: null
      profession: null
      
      patientSpouseName: ''
      patientFatherName: ''
      patientMotherName: ''
      maritalAge: ''
      maritalStatus: ''
      numberOfFamilyMember: ''
      numberOfChildren: ''
      education: null
      employmentInfo: {}
      policyList: []
      belongOrganizationList: [
        {
          organizationId: null
          patientIdbyOrganization: null
        }
      ]
      


  onDivisionChange: (e)->
    @set 'districtIndex', -1
    districtList = @divisionList[@divisionIndex].districtList
    lib.util.delay 5, ()=>
      @set 'districtList', districtList

  _loadPatient: (patientIdentifier, cbfn)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier
    if list.length is 1
      @isPatientValid = true
      patient = list[0]
      patient.name = @$getFullName patient.name
      patient.employmentInfo = patient.employmentDetailsList[0] or {}
      @set 'patient', patient
    else
      @_notifyInvalidPatient()

    cbfn()

  _notifyInvalidPatient: ->
    @isPatientValid = false
    @domHost.showModalDialog 'Invalid Patient Provided'

  getDefaultPasswordForPatientSignup: ()->
    if typeof @settings.otherSettings.patientSignUpDefaultPassword
      return '123456'
    else
      return @settings.otherSettings.patientSignUpDefaultPassword

  createOrganizationSerialForPatient: (orgName, patientSerial)->
    str = orgName
    matches = str.match(/\b(\w)/g);      
    acronym = matches.join('');
    return acronym + patientSerial

  calculateAge: (e)->
    selectedDate = e.detail.value
    selectedDateYear = (new Date selectedDate).getFullYear()
    currentYear = (new Date).getFullYear()
    age = currentYear - selectedDateYear
    @ageInYears = age

  makeDOBFromYears: (e)->
    age = e.target.value
    dateInYear = (new Date).getFullYear()
    dateInYear -= parseInt age
    @set 'patient.dateOfBirth', "#{dateInYear}-01-01" 


  printButtonPressed: (e)->
    window.print()


  

  navigatedIn: ->
    @selectedPatientInfoPage = 0
    params = @domHost.getPageParams()

    @organization = @getCurrentOrganization()
    unless @organization
      @domHost.navigateToPage "#/select-organization"
      
    @_loadUser()
    @settings = @_getSettings()

    if params['patient'] is 'new'
      @_makePatientSignUp()
      @isPatientValid = true
    else
      @_loadPatient params['patient'], =>
        @set "EDIT_MODE_ON", true

      
  ## -- signup - start

  standardPatientSignupPressed: (e)->
    console.log 'PATIENT', @patient
    unless @patient.name and @patient.password and @patient.phone
      @domHost.showToast 'Please Fill Up Required Information'
      return

    patient = @patient
    patient.name = @_makeNameObject patient.name
    patient.belongOrganizationList[0].organizationId = @organization.idOnServer

    @_callBDEMRPatientSignupApi patient

  _callBDEMRPatientSignupApi: (patient) ->

    data =
      patient: patient
      apiKey: @user.apiKey

    @callApi '/bdemr-birdem-patient-registration', data, (err, response)=>
      console.log response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        # @savePatientClinicalData patient, =>
        @domHost.showModalDialog "Patient Created Successfully!"
        @domHost.navigateToPage '#/patient-manager/query:' + patient.phone

  ## -- signup - end

  ## -- update - start

  updatePatientDetails: (e)->
    console.log 'PATIENT', @patient
    unless @patient.name and @patient.dateOfBirth
      @domHost.showToast 'Please Fill Up Required Information'
      return

    @patient.gender = @genderList[@sexSelectedIndex]

    patient = @patient
    patient.name = @_makeNameObject patient.name

    app.db.upsert 'patient-list', patient, ({serial})=> patient.serial is serial

    @_callBDEMRPatientDetailsUpdateApi patient

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

        id = (app.db.find 'patient-list', ({serial})-> serial is patient.serial)[0]._id
        if id
          app.db.remove 'patient-list', id

        patient.flags = {
          isImported: false
          isLocalOnly: false
          isOnlineOnly: false
        }
        patient.flags.isImported = true

        @domHost.setCurrentPatientsDetails patient

        _id = app.db.insert 'patient-list', patient
        cbfn _id


  _callBDEMRPatientDetailsUpdateApi: (patient, cbfn) ->
    data =
      patient: patient
      apiKey: @user.apiKey
    @callApi '/bdemr-patient-details-update', data, (err, response)=>
      console.log response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        cbfn()


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
        fullVisitHeadline: 'Print Full Visit/Discharge Certificate'
        footerLine: 'A simple message on the bottom'
        logoDataUri: null
      billingTargetEmailAddress: ''
      nsqipTargetEmailAddress: ''
      monetaryUnit: 'BDT'
      otherSettings:
        patientSignUpDefaultPassword: '123456'

  _getSettings: ->
    list = app.db.find 'settings'
    console.log list
    if list.length is 0
      settings = @_makeSettings()
    else
      settings = list[0]
    return settings

  _saveSettings: ->
    @settings.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'settings', @settings, ({serial})=> @settings.serial is serial


  _generateRandomString: ->

    randomString = ''

    possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    i = 0
    while i < 255
      randomString += possible.charAt(Math.floor(Math.random() * possible.length))
      i++
    console.log randomString
    randomString

  createOfflinePatient: (data)->
    patient = {}

    patient =
      name : "#{data.name.first} #{data.name.middle or ''} #{data.name.last or ''}".replace "  ", " "
      serial: data.serial
      idOnServer: "Unregistered"
      source: "local"
      lastSyncedDatetimeStamp: 0
      lastModifiedDatetimeStamp: lib.datetime.mkDate lib.datetime.now()
      createdDatetimeStamp: lib.datetime.mkDate lib.datetime.now()
      createdByUserSerial: @user.serial
      email: data.phone
      phone: data.email
      address:
        line1: data.addressList[0].addressLine1
        line2: data.addressList[0].addressLine2
        postalCode: data.addressList[0].addressPostalOrZipCode
        cityOrTown: data.addressList[0].addressCityOrTown
        stateOrProvince: data.addressList[0].stateOrProvince
        country: data.addressList[0].addressCountry
      dob: data.dateOfBirth
      nIdOrSsn: "#{data.nationalIdCardNumber or ''}"
      doctorsPrivateNote: "#{data.doctorQuickNotes or ''}"
      hospitalNumber: "#{data.hospitalSerial or ''}"
      initialVisitDate: "#{data.patientInitialVisitDate or ''}"
      lastVisitDate: "#{data.lastVisitDate or ''}"
      admissionDate: "#{data.admissionDate or ''}"

    app.db.insert 'patient-list', patient


  _savePatientOfflineSignupDetails: (data) ->
    data.serial = @generateSerialForPatient()
    app.db.insert 'unregsitered-patient-details', data
    @domHost.showModalDialog "Patient Registered Successfully Offline."

    @createOfflinePatient data
    
    @_makePatientSignUp()
    @domHost.navigateToPage '#/patient-manager/unregsiterd:' + data.phone





  networkCheck: () ->
    state = if navigator.onLine then true else false
    return state

        
  _makeNameObject: (fullName)->
    if typeof fullName is 'string'

      fullName = fullName.trim()

      partArray = fullName.split('.')

      namePart = partArray.pop()

      if partArray.length is 0 
        honorifics = ''
      else
        honorifics = partArray.join('.').trim()

      partArray = (namePart.trim()).split(' ')

      nameObject = {}

      if (partArray.length <= 1)
        first = partArray[0]
      else
        first = partArray.shift()
        last = partArray.pop()
        middle = partArray.join(' ')

        if middle is ''
          middle = null
        
        if last is ''
          last = null

      if honorifics is ''
        honorifics = null

      nameObject.honorifics = honorifics
      nameObject.first = first
      nameObject.middle = middle
      nameObject.last = last
      return nameObject
    else
      return fullName


  openPolicyModalClicked: ->
    @$.policyModal.toggle()
    @policy = {}

  addPolicyButtonClicked: (e)->
    return unless @policy.number and @policy.insuranceProvider and @policy.startDate and @policy.endDate
    if @patient.policyList
      @push 'patient.policyList', @policy
    else
      @set 'patient.policyList', []
      @push 'patient.policyList', @policy
    @policy = {}
    @$.policyModal.close()
    console.log @patient

  editPolicyClicked: (e)->
    index = e.model.index
    @policy = @patient.policyList[index]
    @$.policyModal.toggle()

  deletePolicyClicked: (e)->
    index = e.model.index
    @splice 'patient.policyList', index, 1

    

  navigatedOut: ->
    # console.trace 'navigatedOut'
    @patient = null
    @isPatientValid = false
    @set "EDIT_MODE_ON", false


}
