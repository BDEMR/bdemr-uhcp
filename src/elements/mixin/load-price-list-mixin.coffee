unless app.behaviors.local.loadPriceListMixin
  app.behaviors.local.loadPriceListMixin = {}
app.behaviors.local.loadPriceListMixin =

  masterOrganizationId:
    type: String
    value: -> app.config.masterOrganizationId
  
  _getLastSyncedDatetime: -> parseInt window.localStorage.getItem 'priceListLastSyncedDatetimeStamp'
  
  
  # _loadPriceList: (cbfn)->
  #   @domHost.toggleModalLoader 'Downloading Price List'
  #   query = {
  #     apiKey: @getCurrentUser().apiKey
  #     organizationId: app.config.masterOrganizationId
  #   }

  #   @callApi 'uhcp--get-organization-price-list', query, (err, response)=>
  #     @domHost.toggleModalLoader()
      
  #     if response.hasError
  #       @domHost.showModalDialog response.error.message
  #       cbfn()
  #     else
  #       priceList = response.data
  #       # @_insertItemIntoDatabase priceList
  #       cbfn(priceList)

  
  _loadPriceList: (cbfn)->
    
    lastSyncedDatetimeStamp = @_getLastSyncedDatetime()

    unless lastSyncedDatetimeStamp
      return @domHost._syncPriceListOnly (errMessage)=> 
        if errMessage 
          return @domHost.showModalDialog(JSON.stringify errMessage) 
        else 
          return @domHost.reloadPage()
    
    localforage.getItem('organization-price-list')
    .then (priceListFromLocalStorage)=>
      if priceListFromLocalStorage?.length
        @set 'priceList', priceListFromLocalStorage
        return cbfn priceListFromLocalStorage
    .catch (err)=>
      console.error err


      
   