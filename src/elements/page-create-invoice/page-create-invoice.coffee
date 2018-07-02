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

    visit:
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
      type: Array
      value: -> []

    priceListCategories:
      type: Array
      value: -> []

    exclusionCriteria: Boolean

    selectedTestAdviseList:
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

  generateTransactionIdForWallet: ->
    return "#{@visit.serial}#{@invoice.serial}#{@invoice.totalAmountReceieved}#{@invoice.lastModifiedDatetimeStamp}"

  _deductServiceValueToPatient: ({patientId, outdoorBalanceToDeduct, indoorBalanceToDeduct}, cbfn)->
    data = { 
      apiKey: @user.apiKey
      targetUserId: patientId
      outdoorBalanceToDeduct: parseFloat(outdoorBalanceToDeduct)
      indoorBalanceToDeduct: parseFloat(indoorBalanceToDeduct)
      serial: @visit.serial or @invoice.serial
      type: 'visit'
      transactionId: @generateTransactionIdForWallet()
      organizationId: @organization.idOnServer
      createdByUserSerial: @user.serial
    }
    @callApi '/bdemr-uhcp--deduct-patient-service-value', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
        return cbfn(null)
      else
        @domHost.showToast 'Value Deducted Successfully'
        return cbfn(data.transactionId)

  navigatedIn: ->

    params = @domHost.getPageParams()

    if params['exclusion']
      @set 'exclusionCriteria', true

    @_loadUser()

    @_loadOrganization()
    
    if params['patient']
      @_loadPatient params['patient']
    else
      @domHost.showModalDialog 'No Patient Found for this Invoice'
      return

    unless params['visit']
      return @_notifyInvalidVisit()
    
    if params['visit'] is 'new'
      @_makeNewVisitForInvoice()
    else
      @_loadVisit(params['visit'])
    
    unless params['invoice']
      @domHost.showModalDialog 'No Invoice Found'
      return
    
    if params['invoice'] is 'new'
      @_makeNewInvoice @organization.idOnServer
      if params['testAdviseAdded']
        @selectedTestAdviseList = JSON.parse(decodeURIComponent(params['testAdviseAdded']))
        @_addSelectedTestAdviseToInvoice @invoice, @selectedTestAdviseList
    else
      @_loadInvoice params['invoice']

    # _loadPriceList from ../mixin/load-price-list-mixin.coffee
    @_loadPriceList (priceList)=>
      if priceList?.length
        @set 'priceList', priceList
        @_loadItemSearchAutoComplete priceList
        @_loadCategories priceList
      else
        @domHost.showModalDialog 'No Pricelist found, please contact your admin to setup a price list'


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

  _makeNewVisitForInvoice: ()->
    @set 'visit', {
      serial: @generateSerialForVisit()
      idOnServer: null
      source: 'local'
      recordCreatedDateTimeStamp: lib.datetime.now()
      createdDatetimeStamp: lib.datetime.now()
      lastModifiedDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      organizationId: @organization.idOnServer
      doctorsPrivateNote: ''
      patientSerial: @patient.serial
      recordType: 'doctor-visit'
      doctorName: @user.name
      hospitalName: @organization.name
      doctorSpeciality: @getDoctorSpeciality()
      prescriptionSerial: null
      doctorNotesSerial: null
      nextVisitSerial: null
      advisedTestSerial: null
      patientStaySerial: null
      invoiceSerialList: []
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
      dischargeNote: {
        dischargeType: 'OPD'
        admissionDateTimeStamp: null
        advise: null
        referredByDoctorName: null
        admittedByDoctorName: null
        admittedToOrganization: null
      }
    }
  
  _loadVisit: (visitIdentifier)->
    list = app.db.find 'doctor-visit', ({serial})-> serial is visitIdentifier
    if list.length is 1
      @set 'visit', list[0]
      return true
    else
      @_notifyInvalidVisit()
      return false
  
  _notifyInvalidVisit: ->
    @domHost.showModalDialog 'Invalid Visit Provided'

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
    @$$("#invoiceSearchInput").clear()
  
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
      visitSerial: @visit.serial
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
      lastSyncedDatetimeStamp: 0
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
    value = parseFloat e.target.value
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
      price += parseFloat (item.price * item.qty)

    @set "invoiceGrossPrice", price
    @set 'invoice.totalBilled', price

    @set 'invoice.lastModifiedDatetimeStamp', lib.datetime.now()

  _calculateDue: (total=0, paid=0, lastPaid=0)->
    paid = parseFloat paid
    paid = 0 if Number.isNaN(paid)
    if total > 0
      return total- ((paid) + (parseFloat lastPaid) )
   
      

  _calculateTotalAmtReceived: (paid=0, lastPaid=0)->
    paid = parseFloat paid
    paid = 0 if Number.isNaN(paid)
    totalAmountReceieved = (paid) + (parseFloat lastPaid)
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
      lastSyncedDatetimeStamp: 0
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
      lastSyncedDatetimeStamp: 0
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
  # ADD INVESTIGATION TO INVOICE
  # ===========================================================
  
  _mergeDuplicateTestWithHighestPrice: (list)->
    testNameMap = {}
    for item in list
      if item.name in testNames
        if item.name of testNameMap
          price = testNameMap[item.name]
          if item.price < price
            testNameMap[item.name] = item.price
        else
          testNameMap[item.name] = item.price
    return testNameMap
  
  _addSelectedTestAdviseToInvoice: (invoice, selectedTestList)->
    # Merging Duplicates with Highest Price
    # testNameMap = @_mergeDuplicateTestWithHighestPrice(@investigationPriceList.data)

    for itemPrice in @priceList
      for test in selectedTestList
        if itemPrice.name is test.data.investigationName
          @push 'invoice.data', {
            name: itemPrice.name
            visitSerial: test.visitSerial
            advisedTestSerial: test.advisedTestSerial
            investigationSerial: test.data.serial
            price: itemPrice.price?= 0
            actualCost: itemPrice.actualCost?= 0
            totalPrice: itemPrice.price?= 0
            qty: 1
            category: 'Investigation'
          }
    
    # Adding Custom Investigation
    unless selectedTestList.length is invoice.data.length
      invoiceMade = (item.name for item in invoice.data)
      for item in selectedTestList
        unless item.name in invoiceMade
          test = {
            qty: 1
            name: item.data.investigationName
            visitSerial: item.visitSerial?=""
            advisedTestSerial: item.advisedTestSerial
            investigationSerial: item.data.serial
            price: 0
            actualCost: 0
            totalPrice: 0
            category: 'investigation'
          }
          @push 'invoice.data', test
    

  # ===========================================================
  # SAVING INVOICE
  # ===========================================================

  _validateInvoice: (invoice)->
    unless invoice.data.length
      @domHost.showToast 'Add some item into invoice'
      return false
    
    return true
  
  _updateAdvisedTestForInvoice: (invoiceSerial, invoicedTestAdvisedList, cbfn)->
    updatedAdviseListWithInvoice = {
      apiKey: @user.apiKey
      apiKey: @user.apiKey
      data: []
    }
    
    for item in invoicedTestAdvisedList
      if 'advisedTestSerial' of item
        updatedAdviseListWithInvoice.data.push {
          invoiceSerial: invoiceSerial
          investigationSerial: item.investigationSerial
          advisedTestSerial: item.advisedTestSerial
        }
    
    if updatedAdviseListWithInvoice.data.length
      @callApi '/bdemr-update-test-advise-list-for-invoice', updatedAdviseListWithInvoice, (err, response)=>
        if response.hasError
          @domHost.showModalDialog response.error.message
        else
          cbfn()
    else
      cbfn()
  
  _reduceInventoryItems: (invoice)->
    for item in invoice.data
      doc = (app.db.find 'organization-price-list', ({serial})=> serial is item.serial)[0]
      if doc?.qty
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
    return unless invoiceSerial
    if @visit.invoiceSerialList and (invoiceSerial not in @visit.invoiceSerialList)
      @visit.invoiceSerialList.push invoiceSerial
    else
      @visit.invoiceSerial = invoiceSerial
    @visit.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'doctor-visit', @visit, ({serial})=> @visit.serial is serial
  
  
  _saveInvoice: (markAsCompleted)->
    return unless @_validateInvoice @invoice
    
    if markAsCompleted
      @invoice.flags.markAsCompleted = true
    
    @_addModificationHistory()
    app.db.upsert 'visit-invoice', @invoice, ({serial})=> serial is @invoice.serial
    @_updateVisit(@invoice.serial)
    
    if @selectedTestAdviseList.length
      invoicedTestAdvisedList = @invoice.data.filter (item)=> item.advisedTestSerial
      @_updateAdvisedTestForInvoice @invoice.serial, invoicedTestAdvisedList, ()=>
        @domHost.showToast 'Invoice Saved Successfully'
        @domHost.navigateToPreviousPage()
    else
      @domHost.showToast 'Invoice Saved Successfully'
      @domHost.navigateToPreviousPage()
     

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
    @_deductServiceValueToPatient {patientId: @patient.idOnServer, outdoorBalanceToDeduct: @invoice.totalAmountReceieved, indoorBalanceToDeduct: 0}, (transactionId)=> 
      if transactionId
        @invoice.transactionId = transactionId

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
    @selectedTestAdviseList - []


}