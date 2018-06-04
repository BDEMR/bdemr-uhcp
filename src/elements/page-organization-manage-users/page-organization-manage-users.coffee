
Polymer {

  is: 'page-organization-manage-users'

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

    memberSearchResultList:
      type: Array
      value: -> []

    memberList:
      type: Array
      value: -> []

    matchingPatientList:
      type: Array
      value: -> []


    ## Role Manager - start

    role:
      type: Object
      notify: true
      value: null

    roleList:
      type: Array
      value: -> []

    selectedRoleTypeForUser:
      type: String
      notify: true
      value: null

    selectecMemberId:
      type: String
      notify: true
      value: null

    selectedRoleIndex:
      type: Number
      notify: true
      value: null

    departmentList:
      type: Array
      notify: true
      value: -> []



    ## Role Manager - end

  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  _notifyInvalidOrganization: ->
    @isOrganizationValid = false
    @domHost.showModalDialog 'Invalid Organization Provided'

  _loadPatientStayObject: (organizationIdentifier)->
    data = { 
      apiKey: @user.apiKey
      organizationId: organizationIdentifier
    }
    @callApi '/bdemr-organization-patient-stay-get-object', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        departmentList = response.data.patientStayObject.departmentList
        seatList = response.data.patientStayObject.seatList
        @set 'departmentList', @_modifyList departmentList, seatList

        console.log 'departmentList', @departmentList
        

  _modifyList: (deptList, seatList)->
    modDeptList = []
    if deptList
      for dept in deptList
        modDept =
          name: dept.name
          checked: false

        unitList = dept.unitList
        modUnitList = []
        if unitList
          for unit in unitList
            modUnit =
              name: unit.name
              checked: false

            wardList = unit.wardList
            modWardList = []
            if wardList
              for ward in wardList
                modWard =
                  name: ward.name
                  checked: false
                  seatList: @_getSeatListForWard ward.name, seatList
                modWardList.push modWard
              modUnit.wardList =  modWardList
            else
              modUnit.wardList =  modWardList

            modUnitList.push modUnit
          modDept.unitList = modUnitList

        else
          modDept.unitList = modUnitList

        modDeptList.push modDept

      return modDeptList
    else
      return modDeptList

  _getSeatListForWard: (wardName, seatList)->
    modSeatList = []
    if seatList
      for seat in seatList
        if seat.ward
          seat.checked = false
          modSeatList.push seat
      return modSeatList
    else
      return modSeatList

  onDeptSelect: (e)->
    checked = e.target.checked
    selectedDept = e.model.dept
    departmentList = @departmentList

    unitList = selectedDept.unitList
    modUnitList = []

    if checked
      if unitList
        for unit in unitList
          unit.checked = true
          modUnitList.push unit
        selectedDept.unitList = modUnitList
      else
        selectedDept.unitList = modUnitList

      console.log 'selectedDept', selectedDept

      for dept, index in departmentList
        if dept.name is selectedDept.name
          departmentList[index] = selectedDept

      @set 'departmentList', []
      @set 'departmentList', departmentList

    else
      if unitList
        for unit in unitList
          unit.checked = false
          modUnitList.push unit
        selectedDept.unitList = modUnitList
      else
        selectedDept.unitList = modUnitList

      for dept, index in departmentList
        if dept.name is selectedDept.name
          departmentList[index] = selectedDept

      @set 'departmentList', departmentList




          



  navigatedIn: ->
    # currentOrganization = @getCurrentOrganization()
    # unless currentOrganization
    #   @domHost.navigateToPage "#/select-organization"
      
    @_loadUser()
    @_makePrivilegeList()
    
    params = @domHost.getPageParams()
    if params['organization']
      @_loadOrganization params['organization']
      @_loadPatientStayObject params['organization']
    else
      @_notifyInvalidOrganization()
    
  navigatedOut: ->
    @organization = null
    @isOrganizationValid = false
    @memberSearchResultList = []
    @memberList = []

  searchMemberOrganizationTapped: (e)->
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      searchString: @memberOrganizationSearchString
      overrideWithIdList: []
    }
    @callApi '/bdemr-organization-find-user', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @set 'memberSearchResultList', response.data.matchingUserList

  _loadOrganization: (idOnServer)->
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

        console.log @organization
        @set 'isOrganizationValid', true
        @_loadRoleList response.data.matchingOrganizationList[0]
        @_loadMemberList()

  _loadMemberList: ->
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      overrideWithIdList: (user.id for user in @organization.userList)
      searchString: 'N/A'
    }
    @callApi '/bdemr-organization-find-user', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @set 'memberList', response.data.matchingUserList

  addMemberTapped: (e)->
    { member } = e.model
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      targetUserId: member.idOnServer
    }
    @callApi '/bdemr-organization-add-user', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @domHost.showToast 'User Added'
        @splice 'memberSearchResultList', (@memberSearchResultList.indexOf member), 1
        params = @domHost.getPageParams()
        @_loadOrganization params['organization']

  removeMemberTapped: (e)->
    { member } = e.model
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      targetUserId: member.idOnServer
    }
    @callApi '/bdemr-organization-remove-user', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @domHost.showToast 'User Removed'
        params = @domHost.getPageParams()
        @_loadOrganization params['organization']

  $isAdmin: (userId, userList)->
    for user in userList
      if userId is user.id
        return user.isAdmin

  _setUserPrivilege: (member, shouldBeAdmin)->
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      targetUserId: member.idOnServer
      shouldBeAdmin: shouldBeAdmin
    }
    @callApi '/bdemr-organization-set-user-privilege', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @domHost.showToast 'User Access Updated'
        params = @domHost.getPageParams()
        @_loadOrganization params['organization']

  makeAdminTapped: (e)->
    { member } = e.model
    @_setUserPrivilege member, true

  makeRegularUserTapped: (e)->
    { member } = e.model
    @_setUserPrivilege member, false


  ## Role Manager - start
  _loadRoleList: (org)->
    if typeof org.roleList is 'undefined'
      @set 'roleList', []
    else
      @set 'roleList', @organization.roleList

    console.log @roleList

  _makePrivilegeList: ()->
    @privilegeList = [
      {
        serial: 'D001'
        type: 'manage-patient'
        name: 'Patient Manager'
        isSelected: false
      }
      {
        serial: 'D002'
        type: 'manage-reports'
        name: 'Report Manger'
        isSelected: false
      }
      # {
      #   serial: 'D003'
      #   type: 'manage-chamber'
      #   name: 'Chamber Manager'
      #   isSelected: false
      # }
      {
        serial: 'D004'
        type: 'medicine-dispension'
        name: 'Medicine Dispension'
        isSelected: false
      }
      {
        serial: 'D005'
        type: 'assistant-manager'
        name: 'Assistant Manager'
        isSelected: false
      }
      {
        serial: 'D006'
        type: 'search-records'
        name: 'Records Manager'
        isSelected: false
      }
      # {
      #   serial: 'D007'
      #   type: 'manage-invoice'
      #   name: 'Invoice Manager'
      #   isSelected: false
      # }
      # {
      #   serial: 'D009'
      #   type: 'booking-and-services'
      #   name: 'Booking And Services'
      #   isSelected: false
      # }
      {
        serial: 'D010'
        type: 'manage-organization'
        name: 'Organization Manger'
        isSelected: false
      }
      {
        serial: 'D011'
        type: 'send-notification'
        name: 'Send Notification'
        isSelected: false
      }
      {
        serial: 'D012'
        type: 'send-feedback'
        name: 'Send Feedback'
        isSelected: false
      }
      {
        serial: 'D013'
        name: 'Create Patient Visit Record'
        type: 'create-visit-record'
        isSelected: false
      }

      {
        serial: 'D014'
        name: 'Patient Details'
        type: 'patient-details'
        isSelected: false
      }
      # {
      #   serial: 'D016'
      #   name: 'Invoice Manager'
      #   type: 'invoice'
      #   isSelected: false
      # }
      
      
      # {
      #   serial: 'D019'
      #   name: 'Accounts Manager'
      #   type: 'accounts-manager'
      #   isSelected: false
      # }
      # {
      #   serial: 'D020'
      #   name: 'Pharmacy Manager'
      #   type: 'pharmacy-manager'
      #   isSelected: false
      # }
      # {
      #   serial: 'D021'
      #   name: 'Billing Report'
      #   type: 'billing-report'
      #   isSelected: false
      # }

      {
        serial: 'D022'
        name: 'Patient Leave Info'
        type: 'pharmacy-manager'
        isSelected: false
      }
      {
        serial: 'D023'
        name: 'Patient Policy Info'
        type: 'billing-report'
        isSelected: false
      }
      {
        serial: 'R001'
        name: 'Summary Report'
        type: 'report'
        isSelected: false
      }
      {
        serial: 'R002'
        name: 'All Visit Report'
        type: 'report'
        isSelected: false
      }

    ]

  _makeNewRole: ()->

    @role = 
      type: ''
      title: ''
      serial: null
      privilegeList: []
      userList: []

  _makeRoleType: (str)->
    converToStr = str.toString()
    lowerCaseStr = converToStr.toLowerCase()
    replaced = str.split(' ').join('-');
    return replaced

  saveRole: (object)->
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      roleObject: object
    }
    @callApi '/bdemr-organization-add-role', data, (err, response)=>
      console.log response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @domHost.showToast 'Role Added!'
        params = @domHost.getPageParams()
        @_makeNewRole()
        @_loadOrganization params['organization']
        @$$('#dialogAddRole').close()


  showAddRoleDialog: ()->
    @$$('#dialogAddRole').toggle()
    @_makeNewRole()

  filterPrivilegeList: ()->
    selectedItemSerialList = []
    for item in @privilegeList
      if item.isSelected
        selectedItemSerialList.push item

    return selectedItemSerialList

  addRole: ()->
    unless @role.title is ''
      @role.type =  @role.title
      @role.privilegeList = @filterPrivilegeList()
      @role.serial = @generateSerialForOrgRole()
      console.log 'ROLE', @role
      @saveRole @role
    @domHost.showToast 'Type Role Title!'

  showEditRoleDialog: (e)->
    index = e.model.index
    @role = @roleList[index]
    @$$('#dialogEditRole').toggle()

  editRole: (e)->
    unless @role.title is ''
      @role.type =  @role.title
      @updateRole @role

  updateRole: (role)->
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      roleObject: role
    }
    @callApi '/bdemr-organization-update-role', data, (err, response)=>
      console.log response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @domHost.showToast 'Role Updated!'
        params = @domHost.getPageParams()
        @_makeNewRole()
        @_loadOrganization params['organization']
        @$$('#dialogEditRole').close()


  showDialogForSetRole: (e)->
    { member } = e.model
    
    @set 'selectecMemberId', member.idOnServer

    roleTitle = @_getRoleTitleForUser member.idOnServer

    @set 'selectedRoleTypeForUser', roleTitle

    @$$('#dialogSetRoleForUser').toggle()

  # setRoleForUserValueChanged: (e)->
  #   console.log 'selectedRoleIndex', @selectedRoleIndex
  #   @selectedRoleTypeForUser = @roleList[@selectedRoleIndex].type
    

  setRoleForUser: (e)->
    { member } = e.model
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      targetUserId: @selectecMemberId
      roleType: @selectedRoleTypeForUser
    }
    @callApi '/bdemr-organization-set-user-on-specific-role', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @domHost.showToast 'User Role Added.'
        params = @domHost.getPageParams()
        @_loadOrganization params['organization']
        @$$('#dialogSetRoleForUser').close()

  removeRole:(e)->
    role = @roleList[e.model.index]
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      roleObject: role
    }
    @callApi '/bdemr-organization-remove-role', data, (err, response)=>
      console.log response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @domHost.showToast 'Role Removed!'
        params = @domHost.getPageParams()
        @_makeNewRole()
        @_loadOrganization params['organization']


  _getRoleTitleForUser: (userIdentifier)->
    roleTitle = ''

    if @roleList.length > 0
      for role in @roleList
        for user in role.userList
          if user.id is userIdentifier
            roleTitle = role.title
            return roleTitle
    else
      return roleTitle


  ## Role Manager - end

}
