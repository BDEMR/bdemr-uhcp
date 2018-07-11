unless app.behaviors.local.loadPriceListMixin
  app.behaviors.local.loadPriceListMixin = {}
app.behaviors.local.loadPriceListMixin =

  _getLastSyncedDatetime: -> parseInt window.localStorage.getItem 'priceListLastSyncedDatetimeStamp'
  
  _loadPriceList: (cbfn)->
    
    localforage.getItem 'organization-price-list', (err, priceListFromLocalStorage)=>
      if err
        console.error err
        return cbfn()
      if priceListFromLocalStorage?.length
        cbfn priceListFromLocalStorage
      else
        window.localStorage.setItem('priceListLastSyncedDatetimeStamp',0)
        @domHost._syncPriceListOnly (errMessage)=>
          if errMessage 
            @domHost.showModalDialog(JSON.stringify errMessage) 
          else 
            @domHost.reloadPage()
    
      


      
   