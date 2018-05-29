Polymer {
  is: 'page-create-invoice'
  
  behaviors: [
    app.behaviors.dbUsing
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
    app.behaviors.commonComputes
    app.behaviors.local.loadPriceListMixin
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

    priceList:
      type: Object
      value: -> {}

    priceListCategories:
      type: Array
      value: -> []

  observers: [
    'calculateTotalPrice(invoice.data.splices, invoice.discount)'
    # '_calculateCommission(invoice.commission.billed, invoice.commission.percentage)'
  ]

  # UTIL
  isEmpty: (array)->
    return false if array is undefined or array is null 
    if array.length then return true else return false

  _getPatientServiceBalance: (patientId, cbfn)->
    data = {
      patientId: patientId
      apiKey: @user.apiKey
    }
    @callApi '/bdemr-uhcp--get-patient-service-value', data, (err, response)=>
      if response.hasError
        @domHost.showToast response.error.message
      else
        cbfn response.data

  _deductServiceValueToPatient: ({patientId, outdoorBalanceToDeduct, indoorBalanceToDeduct}, cbfn)->
    @_getPatientServiceBalance patientId, ({outdoorBalance, indoorBalance})=>
      newOutdoorBalance = outdoorBalance - outdoorBalanceToDeduct
      newIndoorBalance = indoorBalance - indoorBalanceToDeduct
      if newOutdoorBalance < 0
        @domHost.showModalDialog 'Do not have sufficient OPD Balance'
        return cbfn(err=true)
      if newIndoorBalance < 0
        @domHost.showModalDialog 'Do not have sufficient IPD Balance'
        return cbfn(err=true)

      data = { 
        apiKey: @user.apiKey
        targetUserId: patientId
        outdoorBalance: parseInt(newOutdoorBalance)
        indoorBalance: parseInt(newIndoorBalance)
      }
      @callApi '/bdemr-uhcp--add-service-value-to-patient', data, (err, response)=>
        if response.hasError
          @domHost.showModalDialog response.error.message
          return cbfn(err=true)
        else
          @domHost.showToast 'Value Deducted Successfully'
          return cbfn()

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

    @_loadInvoiceCategoryList @organization.idOnServer

    @_loadPriceList @organization.idOnServer, (priceListData)=>
      @_loadItemSearchAutoComplete priceListData
      @_loadCategories priceListData

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

  # _getLastSyncedDatetime: -> parseInt window.localStorage.getItem 'lastSyncedDatetimeStamp'
  
  # _loadPriceList: (organizationIdentifier, cbfn)->
  #   lastSyncedDatetimeStamp = @_getLastSyncedDatetime()
    
  #   if lastSyncedDatetimeStamp
  #     priceListFromLocalStorage = app.db.find 'organization-price-list', ({organizationId})-> organizationId is organizationIdentifier
  #     if priceListFromLocalStorage.length
  #       @set 'priceList', priceListFromLocalStorage
  #       cbfn priceListFromLocalStorage
  #     else 
  #       @_createNewPriceList organizationIdentifier, (priceListFromFile)=>
  #         @_insertItemIntoDatabase priceListFromFile
  #         @set 'priceList', priceListFromFile
  #         cbfn priceListFromFile
  #   else
  #     @domHost._sync()

  _getCategoriesFromPriceListData: (priceListData)->
    categoryMap = priceListData.reduce ((obj, item)=>
      obj[item.category] = null
      return obj
    ), {}
    return Object.keys categoryMap
  
  _loadCategories: (priceListData)->
    priceListCategories = @_getCategoriesFromPriceListData priceListData
    @set 'priceListCategories', priceListCategories

  getDataForCategory: (categoryName)-> @priceList.filter (item)-> item.category is categoryName
  
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
        data.category = 'custom'
        data.qty = 1
        data.totalPrice = data.price
        @push 'invoice.data', data
  
  # AUTOCOMPLETE SEARCH
  # ===========================================
  
  _loadItemSearchAutoComplete: (priceListData)->
    @invoiceAutoCompleteSourceDataList = priceListData.map (item)=> return { text: item.name, value: item }

  invoiceItemAutocompleteSelected: (e)->
    item = e.detail.value
    item.qty = 1
    item.totalPrice = item.price
    @push 'invoice.data', item
    console.log item
    @.$.invoiceSearchInput.clear()
  
  # =============================================
  
  _loadThirdPartyUserAutocompleteList: (organizationIdentifier)->
    @thirdPartyUserList = app.db.find 'third-party-user-list', ({organizationId})-> organizationId is organizationIdentifier
    @thirdPartyUserListSourceMap = ({text: item.name, value: item.mobile} for item in @thirdPartyUserList)
  
  _loadInvoiceCategoryList: (organizationIdentifier)->
    list = app.db.find 'invoice-category-list', ({organizationId})-> organizationId is organizationIdentifier
    if list.length
      @set 'invoiceCategoryList', list[0]
    else
      @set 'invoiceCategoryList', @_makeNewInvoiceCategoryList organizationIdentifier

  # _loadMedicineInventory: (organizationIdentifier)->
  #   @domHost.getStaticData 'pccMedicineList', (medicineCompositionList)=>
  #     brandNameMap = {}
  #     for item in medicineCompositionList
  #       brandNameMap[item.brandName] = null
  #     generatedMedicineList = ({data: {name: item, actualCost: 0, price: 0, qty: 1, category: '', subCategory: ''}} for item in Object.keys brandNameMap)

  #     inventory = app.db.find 'organization-inventory', ({organizationId})-> organizationId is organizationIdentifier
  #     @medicineInventory = [].concat inventory, generatedMedicineList
      

  # TOGGLE COLLAPSE
  convertCategoryNameToId: (categoryName)-> categoryName.toLowerCase().split(" ").join("")

  toggleCollapseClicked: (e)->
    categoryName = @convertCategoryNameToId e.model.categoryName
    @$$("##{categoryName}").toggle()

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
    # item.totalPrice = item.price?= 0
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

  $calculateItemTotalPrice: (price=0, qty=1)-> return qty * price

  itemUnitPriceChanged: (e)->
    value = parseInt e.target.value
    el = @locateParentNode e.target, 'TR'
    repeater = @$$ '#invoice-item-repeater'
    index = repeater.indexForElement el
    model = repeater.modelForElement el
    invoiceItem = @invoice.data[index]
    invoiceItem.price = value
    invoiceItem.totalPrice = value * invoiceItem.qty
    model.set 'item.price', value
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

    for item in @invoice.data
      price += parseInt (item.price * item.qty)

    @set "invoiceGrossPrice", price
    @set 'invoice.totalBilled', price

  _calculateDue: (total=0, paid=0, lastPaid=0)->
    paid = parseInt paid
    paid = 0 if Number.isNaN(paid)
    if total > 0
      return total- ((paid) + (parseInt lastPaid) )
   
      

  _calculateTotalAmtReceived: (paid=0, lastPaid=0)->
    paid = parseInt paid
    paid = 0 if Number.isNaN(paid)
    totalAmountReceieved = (paid) + (parseInt lastPaid)
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
  
  _reduceInventoryItems: (invoice)->
    for item in invoice.data
      doc = (app.db.find 'organization-price-list', ({serial})=> serial is item.serial)[0]
      if doc.qty
        doc.qty -= item.qty
        app.db.update 'organization-price-list', doc._id, doc

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

    # Saving Custom Invoice Category List
    app.db.upsert 'invoice-category-list', @invoiceCategoryList, ({serial})=> serial is @invoiceCategoryList.serial
    
    # Assign a referenceNumber if not present
    @_assignInvoiceRef @invoice.referenceNumber, (refNumber)=>
      @invoice.referenceNumber = refNumber if refNumber
      app.db.upsert 'visit-invoice', @invoice, ({serial})=> serial is @invoice.serial
      @domHost.showToast 'Invoice Saved Successfully'
      @_updateVisit @invoice.serial
      @domHost.navigateToPage "#/visit-editor/visit:#{@visit.serial}/patient:#{@patient.serial}"
     

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


  chargeOutdoorWalletButtonPressed: ->
    @_deductServiceValueToPatient {patientId: @patient.idOnServer, outdoorBalanceToDeduct: @invoice.totalBilled, indoorBalanceToDeduct: 0}, ()=> console.log 'deduction successful'

  getDoctorSpeciality: () ->
    unless @user.specializationList.length is 0
      return @user.specializationList[0].specializationTitle
    return 'not provided yet'
  
  
  arrowBackButtonPressed: ->
    @domHost.navigateToPreviousPage()

  navigatedOut: ->
    @set 'invoice', {}
    @set "invoiceGrossPrice", 0
    @set "invoiceDiscountAmt",  0


}