
Polymer {

  is: 'page-uhcp-report'

  behaviors: [ 
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

    organization:
      type: Object
      notify: true
      value: null

    loading:
     type: Boolean
     value: -> false

    categoryList:
      type: Array
      value: -> ['Symptoms','Diagnosis','Investigation', 'Medicine']
    
    ageGroupList:
      type: Array
      value: -> [
        '0 to 18'
        '18 to 25'
        '25 to 35'
        '35 to 50'
        '50 to above'
      ]
    
    salaryRangeList:
      type: Array
      value: -> [
        "0 to 10,000"
        "10,000 to 20,000"
        "20,000 to 30,000"
        "30,000 to 40,000"
        "40,000 to 50,000"
        "50,000 to above"
      ]

    reportResults:
      type: Array
      value: -> []

    selectedReportType: String
    dateCreatedFrom: String
    dateCreatedTo: String
    selectedGender: String
    selectedAgeGroup: Array
    selectedSalaryRange: Array


  navigatedIn: ->
    @_loadUser()
    @_loadOrganization()


  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @set 'user', userList[0]

    
  _loadOrganization: ->
    organizationList = app.db.find 'organization'
    if organizationList.length is 1
      @set 'organization', organizationList[0]

  resetButtonClicked: -> @domHost.reloadPage()

  
  searchButtonClicked: ->
    @reportResults = []
    
    unless @selectedReportType
      @domHost.showWarningToast 'Select a Type of Report'
      return
    
    query = {
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      reportType: @selectedReportType
      searchParameters: {
        searchString: @searchString
        dateCreatedFrom: @dateCreatedFrom?=""
        dateCreatedTo: @dateCreatedTo?=""
        gender: @selectedGender?=""
        ageGroup: @selectedAgeGroup?=[]
        salaryRange: @selectedSalaryRange?=[]
      }
    }

    @loading = true
    @callApi '/uhcp--get-reports', query, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
        @loading = false
      else
        @set 'reportResults', response.data
        console.log @reportResults
        @loading = false

  categorySelected: (e)->
    index = e.detail.selected
    @set 'selectedReportType', @categoryList[index].toLowerCase()
  
  genderSelected: (e)->
    index = e.detail.selected
    gender = switch index
      when 1 then 'male'
      when 2 then 'female'
      else ''
    @set 'selectedGender', gender
  
  _createAgeGroupFromString: (ageGroupString)->
    ageGroupStringArr = ageGroupString.split('to')
    fromAge = parseInt ageGroupStringArr[0]
    toAge = (if isNaN(parseInt ageGroupStringArr[1]) then 999 else (parseInt ageGroupStringArr[1]))
    return [fromAge, toAge]
  
  ageGroupSelected: (e)->
    index = e.detail.selected
    selectedAgeGroupString = @ageGroupList[index]
    @set 'selectedAgeGroup', @_createAgeGroupFromString selectedAgeGroupString 
    
  
  _createSalarRangeFromString: (salaryRangeString)->
    salaryRangeStringArr = salaryRangeString.split('to')
    salaryRangeStringArr.splice 0, 1, (salaryRangeStringArr[0].split(",").join(""))
    salaryRangeStringArr.splice 1, 1, (salaryRangeStringArr[1].split(",").join(""))
    fromSalary = (if isNaN(parseInt salaryRangeStringArr[0]) then 0 else (parseInt salaryRangeStringArr[0]))
    toSalary = (if isNaN(parseInt salaryRangeStringArr[1]) then 99999999999 else (parseInt salaryRangeStringArr[1]))
    return [fromSalary, toSalary]
  
  salaryRangeSelected: (e)->
    index = e.detail.selected
    selectedSalaryRangeString = @salaryRangeList[index]
    @set 'selectedSalaryRange', @_createSalarRangeFromString selectedSalaryRangeString

  filterByDateClicked: (e)->
    startDate = new Date e.detail.startDate
    startDate.setHours(0,0,0,0)
    endDate = new Date e.detail.endDate
    endDate.setHours(23,59,59,999)
    @set 'dateCreatedFrom', (startDate.getTime())
    @set 'dateCreatedTo', (endDate.getTime())

  filterByDateClearButtonClicked: ->
    @dateCreatedFrom = 0
    @dateCreatedTo = 0

}
