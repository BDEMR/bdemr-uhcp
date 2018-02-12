
Polymer {
  
  is: 'page-chamber-manager'

  behaviors: [ 
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
    app.behaviors.commonComputes
    app.behaviors.dbUsing
  ]

  properties:

    hasSearchBeenPressed:
      type: Boolean
      notify: true
      value: true


    matchingChamberList:
      type: Array
      notify: true
      value: []

    chamberSearchString: 
      type: String
      notify: true
      value: ''
      
    user:
      type: Object
      notify: true
      value: null


  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]
      # console.log @user


  navigatedIn: ->
    @_loadUser()

  searchChamberTapped: (e)->
    data = { 
      apiKey: @user.apiKey
      searchString: @chamberSearchString
    }
    @callApi '/bdemr-chamber-search', data, (err, response)=>
      console.log response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @matchingChamberList = response.data.matchingChamberList



  clearSearchResultsClicked: (e)->
    @matchingChamberList = []



  ## ------------------ import / publish start

  
  viewChamber: (e)->
    chamber = e.model.chamber
    @domHost.navigateToPage '#/chamber/which:' + chamber.name



  _isEmptyArray: (data)->
    if data.length is 0
      return true
    else
      return false

  newPatientPressed: (e)->
    @domHost.navigateToPage '#/patient-editor/patient:new'



}
