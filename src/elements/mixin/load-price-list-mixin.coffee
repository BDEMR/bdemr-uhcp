unless app.behaviors.local.loadPriceListMixin
  app.behaviors.local.loadPriceListMixin = {}
app.behaviors.local.loadPriceListMixin =

  masterOrganizationId:
    type: String
    value: -> app.config.masterOrganizationId
  
  _getLastSyncedDatetime: -> parseInt window.localStorage.getItem 'lastSyncedDatetimeStamp'
  
  _insertItemIntoDatabase: (priceList)->
    app.db.__allowCommit = false;
    for item, index in priceList
      if index is priceList.length-1
        app.db.__allowCommit = true;
      app.db.insert 'organization-price-list', item
    app.db.__allowCommit = true
  
  
  _loadPriceList: (cbfn)->
    
    if @priceList.length
      return cbfn priceList
    
    query = {
      apiKey: @getCurrentUser().apiKey
      organizationId: app.config.masterOrganizationId
    }

    @callApi 'uhcp--get-organization-price-list', query, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
        cbfn()
      else
        priceList = response.data
        # @_insertItemIntoDatabase priceList
        cbfn(priceList)

  
  # _loadPriceList: (cbfn)->
    
    # lastSyncedDatetimeStamp = @_getLastSyncedDatetime()

    # unless lastSyncedDatetimeStamp
    #   return @domHost._newSync (errMessage)=> 
    #     if errMessage 
    #       return @domHost.showModalDialog(errMessage) 
    #     else 
    #       return @domHost.reloadPage()
    
    # priceListFromLocalStorage = app.db.find 'organization-price-list', ({organizationId})-> organizationId is app.config.masterOrganizationId
    
    # if priceListFromLocalStorage.length
    #   return cbfn priceListFromLocalStorage
    # else
    #   @_loadMasterOrganizationPriceList app.config.masterOrganizationId, cbfn


      
   