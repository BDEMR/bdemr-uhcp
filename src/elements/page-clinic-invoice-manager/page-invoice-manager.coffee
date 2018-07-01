
Polymer {
  
  is: 'page-invoice-manager'

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

    invoiceList:
      type: Array
      notify: true
      value: []

    matchingInvoiceList:
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
        'Doctor Fees'
        'Services'
        'Supplies'
        'Ambulance'
        'Package'
        'Other'
      ]

    loadingCounter:
      type: Number
      value: -> 0
      
  observers: [
    '_calculateTotalProfit(matchingInvoiceList.splices)'
    '_calculateTotalInvoiceIncome(matchingInvoiceList.splices)'
  ]

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

  _calculateTotalInvoiceIncome: ()->
    totalInvoiceIncome = 0
    for item in @matchingInvoiceList
      totalInvoiceIncome += parseInt (item.totalAmountReceieved?=0)
    @set 'totalInvoiceIncome', totalInvoiceIncome


  _calculateTotalProfit: ()->
    totalProfit = 0
    for item in @matchingInvoiceList
      totalProfit += @calculateProfit item
    @set 'totalProfit', totalProfit


  calculateDue: (billed = 0, amtReceived = 0)-> billed - amtReceived

  calculateProfit: (invoice)->
    return unless invoice
    totalCost = 0
    for item in invoice.data
      total = (item.actualCost ?= 0) * item.qty
      totalCost += total
    return invoice.totalAmountReceieved - totalCost
  
  navigatedIn: ->
    @_loadUser()
    @_loadOrganization (organizationIdentifier)=>    
      @_loadInvoice organizationIdentifier, 100, 1, ()=>
      @_loadInvestigationAutocomplete()

  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  
  _loadOrganization: (cbfn)->
    organizationId = @getCurrentOrganization().idOnServer
    unless organizationId
      @_notifyInvalidOrganization()
      return
    # Check if User belongs to this Organization
    data = { 
      apiKey: @user.apiKey
      idList: [ organizationId ]
    }

    @loadingCounter += 1

    @callApi '/bdemr-organization-list-organizations-by-ids', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
        @loadingCounter -= 1
      else
        @loadingCounter -= 1
        unless response.data.matchingOrganizationList.length is 1
          @domHost.showModalDialog "Invalid Organization"
          return
        @set 'organization', response.data.matchingOrganizationList[0]
        cbfn @organization.idOnServer
       

  _loadInvoice: (organizationIdentifier, size=100, page=1, cbfn)->
    # TODO - merge invoice from localStorage (avoiding duplicate copy)
    data =
      apiKey: @user.apiKey
      organizationId: organizationIdentifier
      size: size
      page: page

    @loadingCounter += 1
    @callApi 'bdemr-clinic-app-get-organization-invoice', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
        @loadingCounter -= 1
      else
        @loadingCounter -= 1
        invoiceItems = response.data
        @set 'invoiceList', invoiceItems
        @set 'matchingInvoiceList', invoiceItems
        cbfn()

  _notifyInvalidOrganization: ->
    @domHost.showModalDialog 'No Organization is Present. Please Select an Organization first.'

  
  invoiceCustomSearchClicked: (e)->
    startDate = new Date e.detail.startDate
    endDate = new Date e.detail.endDate
    endDate.setHours 24 + endDate.getHours()
    filteredList = (item for item in @invoiceList when ( startDate.getTime() <= (new Date item.createdDatetimeStamp).getTime() <= endDate.getTime() ))
    @set 'matchingInvoiceList', filteredList
    
  invoiceSearchClearButtonClicked: (e)->
    @set 'matchingInvoiceList', @invoiceList

  
  viewInvoiceButtonPressed: (e)->
    item = e.model.item
    @domHost.navigateToPage '#/print-invoice/invoice:' + item.serial + '/patient:' + item.patientSerial


  _loadInvestigationAutocomplete: ->
    @domHost.getStaticData 'investigationList', (investigationList)=>
      @investigationNameSourceDataList = ({text: item.name, value: item.investigationId} for item in investigationList)

                    
  searchByInvestigationPressed: ->
    return unless @investigationQuery
    searchString = @investigationQuery.toLowerCase()
    matchedList = @invoiceList.filter (invoice)->
      return invoice.data.some (invoiceItem)->
        return invoiceItem.name?.toLowerCase().indexOf(searchString) isnt -1
    @set 'matchingInvoiceList', matchedList

  resetInvestigationSearchPressed: (e)->
    @set 'matchingInvoiceList', @invoiceList

  
  invoiceSearchKeyPressed: (e)->
    if e.which is 13
      searchQuery = e.target.value
      matchedList = @invoiceList.filter (invoice)->
        return invoice.data.some (invoiceItem)->
          return invoiceItem.name?.toLowerCase().indexOf(searchQuery) isnt -1
      @set 'matchingInvoiceList', matchedList

  
  categorySelected: (e)->
    selectedIndex = e.detail.selected
    switch selectedIndex
      when 0 then @resetInvestigationSearchPressed()
      when 1 then @_filterInvoiceByCategory 'investigation'
      when 2 then @_filterInvoiceByCategory 'doctor-fees'
      when 3 then @_filterInvoiceByCategory 'services'
      when 4 then @_filterInvoiceByCategory 'supplies'
      when 5 then @_filterInvoiceByCategory 'ambulance'
      when 6 then @_filterInvoiceByCategory 'package'
      when 7 then @_filterInvoiceByCategory 'other'

  _filterInvoiceByCategory: (selectedCategory)->
    matchedList = @invoiceList.filter (invoice)->
      return invoice.data.some (invoiceItem)->
        return invoiceItem.category?.toLowerCase() is selectedCategory
    @set 'matchingInvoiceList', matchedList

    
}
