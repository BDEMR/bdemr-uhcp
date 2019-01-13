
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
      computed: '_calculateTotalInvoiceIncome(matchingInvoiceReportList)'

    totalInvoiceBilled:
      type: Number
      computed: '_computedTotalInvoiceBilled(matchingInvoiceReportList)'
    
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

    showOnlyDues:
      type: Boolean
      value: false
      observer: '_showOnlyDuesChcked'

    loadingCounter:
      type: Number
      value: -> 0
      
  

  _sortByDate: (a, b)->
    if a.createdDatetimeStamp < b.createdDatetimeStamp
      return 1
    if a.createdDatetimeStamp > b.createdDatetimeStamp
      return -1
  
  $isAdmin: (userId, userList)->
    for user in userList
      if userId is user.id
        return user.isAdmin
        break
    return false

  getBoolean: (data)-> if data then true else false

  _calculateTotalInvoiceIncome: (matchingInvoiceReportList)->
    totalInvoiceIncome = 0
    for item in matchingInvoiceReportList
      totalInvoiceIncome += parseInt (item.totalAmountReceieved?=0)
    return totalInvoiceIncome


  _computedTotalInvoiceBilled: (matchingInvoiceReportList)->
    totalInvoiceBilled = 0
    for item in matchingInvoiceReportList
      totalInvoiceBilled += parseInt (item.totalBilled?=0)
    return totalInvoiceBilled
    
  _calculateTotalProfit: ()->
    totalProfit = 0
    for item in @matchingInvoiceReportList
      totalProfit += @calculateProfit item
    @set 'totalProfit', totalProfit


  $calculateDue: (billed = 0, amtReceived = 0)-> @$toTwoDecimalPlace (billed - amtReceived)

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
        organizationSelectorComboBox = this.$.invoiceOrganizationSelector
        organizationSelectorComboBox.items = [{ label: this.organization.name, value: this.organization.idOnServer }]
        organizationSelectorComboBox.value = this.organization.idOnServer
        # this.domHost.showToast('No Child Organization Found')

  _loadInvoice: (organizationIdentifier, size=100, page=1, cbfn)->
    @set 'invoiceReportList', []
    @set 'matchingInvoiceReportList', []
    
    query = {
      apiKey: @user.apiKey
      organizationIdList: []
      size
      page
      searchParameters: {
        employeeIdOrPhone: @employeeIdOrPhone
        doctorPhone: @doctorPhone
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


  filterByDateClicked: (e)->
    startDate = new Date e.detail.startDate
    startDate.setHours(0,0,0,0)
    endDate = new Date e.detail.endDate
    endDate.setHours(23,59,59,999)
    @set 'dateCreatedFrom', (startDate.getTime())
    @set 'dateCreatedTo', (endDate.getTime())

  filterByDateClearButtonClicked: ->
    @dateCreatedFrom = 0
    @dateCreatedTo = 0

  _showOnlyDuesChcked: (value)->
    if value
      duesOnlyInvoices = @matchingInvoiceReportList.filter (item)=> @$calculateDue(item.totalBilled, item.totalAmountReceieved) > 0
      @set 'matchingInvoiceReportList', duesOnlyInvoices
    else
      @set 'matchingInvoiceReportList', @invoiceReportList
        
  resetButtonClicked: -> @domHost.reloadPage()

  navigatedOut: ->
    @employeeIdOrPhone = ''
    @doctorPhone = ''
    @dateCreatedFrom = ''
    @dateCreatedTo  = ''

  

  _prepareJsonData:(rawReport)->
    return rawReport.map (item) =>
      return {
        'Visit Serial': item.visitSerial,
        'Invoice Serial': item.serial
        'Date': this.$formatDateTime(item.createdDatetimeStamp),
        'EmployeeId': if item.patientInfo then item.patientInfo.employeeId else '',
        'Name': if item.patientInfo then item.patientInfo.name else '',
        'Invoice Items': if item.data.length then item.data.map (i)-> i.name else "",
        'Total Billed': item.totalBilled,
        'Total Received': item.totalAmountReceieved,
        'Due': @$calculateDue(item.totalBilled, item.totalAmountReceieved)
      }
    
  downloadCsv:(csv)->
    exportedFilenmae = "uhcp-invoice-export-#{Date.now()}.csv"
    blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' })
    link = document.createElement("a")
    url = URL.createObjectURL(blob)
    link.setAttribute("href", url)
    link.setAttribute("download", exportedFilenmae);
    link.style.visibility = 'hidden'
    link.target = '_blank'
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)


  exportButtonClicked:->
    return this.domHost.showModalDialog('Search for a Report First') unless this.matchingInvoiceReportList.length
    preppedData = this._prepareJsonData(this.matchingInvoiceReportList);
    csvString = Papa.unparse(preppedData);
    this.downloadCsv(csvString)

    
}
