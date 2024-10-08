
Polymer {

  is: 'page-organization-editor'

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

    isOrganizationValid: 
      type: Boolean
      notify: true
      value: false

    organization:
      type: Object
      notify: true
      value: null

    parentSearchResultList:
      type: Array
      value: -> []

    parentList:
      type: Array
      value: -> []

    childOrganizationList:
      type: Array
      value: -> []
    

    loadingCounter: Number

  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  saveButtonPressed: (e)->
    params = @domHost.getPageParams()
    if params['organization'] is 'new'
      @_createOrganization =>
        @domHost.showToast 'Organization Created'
        @arrowBackButtonPressed()
    else
      @_updateOrganization =>
        @domHost.showToast 'Organization Updated'
        @arrowBackButtonPressed()
    
  _makeNewOrganization: ->
    @organization = 
      idOnServer: null
      serial: null
      name: ''
      address: ''
      effectiveRegion: ''
      parentOrganizationIdList: []
    @isOrganizationValid = true

  _notifyInvalidOrganization: ->
    @isOrganizationValid = false
    @domHost.showModalDialog 'Invalid Organization Provided'

  _createOrganization: (cbfn)->
    @loadingCounter++
    data = { 
      apiKey: @user.apiKey
      name: @organization.name
      serial: @organization.serial
      address: @organization.address
      effectiveRegion: @organization.effectiveRegion
      parentOrganizationIdList: @organization.parentOrganizationIdList
    }
    @callApi '/bdemr-organization-create', data, (err, response)=>
      @loadingCounter--
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        cbfn()

  _updateOrganization: (cbfn)->
    @loadingCounter++
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      name: @organization.name
      serial: @organization.serial
      address: @organization.address
      effectiveRegion: @organization.effectiveRegion
      parentOrganizationIdList: @organization.parentOrganizationIdList
    }
    @callApi '/bdemr-organization-update', data, (err, response)=>
      @loadingCounter--
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        cbfn()

  navigatedIn: ->
    @_loadUser()
   
    params = @domHost.getPageParams()
    if params['organization']
      if params['organization'] is 'new'
        @_makeNewOrganization()
      else
        @_loadOrganization params['organization']
    else
      @_notifyInvalidOrganization()
    
  navigatedOut: ->
    @organization = null
    @isOrganizationValid = false
    @parentSearchResultList = []
    @parentList = []

  searchParentOrganizationTapped: (e)->
    @loadingCounter++
    data = { 
      apiKey: @user.apiKey
      searchString: @parentOrganizationSearchString
    }
    @callApi '/bdemr-organization-search', data, (err, response)=>
      @loadingCounter--
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @set 'parentSearchResultList', response.data.matchingOrganizationList

  $in: (value, list)-> 
    value in list

  addParentTapped: (e)->
    { parent } = e.model
    @push 'organization.parentOrganizationIdList', parent.idOnServer
    @push 'parentList', parent
    @splice 'parentSearchResultList', (@parentSearchResultList.indexOf parent), 1

  removeParentTapped: (e)->
    { parent } = e.model
    @splice 'organization.parentOrganizationIdList', (@organization.parentOrganizationIdList.indexOf parent.idOnServer), 1
    @splice 'parentList', (@parentList.indexOf parent), 1

  _loadOrganization: (idOnServer)->
    @loadingCounter++
    data = { 
      apiKey: @user.apiKey
      idList: [ idOnServer ]
    }
    @callApi '/bdemr-organization-list-organizations-by-ids', data, (err, response)=>
      @loadingCounter--
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        unless response.data.matchingOrganizationList.length is 1
          @domHost.showModalDialog "Invalid Organization"
          return
        @set 'organization', response.data.matchingOrganizationList[0]
        @set 'isOrganizationValid', true
        @_loadParentList()
        @_loadChildOrganizationList()
        

  _loadParentList: ->
    @loadingCounter++
    data = { 
      apiKey: @user.apiKey
      idList: @organization.parentOrganizationIdList
    }
    @callApi '/bdemr-organization-list-organizations-by-ids', data, (err, response)=>
      @loadingCounter--
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @set 'parentList', response.data.matchingOrganizationList

  _loadChildOrganizationList: () ->
    @loadingCounter++
    query = {
      apiKey: this.user.apiKey,
      organizationId: @organization.idOnServer
    }
    this.callApi '/bdemr--get-child-organization-list', query, (err, response) =>
      @loadingCounter--
      organizationList = response.data
      if organizationList.length 
        this.set('childOrganizationList', organizationList)
  

}
