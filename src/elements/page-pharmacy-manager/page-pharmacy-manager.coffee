
Polymer {
  is: 'page-pharmacy-manager'

  behaviors: [
    app.behaviors.dbUsing
    app.behaviors.apiCalling
    app.behaviors.translating
    app.behaviors.pageLike
  ]

  properties:
    user:
      type: Object
      value: {}

    organization:
      type: Object
      value: {}
    
    inventoryList:
      type: Array
      value: []

    inventory:
      type: Object
      value: {}

    isLoading:
      type: Boolean
      value: true

    
  _formatDate: (dateTime)->
    lib.datetime.format(dateTime, 'mmm d, yyyy')
  
  navigatedIn: ->
    @_loadUser()

    @_loadOrganization @getCurrentOrganization().idOnServer, ()=> 
      @set 'isLoading', false
      @_resetInventoryForm()
    

  _checkUserAccess: (userIdOnServer, userList)->
    found = false
    for item in userList
      if item.id is userIdOnServer
        if item.isAdmin
          found = true
          break
    
    if found then @_loadData() else @_notifyInvalidAccess()
  
  _loadData: ->  
    @_loadInventoryItems @organization.idOnServer
    @domHost.getStaticData 'pccMedicineList', (medicineCompositionList)=>
      @_loadMedicineCompositionList medicineCompositionList


  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

 _loadOrganization: (idOnServer, cbfn)->
    data = { 
      apiKey: @user.apiKey
      idList: [ idOnServer ]
    }
    @callApi '/bdemr-organization-list-organizations-by-ids', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        unless response.data.matchingOrganizationList.length is 1
          @domHost.showModalDialog "Invalid Organization"
          return
        @set 'organization', response.data.matchingOrganizationList[0]
        @_checkUserAccess @user.idOnServer, response.data.matchingOrganizationList[0].userList
        cbfn()

  _loadInventoryItems: (idOnServer)->
    @inventoryList = app.db.find 'organization-inventory', ({organizationId})=> organizationId is idOnServer
  
  
  _loadMedicineCompositionList: (medicineCompositionList)->  
    brandNameMap = {}
    for item in medicineCompositionList
      brandNameMap[item.brandName] = null
    @brandNameSourceDataList = ({text: item, value: item} for item in Object.keys brandNameMap)
  
  
  
  _resetInventoryForm: ->
    # Setting Expiry Date to One Year From Now
    d = new Date()
    d.setFullYear(d.getFullYear() + 1)
    
    inventory = {
      serial: @generateSerialForInventoryItem()
      lastModifiedDatetimeStamp: null
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      organizationId: @organization.idOnServer
      data:
        name: ""
        buyingPrice: null
        sellingPrice: null
        qty: 1
        category: 'pharmacy'
        expiryDate: lib.datetime.mkDate d
    }
    @set 'inventory', inventory


  _validateInput: (inventory)->
    return false unless inventory.data.name and inventory.data.buyingPrice and inventory.data.sellingPrice and inventory.data.qty
    return true
  
  _addToInventoryButtonClicked: ->
    return unless @_validateInput @inventory
    @inventory.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'organization-inventory', @inventory, ({serial})=> serial is @inventory.serial
    @_resetInventoryForm()
    @_loadInventoryItems @organization.idOnServer

  editInventoryItemButtonClicked: (e)->
    {item, index} = e.model
    inventory = {
      serial: item.serial
      lastModifiedDatetimeStamp: null
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: item.createdByUserSerial
      organizationId: item.organizationId
      data:
        name: item.data.name
        buyingPrice: item.data.buyingPrice
        sellingPrice: item.data.sellingPrice
        qty: item.data.qty
        expiryDate: item.data.expiryDate
    }
    @set 'inventory', inventory
  

  _notifyInvalidOrganization: ->
    @domHost.showModalDialog 'No Organization is Present. Please Select an Organization first.'

  _notifyInvalidAccess: ->
    @domHost.showModalPrompt 'You Do Not Have Access To This Page!', ()=>
      @domHost.navigateToPreviousPage()

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

}
