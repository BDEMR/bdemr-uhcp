
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

    dmStatusList:
      type: Array
      value: -> ['New patient/diabetes', '<1 year/diabetes', '<1-5 year', '6-10 years', '11-15 years', '16-20 years', '>20 years']

    typeOfTreatmentList:
      type: Array
      value: ->
        [
          {
            label: 'Diet'
            value: 'Diet'
          }
          {
            label: 'Diet & OGLD'
            value: 'Diet & OGLD'
          }
          {
            label: 'Diet, OGLD & insulin'
            value: 'Diet, OGLD & insulin'
          }
          {
            label: 'Insulin only'
            value: 'Insulin only'
          }
          {
            label: 'Other'
            value: 'Other'
          }
        ]

    insulinTypeList:
      type: Array
      value: ->
        [
          {
            label: 'Bolus (Mealtime Insulin)'
            value: 'Bolus (Mealtime Insulin)'
          }
          {
            label: 'Premix'
            value: 'Premix'
          }
          {
            label: 'Split Mix'
            value: 'Split Mix'
          }
          {
            label: 'Basal & Bolus'
            value: 'Basal & Bolus'
          }
          {
            label: 'Basal Plus'
            value: 'Basal Plus'
          }
          {
            label: 'Basal Only'
            value: 'Basal Only'
          }
        ]

    basalDrugList:
      type: Array
      value: ->
        [
          {
            label: 'Insulatard 100 IU Vial'
            value: 'Insulatard 100 IU Vial'
          }
          {
            label: 'Insulatard Penfill'
            value: 'Insulatard Penfill'
          }
          {
            label: 'Levemir'
            value: 'Levemir'
          }
          {
            label: 'Tresiba'
            value: 'Tresiba'
          }
          {
            label: 'Victoza'
            value: 'Victoza'
          }
          {
            label: 'Insulatard Flexpen'
            value: 'Insulatard Flexpen'
          }
        ]

    bolusDrugList:
      type: Array
      value: ->
        [
          {
            label: 'Actrapid Penfill'
            value: 'Actrapid Penfill'
          }
          {
            label: 'NovoRapid FlexPen'
            value: 'NovoRapid FlexPen'
          }
          {
            label: 'NovoRapid Penfill'
            value: 'NovoRapid Penfill'
          }
          {
            label: 'Actrapid 100 IU Vial'
            value: 'Actrapid 100 IU Vial'
          }
          {
            label: 'Actrapid FlexPen-Humean Insulin'
            value: 'Actrapid FlexPen-Humean Insulin'
          }

        ]

    premixDrugList:
      type: Array
      value:
        [
          {
            label: 'Mixtard 30 100 IU Vial'
            value: 'Mixtard 30 100 IU Vial'
          }
          {
            label: 'Mixtard 30 Penfill'
            value: 'Mixtard 30 Penfill'
          }
          {
            label: 'Mixtard 50 Penfill'
            value: 'Mixtard 50 Penfill'
          }
          {
            label: 'NovoMix 30 FlexPen'
            value: 'NovoMix 30 FlexPen'
          }
          {
            label: 'Ryzodeg'
            value: 'Ryzodeg'
          }
          {
            label: 'NovoMix 30 Penfill'
            value: 'NovoMix 30 Penfill'
          }
          {
            label: 'Mixtard 30 FlexPen'
            value: 'Mixtard 30 FlexPen'
          }
        ]

    otherInsulinDrugList:
      type: Array
      value: -> ['Maxsuline N', 'Maxsuline 50/50', 'Maxsuline R', 'Maxsuline 30/70', 'Vibrenta', 'Glycet Mix', 'Ansulin N', 'Ansulin 50/50', 'Ansulin R', 'Ansulin 30/70', 'DIASULIN N', 'DIASULIN-50/50', 'DIASULIN-R', 'DIASULIN-30/70', 'GLARINE', 'ACILOG', 'ACILOG MIX', 'INSULET N', 'ISULET 50/50', 'INSULET-R', 'INSULET 30/70', 'INSULET GN', 'INSULET ASP', 'INSULET ASP MIX', 'INSUL N', 'INSUL-50/50', 'INSUL R', 'INSUL 30/70', 'INSUL GLARGINE', 'INSUL LISPRO', 'HUMULIN N', 'HUMULIN-R', 'HUMULIN 70/30', 'HUMALOG-MIX 25', 'HUMALOG-MIX-50', 'HUMALOG-KWIKPEN', 'INSUMAN-COMB', 'INSUMAN-BASAL', 'INSUMAN-RAPID', 'LANTUS', 'APIDRA', 'Actrapid FlexPen']

    waistHipRatio:
      type: Number
      value: 0
      notify: true

    professionList:
      type: Array
      value: -> ['Govt. employee', 'Non Govt. employye', 'Self employed', 'Student', 'House wife', 'Retired', 'Unemployed', 'Others']

    expenditureList:
      type: Array
      value: -> ['bellow 10,000', '10,000-20,000', '20,000-30,000', '30,000-40,000', '40,000-50,000', '50,000 & Above']

    maritalStatusList:
      type: Array
      value: -> ['Married', 'Unmarried', 'Divorced', 'Widowed', 'Widower', 'Separated']

    educationTypeList:
      type: Array
      value: -> ['No Education', 'Primary', 'Secondary', 'College', 'Undergraduate', 'Post-Graduate']

    ecgTypeList:
      type: Array
      value: -> ['RBBB', 'LBBB', 'LVH', 'MI']

    physicalActivityPreList:
      type: Array
      value: -> ['Aerobic dance', 'Walking', 'Running', 'Cycling', 'Treadmill', 'Stair climbing', 'Swimming', 'Jogging', 'Other', 'none']

    physicalActivityObj:
      type: Object
      value: -> {
        name: null
        duration: null
        unit: 'min/day'
      }

    foodItemPreList:
      type: Array
      value: -> ['Rice', 'Ruti', 'Chapati', 'Fish', 'Meat', 'Green Vegetable', 'Fruits', 'Soft drinks', 'Table Salt', 'Sweets', 'Fast Foods', 'Ghee/butter', 'Hotel Food']

    customTest:
      type: Object
      value: {}

    customComplication:
      type: String
      value: null

    otherFamilyHistoryDisease:
      type: Object
      value: ->
        {
          disease: ''
          value: 'yes'
        }

    historyDisease:
      type: Object
      value: ->
        {
          disease: ''
          value: 'yes'
        }

    otherTypeOfCookingOil:
      type: Object
      value: ->
        {
          type: ''
          isYes: 'yes'
          amount: ''
          unit: 'Litres'
          duration: 'Month'
        }

    otherDietItem:
      type: Object
      value: ->
        {
          type: ''
          consumeAmount: [
            {
              time: 'daily'
              value: null
              unit: ''
            }
            {
              time: 'weekly'
              value: null
              unit: ''
            }
            {
              time: 'monthly'
              value: null
              unit: ''
            }
          ]
        }

    antiHTNList:
      type: Array
      value: -> ['BB (Beta Blocker)', 'CCB (Calcium Channel Blocker)', 'ACE-1 (Angiotensin-converting Enzyme Inhibitors)', 'ARB (Angiotensis Receptor Blocker', 'α - Blocker', 'Diuretics', '2 Drugs', '3 Drugs', 'Other']

    antiLipidsList:
      type: Array
      value: -> ['Statin', 'Fibrate', 'Ezetimibe', 'Others']

    visitTypeList:
      type: Array
      value: -> ['At time of diagnosis', 'At 5 years of diagnosis', 'After 5 years of diagnosis', 'Recruitment', 'Visit 1', 'Visit 2', 'Visit 3', 'Visit 4', 'Visit 5', 'Visit 6', 'Visit 7', 'Visit 8', 'Visit 9', 'Visit 10', 'Visit 11', 'Visit 12', 'Visit 13', 'Visit 14', 'Visit 15', 'Other']


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
    params = @domHost.getPageParams()

    if @patient.serial is null or params['patient'] is 'new'
      @patient.serial = @generateSerialForPatient()

    @patient.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'patient-list', @patient, ({serial})=> @patient.serial is serial
    @domHost.showToast 'Patient Saved'
    @domHost.__patientView__oneTimeSearchFilter = @patient.serial
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

      belongOrganizationList: [
        {
          organizationId: null
          patientIdbyOrganization: null
        }
      ]

      diabeticRecord:

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
            isSelected: ''
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


  onDivisionChange: (e)->
    @set 'districtIndex', -1
    districtList = @divisionList[@divisionIndex].districtList
    lib.util.delay 5, ()=>
      @set 'districtList', districtList

  computeWaistHipRatio:()->
    waist = 0
    hip = 0
    for item in @patient.diabeticRecord.clinicalInfoList
      if item.type is 'waist'
        waist = parseInt item.value
      else if item.type is 'hip'
        console.log 'hip', item
        hip = parseInt item.value

    @waistHipRatio = waist/hip


  _loadPatient: (patientIdentifier, cbfn)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier
    if list.length is 1
      @isPatientValid = true
      patient = list[0]
      patient.name = @$getFullName patient.name
      @patient = patient

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


  saveBPData: (clinicalInfoList)->
    bloodPressure =
      serial: null
      visitSerial: null
      createdByUserSerial: null
      patientSerial: null
      createdDatetimeStamp: null
      lastModifiedDatetimeStamp: null
      lastSyncedDatetimeStamp: null
      data:
        systolic: ''
        diastolic: ''
        random: ''
        unit: 'mm Hg'
        flags:
          flagAsError: false

    for item in clinicalInfoList
      if item.type is 'sbp'
        bloodPressure.data.systolic = parseInt item.value
      else if item.type is 'dbp'
        bloodPressure.data.diastolic = parseInt item.value


    bloodPressure.serial = @generateSerialForVitals 'BP-REG'
    bloodPressure.lastModifiedDatetimeStamp = lib.datetime.now()
    bloodPressure.createdByUserSerial = @user.serial
    bloodPressure.patientSerial = @patient.serial
    bloodPressure.createdDatetimeStamp = lib.datetime.now()

    app.db.upsert 'patient-vitals-blood-pressure', bloodPressure, ({serial})=> bloodPressure.serial is serial

  saveToOtherTest: (data)->
    otherTest =
      serial: @generateSerialForVitals 'OT'
      createdByUserSerial: @user.serial
      patientSerial: @patient.serial
      createdDatetimeStamp: lib.datetime.now()
      lastModifiedDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      data:
        date: lib.datetime.mkDate()
        name: data.name
        institution: null
        result: data.value
        unit: data.unit
        attachmentSerialList: []

    app.db.upsert 'patient-test-other', otherTest, ({serial})=> otherTest.serial is serial

  saveLabDataToOtherTest: (laboratoryTestList)->
    for item in laboratoryTestList
      if item.value
        @saveToOtherTest item  


  savePatientClinicalData: (patient, cbfn)->
    @saveBPData patient.clinicalInfoList
    @saveLabDataToOtherTest patient.laboratoryTestList
    # @saveComplicationDataToDiagnosis patient.complicationList
    cbfn()

  addPhysicalActivity: ()->
    unless @physicalActivityObj.name and @physicalActivityObj.duration
      @domHost.showToast 'Please Fill Up Name and Duration'
      return

    @push "patient.diabeticRecord.physicalActivityList", @physicalActivityObj
    @makeNewPhysicalActivityObj()

  deletePhysicalActivity: (e)->
    index = e.model.index
    @splice "patient.diabeticRecord.physicalActivityList", index, 1

  makeNewPhysicalActivityObj: ()->
    @physicalActivityObj =
      name: null
      duration: null
      unit: 'min/day'

  addCustomTest: ()->
    unless @customTest.name and @physicalActivityObj.unit
      @domHost.showToast 'Test Name and Unit is Required!'
      return

    @push "patient.diabeticRecord.laboratoryTestList", @customTest
    @makeNewCustomTest()

  deleteCustomTest: (e)->
    el = @locateParentNode e.target, 'PAPER-ICON-BUTTON'
    el.opened = false
    repeater = @$$ '#lab-test-list-repeater'

    index = repeater.indexForElement el

    @splice "patient.diabeticRecord.laboratoryTestList", index, 1

  makeNewCustomTest: ()->
    @customTest =
      name: null
      value: null
      unit: ''
      isSelected:  ''
      costType: 'free'
      inputType: 'number'
      isCustomTest: true


  addFamilyHistoryDisease: ()->
    @push "patient.diabeticRecord.medicalInfo.familyHistoryList", @otherFamilyHistoryDisease
    # @set 'otherFamilyHistoryDisease.disease', ''

  addCustomComplication:()->
    @push "patient.diabeticRecord.complicationList", {
      name: @customComplication
      isSelected: true
    }

  addHistoryDisease: ()->
    @push "patient.diabeticRecord.medicalInfo.historyOfDeseaseList", @historyDisease
    # @set 'historyDisease.diseaseName', ''


  addCookingOil: ()->
    @push "patient.diabeticRecord.medicalInfo.typeOfCookingOilList", @otherTypeOfCookingOil
    # @set 'otherTypeOfCookingOil.type', ''

  addVaccine: ()->
    @push "patient.diabeticRecord.medicalInfo.vaccinationList", @otherVaccine
    # @set 'otherVaccine.name', ''

  addDietItem: ()->
    @push "patient.diabeticRecord.medicalInfo.dietaryHistoryList", @otherDietItem

  deleteDietItem: (e)->
    index = e.model.index
    @splice "patient.diabeticRecord.medicalInfo.dietaryHistoryList", index, 1


  onDietaryItemValue: (e)->
    el = @locateParentNode e.target, 'PAPER-INPUT'
    el.opened = false
    repeater = @$$ '#dietary-list-repeater'
    index = repeater.indexForElement el
    memberIndex = e.model.index

    dailyIndex = 0
    weeklyIndex = 1
    monthlyIndex = 2

    if memberIndex is 0
      dailyValue = @patient.diabeticRecord.medicalInfo.dietaryHistoryList[index].consumeAmount[memberIndex].value
      @set "patient.diabeticRecord.medicalInfo.dietaryHistoryList.#{index}.consumeAmount.#{weeklyIndex}.value", parseInt((dailyValue * 7).toString())
      @set "patient.diabeticRecord.medicalInfo.dietaryHistoryList.#{index}.consumeAmount.#{monthlyIndex}.value", parseInt((dailyValue * 30).toString())


    if memberIndex is 1
      weeklyValue = @patient.diabeticRecord.medicalInfo.dietaryHistoryList[index].consumeAmount[memberIndex].value
      dailyValue = weeklyValue / 7
      @set "patient.diabeticRecord.medicalInfo.dietaryHistoryList.#{index}.consumeAmount.#{dailyIndex}.value", parseInt(dailyValue.toString())
      @set "patient.diabeticRecord.medicalInfo.dietaryHistoryList.#{index}.consumeAmount.#{monthlyIndex}.value", parseInt((dailyValue * 30).toString())


    if memberIndex is 2
      monthlyValue = @patient.diabeticRecord.medicalInfo.dietaryHistoryList[index].consumeAmount[memberIndex].value
      dailyValue = monthlyValue / 30
      @set "patient.diabeticRecord.medicalInfo.dietaryHistoryList.#{index}.consumeAmount.#{dailyIndex}.value", 0
      @set "patient.diabeticRecord.medicalInfo.dietaryHistoryList.#{index}.consumeAmount.#{weeklyIndex}.value", 0


    # @patient.diabeticRecord.medicalInfo.dietaryHistoryList[index].consumeAmount[weeklyIndex].value = (value * 7).toString()

    
    console.log 'list', @patient.diabeticRecord.medicalInfo.dietaryHistoryList

  addMedicine: (e)->
    index = e.model.index
    console.log index
    path = "patient.diabeticRecord.otherMedicationList.#{index}.medicineList"
    @push path , {
      name: ''
      dose: ''
      unit: ''
    }

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

    @makeNewCustomTest()

    # otherInsulinDrugList = []
    # for item in @otherInsulinDrugList
    #   otherInsulinDrugList.push {label: item, value: item}

  # _filterSlectedArrayItemForCheckbox: (list)->
  #   modifiedList = []
  #   for item in list
  #     if item.isSelected
  #       modifiedList.push item
  #   return modifiedList

  # _filterSlectedArrayItemForInput: (list)->
  #   modifiedList = []
  #   for item in list
  #     if !((item.value is null) or (item.value is ''))
  #       modifiedList.push item
  #   return modifiedList

  addOgldDrug: (e)->
    index = e.model
    @push 'patient.diabeticRecord.currentTreatment.ogld.ogldDrugList', {
      ogldDrugName: ''
      drugDosage: ''
    }
  deleteSelectedOgldDrug: (e)->
    len = @patient.diabeticRecord.currentTreatment.ogld.ogldDrugList.length
    console.log 'length', length
    if len is 1
      @domHost.showToast "Sorry! Add Another field & TRY AGAIN."
    else
      index = e.model.index
      @splice 'patient.diabeticRecord.currentTreatment.ogld.ogldDrugList', index, 1
      
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


  _callBDEMRPatientDetailsUpdateApi: (patient) ->

    data =
      patient: patient
      apiKey: @user.apiKey

    @callApi '/bdemr-birdem-patient-details-update', data, (err, response)=>
      console.log response
      if response.hasError
        @domHost.showModalDialog response.error.message
        return
      else
        @arrowBackButtonPressed()
        return


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


    

    

  navigatedOut: ->
    # console.trace 'navigatedOut'
    @patient = null
    @isPatientValid = false
    @set "EDIT_MODE_ON", false


}
