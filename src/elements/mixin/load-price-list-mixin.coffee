unless app.behaviors.local.loadPriceListMixin
  app.behaviors.local.loadPriceListMixin = {}
app.behaviors.local.loadPriceListMixin =

  _getLastSyncedDatetime: -> parseInt window.localStorage.getItem 'priceListLastSyncedDatetimeStamp'
  
  _loadPriceList: (cbfn)->
    
    localforage.getItem 'organization-price-list'
    .then (priceListFromLocalStorage)=>
      if priceListFromLocalStorage?.length
        cbfn priceListFromLocalStorage
        Promise.resolve()
      else
        window.localStorage.setItem('priceListLastSyncedDatetimeStamp',0)
        @domHost._syncPriceListOnly (errMessage)=>
          if errMessage 
            @domHost.showModalDialog(JSON.stringify errMessage) 
          else 
            @domHost.reloadPage()
          Promise.resolve()
        
    .catch (err)=>
      console.error err
      return cbfn()


      
   