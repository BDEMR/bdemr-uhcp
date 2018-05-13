unless app.behaviors.local.loadPriceListMixin
  app.behaviors.local.loadPriceListMixin = {}
app.behaviors.local.loadPriceListMixin =

  properties:

    priceList:
      type: Object
      value: -> {}


  _getLastSyncedDatetime: -> parseInt window.localStorage.getItem 'lastSyncedDatetimeStamp'
  
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
  #     @domHost._syncOnlyPriceList ()=> 
  #       window.localStorage.setItem 'lastSyncedDatetimeStamp', lib.datetime.now()
  #       @domHost.reloadPage() 

  _loadPriceList: (organizationIdentifier, cbfn)->
    @_createNewPriceList (priceListFromFile)=>
      # @_insertItemIntoDatabase priceListFromFile
      @set 'priceList', priceListFromFile
      cbfn priceListFromFile

  _prepareNewItemForDB: (data)->
    data.serial = @generateSerialForPriceListItem()
    data.organizationId = @organization.idOnServer
    data.createdDatetimeStamp = lib.datetime.now()
    data.lastModifiedDatetimeStamp = lib.datetime.now()
    data.createdByUserSerial = @user.serial
    return data
    
  _preparePriceListData: (priceList)-> 
    return priceList.map (newItem)=> 
      # newItem = @_prepareNewItemForDB item
      newItem.actualCost = newItem.actualCost or newItem.price
      newItem.qty = newItem.qty or null
      return newItem
  
  _createNewPriceList: (cbfn)->
    @domHost.getStaticData 'uhcpInvoicePriceList', (priceList)=>
      priceListData = @_preparePriceListData priceList
      cbfn priceListData

  _insertItemIntoDatabase: (priceList)->
    app.db.__allowCommit = false
    for item, index in priceList
      console.log item
      if index is priceList.length-1
        app.db.__allowCommit = true
      app.db.insert 'organization-price-list', item

    app.db.__allowCommit = true