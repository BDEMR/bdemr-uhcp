Polymer {
  is: 'page-manage-price-list'
  
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

    organization:
      type: Object
      notify: true
      value: {}

    selectedCategoryViewIndex:
      type: Number
      value: -> 0

    priceListForSelectedCategory:
      type: Array
      value: -> []

    priceList:
      type: Object
      value: -> {}

    priceListCategories:
      type: Array
      value: -> []

    customItem:
      type: Object
      value: -> {}

    loading:
      type: Boolean
      value: -> false

  
  # attached: ()->
  #   # HACK - vaadin-grid element stops the navigatedIn call somehow
  #   @navigatedIn()
  
  navigatedIn: ->
    
    @_loadUser()
    
    params = @domHost.getPageParams()

    unless params['organization']
      @_notifyInvalidOrganization()
      return
    
    @loading = true
    @_loadOrganization params['organization'], (organization)=>
      @set 'organization', organization
      @_checkUserAccess @user.idOnServer, organization.userList, (hasAccess)=>
        if hasAccess 
          @_loadPriceList organization.idOnServer, (priceListData)=>
            @loading = false
            @_loadCategories priceListData
            @showPriceListForSelectedCategory 0
            # hack otherwise can't find the element
            @async =>
              @$$("#categoryTabs").selectIndex(0)
            
        else 
          @_notifyInvalidAccess()
          @loading = false
      

  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]
  
  _checkUserAccess: (userIdOnServer, userList, cbfn)->
    user = item for item in userList when item.id is userIdOnServer
    cbfn user.isAdmin
    
  _loadOrganization: (idOnServer, cbfn)->
    data = { 
      apiKey: @user.apiKey
      idList: [ idOnServer ]
    }
    @callApi '/bdemr-organization-list-organizations-by-ids', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
        @loading = false
      else
        unless response.data.matchingOrganizationList.length is 1
          @domHost.showModalDialog "Invalid Organization"
          return
        cbfn response.data.matchingOrganizationList[0]
        
  _notifyInvalidOrganization: ->
    @isOrganizationValid = false
    @domHost.showModalDialog 'Invalid Organization Provided'

  _notifyInvalidAccess: ->
    @domHost.showModalPrompt 'You Do Not Have Access To This Page!', ()=>


  _getLastSyncedDatetime: -> parseInt window.localStorage.getItem 'lastSyncedDatetimeStamp'

  
  _preparePriceListData: (priceList)->
    return priceList.map (item)=>
      return Object.assign item, {
        serial: @generateSerialForPriceListItem()
        organizationId: @organization.idOnServer
        createdDatetimeStamp: lib.datetime.now()
        lastModifiedDatetimeStamp: lib.datetime.now()
        createdByUserSerial: @user.serial
        actualCost: item.actualCost or item.price
      }
  
  _getPriceListFromFile: (fileName, cbfn)->
    @domHost.getStaticData fileName, (priceList)=>
      cbfn priceList

  _getCategoriesFromPriceListData: (priceListData)->
    categoryMap = priceListData.reduce ((obj, item)=>
      obj[item.category] = null
      return obj
    ), {}
    return Object.keys categoryMap

  _createNewPriceList: (organizationIdentifier, cbfn)->
    @_getPriceListFromFile 'uhcpInvoicePriceList', (priceList)=>
      priceListData = @_preparePriceListData priceList
      cbfn priceListData

  _insertItemIntoDatabase: (priceList)->
    for item in priceList
      app.db.insert 'organization-price-list', item


  _loadPriceList: (organizationIdentifier, cbfn)->
    lastSyncedDatetimeStamp = @_getLastSyncedDatetime()
    
    if lastSyncedDatetimeStamp
      priceListFromLocalStorage = app.db.find 'organization-price-list', ({organizationId})-> organizationId is organizationIdentifier
      if priceListFromLocalStorage.length
        @set 'priceList', priceListFromLocalStorage
        cbfn priceListFromLocalStorage
      else 
        @_createNewPriceList organizationIdentifier, (priceListFromFile)=>
          @_insertItemIntoDatabase priceListFromFile
          @set 'priceList', priceListFromFile
          cbfn priceListFromFile
    else
      @domHost._sync()

  _loadCategories: (priceListData)->
    priceListCategories = @_getCategoriesFromPriceListData priceListData
    @set 'priceListCategories', priceListCategories

  
  showPriceListForSelectedCategory: (selectedIndex)->
    selectedCategoryName = @priceListCategories[selectedIndex]
    priceListForSelectedCategory = @priceList.filter (item)-> item.category is selectedCategoryName
    @set 'priceListForSelectedCategory', priceListForSelectedCategory


  # Add Investigation to Custom List for use in other place
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


  # Events
  # =================================
  actualCostChanged: (e)->
    item = e.model.item
    app.db.upsert 'organization-price-list', item, ({serial})=> serial is item.serial

  priceChanged: (e)->
    item = e.model.item
    app.db.upsert 'organization-price-list', item, ({serial})=> serial is item.serial
  
  categorySelected: (e)->
    selectedIndex = e.detail.selected
    @async ()=>
      @showPriceListForSelectedCategory selectedIndex

  deleteItemPressed: (e)->
    @domHost.showModalPrompt 'Are you sure to delete this item', (answer)=>
      if answer
        {item, index} = e.model
        @splice 'priceListForSelectedCategory', index, 1
        indexOnPriceList = @priceList.findIndex (priceItem)=> item.serial is priceItem.serial
        @splice "priceList", indexOnPriceList, 1
        app.db.remove 'organization-price-list', item._id
        app.db.insert 'organization-price-list--deleted', {serial: item.serial}

  saveButtonPressed: ->
    @domHost.showSuccessToast 'Data Saved'

  addNewItemPressed: (e)->
    @_invokeCustomModal (data)->
      if data
        newItem = Object.assign {
          serial: @generateSerialForPriceListItem()
          organizationId: @organization.idOnServer
          createdDatetimeStamp: lib.datetime.now()
          lastModifiedDatetimeStamp: lib.datetime.now()
          createdByUserSerial: @user.serial
        }, data
        app.db.insert 'organization-price-list', newItem
        @push 'priceList', newItem
        if (@priceListCategories.indexOf newItem.category) is -1
          @_loadCategories @priceList
        if data.category is 'Investigation'
          @_addToCustomInvestigation data
  

  # Add Custom Item Modal Code
  # ==========================

  _invokeCustomModal: (cbfn)->
    @.$.customItemModal.toggle()
    @modalSuccessCallBack = cbfn

  modalClosedEvent: (e)->
    if e.detail.confirmed
      @modalSuccessCallBack @customItem
    else
      @modalSuccessCallBack false
    @modalSuccessCallBack = null
    @customItem = {}

    
  
      


}
      