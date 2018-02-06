
Polymer {
  
  is: 'page-chamber-patients'

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
      value: -> (app.db.find 'user')[0]
    chamberName:
      type: Object
      value: null
    timeSlotAvailability:
      type: Object
      value: null

  _notify: (patientId, message)->
    user = @getCurrentUser()
    request = {
      operation: 'notify-single'
      apiKey: user.apiKey
      notificationCategory: 'Booking'
      notificationMessage: message
      notificationTargetId: patientId
      sender: user.name
    }
    @domHost.ws.send JSON.stringify request
    
  _getChamber: (cbfn)->
    data = { 
      apiKey: this.user.apiKey
    }
    this.callApi '/bdemr-booking--doctor--get-chamber-list', data, (err, response)=>
      if response.hasError
        this.domHost.showModalDialog response.error.message
      else if response.data
        this.chamber =  null
        chamberList = response.data.chamberList
        for chamber in chamberList
          if chamber.name is this.chamberName
            this.chamber = chamber
        cbfn()
      else
        this.chamber = null
        cbfn()

  _getScheduleForMonth: (monthString, chamberName, cbfn)->
    data = { 
      apiKey: this.user.apiKey
      monthString
      chamberName
    }
    this.callApi '/bdemr-booking--doctor--get-schedule-for-month', data, (err, response)=>
      if response.hasError
        this.domHost.showModalDialog response.error.message
      else if response.data
        this.scheduleForMonth = []
        scheduleForMonth = response.data 
        this.scheduleForMonth = scheduleForMonth
        cbfn()
      else
        this.scheduleForMonth = []
        cbfn()

  _getMonthString: ->
    array = this.dateString.split '-'
    array.pop()
    return array.join '-'

  _getScheduleForDate: (dateString, cbfn)->
    monthString = this._getMonthString()
    this._getScheduleForMonth monthString, this.chamberName, =>
      selectedSchedule = null
      for schedule in this.scheduleForMonth
        if dateString is schedule.dateString
          selectedSchedule = schedule
      this.schedule = null
      this.schedule = selectedSchedule
      this._computeTimeSlotAvailability()
      cbfn()

  _setScheduleForDate: (schedule, cbfn)->
    data = { 
      apiKey: this.user.apiKey
    }
    Object.assign(data, schedule)
    this.callApi '/bdemr-booking--doctor--set-schedule-for-date', data, (err, response)=>
      if response.hasError
        this.domHost.showModalDialog response.error.message
      else
        cbfn()

  addPatientTapped: (e)->
    { patient } = e.model   
    newEntry = {
      patientId: patient.idOnServer
      patientFullName: patient.name
      patientEmail: patient.email
      patientPhone: patient.phone
      patientSerial: patient.serial # extra
      timeSlot: this.schedule.timeSlotList[0]
      paymentStatus: 'manual' # 'manual', 'online-pending', 'online-successful', 'online-failure'
      status: 'awaiting' # 'awaiting', 'completed', 'require-second-visit', 'canceled'
      bookedByUserType: 'doctor'
      bookedByUserId: this.user.idOnServer
      bookedDatetimeStamp: (new Date).getTime()
    }
    this.push('schedule.bookingList', newEntry)
    this._setScheduleForDate this.schedule, =>
      this._getScheduleForDate this.dateString, =>
        message = "#{this.user.name} of #{this.chamberName} created an appointment for you on #{this.dateString} at #{newEntry.timeSlot.replace(/\-/g,':')}"
        this._notify(newEntry.patientId, message)
        null

  _searchOnline: ->
    @matchingPatientList = []
    @callApi '/bdemr-patient-search', {searchQuery: @searchPatientInput}, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else  
        if response.data.length is 0
          @domHost.showToast 'No Patient Found'
          return
        @matchingPatientList = response.data
        
  searchPatientTapped: (e)->
    this._searchOnline()

  searchPatintKeyPressed: (e)->
    if e.which is 13
      @_searchOnline()

  markAsDoneTapped: (e)->
    { entry } = e.model   
    e.model.set('entry.status', 'completed')
    this._setScheduleForDate this.schedule, =>
      this._getScheduleForDate this.dateString, =>
        message = "#{this.user.name} of #{this.chamberName} completed your appointment on #{this.dateString}"
        this._notify(entry.patientId, message)
        null

  requiresSecondVisitTapped: (e)->
    { entry } = e.model   
    e.model.set('entry.status', 'require-second-visit')
    this._setScheduleForDate this.schedule, =>
      this._getScheduleForDate this.dateString, =>
        message = "#{this.user.name} of #{this.chamberName} completed your appointment on #{this.dateString} and required a second visit"
        this._notify(entry.patientId, message)
        null

  doctorCancelTapped: (e)->
    { entry } = e.model   
    e.model.set('entry.status', 'canceled')
    this._setScheduleForDate this.schedule, =>
      this._getScheduleForDate this.dateString, =>
        message = "#{this.user.name} of #{this.chamberName} canceled your appointment on #{this.dateString}"
        this._notify(entry.patientId, message)
        null

  setTimeSlotTapped: (e)->
    { entry } = e.model   
    console.log(entry._selectedTimeSlotIndex)
    return unless entry._selectedTimeSlotIndex > -1
    newTimeSlot = this.schedule.timeSlotList[entry._selectedTimeSlotIndex]
    oldTimeSlot = entry.timeSlot
    e.model.set('entry.timeSlot', newTimeSlot)
    this._setScheduleForDate this.schedule, =>
      this._getScheduleForDate this.dateString, =>
        message = "#{this.user.name} of #{this.chamberName} changed your timeslot on #{this.dateString} from (#{oldTimeSlot}) to (#{newTimeSlot})"
        this._notify(entry.patientId, message)

  navigatedIn: ->
    this.chamberName = this.domHost.getPageParams()['chamber']
    this.dateString =  this.domHost.getPageParams()['date']
    this._getChamber =>
      this._getScheduleForDate this.dateString, =>
        
        null
      
  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  _computeTimeSlotAvailability: ->

    map = {}
    
    for timeSlot in this.schedule.timeSlotList
      map[timeSlot] = 0

    for booking in this.schedule.bookingList
      unless booking.timeSlot of map
        map[booking.timeSlot] = 0
      map[booking.timeSlot] += 1

    freeSchedule = []
    for timeSlot, count of map
      freeSchedule.push {
        timeSlot
        availableCount: (this.chamber.maximumVisitorPerBookingSlot - count)
      }

    this.timeSlotAvailability = freeSchedule

    console.log this.timeSlotAvailability

  _changeStatusColorForPatientChamberBooking: (statusData)->
    if statusData is "awaiting"
      return "status awaiting"
    else if statusData is "completed"
      return "status completed"
    else if statusData is "require-second-visit"
      return "status require-second-visit"
    else
      return "status canceled" 
}
