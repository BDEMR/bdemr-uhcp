
Polymer {
  
  is: 'page-invoice-report'

  behaviors: [ 
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
    app.behaviors.commonComputes
    app.behaviors.dbUsing
  ]

  properties:

    user:
      type: Object
      value: {}
    
    organization:
      type: Object
      value: {}

    childOrganizationList: {
      type: Array
      notify: true
      value: []
    }
    
    dateCreatedFrom: String
    dateCreatedTo: String
    selectedGender: String
    selectedOrganizationId: String

    invoiceReportList:
      type: Array
      notify: true
      value: []

    matchingInvoiceReportList:
      type: Array
      notify: true
      value: []

    totalInvoiceIncome:
      type: Number
      value: 0

    totalProfit:
      type: Number
      value: 0

    investigationNameSourceDataList:
      type: Array
      value: -> []

    categoryList:
      type: Array
      value: -> [
        'All'
        'Investigation'
        'Medicine'
      ]

    loadingCounter:
      type: Number
      value: -> 0
      
  observers: [
    # '_calculateTotalProfit(matchingInvoiceReportList.splices)'
    '_calculateTotalInvoiceIncome(matchingInvoiceReportList.splices)'
  ]

  _sortByDate: (a, b)->
    if a.createdDatetimeStamp < b.createdDatetimeStamp
      return 1
    if a.createdDatetimeStamp > b.createdDatetimeStamp
      return -1
  
  _formatDateTime: (dateTime)->
    lib.datetime.format( dateTime, 'mmm d, yyyy')
  
  $isAdmin: (userId, userList)->
    for user in userList
      if userId is user.id
        return user.isAdmin
        break
    return false

  getBoolean: (data)-> if data then true else false

  _calculateTotalInvoiceIncome: ()->
    totalInvoiceIncome = 0
    for item in @matchingInvoiceReportList
      totalInvoiceIncome += parseInt (item.totalAmountReceieved?=0)
    @set 'totalInvoiceIncome', totalInvoiceIncome


  _calculateTotalProfit: ()->
    totalProfit = 0
    for item in @matchingInvoiceReportList
      totalProfit += @calculateProfit item
    @set 'totalProfit', totalProfit


  $calculateDue: (billed = 0, amtReceived = 0)-> billed - amtReceived

  calculateProfit: (invoice)->
    return unless invoice
    totalCost = 0
    for item in invoice.data
      total = (item.actualCost ?= 0) * item.qty
      totalCost += total
    return invoice.totalAmountReceieved - totalCost
  
  navigatedIn: ->
    @_loadUser()
    @_loadOrganization()
      

  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  
  _loadOrganization: ()->
    organizationList = app.db.find 'organization'
    if organizationList.length is 1
      @set 'organization', organizationList[0]
      @_loadChildOrganizationList @organization.idOnServer

  organizationSelected: (e)->
    organizationId = e.detail.value;
    this.set('selectedOrganizationId', organizationId)
  
  _loadChildOrganizationList: (organizationIdentifier)-> 
    this.loading = true
    query = {
      apiKey: this.user.apiKey
      organizationId: organizationIdentifier
    }
    this.callApi '/bdemr--get-child-organization-list', query, (err, response) => 
      this.loading = false;
      organizationList = response.data
      if organizationList.length
        mappedValue = organizationList.map (item) => 
          return { label: item.name, value: item._id }
        mappedValue.unshift({ label: 'All', value: '' })
        this.set('childOrganizationList', mappedValue)
      else
        this.domHost.showToast('No Child Organization Found')

  _loadInvoice: (organizationIdentifier, size=100, page=1, cbfn)->
    # TODO - merge invoice from localStorage (avoiding duplicate copy)
    query = {
      apiKey: @user.apiKey
      organizationIdList: []
      size
      page
      searchParameters: {
        searchString: @searchString
        dateCreatedFrom: @dateCreatedFrom?=""
        dateCreatedTo: @dateCreatedTo?=""
      }
    }

    # search parent+child when selecting all
    if !this.selectedOrganizationId
      organizationIdList = this.childOrganizationList.map (item) => item.value
      organizationIdList.splice(0, 1, this.organization.idOnServer)
      query.organizationIdList = organizationIdList
    else 
      query.organizationIdList = [this.selectedOrganizationId]
    
    
    @loadingCounter++
    @callApi 'uhcp--get-organization-invoice-report', query, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
        @loadingCounter -= 1
      else
        @loadingCounter -= 1
        invoiceItems = response.data
        console.log invoiceItems
        @set 'invoiceReportList', invoiceItems
        @set 'matchingInvoiceReportList', invoiceItems
        cbfn() if cbfn

  _notifyInvalidOrganization: ->
    @domHost.showModalDialog 'No Organization is Present. Please Select an Organization first.'

  
  searchButtonClicked: ->
    @_loadInvoice()
  
  viewInvoiceButtonPressed: (e)->
    item = e.model.item
    @domHost.navigateToPage '#/print-invoice/invoice:' + item.serial + '/visit:' + item.visitSerial + '/patient:' + item.patientSerial



    
}
