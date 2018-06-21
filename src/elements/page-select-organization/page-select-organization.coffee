
Polymer {

  is: 'page-select-organization'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
  ]

  properties:

    user:
      type: Object
      notify: true
      value: null

    organizationsIBelongToList:
      type: Array
      value: -> []
    
    selectedOrganization:
      type: Object
      notify: true
      value: null

    selectedUserRoleIndex:
      type: Number
      notify: true
      value: 0
      
    

  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  organizationSelected: (e)->
    return unless e.detail.value
    selectedOrganizationId = e.detail.value
    selectedOrganization = @organizationsIBelongToList.find (item)=> item.idOnServer is selectedOrganizationId
    if selectedOrganization
      @set 'selectedOrganization', selectedOrganization
      @set 'userRoleList', selectedOrganization.userRoleList
  
  $notUndefined: (value)-> if value? then true else false

  navigatedIn: ->
    @_loadUser()
    @_findOrganizationsUserBelongsTo @user.apiKey
    
  navigatedOut: ->
    @isOrganizationValid = false
    @memberSearchResultList = []
    @memberList = []

  _findOrganizationsUserBelongsTo: (apiKey)->
    @organizationLoading = true
    @callApi '/bdemr-organization-list-those-user-belongs-to', apiKey: apiKey, (err, response)=>
      @organizationLoading = false
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @set 'organizationsIBelongToList', response.data.organizationObjectList
        @mappedOrganizationList = response.data.organizationObjectList.map (item)=>
          return {label: item.name, value: item.idOnServer}
  
  
  navigateWithOrganizationSelected: ->
    if @selectedOrganization
      app.db.remove 'organization', item._id for item in app.db.find 'organization'
      app.db.insert 'organization', @selectedOrganization

      selectedUserRole = @userRoleList[@selectedUserRoleIndex]
      if selectedUserRole
        @_getUserRoleDetails selectedUserRole, @selectedOrganization.idOnServer, =>
          @domHost.navigateToPage "#/dashboard"
          window.location.reload()
      else
        @domHost.navigateToPage "#/dashboard"
        window.location.reload()

      # error tracking js meta
      if app.mode is 'production'
        unless bugsnagClient['metaData']
          bugsnagClient.metaData = {}
        unless bugsnagClient.metaData['organization']
          bugsnagClient.metaData['organization'] = {}
        bugsnagClient.metaData.organization = {
          name: @selectedOrganization.name
          id: @selectedOrganization.idOnServer
          isCurrentUserAnAdmin: @selectedOrganization.isCurrentUserAnAdmin
        }

    else
      @domHost.showModalDialog "Chose an Organization to Continue"

  _getUserRoleDetails: (selectedRole, orgIdentifier, cbfn)->
    data =
      apiKey: @user.apiKey
      organizationId: orgIdentifier
      roleId: selectedRole.serial
    console.log 'data', data

    @callApi '/bdemr-get-user-role-details-from-belong-organization', data , (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        selectedOrganization = @get 'selectedOrganization'
        selectedOrganization.userActiveRole = response.data
        app.db.upsert 'organization', selectedOrganization, ({idOnServer})=> selectedOrganization.idOnServer is idOnServer
        cbfn()

  
  createOrganizationButtonPressed: ->
     @domHost.navigateToPage "#/organization-manager"

  _isEmpty: (data)-> 
    if data is 0
      return true
    else
      return false
}
