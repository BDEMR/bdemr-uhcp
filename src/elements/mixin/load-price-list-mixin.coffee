unless app.behaviors.local.loadPriceListMixin
  app.behaviors.local.loadPriceListMixin = {}
app.behaviors.local.loadPriceListMixin =

  properties:

    priceList:
      type: Object
      value: -> {}


  _getLastSyncedDatetime: -> parseInt window.localStorage.getItem 'lastSyncedDatetimeStamp'
  
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

  _prepareNewItemForDB: (data)->
    return Object.assign data, {
      serial: @generateSerialForPriceListItem()
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
  
  _getPriceListFromFile: (fileName, cbfn)->
    @domHost.getStaticData fileName, (priceList)=>
      cbfn priceList

  _createNewPriceList: (organizationIdentifier, cbfn)->
    @_getPriceListFromFile 'uhcpInvoicePriceList', (priceList)=>
      priceListData = @_preparePriceListData priceList
      cbfn priceListData

  _insertItemIntoDatabase: (priceList)->
    for item in priceList
      app.db.insert 'organization-price-list', item