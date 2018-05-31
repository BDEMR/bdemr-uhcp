unless app.behaviors.local.loadPriceListMixin
  app.behaviors.local.loadPriceListMixin = {}
app.behaviors.local.loadPriceListMixin =

  _getLastSyncedDatetime: -> parseInt window.localStorage.getItem 'lastSyncedDatetimeStamp'
  
  # _loadPriceList: (organizationIdentifier, cbfn)->
  #   lastSyncedDatetimeStamp = @_getLastSyncedDatetime()

  #   if lastSyncedDatetimeStamp
  #     priceListFromLocalStorage = app.db.find 'organization-price-list', ({organizationId})-> organizationId is organizationIdentifier
  #     return cbfn priceListFromLocalStorage
  #   else
  #     @domHost._newSync (errMessage)=> 
  #       if errMessage
  #         @async => @domHost.showModalDialog(errMessage) 
  #       else
  #         @domHost.reloadPage()

  # Temporary Fix
  _loadPriceList: (organizationIdentifier, cbfn)->
    @domHost.getStaticData 'uhcpInvoicePriceList', (priceList)=>
      priceListData = priceList.map (item)=> 
        item.actualCost = item.actualCost or item.price or null
        item.qty = item.qty or null
        return item
      cbfn priceListData