unless app.behaviors.local.invoiceMixin
  app.behaviors.local.invoiceMixin = {}
app.behaviors.local.invoiceMixin =

  properties:

    invoice:
      type: Object
      value: -> {}

  observers: [
    'calculateTotalPrice(invoice.data.splices)'
  ]


  _makeNewInvoice: (visitSerial)->
    invoice = {
      serial: @generateSerialForinvoice()
      visitSerial: visitSerial
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
  
  
  _reduceInventoryItems: (invoice)->
    for item in invoice.data
      continue if item.category is 'custom'
      doc = (app.db.find 'organization-price-list', ({serial})=> serial is item.serial)[0]
      if doc?.qty
        doc.qty -= item.qty
        app.db.update 'organization-price-list', doc._id, doc

  _addModificationHistory: ->
    modificationHistory =
      userSerial: @user.serial
      lastModifiedDatetimeStamp: lib.datetime.now()
    @invoice.modificationHistory.push modificationHistory
    @invoice.lastModifiedDatetimeStamp = lib.datetime.now()
  
  _updateVisit: (invoiceSerial)->
    params = @domHost.getPageParams()
    if params['visit'] is 'new'
      @visit.serial = @generateSerialForVisit()
    unless invoiceSerial in @visit.invoiceSerialList
      @visit.invoiceSerialList.push invoiceSerial
    @visit.lastModifiedDatetimeStamp = lib.datetime.now()
  
  _saveInvoice: (markAsCompleted)->

    if markAsCompleted
      @invoice.flags.markAsCompleted = true
    
    @invoice.paid = @invoice.totalBilled
    @invoice.totalAmountReceieved = @invoice.totalBilled
    
    @_addModificationHistory()
    # @domHost.showToast 'Invoice Saved Successfully'
    @_updateVisit @invoice.serial

  
  itemUnitPriceChanged: (e)->
    value = parseFloat e.target.value
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
    
  deleteInvoiceItem: (e)-> 
    @splice 'invoice.data', e.model.index, 1
    @_saveInvoice()

  calculateTotalPrice: ->
    return unless Object.keys(@invoice).length
    unless @invoice.data.length
      @set 'invoice.totalBilled', 0
      return
    price = @invoice.data.reduce (total, item)->
      return total + (parseFloat (item.price * (item.qty or 1)))
    , 0
    @set 'invoice.totalBilled', price