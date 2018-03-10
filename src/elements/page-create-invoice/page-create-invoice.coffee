Polymer {
  is: 'page-create-invoice'
  
  behaviors: [
    app.behaviors.dbUsing
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
    app.behaviors.commonComputes
  ]
  
  properties:
    user:
      type: Object
      notify: true
      value: null

    patient:
      type: Object
      notify: true
      value: null

    organization:
      type: Object
      notify: true
      value: null
    
    invoice:
      type: Object
      notify: true
      value: -> {}
        
    discountType:
      type: Number
      value: -> 1

    investigationPriceList:
      type: Object
      notify: true
      value: -> {
        serial: null
        lastModifiedDatetimeStamp: null
        data: []
      }

    servicePriceList:
      type: Object
      notify: true
      value: -> {
        serial: null
        lastModifiedDatetimeStamp: null
        data: []
      }

    supplyPriceList:
      type: Object
      notify: true
      value: -> {
        serial: null
        lastModifiedDatetimeStamp: null
        data: []
      }

    ambulancePriceList:
      type: Object
      notify: true
      value: -> {
        serial: null
        lastModifiedDatetimeStamp: null
        data: []
      }

    packagePriceList:
      type: Object
      value: -> {
        serial: null
        lastModifiedDatetimeStamp: null
        data: [] 
      }
    
    otherPriceList:
      type: Object
      notify: true
      value: -> {
        serial: null
        lastModifiedDatetimeStamp: null
        data: []
      }

    inventoryList:
      type: Object
      value: -> {
        serial: null
        lastModifiedDatetimeStamp: null
        data: []
      }

    invoiceSourceDataList:
      type: Array
      value: []

    thirdPartyUserList:
      type: Array
      value: -> []

    fluidTypeList:
      type: Array
      value: -> ['NS','RL','Plasmalyte','D5','D5 NS','NS with 20 mmol KCL']
    
    transfusionTypeList:
      type: Array
      value: -> ['Albumin','Voluven','Volulyte','Pentastarch','Dextran','RCC','Platelet','FFP','Cryo(Bottle)','Cryo(Unit)']

    invoiceCategoryList:
      type: Object
      value: -> {}

    invoiceGrossPrice:
      type: Number
      value: -> 0
    
    invoiceDiscountAmt:
      type: Number
      value: -> 0

    customUnit:
      type: Object
      value: {}

  observers: [
    'calculateTotalPrice(invoice.data.splices, invoice.discount)'
    '_calculateCommission(invoice.commission.billed, invoice.commission.percentage)'
  ]

  # UTIL
  isEmpty: (array)->
    return false if array is undefined or array is null 
    if array.length then return true else return false

  navigatedIn: ->

    params = @domHost.getPageParams()

    @_loadUser()

    @_loadOrganization()
    
    if params['patient']
      @_loadPatient params['patient']
    else
      @domHost.showModalDialog 'No Patient Found for this Invoice'
      return

    unless params['visit']
      @_notifyInvalidVisit()
      return
    else
      @_loadVisit(params['visit'])
    
    unless params['invoice']
      @domHost.showModalDialog 'No Invoice Found'
      return
    
    if params['invoice'] is 'new'
      @_makeNewInvoice @organization.idOnServer
    else
      @_loadInvoice params['invoice']


    @_loadInvestigationPriceList @organization.idOnServer
    @_loadDoctorFeesPriceList @organization.idOnServer
    @_loadServicePriceList @organization.idOnServer
    @_loadMedicineInventory @organization.idOnServer
    @_loadSupplyPriceList @organization.idOnServer
    @_loadAmbulancePriceList @organization.idOnServer
    @_loadPackagePriceList @organization.idOnServer
    @_loadOtherPriceList @organization.idOnServer
    @_loadThirdPartyUserAutocompleteList @organization.idOnServer
    @_loadInvoiceCategoryList @organization.idOnServer
    @_loadItemSearchAutoComplete()
    
  navigatedOut: ->
    @set 'invoice', {}
    @set "invoiceGrossPrice", 0
    @set "invoiceDiscountAmt",  0

  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]
  
  _loadPatient: (patientIdentifier)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier
    if list.length is 1
      @isPatientValid = true
      @patient = list[0]
    else
      @_notifyInvalidPatient()
  
  _loadOrganization: ->
    organizationList = app.db.find 'organization'
    if organizationList.length is 1
      @set 'organization', organizationList[0]
    else
      @_notifyInvalidOrganization()
  
  _loadInvoice: (invoiceIdentifier)->
    list = app.db.find 'visit-invoice', ({serial})-> serial is invoiceIdentifier
    if list.length > 0
      @set 'invoice', list[0]
      @calculateTotalPrice()
    else
      @domHost.showModalDialog 'No Invoice Found'

  _loadVisit: (visitIdentifier)->
    list = app.db.find 'doctor-visit', ({serial})-> serial is visitIdentifier
    if list.length is 1
      @visit = list[0]
      return true
    else
      @_notifyInvalidVisit()
      return false
  
  _notifyInvalidVisit: ->
    @domHost.showModalDialog 'Invalid Visit Provided'
  
  # Modal
  # ===================================
  
  modalClosedEvent: (e)->
    if e.detail.confirmed
      @modalSuccessCallBack @customUnit
    else
      @modalSuccessCallBack false
    @modalSuccessCallBack = null
    @customUnit = {}
  
  _invokeCustomModal: (cbfn)->
    @.$.customItemModal.toggle()
    @modalSuccessCallBack = cbfn
  
  addCustomItemToInvoiceButtonPressed: ->  
    @_invokeCustomModal (data)->
      if data
        data.qty = 1
        data.totalPrice = data.price
        @push 'invoice.data', data
  
  # AUTOCOMPLETE SEARCH
  # ===========================================
  
  _loadItemSearchAutoComplete: ->
    inventoryList = ({name: item.data.name, price: item.data.sellingPrice, actualCost: item.data.buyingPrice, category: 'medicine'} for item in @inventoryList)

    @_loadMedicineCompositionList (medicineSourceDataList)=>
      # Getting All Prices Together
      concatList = [].concat @investigationPriceList.data,  @servicePriceList.data, @otherPriceList.data, @packagePriceList.data, @supplyPriceList.data, @ambulancePriceList.data, inventoryList, medicineSourceDataList

      autocompleteList = ({text: item.name, value: item} for item in concatList)

      @set 'invoiceSourceDataList', autocompleteList

  invoiceItemAutocompleteSelected: (e)->
    item = e.detail.value
    item.qty = 1
    item.totalPrice = item.price
    @push 'invoice.data', item
    console.log item
    @.$.invoiceSearchInput.clear()
  
  # =============================================
  
  _loadMedicineCompositionList: (cbfn)->
    @domHost.getStaticData 'pccMedicineList', (medicineCompositionList)=>
      brandNameMap = {}
      for item in medicineCompositionList
        brandNameMap[item.brandName] = null
      brandNameSourceDataList = ({name: item, price: null, category: 'medicine', actualCost: null} for item in Object.keys brandNameMap)

      cbfn brandNameSourceDataList

  
  _loadThirdPartyUserAutocompleteList: (organizationIdentifier)->
    @thirdPartyUserList = app.db.find 'third-party-user-list', ({organizationId})-> organizationId is organizationIdentifier
    @thirdPartyUserListSourceMap = ({text: item.name, value: item.mobile} for item in @thirdPartyUserList)
  
  _loadInvoiceCategoryList: (organizationIdentifier)->
    list = app.db.find 'invoice-category-list', ({organizationId})-> organizationId is organizationIdentifier
    if list.length
      @set 'invoiceCategoryList', list[0]
    else
      @set 'invoiceCategoryList', @_makeNewInvoiceCategoryList organizationIdentifier

  
  syncPriceListButtonClicked: ->
    collector2 = new lib.util.Collector 7

    @domHost._syncOrganizationData @domHost.syncInvestigationPriceList, ()=> collector2.collect 'A1', null
    @domHost._syncOrganizationData @domHost.syncServicesPriceList, ()=> collector2.collect 'A1', null
    @domHost._syncOrganizationData @domHost.syncPharmacyPriceList, ()=> collector2.collect 'A1', null
    @domHost._syncOrganizationData @domHost.syncSupplyPriceList, ()=> collector2.collect 'A1', null
    @domHost._syncOrganizationData @domHost.syncAmbulancePriceList, ()=> collector2.collect 'A1', null
    @domHost._syncOrganizationData @domHost.syncPackageList, ()=> collector2.collect 'A1', null
    @domHost._syncOrganizationData @domHost.syncOtherPriceList, ()=> collector2.collect 'A1', null

    collector2.finally =>
      @domHost.reloadPage()
  
  _loadInvestigationPriceList: (organizationIdentifier)->
    investigationPriceList = (app.db.find 'investigation-price-list', ({organizationId})-> organizationId is organizationIdentifier)

    if investigationPriceList.length > 0
      @investigationPriceList = investigationPriceList[0]

  
  _loadDoctorFeesPriceList: (organizationIdentifier)->
    # Check if User already has a Price List
    doctorFeesPriceList = app.db.find 'doctor-fees-price-list', ({organizationId})-> organizationId is organizationIdentifier

    if doctorFeesPriceList.length > 0
      @doctorFeesPriceList = doctorFeesPriceList[0]

  
  _loadServicePriceList: (organizationIdentifier)->
    # Check if User already has a Price List
    servicePriceList = app.db.find 'service-price-list', ({organizationId})-> organizationId is organizationIdentifier
    
    if servicePriceList.length > 0
      @servicePriceList = servicePriceList[0]
    


  _loadMedicineInventory: (organizationIdentifier)->
    @domHost.getStaticData 'pccMedicineList', (medicineCompositionList)=>
      brandNameMap = {}
      for item in medicineCompositionList
        brandNameMap[item.brandName] = null
      generatedMedicineList = ({data: {name: item, buyingPrice: 0, sellingPrice: 0, qty: 1}} for item in Object.keys brandNameMap)

      inventory = app.db.find 'organization-inventory', ({organizationId})-> organizationId is organizationIdentifier
      @medicineInventory = [].concat inventory, generatedMedicineList
      

  _loadSupplyPriceList: (organizationIdentifier)->
    # Check if User already has a Price List
    supplyPriceList = app.db.find 'supply-price-list', ({organizationId})-> organizationId is organizationIdentifier
    
    if supplyPriceList.length > 0
      @supplyPriceList = supplyPriceList[0]
     

  _loadAmbulancePriceList: (organizationIdentifier)->
    # Check if User already has a Price List
    ambulancePriceList = app.db.find 'ambulance-price-list', ({organizationId})-> organizationId is organizationIdentifier
    
    if ambulancePriceList.length > 0
      @ambulancePriceList = ambulancePriceList[0]
    

  _loadPackagePriceList: (organizationIdentifier)->
    # Check if User already has a Price List
    packagePriceList = app.db.find 'package-price-list', ({organizationId})-> organizationId is organizationIdentifier
    
    if packagePriceList.length > 0
      @packagePriceList = packagePriceList[0]
    
  
  _loadOtherPriceList: (organizationIdentifier)->
    # Check if User already has a Price List
    otherPriceList = app.db.find 'other-price-list', ({organizationId})-> organizationId is organizationIdentifier
    
    if otherPriceList.length > 0
      @otherPriceList = otherPriceList[0]    
  
  
  # TOGGLE COLLAPSE
  toggleInvestigation: (e)-> @.$.investigation.toggle()
  toggleDoctorFees: (e)-> @.$.doctorFees.toggle()
  toggleServcie: (e)-> @.$.service.toggle()
  toggleSupply: (e)-> @.$.supply.toggle()
  togglePharmacy: (e)-> @.$.pharmacy.toggle()
  toggleAmbulance: (e)-> @.$.ambulance.toggle()
  togglePackage: (e)-> @.$.package.toggle()
  toggleOther: (e)-> @.$.other.toggle()

  _getNextInvoiceRef: (cbfn)->
    query =
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer

    @callApi '/bdemr-clinic-app--organization-invoice--get-next-ref-number', query, (err, response)=>
      cbfn response.data.ref
  
  _makeInvoiceRef: (refNumber)->
    organizationNamePart = @organization.name.trim().split(" ")
    string = ""
    for item in organizationNamePart
      string += item.split("")[0]
    return "#{string}-#{refNumber}"  
  
  _makeNewInvoice: ->
    invoice = {
      serial: @generateSerialForinvoice()
      referenceNumber: null
      createdDatetimeStamp: lib.datetime.now()
      createdByUserSerial: @user.serial
      patientSerial: @patient.serial
      patientName: @patient.name
      patientPhone: @patient.phone
      patientEmail: @patient.email
      organizationId: @organization.idOnServer
      organizationName: @organization.name
      modificationHistory: []
      lastModifiedDatetimeStamp: null
      category: ''
      totalBilled: 0
      paid: null
      lastPaid: null
      discount: null
      totalAmountReceieved: null
      flags:
        flagAsError: false
        markAsCompleted: false
      data: []
      commission: {}
      availableToPatient: true
    }
    @set 'invoice', invoice
  
  
  
  addToListButtonClicked: (e)->
    item = e.model.item
    item.qty = 1
    item.price = item.price?= 0
    item.totalPrice = item.price?= 0
    @push 'invoice.data', item
    console.log item


  addInventoryItemToListButtonClicked: (e)->
    doc = e.model.item.data
    item = {}
    
    if 'serial' of e.model.item
      item.inventorySerial = e.model.item.serial
    
    item.name = doc.name
    item.qty = 1
    item.actualCost = doc.buyingPrice?=0
    item.price = doc.sellingPrice?=0
    item.totalPrice = doc.sellingPrice?=0
    item.category = 'pharmacy'
    @push 'invoice.data', item

  deleteInvoiceItem: (e)->
    @splice 'invoice.data', e.model.index, 1
  
  
  discountTypeChanged: ->
    @calculateTotalPrice()

  lastPaymentChanged: (e)->
    el = e.target
    due = @_calculateDue(@invoice.totalBilled, @invoice.paid, 0)
    if el.value > due
      el.invalid = true

  
  itemUnitPriceChanged: (e)->
    value = parseInt e.target.value
    el = @locateParentNode e.target, 'PAPER-ITEM'
    repeater = @$$ '#invoice-item-repeater'
    index = repeater.indexForElement el
    model = repeater.modelForElement el
    invoiceItem = @invoice.data[index]
    invoiceItem.price = value
    invoiceItem.totalPrice = value * invoiceItem.qty
    model.set 'item.totalPrice', (value * model.item.qty)
    @splice 'invoice.data', index, 1, invoiceItem
  
  quantityChanged: (e)->
    model = e.model
    value = parseInt e.target.value

    if value > 1
      model.set 'item.qty', value
      model.set 'item.totalPrice', ( parseInt model.item.price * parseInt value)
      @calculateTotalPrice()
    else 
      model.set 'item.qty', 1
      model.set 'item.totalPrice', model.item.price
    

  calculateTotalPrice: ->
    price = 0
    discount = parseInt @invoice.discount?= 0

    for item in @invoice.data
      price += parseInt (item.price * item.qty)

    if discount
      if @discountType is 0
        discountAmt = (price * discount /100)
        priceAfterDiscount = price - discountAmt
      else
        discountAmt = discount
        priceAfterDiscount = price - discount
      
    else
      priceAfterDiscount = price

    @set "invoiceGrossPrice", price
    @set "invoiceDiscountAmt", discountAmt

    @set 'invoice.totalBilled', priceAfterDiscount

  _calculateDue: (total=0, paid=0, lastPaid=0)->
    if total > 0
      return total- ((parseInt paid) + (parseInt lastPaid) )
      

  _calculateTotalAmtReceived: (paid=0, lastPaid=0)->
    totalAmountReceieved = (parseInt paid) + (parseInt lastPaid)
    @set 'invoice.totalAmountReceieved', totalAmountReceieved
    return totalAmountReceieved

  _calculateCommission: (billed, commissionPercentage)->
    amount = (billed * commissionPercentage) / 100
    @set 'invoice.commission.amount', amount
    

  _makeNewThirdPartyUser: (name, mobile)->
    return {
      serial: @generateSerialForThirdPartyUser()
      createdDatetimeStamp: lib.datetime.now()
      lastModifiedDatetimeStamp: lib.datetime.now()
      createdByUserSerial: @user.serial
      organizationId: @organization.idOnServer
      name: name
      mobile: mobile
    }

  thirdPartyUserSelected: (e)-> 
    @set 'invoice.commission.mobile', e.detail.value

  # INVOICE CATEGORY COMBO BOX
  # =====================================================

  _makeNewInvoiceCategoryList: (organizationIdentifier)->
    return {
      serial: @generateSerialForInvoiceCategory()
      createdDatetimeStamp: lib.datetime.now()
      lastModifiedDatetimeStamp: lib.datetime.now()
      createdByUserSerial: @user.serial
      organizationId: organizationIdentifier
      data: []
    }
  
  invoiceTypeCustomValueSet: (e)->
    e.preventDefault()
    value = e.detail
    @push 'invoiceCategoryList.data', value
    @invoiceCategoryList.lastModifiedDatetimeStamp = lib.datetime.now()
    @set 'invoice.category', value

  # ===========================================================
  # SAVING INVOICE
  # ===========================================================

  _validateInvoice: (invoice)->
    unless invoice.data.length
      @domHost.showToast 'Add some item into invoice'
      return false
    unless invoice.totalAmountReceieved
      @domHost.showToast 'Please Add some amount in Paid Amount'
      return false
    return true
  
  
  _saveThirdPartyCommissionUser: (invoice)->
    thirdPartyUserName = invoice.commission.name
    thirdPartyUserMobile = invoice.commission.mobile
    thirdPartyUserFound = false
    for item in @thirdPartyUserList
      if item.name is thirdPartyUserName or item.mobile is thirdPartyUserMobile
        thirdPartyUserFound = true
        break
    unless thirdPartyUserFound
      app.db.insert 'third-party-user-list', @_makeNewThirdPartyUser(thirdPartyUserName, thirdPartyUserMobile)
  
  _reduceInventoryItems: (invoice)->
    for item in invoice.data
      if 'inventorySerial' of item
        doc = (app.db.find 'organization-inventory', ({serial})=> serial is item.inventorySerial)[0]
        console.log doc
        doc.data.qty -= item.qty
        app.db.update 'organization-inventory', doc._id, doc

  _assignInvoiceRef: (referenceNumber, cbfn)->
    if referenceNumber
      cbfn(null)
    else
      @_getNextInvoiceRef (refNumber)=>
        referenceNumber = @_makeInvoiceRef refNumber
        cbfn(referenceNumber)
  
  _addModificationHistory: ->
    modificationHistory =
      userSerial: @user.serial
      lastModifiedDatetimeStamp: lib.datetime.now()
    @invoice.modificationHistory.push modificationHistory
    @invoice.lastModifiedDatetimeStamp = lib.datetime.now()
  
  _updateVisit: (invoiceSerial)->
    if @visit.invoiceSerial is null
      @visit.invoiceSerial = invoiceSerial
    @visit.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'doctor-visit', @visit, ({serial})=> @visit.serial is serial
  
  _saveInvoice: (markAsCompleted)->
    
    return unless @_validateInvoice @invoice
    
    if markAsCompleted
      @invoice.flags.markAsCompleted = true
    
    @_addModificationHistory()
    
    # check for inventory items and reduce
    @_reduceInventoryItems @invoice

    # Save Unique Third Party Commission User
    @_saveThirdPartyCommissionUser @invoice

    # Saving Custom Invoice Category List
    app.db.upsert 'invoice-category-list', @invoiceCategoryList, ({serial})=> serial is @invoiceCategoryList.serial
    
    # Assign a referenceNumber if not present
    @_assignInvoiceRef @invoice.referenceNumber, (refNumber)=>
      @invoice.referenceNumber = refNumber if refNumber
      app.db.upsert 'visit-invoice', @invoice, ({serial})=> serial is @invoice.serial
      @domHost.showToast 'Invoice Saved Successfully'
      @_updateVisit @invoice.serial
      @domHost.navigateToPage "#/visit-editor/visit:#{@visit.serial}/patient:g"
     

  # =====================================================================


  _notifyInvalidPatient: ->
    @showModal 'Invalid Patient Provided'

  _notifyInvalidOrganization: ->
    @showModal 'No Organization is Present. Please Select an Organization first.'
  
  saveButtonPressed: ->
    @_saveInvoice()

  saveAndCompleteInvoiceButtonClicked: ->
    @_saveInvoice markAsCompleted = true

  saveInvoiceButtonClicked: ()->
    @_saveInvoice()

  _chargeWalletContextual: (context)->
    chargeDoc = {
      patientId: @patient.idOnServer
      amount: @invoice.totalAmountReceieved
      purpose: "Invoice Bill"
      organizationId: @organization.idOnServer
      context
    }

    @_chargePatientContextual chargeDoc, (err)=>
      if (err)
        @domHost.showModalDialog("Unable to charge the patient. #{err.message}")
      else
        @domHost.showModalDialog "Successfully Charged"
  
  chargeIndoorWalletButtonPressed: ->
    @_chargeWalletContextual 'indoor'

  chargeOutdoorWalletButtonPressed: ->
    @_chargeWalletContextual 'outdoor'


  getDoctorSpeciality: () ->
    unless @user.specializationList.length is 0
      return @user.specializationList[0].specializationTitle
    return 'not provided yet'
  
  
  arrowBackButtonPressed: ->
    @domHost.navigateToPreviousPage()


}