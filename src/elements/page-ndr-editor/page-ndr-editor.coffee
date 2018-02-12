
Polymer {

  is: 'page-ndr-editor'

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

    visitTypeIndex:
      type: Number
      notify: true
      value:-> -1


    showPhysicalActivity:
      type: String
      notify: true
      value: 'no'

    showDietaryHistory:
      type: String
      notify: true
      value: 'no'

    showCookingOil:
      type: String
      notify: true
      value: 'no'

    showPhysicalActivity2:
      type: String
      notify: true
      value: 'no'

    showDietaryHistory2:
      type: String
      notify: true
      value: 'no'

    showCookingOil2:
      type: String
      notify: true
      value: 'no'


    showInsulin:
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

    isRecordValid: 
      type: Boolean
      notify: true
      value: false


    patient:
      type: Object
      notify: true
      value: null

    organization:
      type: Object
      notify: true
      value: null

    ndr:
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

    physicalActivityObj2:
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

    otherAddiction:
      type: Object
      value: ->
        {
          type: ''
          isYes: 'yes'
          amount: ''
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

    otherTypeOfCookingOil2:
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

    otherDietItem2:
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
      value: -> ['Newly Diagnosed', 'At time of diagnosis', '1 year after Diagnosis', '5 years after Diagnosis', '10 years after Diagnosis', '15 years after Diagnosis', '20 years after Diagnosis', 'Recruitment', 'Visit 1', 'Visit 2', 'Visit 3', 'Visit 4', 'Visit 5', 'Visit 6', 'Visit 7', 'Visit 8', 'Visit 9', 'Visit 10', 'Visit 11', 'Visit 12', 'Visit 13', 'Visit 14', 'Visit 15', 'Other']

    laboratoryTestList:
      type: Array
      value: []

    complicationList:
      type: Array
      value: []

  _makeComplicationList: (cbfn)->
    @complicationList = [
      {
        name: 'Hypogycemia'
        isSelected: false
        serial: null
      }
      {
        name: 'DKA'
        isSelected: false
        serial: null
      }
      {
        name: 'HHNS'
        isSelected: false
        serial: null
      }
      {
        name: 'Retinopathy'
        isSelected: false
        serial: null
      }
      {
        name: 'Nuropathy'
        isSelected: false
        serial: null
      }
      {
        name: 'CKD/Nephropathy'
        isSelected: false
        serial: null
      }
      {
        name: 'Heart Disease'
        isSelected: false
        serial: null
      }
      
      {
        name: 'Stroke'
        isSelected: false
        serial: null
      }
      {
        name: 'PVD'
        isSelected: false
        serial: null
      }
      {
        name: 'Foot Complication'
        isSelected: false
        serial: null
      }
    ]
    cbfn()

  _makeLaboratoryTestList: (cbfn)->
    @laboratoryTestList = [
      {
        name: 'hbA1c'
        value: null
        unit: '%'
        isSelected: ''
        costType: 'free'
        inputType: 'number'
        isCustomTest: false
        serial: null
      }
      {
        name: 'FPG'
        value: null
        unit: 'mmol'
        isSelected:  ''
        costType: 'free'
        inputType: 'number'
        isCustomTest: false
        serial: null
      }
      {
        name: '2hPG'
        value: null
        unit: 'mmol'
        isSelected:  ''
        costType: 'free'
        inputType: 'number'
        isCustomTest: false
        serial: null
      }
      {
        name: 'Post Meal'
        value: null
        unit: 'mmol'
        isSelected:  ''
        costType: 'free'
        inputType: 'number'
        isCustomTest: false
        serial: null
      }
      {
        name: 'Urine Acetone'
        value: null
        unit: '+'
        isSelected:  ''
        costType: 'free'
        inputType: 'number'
        isCustomTest: false
        serial: null
      }
      {
        name: 'Urine Albumine'
        value: null
        unit: ''
        isSelected:  ''
        costType: 'free'
        inputType: 'number'
        isCustomTest: false
        serial: null
      }
      {
        name: 'S. Creatinine'
        value: null
        unit: 'mg/dl'
        isSelected:  ''
        costType: 'free'
        inputType: 'number'
        isCustomTest: false
        serial: null
      }
      {
        name: 'SGPT'
        value: null
        unit: 'Units per liter'
        isSelected:  ''
        costType: 'free'
        inputType: 'number'
        isCustomTest: false
        serial: null
      }
      {
        name: 'HB'
        value: null
        unit: '%'
        isSelected:  ''
        costType: 'free'
        inputType: 'number'
        isCustomTest: false
        serial: null
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
        serial: null
      }
      {
        name: 'CHOL'
        value: null
        unit: 'mg/dl'
        isSelected:  ''
        costType: 'free'
        inputType: 'number'
        isCustomTest: false
        serial: null
      }
      {
        name: 'LDL-C'
        value: null
        unit: 'mg/dl'
        isSelected:  ''
        costType: 'free'
        inputType: 'number'
        isCustomTest: false
        serial: null
      }
      {
        name: 'HDL-C'
        value: null
        unit: 'mg/dl'
        isSelected:  ''
        costType: 'free'
        inputType: 'number'
        isCustomTest: false
        serial: null
      }
      {
        name: 'Triglycerides'
        value: null
        unit: 'mg/dl'
        isSelected:  ''
        costType: 'free'
        inputType: 'number'
        isCustomTest: false
        serial: null
      }
    ]
    cbfn()

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


  _loadUser:(cbfn)->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]
    cbfn()

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()


  $findCreator: (creatorSerial)-> 'me'

  _computeAge: (dateString)->
    today = new Date()
    birthDate = new Date dateString
    age = today.getFullYear() - birthDate.getFullYear()
    m = today.getMonth() - birthDate.getMonth()

    if m < 0 || (m == 0 && today.getDate() < birthDate.getDate())
      age--

    return age

  getDoctorSpeciality: () ->
    unless @user.specializationList.length is 0
      return @user.specializationList[0].specializationTitle

  _makeNdr: ->
    @ndr =

      serial: null
      lastModifiedDatetimeStamp: lib.datetime.now()
      createdDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      patientSerial: @patient.serial
      doctorName: @$getFullName @user.name
      doctorSpeciality: @getDoctorSpeciality()
      data:

        visitType: null
        registeredCenter:
          name: null
          id: null
        diabeticsInfo:
          patientBookSerial: null
          duration: null
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
            value: null
            unit: 'cm'
            inputType: 'number'
          }
          {
            type: 'hip'
            name: 'Hip'
            value: null
            unit: 'cm'
            inputType: 'number'
          }
          {
            type: 'waist-hip-ratio'
            name: 'Waist Hip Ratio'
            value: null
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

        complicationList: [
          {
            name: 'Hypogycemia'
            isSelected: false
            serial: null
          }
          {
            name: 'DKA'
            isSelected: false
            serial: null
          }
          {
            name: 'HHNS'
            isSelected: false
            serial: null
          }
          {
            name: 'Retinopathy'
            isSelected: false
            serial: null
          }
          {
            name: 'Nuropathy'
            isSelected: false
            serial: null
          }
          {
            name: 'CKD/Nephropathy'
            isSelected: false
            serial: null
          }
          {
            name: 'Heart Disease'
            isSelected: false
            serial: null
          }
          
          {
            name: 'Stroke'
            isSelected: false
            serial: null
          }
          {
            name: 'PVD'
            isSelected: false
            serial: null
          }
          {
            name: 'Foot Complication'
            isSelected: false
            serial: null
          }
        ]
        associateComplicationList: [
          {
            name: 'HTN (Hypertension)'
            isSelected: false
          }
          
          {
            name: 'Gastro Complication'
            isSelected: false
          }
          
          {
            name: 'Lipid Disorder'
            isSelected: false
          }
          # {
          #   name: 'Skin Disease'
          #   isSelected: false
          # }
        ]

        physicalActivityList: []

        physicalActivityList2: []

        medicalInfo:
          drugAddictionList: [
            {
              type: 'Cigarette/Bidi'
              isYes: ''
              amount: ''
            }
            {
              type: 'Tobacco'
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

          dietaryHistoryList2: []

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

          typeOfCookingOilList2: [
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
        

  loadNdr: (identifier)->
    list = app.db.find 'ndr-records', ({serial})-> serial is identifier
    if list.length is 1
      @isRecordValid = true
      @ndr = list[0]
      @set 'EDIT_MODE_ON', true
    else
      @_notifyInvalidRecord()
      @set 'EDIT_MODE_ON', false

  computeWaistHipRatio:()->
    waist = 0
    hip = 0
    for item in @ndr.data.clinicalInfoList
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
    @domHost.showModalDialog 'Invalid/missing Patient!'

  _notifyInvalidRecord: ->
    @isRecordValid = false
    @domHost.showModalDialog 'Invalid/missing NDR Record!'


  # saveBPData: (clinicalInfoList)->
  #   bloodPressure =
  #     serial: null
  #     visitSerial: null
  #     createdByUserSerial: null
  #     createdByUserName: @user.name
  #     patientSerial: null
  #     createdDatetimeStamp: null
  #     lastModifiedDatetimeStamp: null
  #     lastSyncedDatetimeStamp: null
  #     data:
  #       systolic: ''
  #       diastolic: ''
  #       random: ''
  #       unit: 'mm Hg'
  #       flags:
  #         flagAsError: false

  #   for item in clinicalInfoList
  #     if item.type is 'sbp'
  #       bloodPressure.data.systolic = parseInt item.value
  #     else if item.type is 'dbp'
  #       bloodPressure.data.diastolic = parseInt item.value


  #   bloodPressure.serial = @generateSerialForVitals 'BP-REG'
  #   bloodPressure.lastModifiedDatetimeStamp = lib.datetime.now()
  #   bloodPressure.createdByUserSerial = @user.serial
  #   bloodPressure.patientSerial = @patient.serial
  #   bloodPressure.createdDatetimeStamp = lib.datetime.now()

  #   app.db.upsert 'patient-vitals-blood-pressure', bloodPressure, ({serial})=> bloodPressure.serial is serial

  # saveToOtherTest: (data)->
  #   otherTest =
  #     serial: @generateSerialForVitals 'OT'
  #     createdByUserSerial: @user.serial
  #     patientSerial: @patient.serial
  #     createdDatetimeStamp: lib.datetime.now()
  #     lastModifiedDatetimeStamp: lib.datetime.now()
  #     lastSyncedDatetimeStamp: 0
  #     data:
  #       date: lib.datetime.now()
  #       name: data.name
  #       institution: null
  #       result: data.value
  #       unit: data.unit
  #       attachmentSerialList: []

  #   app.db.upsert 'patient-test-other', otherTest, ({serial})=> otherTest.serial is serial

  # saveLabDataToOtherTest: (list)->
  #   for item in list
  #     if item.value
  #       @saveToOtherTest item  

  # savePatientClinicalData: (patient, cbfn)->
  #   @saveBPData patient.clinicalInfoList
  #   @saveLabDataToOtherTest patient.laboratoryTestList
  #   # @saveComplicationDataToDiagnosis patient.complicationList
  #   cbfn()

  ## Physical Activity -----------------------> start

  addPhysicalActivity: ()->
    unless @physicalActivityObj.name and @physicalActivityObj.duration
      @domHost.showToast 'Please Fill Up Name and Duration'
      return

    @push "ndr.data.physicalActivityList", @physicalActivityObj
    @makeNewPhysicalActivityObj()

  deletePhysicalActivity: (e)->
    index = e.model.index
    @splice "ndr.data.physicalActivityList", index, 1

  makeNewPhysicalActivityObj: ()->
    @physicalActivityObj =
      name: null
      duration: null
      unit: 'min/day'

  ## Physical Activity -----------------------> end


  ## Physical Activity2 -----------------------> start

  addPhysicalActivity2: ()->
    unless @physicalActivityObj2.name and @physicalActivityObj2.duration
      @domHost.showToast 'Please Fill Up Name and Duration'
      return

    @push "ndr.data.physicalActivityList2", @physicalActivityObj2
    @makeNewPhysicalActivityObj2()

  deletePhysicalActivity2: (e)->
    index = e.model.index
    @splice "ndr.data.physicalActivityList2", index, 1

  makeNewPhysicalActivityObj2: ()->
    @physicalActivityObj2 =
      name: null
      duration: null
      unit: 'min/day'

  ## Physical Activity2 -----------------------> end

  addCustomTest: ()->
    unless @customTest.name and @customTest.unit
      @domHost.showToast 'Test Name and Unit is Required!'
      return

    @push "laboratoryTestList", @customTest
    @makeNewCustomTest()

  deleteCustomTest: (e)->
    el = @locateParentNode e.target, 'PAPER-ICON-BUTTON'
    el.opened = false
    repeater = @$$ '#lab-test-list-repeater'

    index = repeater.indexForElement el

    @splice "laboratoryTestList", index, 1

  makeNewCustomTest: ()->
    @customTest =
      name: null
      value: null
      unit: null
      isSelected:  ''
      costType: 'free'
      inputType: 'number'
      isCustomTest: true
      serial: null


  addFamilyHistoryDisease: ()->
    @push "ndr.data.medicalInfo.familyHistoryList", @otherFamilyHistoryDisease
    # @set 'otherFamilyHistoryDisease.disease', ''

  addAddiction: ()->
    @push "ndr.data.medicalInfo.drugAddictionList", @otherAddiction

  addCustomComplication:()->
    @push "complicationList", {
      name: @customComplication
      isSelected: true
      serial: null
    }

  addHistoryDisease: ()->
    @push "ndr.data.medicalInfo.historyOfDeseaseList", @historyDisease
    # @set 'historyDisease.diseaseName', ''


  addCookingOil: ()->
    @push "ndr.data.medicalInfo.typeOfCookingOilList", @otherTypeOfCookingOil
    # @set 'otherTypeOfCookingOil.type', ''

  addCookingOil2: ()->
    @push "ndr.data.medicalInfo.typeOfCookingOilList2", @otherTypeOfCookingOil2
    # @set 'otherTypeOfCookingOil.type', ''

  addVaccine: ()->
    @push "ndr.data.medicalInfo.vaccinationList", @otherVaccine
    # @set 'otherVaccine.name', ''


  ## Dietary ------------------------------> start

  addDietItem: ()->
    @push "ndr.data.medicalInfo.dietaryHistoryList", @otherDietItem

  deleteDietItem: (e)->
    index = e.model.index
    @splice "ndr.data.medicalInfo.dietaryHistoryList", index, 1


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
      dailyValue = @ndr.data.medicalInfo.dietaryHistoryList[index].consumeAmount[memberIndex].value
      @set "ndr.data.medicalInfo.dietaryHistoryList.#{index}.consumeAmount.#{weeklyIndex}.value", parseInt((dailyValue * 7).toString())
      @set "ndr.data.medicalInfo.dietaryHistoryList.#{index}.consumeAmount.#{monthlyIndex}.value", parseInt((dailyValue * 30).toString())


    if memberIndex is 1
      weeklyValue = @ndr.data.medicalInfo.dietaryHistoryList[index].consumeAmount[memberIndex].value
      dailyValue = weeklyValue / 7
      @set "ndr.data.medicalInfo.dietaryHistoryList.#{index}.consumeAmount.#{dailyIndex}.value", parseInt(dailyValue.toString())
      @set "ndr.data.medicalInfo.dietaryHistoryList.#{index}.consumeAmount.#{monthlyIndex}.value", parseInt((dailyValue * 30).toString())


    if memberIndex is 2
      monthlyValue = @ndr.data.medicalInfo.dietaryHistoryList[index].consumeAmount[memberIndex].value
      dailyValue = monthlyValue / 30
      @set "ndr.data.medicalInfo.dietaryHistoryList.#{index}.consumeAmount.#{dailyIndex}.value", 0
      @set "ndr.data.medicalInfo.dietaryHistoryList.#{index}.consumeAmount.#{weeklyIndex}.value", 0


    # @ndr.data.medicalInfo.dietaryHistoryList[index].consumeAmount[weeklyIndex].value = (value * 7).toString()

    
    console.log 'list', @ndr.data.medicalInfo.dietaryHistoryList

  ## Dietary ------------------------------> end

  ## Dietary ------------------------------> start
  addDietItem2: ()->
    @push "ndr.data.medicalInfo.dietaryHistoryList2", @otherDietItem2

  deleteDietItem2: (e)->
    index = e.model.index
    @splice "ndr.data.medicalInfo.dietaryHistoryList2", index, 1


  onDietaryItemValue2: (e)->
    el = @locateParentNode e.target, 'PAPER-INPUT'
    el.opened = false
    repeater = @$$ '#dietary-list-repeater-2'
    index = repeater.indexForElement el
    memberIndex = e.model.index

    dailyIndex = 0
    weeklyIndex = 1
    monthlyIndex = 2

    if memberIndex is 0
      dailyValue = @ndr.data.medicalInfo.dietaryHistoryList2[index].consumeAmount[memberIndex].value
      @set "ndr.data.medicalInfo.dietaryHistoryList2.#{index}.consumeAmount.#{weeklyIndex}.value", parseInt((dailyValue * 7).toString())
      @set "ndr.data.medicalInfo.dietaryHistoryList2.#{index}.consumeAmount.#{monthlyIndex}.value", parseInt((dailyValue * 30).toString())


    if memberIndex is 1
      weeklyValue = @ndr.data.medicalInfo.dietaryHistoryList2[index].consumeAmount[memberIndex].value
      dailyValue = weeklyValue / 7
      @set "ndr.data.medicalInfo.dietaryHistoryList2.#{index}.consumeAmount.#{dailyIndex}.value", parseInt(dailyValue.toString())
      @set "ndr.data.medicalInfo.dietaryHistoryList2.#{index}.consumeAmount.#{monthlyIndex}.value", parseInt((dailyValue * 30).toString())


    if memberIndex is 2
      monthlyValue = @ndr.data.medicalInfo.dietaryHistoryList2[index].consumeAmount[memberIndex].value
      dailyValue = monthlyValue / 30
      @set "ndr.data.medicalInfo.dietaryHistoryList2.#{index}.consumeAmount.#{dailyIndex}.value", 0
      @set "ndr.data.medicalInfo.dietaryHistoryList2.#{index}.consumeAmount.#{weeklyIndex}.value", 0


    # @ndr.data.medicalInfo.dietaryHistoryList[index].consumeAmount[weeklyIndex].value = (value * 7).toString()

    
    console.log 'list', @ndr.data.medicalInfo.dietaryHistoryList2

  ## Dietary ------------------------------> end

  addMedicine: (e)->
    index = e.model.index
    console.log index
    path = "ndr.data.otherMedicationList.#{index}.medicineList"
    @push path , {
      name: ''
      dose: ''
      unit: ''
    }

  saveBtnPressed: ()->
    unless @ndr.data.visitType
      @domHost.showToast 'Please Fill Up Visit type First!'
      return

    if @ndr.serial is null
      @ndr.serial = @generateSerialForNdrRecord()

    console.log @ndr

    @saveNdrData @ndr, =>
      @filterAndSaveNdrLaboratoryTestList =>
        @filterAndSaveNdrComplicationList =>
          @domHost.showToast 'Record Saved!'
          @arrowBackButtonPressed()

  saveNdrData: (data, cbfn)->
    data.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'ndr-records', data, ({serial})=> data.serial is serial
    cbfn()

  # Laboratory Data a.k.a "other test" -------> start
  _makeOtherTest: (data, cbfn) ->
    otherTest =
      serial: data.serial
      visitSerial: @ndr.serial
      visitType: 'bdemr-ndr'
      createdByUserSerial: @user.serial
      patientSerial: @patient.serial
      createdDatetimeStamp: lib.datetime.now()
      lastModifiedDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      data:
        date: lib.datetime.now()
        name: data.name
        institution: @organization.name
        institutionSerial: @organization.idOnServer
        result: data.value
        unit: data.unit
        attachmentSerialList: []


    if data.serial is null
      otherTest.serial = @generateSerialForVitals 'OT'

    cbfn otherTest
    return

  _makeBloodSugar: (data, cbfn) ->
    bloodSugar =
      serial: data.serial
      visitSerial: @ndr.serial
      visitType: 'bdemr-ndr'
      createdByUserSerial: @user.serial
      patientSerial: @patient.serial
      createdDatetimeStamp: lib.datetime.now()
      lastModifiedDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      data:
        type: data.name
        value: data.value
        unit: data.unit

    if data.serial is null
      bloodSugar.serial = @generateSerialForVitals 'BS'

    cbfn bloodSugar
    return

  upsertOtherTest: (item)->
    console.log 'OTHER TEST', item
    item.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'patient-test-other', item, ({serial})=> item.serial is serial

  upsertBloodSugar: (item)->
    console.log 'BLOOD SUGAR'
    item.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'patient-test-blood-sugar', item, ({serial})=> item.serial is serial

  filterAndSaveNdrLaboratoryTestList: (cbfn)->
    list = @laboratoryTestList
    for item in list
      if item.value
        # for fpg, 2hpg and Post Meal only
        if ((item.name is 'FPG') or (item.name is '2hPG') or (item.name is 'Post Meal'))
          @_makeBloodSugar item, (test)=>
            @upsertBloodSugar test
        else
          # for other test
          @_makeOtherTest item, (test)=>
            @upsertOtherTest test

    cbfn()


  loadAndFilterNdrLaboratoryTestList: (ndrIdentifier) ->
    @_makeLaboratoryTestList =>
      otherTestList = app.db.find 'patient-test-other', ({visitSerial})=> visitSerial is ndrIdentifier
      bloodSugarList = app.db.find 'patient-test-blood-sugar', ({visitSerial})=> visitSerial is ndrIdentifier
      # list = otherTestList.concat bloodSugarList
      console.log 'otherTestList', otherTestList
      console.log 'bloodSugarList', bloodSugarList

      if otherTestList.length > 0
        for item in otherTestList
          @checkAndPushOtherTestAsLaboratoryData item

      if bloodSugarList.length > 0
        for item in bloodSugarList
          @checkAndPushBloodSugarAsLaboratoryData item

      console.log 'laboratoryTestList', @laboratoryTestList

  checkAndPushOtherTestAsLaboratoryData: (test)->
    list = @laboratoryTestList
    for item, index in list
      if test.serial

        if test.data.name is item.name
          # console.log 'test.data.name', test
          @set "laboratoryTestList.#{index}.value", test.data.result
          @set "laboratoryTestList.#{index}.serial", test.serial
          return
        else
          console.log 'test', test
          @push "laboratoryTestList", {
            name: test.data.name
            value: test.data.result
            unit: test.data.unit
            isSelected: 'yes'
            costType: 'free'
            inputType: 'number'
            isCustomTest: true
            serial: test.serial
          }
          return

  checkAndPushBloodSugarAsLaboratoryData: (test)->
    list = @laboratoryTestList
    for item, index in list
      if test.serial
        if test.data.type is item.name
          @set "laboratoryTestList.#{index}.value", test.data.value
          @set "laboratoryTestList.#{index}.serial", test.serial
          return

  # Laboratory Data a.k.a "other test" -------> end

  # Complication & Assosiate Complication Data a.k.a "Confirm Diagnosis" -------> start
  _makeConfirmDiagnosis: (data, cbfn) ->
    diagnosis =
      serial: data.serial
      visitSerial: @ndr.serial
      visitType: 'bdemr-ndr'
      createdByUserSerial: @user.serial
      patientSerial: @patient.serial
      createdDatetimeStamp: lib.datetime.now()
      lastModifiedDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      diagnosis: data.name

    if data.serial is null
      diagnosis.serial = @generateSerialForDiagnosis()

    cbfn diagnosis
    return

  upsertConfirmDiagnosis: (item)->
    console.log 'CONFIRM  DIAGNOSIS'
    item.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'visit-diagnosis', item, ({serial})=> item.serial is serial

  loadAndFilterNdrComplicationList: (ndrIdentifier) ->
    @_makeComplicationList =>
      list = app.db.find 'visit-diagnosis', ({visitSerial})=> visitSerial is ndrIdentifier

      if list.length > 0
        for item in list
          @formatDiagnosisDataToComplicationData item

  formatDiagnosisDataToComplicationData: (data)->
    list = @complicationList
    # console.log 'complicationList', @complicationList
    for item, index in list
      if data.serial
        if data.diagnosis is item.name 
          @set "complicationList.#{index}.isSelected", true
          @set "complicationList.#{index}.serial", data.serial
          return
        else
          @push "complicationList", {
            name: data.diagnosis
            isSelected: true
            serial: data.serial
            isCustom: true
          }
          return

    console.log 'complicationList', @complicationList

  filterAndSaveNdrComplicationList: (cbfn)->
    list = @complicationList
    for item in list
      if item.isSelected
        # for other test
        @_makeConfirmDiagnosis item, (test)=>
          @upsertConfirmDiagnosis test
      else
        @deleteConfirmDiagnosisDataIfAvaialble item.serial

    cbfn()

  deleteConfirmDiagnosisDataIfAvaialble: (diagnosisIdentifier)->
    if diagnosisIdentifier
      id = (app.db.find 'visit-diagnosis', ({serial})-> serial is diagnosisIdentifier)[0]._id
      app.db.remove 'visit-diagnosis', id


  # Complication & Assosiate Complication Data a.k.a "Confirm Diagnosis" -------> end


  printBtnPressed: ()->
    window.print()

  navigatedIn: ->

    params = @domHost.getPageParams()

    @organization = @getCurrentOrganization()
    unless @organization
      @domHost.navigateToPage "#/select-organization"
      
    @_loadUser =>

      if params['patient']
        @_loadPatient params['patient'], =>
          if params['record'] is 'new'
            @_makeNdr()
            @isRecordValid = true
          else
            @loadNdr params['record']

          @loadAndFilterNdrLaboratoryTestList params['record']
          @loadAndFilterNdrComplicationList params['record']
      else
        @_notifyInvalidPatient()



  addOgldDrug: (e)->
    index = e.model
    @push 'ndr.data.currentTreatment.ogld.ogldDrugList', {
      ogldDrugName: ''
      drugDosage: ''
    }
  deleteSelectedOgldDrug: (e)->
    len = @ndr.data.currentTreatment.ogld.ogldDrugList.length
    console.log 'length', length
    if len is 1
      @domHost.showToast "Sorry! Add Another field & TRY AGAIN."
    else
      index = e.model.index
      @splice 'ndr.data.currentTreatment.ogld.ogldDrugList', index, 1
      


  navigatedOut: ->
    @set 'EDIT_MODE_ON', false
    


}
