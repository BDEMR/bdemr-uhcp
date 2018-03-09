Polymer {
  is: 'page-set-unit-price'
  
  behaviors: [
    app.behaviors.dbUsing
    app.behaviors.pageLike
    app.behaviors.translating
    app.behaviors.apiCalling
  ]
  
  properties:
    user:
      type: Object
      notify: true
      value: {}
    
    isOrganizationValid: 
      type: Boolean
      notify: true
      value: false

    organization:
      type: Object
      notify: true
      value: {}
    
    setPriceView:
      type: Number
      value: -> 0

    investigationPriceList:
      type: Object
      notify: true
      value: 
        serial: null
        organizationId: null
        lastModifiedDatetimeStamp: null
        data: []
       
    doctorFeesPriceList:
      type: Object
      notify: true
      value: 
        serial: null
        organizationId: null
        lastModifiedDatetimeStamp: null

    servicePriceList:
      type: Object
      notify: true
      value: 
        serial: null
        organizationId: null
        lastModifiedDatetimeStamp: null
        data: []

    pharmacyPriceList:
      type: Object
      notify: true
      value: 
        serial: null
        organizationId: null
        lastModifiedDatetimeStamp: null
        data:
          medicinePriceList: []
          fluidPriceList: []
          transfusionPriceList: []
          customPharmacyPriceList: []
        
    packagePriceList:
      type: Object
      value:
        serial: null
        organizationId: null
        lastModifiedDatetimeStamp: null
        data: []     

    supplyPriceList:
      type: Object
      notify: true
      value: 
        serial: null
        organizationId: null
        lastModifiedDatetimeStamp: null
        data: []

    ambulancePriceList:
      type: Object
      notify: true
      value: 
        serial: null
        organizationId: null
        lastModifiedDatetimeStamp: null
        data: []

    otherPriceList:
      type: Object
      notify: true
      value: 
        serial: null
        organizationId: null
        lastModifiedDatetimeStamp: null
        data: []

    fluidTypeList:
      type: Array
      value: -> ['NS','RL','Plasmalyte','D5','D5 NS','NS with 20 mmol KCL']
    
    transfusionTypeList:
      type: Array
      value: -> ['Albumin','Voluven','Volulyte','Pentastarch','Dextran','RCC','Platelet','FFP','Cryo(Bottle)','Cryo(Unit)']
    
    customUnit:
      type: Object
      value: {}

    customCategoryEnabled:
      type: Boolean
      value: -> false

    customCategoryList:
      type: Array
      value: -> []

    InvestigationNameSourceDataList:
      type: Array
      value: -> []

    visitTypeList:
      type: Array
      value: -> ['First Visit', 'Second Visit', 'Report Analysis']

          
  attached: ()->
    # HACK - vaadin-grid element stops the navigatedIn call somehow
    @navigatedIn()
  
  navigatedIn: ->
    @_loadUser()
    params = @domHost.getPageParams()
    if params['organization']
      @_loadOrganization params['organization']
    else
      @_notifyInvalidOrganization()

  _loadData: ()->
    @_loadInvestigationPriceList @organization.idOnServer
    @_loadServicePriceList @organization.idOnServer
    @_loadDoctorFeesPriceList @organization.idOnServer
    @_loadSupplyPriceList @organization.idOnServer
    @_loadAmbulancePriceList @organization.idOnServer
    @_loadPackagePriceList @organization.idOnServer
    @_loadOtherPriceList @organization.idOnServer
    @_loadCustomCategoryList @organization.idOnServer

    @async =>
      @_loadInvestigationModalAutocomplete()

  
  saveButtonPressed: ->
    @_saveInvestigationPriceList()
    @_saveServiceChargeList()
    @_saveDoctorFeesChargeList()
    @_saveSupplyPriceList()
    @_saveAmbulanceChargePriceList()
    @_savePackageChargePriceList()
    @_saveOtherChargePriceList()

    @domHost.showToast 'Saved Successfully'

  
  # ORGANIZATION RELATED
  # ==========================================
  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]
  
  _checkUserAccess: (userIdOnServer, userList)->
    found = false
    for item in userList
      if item.id is userIdOnServer
        if item.isAdmin
          found = true
          break
    
    if found then @_loadData() else @_notifyInvalidAccess()
  
  _loadOrganization: (idOnServer)->
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
        @_checkUserAccess @user.idOnServer, response.data.matchingOrganizationList[0].userList

  _loadMemberList: ->
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      overrideWithIdList: (user.id for user in @organization.userList)
      searchString: 'N/A'
    }
    @callApi '/bdemr-organization-find-user', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @set 'memberList', response.data.matchingUserList
        console.log @memberList, @user

  _loadCustomCategoryList: (organizationIdentifier)->
    list = app.db.find 'custom-inventory-category-list', ({organizationId})-> organizationId is organizationIdentifier
    if list.length
      @set 'customCategoryList', list[0]
    else
      @set 'customCategoryList', @_makeNewCutomCategoryList organizationIdentifier
  
  _notifyInvalidOrganization: ->
    @isOrganizationValid = false
    @domHost.showModalDialog 'Invalid Organization Provided'

  _notifyInvalidAccess: ->
    @domHost.showModalPrompt 'You Do Not Have Access To This Page!', ()=>
      @domHost.navigateToPreviousPage()
  
  # MAKE UNIT CATEGORIES
  # =========================================

  _makeNewCutomCategoryList: (organizationIdentifier)->
    return {
      serial: @generateSerialCustomCategory()
      createdDatetimeStamp: lib.datetime.now()
      lastModifiedDatetimeStamp: lib.datetime.now()
      createdByUserSerial: @user.serial
      organizationId: organizationIdentifier
      data: []
    }
  

  _loadInvestigationModalAutocomplete: ->
    @domHost.getStaticData 'investigationList', (investigationList)=>
      @InvestigationNameSourceDataList = ({text: item.name, value: item.investigationId} for item in investigationList)
  
  # INVESTIGATION PRICE LIST
  # ===========================================
    
  _loadInvestigationPriceList: (organizationIdentifier)->
    # Check if User already has a Price List
    investigationPriceList = app.db.find 'investigation-price-list', ({organizationId})-> organizationId is organizationIdentifier

    if investigationPriceList.length > 0
      @investigationPriceList = investigationPriceList[0]
    else
      @_makeInvestigationListFromFile organizationIdentifier, (priceList)=>
        app.db.insert 'investigation-price-list', priceList
        @set 'investigationPriceList', priceList
        @notifyPath 'investigationPriceList.data'

  
  _makeInvestigationListFromFile: (organizationIdentifier, cbfn)->
    @domHost.getStaticData 'investigationList', (investigationList)=>

      investigationPriceList =
        serial : @generateSerialForInvestigationPriceList organizationIdentifier
        organizationId: organizationIdentifier
        lastModifiedDatetimeStamp: null
        data : []

      for item in investigationList
        investigationPriceList.data.push {
          name: item.name
          price: null
          actualCost: null
          category: 'investigation'
          investigationId: item.investigationId
        }
      
      cbfn investigationPriceList     

  _searchByName: (searchString)->
    if !searchString or (searchString.length < 2)
      return null
    else
      return (item)->
        searchString = searchString.toLowerCase()
        testName = if item.name then item.name.toLowerCase() else ''
        regex = new RegExp "\\b^#{searchString}", 'gi'
        if (testName.search regex) isnt -1 
          return true

  deleteInvestigationItem: (e)->
    @splice 'investigationPriceList.data', e.model.index, 1
    
  
  addNewInvestigationButtonClicked: (e)->
    @_invokeCustomInvestigationModal (data)->
      if data
        data.category = 'investigation'
        @unshift 'investigationPriceList.data', data
        @_saveInvestigationPriceList()
        @_addToCustomInvestigation data
        @domHost.showSuccessToast 'Data Saved'
  
  
  _saveInvestigationPriceList: ->
    @investigationPriceList.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'investigation-price-list', @investigationPriceList, ({serial})=> serial is @investigationPriceList.serial


  _addToCustomInvestigation: (data)->
    serial = @generateSerialForCustomInvestigation()
    customInvestigationObject = {
      serial: serial
      lastModifiedDatetimeStamp: lib.datetime.now()
      createdDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      visitSerial: null
      patientSerial: null
      data:
        name: data.name
        investigationId: serial
        investigationList: [
          {
            name: data.name
            referenceRange: ''
            unitList: []
          }
        ]
      }
    
    app.db.insert 'custom-investigation-list', customInvestigationObject

  _invokeCustomInvestigationModal: (cbfn)->
    @.$.addInvestigationModal.toggle()
    @modalSuccessCallBack = cbfn

  # DOCTOR FEES PRICE LIST
  # ================================================

  _loadDoctorFeesPriceList: (organizationIdentifier)->
    # Check if User already has a Price List
    doctorFeesPriceList = app.db.find 'doctor-fees-price-list', ({organizationId})-> organizationId is organizationIdentifier

    if doctorFeesPriceList.length > 0
      @doctorFeesPriceList = doctorFeesPriceList[0]
    else
      doctorFeesList = {
        serial: @generateSerialDoctorFees organizationIdentifier
        organizationId: organizationIdentifier
        lastModifiedDatetimeStamp: null
        data: []
      }
      app.db.insert 'doctor-fees-price-list', doctorFeesList
      @set 'doctorFeesPriceList', doctorFeesList

  addDoctorVisitFeeButtonPressed: ->
    @_invokeDoctorVisitFeeModal (data)->
      if data
        data.category = 'doctor-fees'
        @unshift 'doctorFeesPriceList.data', data
        @_saveDoctorFeesChargeList()
        @domHost.showSuccessToast 'Data Saved'

  _invokeDoctorVisitFeeModal: (cbfn)->
    @.$.doctorVisitModal.toggle()
    @modalSuccessCallBack = cbfn


  _saveDoctorFeesChargeList: ->
    @doctorFeesPriceList.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'doctor-fees-price-list', @doctorFeesPriceList, ({serial})=> serial is @doctorFeesPriceList.serial

  deleteDoctorFeesItem: (e)->
    @splice 'doctorFeesPriceList.data', e.model.index, 1

  # doctorVisityTypeCustomValueSet: (e)->
  #   @customUnit.type = e.detail.value
  
  # SERVICE PRICE LIST
  # =================================================
  _loadServicePriceList: (organizationIdentifier)->
    # Check if User already has a Price List
    servicePriceList = app.db.find 'service-price-list', ({organizationId})-> organizationId is organizationIdentifier

    if servicePriceList.length > 0
      @servicePriceList = servicePriceList[0]
    else
      @_makeServicePriceList organizationIdentifier, (priceList)=>
        app.db.insert 'service-price-list', priceList
        @set 'servicePriceList', priceList

  _makeServicePriceList: (organizationIdentifier, cbfn)->
    cbfn priceList = 
      serial: @generateSerialForServicePriceList organizationIdentifier
      organizationId: organizationIdentifier
      lastModifiedDatetimeStamp: null
      data: [
        {name: "Operation Theater Charge", price: null, actualCost: null, category: 'services'}
        {name: "OT First Assist Charge", price: null, actualCost: null, category: 'services'}
        {name: "OT Second Assist Charge", price: null, actualCost: null, category: 'services'}
        {name: "Nursing Service Charge", price: null, actualCost: null, category: 'services'}
        {name: "Cleaner Service Charge", price: null, actualCost: null, category: 'services'}
        {name: "Bed Service Charge", price: null, actualCost: null, category: 'services'}
        {name: "Orderly Charge", price: null, actualCost: null, category: 'services'}
        {name: "ICU Bed Charge", price: null, actualCost: null, category: 'services'}
        {name: "ICU Cabin Charge", price: null, actualCost: null, category: 'services'}
        {name: "HDU Bed Charge ", price: null, actualCost: null, category: 'services'}
        {name: "HDU Cabin Charge", price: null, actualCost: null, category: 'services'}
        {name: "Monitoring Equipment Charge", price: null, actualCost: null, category: 'services'}
        {name: "Oxygen Charge/litre", price: null, actualCost: null, category: 'services'}
        {name: "Oxygen Charge/cylinder", price: null, actualCost: null, category: 'services'}
        {name: "Intubation", price: null, actualCost: null, category: 'services'}
        {name: "Catheterization", price: null, actualCost: null, category: 'services'}
        {name: "Incubator Charge", price: null, actualCost: null, category: 'services'}
        {name: "Cannulation Charge", price: null, actualCost: null, category: 'services'}
        {name: "Ancillary Services", price: null, actualCost: null, category: 'services'}
      ]

  addCustomServiceButtonPressed: (e)->
    @_invokeCustomModal (data)->
      if data
        data.category = 'services'
        @unshift 'servicePriceList.data', data
        @_saveServiceChargeList()
        @domHost.showSuccessToast 'Data Saved'

  deleteServiceItem: (e)->
    @splice 'servicePriceList.data', e.model.index, 1

  _saveServiceChargeList: ->
    @servicePriceList.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'service-price-list', @servicePriceList, ({serial})=> serial is @servicePriceList.serial
  
  
  # SUPPLY PRICE LIST
  # =================================================
  _loadSupplyPriceList: (organizationIdentifier)->
    # Check if User already has a Price List
    supplyPriceList = app.db.find 'supply-price-list', ({organizationId})-> organizationId is organizationIdentifier
    
    if supplyPriceList.length > 0
      @supplyPriceList = supplyPriceList[0]
    else
      @_makeSupplyPriceList organizationIdentifier, (priceList)=>
        app.db.insert 'supply-price-list', priceList
        @set 'supplyPriceList', priceList

  _makeSupplyPriceList: (organizationIdentifier, cbfn)->
    cbfn priceList = 
      serial: @generateSerialForSupplyPriceList organizationIdentifier
      organizationId: organizationIdentifier
      lastModifiedDatetimeStamp: null
      data: [
        {name: "Syringes", price: null, actualCost: null, category: 'supplies'}
        {name: "Needles", price: null, actualCost: null, category: 'supplies'}
        {name: "Cannula", price: null, actualCost: null, category: 'supplies'}
        {name: "Bandage", price: null, actualCost: null, category: 'supplies'}
        {name: "Tape", price: null, actualCost: null, category: 'supplies'}         
      ]
  
  addcustomSupplyPriceButtonClicked: (e)->
    @_invokeCustomModal (data)->
      if data
        data.category = 'supplies'
        @unshift 'supplyPriceList.data', data
        @_saveSupplyPriceList()
        @domHost.showSuccessToast 'Data Saved'
  
  deleteCustomSupplyPriceItem: (e)->
    @splice 'supplyPriceList.data', e.model.index, 1
  
  _saveSupplyPriceList: ->
    @supplyPriceList.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'supply-price-list', @supplyPriceList, ({serial})=> serial is @supplyPriceList.serial
  
  # AMBULANCE PRICE LIST
  # =================================================
  _loadAmbulancePriceList: (organizationIdentifier)->
    # Check if User already has a Price List
    ambulancePriceList = app.db.find 'ambulance-price-list', ({organizationId})-> organizationId is organizationIdentifier
    
    if ambulancePriceList.length > 0
      @ambulancePriceList = ambulancePriceList[0]
    else
      @_makeAmbulancePriceList organizationIdentifier, (priceList)=>
        app.db.insert 'ambulance-price-list', priceList
        @set 'ambulancePriceList', priceList

  _makeAmbulancePriceList: (organizationIdentifier, cbfn)->
    cbfn {
      serial: @generateSerialForAmbulancePriceList organizationIdentifier
      organizationId: organizationIdentifier
      lastModifiedDatetimeStamp: null
      data: [
        {name: "One Way Conveyance", price: null, actualCost: null, category: 'ambulance'}
        {name: "Two Way Conveyance", price: null, actualCost: null, category: 'ambulance'}
        {name: "Daily Rent", price: null, actualCost: null, category: 'ambulance'}
        {name: "Per Mile Rent", price: null, actualCost: null, category: 'ambulance'}
        {name: "Gross Rent", price: null, actualCost: null, category: 'ambulance'}
        {name: "Oxygen Charge", price: null, actualCost: null, category: 'ambulance'}
        {name: "Ambulance Attendance Charge", price: null, actualCost: null, category: 'ambulance'}
      ]
    }
    
  addCustomAmbulancePriceButtonClicked: (e)->
    @_invokeCustomModal (data)->
      if data
        data.category = 'ambulance'
        @unshift 'ambulancePriceList.data', data
        @_saveAmbulanceChargePriceList()
        @domHost.showSuccessToast 'Data Saved'

  deleteCustomAmbulancePriceItem: (e)->
    @splice 'ambulancePriceList.data', e.model.index, 1
  
  _saveAmbulanceChargePriceList: ->
    @ambulancePriceList.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'ambulance-price-list', @ambulancePriceList, ({serial})=> serial is @ambulancePriceList.serial
  
  # PACKAGE PRICE LIST
  # ================================================
  _loadPackagePriceList: (organizationIdentifier)->
    # Check if User already has a Price List
    packagePriceList = app.db.find 'package-price-list', ({organizationId})-> organizationId is organizationIdentifier
    
    if packagePriceList.length > 0
      @packagePriceList = packagePriceList[0]
    else
      @_makePackagePriceList organizationIdentifier, (priceList)=>
        app.db.insert 'package-price-list', priceList
        @set 'packagePriceList', priceList

  _makePackagePriceList: (organizationIdentifier, cbfn)->
    cbfn priceList = 
      serial: @generateSerialForPackagePriceList organizationIdentifier
      organizationId: organizationIdentifier
      lastModifiedDatetimeStamp: null
      data: [
        {name: "Gall Bladder Operation Package", price: null, actualCost: null, category: 'package'}
        {name: "Appendicitis Operation Package", price: null, actualCost: null, category: 'package'}
        {name: "C/S Operation Package", price: null, actualCost: null, category: 'package'}
        {name: "Hysterectomy Operation Package", price: null, actualCost: null, category: 'package'}
        {name: "Tonsillectomy Operation Package", price: null, actualCost: null, category: 'package'}
        {name: "Health Checkup Laboratory Package", price: null, actualCost: null, category: 'package'}
        {name: "Endoscopy Package", price: null, actualCost: null, category: 'package'}      
      ]

  addCustomPackagePriceButtonClicked: (e)->
    @domHost.navigateToPage '#/set-package/organization:'+ @organization.idOnServer

  deleteCustomPackagePriceItem: (e)->
    @splice 'packagePriceList.data', e.model.index, 1
  
  _savePackageChargePriceList: ->
    @packagePriceList.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'package-price-list', @packagePriceList, ({serial})=> serial is @packagePriceList.serial
  
  
  # OTHER PRICE LIST
  # ================================================
  _loadOtherPriceList: (organizationIdentifier)->
    # Check if User already has a Price List
    otherPriceList = app.db.find 'other-price-list', ({organizationId})-> organizationId is organizationIdentifier
    
    if otherPriceList.length > 0
      @otherPriceList = otherPriceList[0]
    else
      @_makeOtherPriceList organizationIdentifier, (priceList)=>
        app.db.insert 'other-price-list', priceList
        @set 'otherPriceList', priceList

  _makeOtherPriceList: (organizationIdentifier, cbfn)->
    cbfn priceList = 
      serial: @generateSerialForOtherPriceList organizationIdentifier
      organizationId: organizationIdentifier
      lastModifiedDatetimeStamp: null
      data: []

  addOtherPriceButtonClicked: (e)->
    @customCategoryEnabled = true
    @_invokeCustomModal (data)->
      if data
        @unshift 'otherPriceList.data', data
        @customCategoryEnabled = false
        @_saveOtherChargePriceList()
        @domHost.showSuccessToast 'Data Saved'

  customCategoryValueSet: (e)->
    e.preventDefault()
    value = e.detail
    @push 'customCategoryList.data', value
    @customCategoryList.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'custom-inventory-category-list', @customCategoryList, ({serial})=> serial is @customCategoryList.serial
    @set 'customUnit.category', value
  
  deleteOtherPriceItem: (e)->
    @splice 'otherPriceList.data', e.model.index, 1

  _saveOtherChargePriceList: ->
    @otherPriceList.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'other-price-list', @otherPriceList, ({serial})=> serial is @otherPriceList.serial
  
  # Custom Modal
  # ---------------------------------------------

  _invokeCustomModal: (cbfn)->
    @.$.customUnitModal.toggle()
    @modalSuccessCallBack = cbfn

  modalClosedEvent: (e)->
    if e.detail.confirmed
      @modalSuccessCallBack @customUnit
    else
      @modalSuccessCallBack false

    @modalSuccessCallBack = null
    @customUnit = {}

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()


  navigatedOut: ->
    @set "investigationPriceLis", {
      serial: null
      organizationId: null
      lastModifiedDatetimeStamp: null
      data: []
    }
       
    @set "servicePriceList", {
      serial: null
      organizationId: null
      lastModifiedDatetimeStamp: null
      data: []
    }

    @set "doctorFeesPriceList", {
      serial: null
      organizationId: null
      lastModifiedDatetimeStamp: null
      data: []
    }

    @packagePriceList =
      serial: null
      organizationId: null
      lastModifiedDatetimeStamp: null
      data: []     

    @supplyPriceList =
      serial: null
      organizationId: null
      lastModifiedDatetimeStamp: null
      data: []

    @ambulancePriceList = 
      serial: null
      organizationId: null
      lastModifiedDatetimeStamp: null
      data: []

    @otherPriceList =
      serial: null
      organizationId: null
      lastModifiedDatetimeStamp: null
      data: []
}