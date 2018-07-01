
Polymer {
  
  is: 'page-pending-invoice'

  behaviors: [ 
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
    app.behaviors.commonComputes
    app.behaviors.dbUsing
  ]

  properties:

    user:
      type: Object
      value: {}
    
    organization:
      type: Object
      value: {}

    
    
    dateCreatedFrom: String
    dateCreatedTo: String
    selectedGender: String
    selectedOrganizationId: String

    invoiceReportList:
      type: Array
      notify: true
      value: []

    
    loadingCounter:
      type: Number
      value: -> 0
      
  

  _sortByDate: (a, b)->
    if a.createdDatetimeStamp < b.createdDatetimeStamp
      return 1
    if a.createdDatetimeStamp > b.createdDatetimeStamp
      return -1
  
  $isAdmin: (userId, userList)->
    for user in userList
      if userId is user.id
        return user.isAdmin
        break
    return false

  getBoolean: (data)-> if data then true else false

  navigatedIn: ->
    @_loadUser()
    @_loadOrganization()
      

  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  
  _loadOrganization: ()->
    organizationList = app.db.find 'organization'
    if organizationList.length is 1
      @set 'organization', organizationList[0]

  


    
}
