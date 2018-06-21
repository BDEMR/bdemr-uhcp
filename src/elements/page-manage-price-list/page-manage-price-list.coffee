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
      value: -> @_makeCustomItem()

    loading:
      type: Boolean
      value: -> false

  observers: [
    'updatePriceList(priceListForSelectedCategory.splices)'
  ]

  
  # attached: ()->
  #   # HACK - vaadin-grid element stops the navigatedIn call somehow
  #   @navigatedIn()
  
  navigatedIn: ->
    
    @_loadUser()
    
    params = @domHost.getPageParams()

    unless @_checkOrganizationAccess params['organization']
      return @_notifyInvalidOrganization()

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

  # Prepare Price List Data
  # ======================================
  
  _prepareNewItemForDB: (data)->
    return Object.assign data, {
      serial: @generateSerialForPriceListItem(@organization.idOnServer)
      organizationId: @organization.idOnServer
      createdDatetimeStamp: lib.datetime.now()
      lastModifiedDatetimeStamp: lib.datetime.now()
      createdByUserSerial: @user.serial
    }
  
  _preparePriceListData: (priceList)->
    priceList.map (item)=> 
      newItem = @_prepareNewItemForDB item
      newItem.actualCost = newItem.actualCost or item.price
      newItem.qty = newItem.qty or null
      return newItem
  

  _createNewPriceList: (organizationIdentifier, cbfn)->
    
    @domHost.getStaticData 'uhcpInvoicePriceList', (priceList)=>
      priceListData = @_preparePriceListData priceList
      cbfn priceListData

  _insertItemIntoDatabase: (priceList)->
    app.db.__allowCommit = false;
    for item, index in priceList
      if index is priceList.length-1
        app.db.__allowCommit = true;
      app.db.insert 'organization-price-list', item
    app.db.__allowCommit = true;

  # Prepare Price List Data End
  # ======================================


  _getCategoriesFromPriceListData: (priceListData)->
    categoryMap = priceListData.reduce ((obj, item)=>
      obj[item.category] = null
      return obj
    ), {}
    return Object.keys categoryMap
  
  _loadPriceList: (organizationIdentifier, cbfn)->
    lastSyncedDatetimeStamp = @_getLastSyncedDatetime()
    
    if lastSyncedDatetimeStamp
      priceListFromLocalStorage = app.db.find 'organization-price-list', ({organizationId})-> organizationId is organizationIdentifier
      if priceListFromLocalStorage.length
        @set 'priceList', priceListFromLocalStorage
        return cbfn priceListFromLocalStorage
      else 
        @_createNewPriceList organizationIdentifier, (priceListFromFile)=>
          @_insertItemIntoDatabase priceListFromFile
          @set 'priceList', priceListFromFile
          return cbfn priceListFromFile
    else
      @domHost._newSync (errMessage)=> 
        if errMessage 
          @async => @domHost.showModalDialog(errMessage) 
        else 
          @domHost.reloadPage()

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

  
  addNewItemToPriceList: (newItem)->
    @push 'priceList', newItem
    if (@priceListCategories.indexOf newItem.category) is -1
      @_loadCategories @priceList
      selectedCategoryIndex = @priceListCategories.length-1
      @async => @$$("#categoryTabs").selectIndex selectedCategoryIndex
    currentlySelectedCategoryTabIndex = @$$("#categoryTabs").selected
    @async => @showPriceListForSelectedCategory(currentlySelectedCategoryTabIndex)
    if newItem.category is 'Investigation'
      @_addToCustomInvestigation newItem
    app.db.insert 'organization-price-list', newItem

  removeItemFromPriceList: (removedItem)->
    indexOnPriceList = @priceList.findIndex (item)=> item.serial is removedItem.serial
    @splice "priceList", indexOnPriceList, 1
    x = app.db.remove 'organization-price-list', removedItem._id
    app.db.insert 'organization-price-list--deleted', {serial: removedItem.serial}
    unless @priceListForSelectedCategory.length
      @_loadCategories @priceList
      @async => @$$("#categoryTabs").selectIndex(0)
      @async => @showPriceListForSelectedCategory 0
    

  _validateCustomItem: (data)->
    return unless typeof data is 'object'
    unless data.name
      @domHost.showWarningToast 'Name is required'
      return false
    unless data.price
      @domHost.showWarningToast 'Price is required'
      return false
    unless data.category
      @domHost.showWarningToast 'Category is required'
      return false
    return true

  _makeCustomItem: (obj = {})->
    return Object.assign {
      name: ''
      price: null
      actualCost: null
      qty: null
      category: ''
      subCategory: ''
    }, obj 
  
  # Events
  # =================================
  updatePriceList: (changeRecord)->
    if changeRecord
      changeRecord.indexSplices.forEach (change)=>
        # removing items
        change.removed.forEach (removedItem)=>
          console.log removedItem
          @removeItemFromPriceList removedItem
        # adding new items
        for i in [0...change.addedCount]
          index = change.index + i
          newItem = change.object[index]
          @addNewItemToPriceList newItem


  actualCostChanged: (e)->
    item = e.model.item
    item.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'organization-price-list', item, ({serial})=> serial is item.serial

  priceChanged: (e)->
    item = e.model.item
    item.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'organization-price-list', item, ({serial})=> serial is item.serial
  
  categorySelected: (e)->
    selectedIndex = e.detail.selected
    @async ()=>
      @showPriceListForSelectedCategory selectedIndex

  deleteItemPressed: (e)->
    @domHost.showModalPrompt 'Are you sure to delete this item', (answer)=>
      if answer
        index = @priceListForSelectedCategory.findIndex (item)=> item.serial is e.model.item.serial
        @splice 'priceListForSelectedCategory', index, 1

  saveButtonPressed: -> @domHost.showSuccessToast 'Data Saved'

  addNewItemModalOpen: -> @.$.customItemModal.toggle()
  
  addNewItemAndClosePressed: ->
    data = @get 'customItem'
    valid = @_validateCustomItem data
    if valid
      newItem = @_prepareNewItemForDB data
      @unshift 'priceListForSelectedCategory', newItem
      @$$("#customItemModal").toggle()
      @set 'customItem', {}
      @domHost.showSuccessToast 'Item Added and Saved'
        
  addNextItemPressed: ()->
    data = @get 'customItem'
    valid = @_validateCustomItem data
    if valid
      newItem = @_prepareNewItemForDB data
      @addNewItemToPriceList newItem
      @set 'customItem', @_makeCustomItem {
        category: data.category
        subCategory: data.subCategory
      }
      @domHost.showSuccessToast 'Item Added and Saved'
      

    
  _checkOrganizationAccess: (organizationIdentifier)->
    if organizationIdentifier is app.config.masterOrganizationId and @getCurrentOrganization().idOnServer is app.config.masterOrganizationId
      return true
    else
      return false
      


}
      