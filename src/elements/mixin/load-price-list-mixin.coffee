unless app.behaviors.local.loadPriceListMixin
  app.behaviors.local.loadPriceListMixin = {}
app.behaviors.local.loadPriceListMixin =

  _getLastSyncedDatetime: -> parseInt window.localStorage.getItem 'priceListLastSyncedDatetimeStamp'
  
  _loadPriceList: (cbfn)->
    
    lastSyncedDatetimeStamp = @_getLastSyncedDatetime()

    unless lastSyncedDatetimeStamp
      return @domHost._syncPriceListOnly (errMessage)=> 
        if errMessage 
          return @domHost.showModalDialog(JSON.stringify errMessage) 
        else 
          return @domHost.reloadPage()
    
    localforage.getItem 'organization-price-list'
    .then (priceListFromLocalStorage)=>
      if priceListFromLocalStorage?.length
        return cbfn priceListFromLocalStorage
    .catch (err)=>
      console.error err
      return cbfn()


      
   