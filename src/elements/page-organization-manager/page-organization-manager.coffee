
Polymer {
  
  is: 'page-organization-manager'

  behaviors: [ 
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
    app.behaviors.commonComputes
    app.behaviors.dbUsing
  ]

  properties:
    organizationsIBelongToList:
      type: Array
      value: -> []
    user:
      type: Object
      value: -> (app.db.find 'user')[0]
    organizationSearchResultList:
      type: Array
      value: -> []

  _updateOrganizationsIBelongToList: ->
    data = { 
      apiKey: @user.apiKey
    }
    @callApi '/bdemr-organization-list-those-user-belongs-to', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @organizationsIBelongToList = response.data.organizationObjectList

        console.log 'organizationsIBelongToList', @organizationsIBelongToList

  navigatedIn: ->
    # currentOrganization = @getCurrentOrganization()
    # unless currentOrganization
    #   @domHost.navigateToPage "#/select-organization"
      
    @_updateOrganizationsIBelongToList()

  newOrganizationFabPressed: (e)->
    @domHost.navigateToPage '#/organization-editor/organization:new'

  _removeOrganization: (organizationId, cbfn)->
    data = { 
      apiKey: @user.apiKey
      organizationId: organizationId
    }
    @callApi '/bdemr-organization-remove', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        cbfn response.data.wasRemoved

  removeOrganizationPressed: (e)->
    { organization } = e.model
    @domHost.showModalPrompt "Are you sure?", (answer)=>
      if answer
        @_removeOrganization organization.idOnServer, (wasRemoved)=>
          if wasRemoved
            @domHost.showModalDialog "Removed Successfully"
          else
            @domHost.showModalDialog "Failed to Remove"
          @_updateOrganizationsIBelongToList()

  editOrganizationPressed: (e)->
    { organization } = e.model
    @domHost.navigateToPage '#/organization-editor/organization:' + organization.idOnServer

  accessMedicineSalesStatisticsPressed: (e)->
    { organization } = e.model
    @domHost.navigateToPage '#/organization-medicine-sales-statistics/organization:' + organization.idOnServer

  accessRecordsPressed: (e)->
    { organization } = e.model
    @domHost.navigateToPage '#/organization-records/organization:' + organization.idOnServer

  managePatientPressed: (e)->
    { organization } = e.model
    @domHost.navigateToPage '#/organization-manage-patient/organization:' + organization.idOnServer
  
  manageUsersPressed: (e)->
    { organization } = e.model
    @domHost.navigateToPage '#/organization-manage-users/organization:' + organization.idOnServer

  searchOrganizationTapped: (e)->
    data = { 
      apiKey: @user.apiKey
      searchString: @organizationSearchString
    }
    @callApi '/bdemr-organization-search', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @set 'organizationSearchResultList', response.data.matchingOrganizationList

  managePatientStayPressed: (e)->
    { organization } = e.model
    @domHost.navigateToPage '#/organization-manage-patient-stay/organization:' + organization.idOnServer

  manageWaitlistPressed: (e)->
    { organization } = e.model
    @domHost.navigateToPage '#/organization-manage-waitlist/organization:' + organization.idOnServer

  manageUnitPricePressed: (e)->
    { organization } = e.model
    @domHost.navigateToPage '#/manage-price-list/organization:' + organization.idOnServer

  managePharmacyPressed: (e)->
    { organization } = e.model
    @domHost.navigateToPage '#/pharmacy-manager/organization:' + organization.idOnServer

  joinOrganizationTapped: (e)->
    { organization } = e.model
    
    data = { 
      apiKey: @user.apiKey
      organizationId: organization.idOnServer
    }
    @callApi '/bdemr-organization-join-as-a-user', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @_updateOrganizationsIBelongToList()
        @searchOrganizationTapped null

  claimOrganizationTapped: (e)->
    { organization } = e.model
    
    data = { 
      apiKey: @user.apiKey
      organizationId: organization.idOnServer
    }
    @callApi '/bdemr-organization-claim', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @domHost.showModalDialog response.data

  leaveOrganizationPressed: (e)->
    { organization } = e.model
    @domHost.showModalPrompt "Are you sure?", (answer)=>
      if answer
        data = { 
          apiKey: @user.apiKey
          organizationId: organization.idOnServer
          targetUserId: @user.idOnServer
        }
        @callApi '/bdemr-organization-remove-user', data, (err, response)=>
          if response.hasError
            @domHost.showModalDialog response.error.message
          else
            @_updateOrganizationsIBelongToList()

}
