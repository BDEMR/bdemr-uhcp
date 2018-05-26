
app.behaviors.dbUsing =
 ## DATA EXTRACTION START ================

  _locateItem: (path, context)->
    # console.log context

    return context if path.length is 0

    head = path.shift()
    return null if head isnt context.forKey

    return context if path.length is 0
    
    first = path[0]
    if 'childMap' of context and first of context.childMap
      newContext = context.childMap[first]
      return @_locateItem path, newContext
    else if 'virtualChildMap' of context
      newContext = null
      for originalVirtualChildName of context.virtualChildMap
        virtualChildName = originalVirtualChildName
        virtualChildName = virtualChildName.split '_'
        virtualChildName.pop()
        virtualChildName.shift()
        virtualChildName = virtualChildName.join '_'

        console.log 'virtualChildName', virtualChildName
        console.log 'first', first        
        console.log 'context.virtualChildMap', context.virtualChildMap
        console.log 'originalVirtualChildName', originalVirtualChildName

        maybeNewContext = context.virtualChildMap[originalVirtualChildName]
        if @_locateItem path, maybeNewContext
          newContext = maybeNewContext
          break
      if newContext is null
        return false
      else
        return @_locateItem path, newContext
    else
      return false

  locateItem: (stringPath, record = null)->
    if record is null
      record = @record
    
    path = (stringPath.split '//')
    head = path.shift()
    if head in [ 'preopAssessment', 'opAnaesthesia', 'opSurgery', 'postopAnalysis', 'postopAssessment', 'progressNote' ]
      path.unshift "systemRoot"

      obj = try record.data catch ex then null
      return (if obj then @_locateItem path, obj else null)
    else
      console.log 'CANT FIND MY WAY'

  safeExtractItem: (path, record = null)->
    item = @locateItem path, record
    return (if item then item else null)      

  safeExtractInput: (path, alternativeValue, record = null)->
    item = @locateItem path, record
    return (if item then item.value else alternativeValue)

  ## DATA EXTRACTION END ================ 

  isUserLoggedIn: ->
    userList = app.db.find 'user'
    if (userList.length is 0) or (not userList[0].apiKey)
      return false
    else if userList.length is 1
      return true
    else
      throw new Error 'More than one active user'

  removeAllUserInfo: ->
    app.db.remove 'user', item._id for item in app.db.find 'user'
    app.db.remove '--persistent-session', item._id for item in app.db.find '--persistent-session'
    app.db.remove '--serial-generator', item._id for item in app.db.find '--serial-generator'
    
    
  removeUserUnlessSessionIsPersistent: ->
    userList = app.db.find 'user'
    persistentSessionList = app.db.find '--persistent-session'

    if userList.length is 1 and persistentSessionList.length is 1
      if persistentSessionList[0].shouldRememberUser isnt true
        item = lib.tabStorage.getItem 'is-tab-authenticated'
        if item
          if (lib.json.parse item) is false
            @removeAllUserInfo()
        else
          @removeAllUserInfo()

  loginDbAction: (user, shouldRememberUser) ->
    previousUser = (app.db.find 'user')[0]
    @removeAllUserInfo()
    
    if previousUser 
      unless user.serial is previousUser.serial
        app.db.removeExistingDatabase()
        app.db.initializeDatabase()
    
    app.db.insert 'user', user

    persistentSession = 
      shouldRememberUser: shouldRememberUser
    app.db.insert '--persistent-session', persistentSession

    serialGenerator = 
      'patient-seed': 0
      'offline-patient-serial-seed': 1
      'doctor-visit-seed': 0
      'doctor-pcc-seed': 1
      'doctor-ndr-seed': 1
      'doctor-visit-prescription-seed': 0
      'doctor-visit-note-seed': 0
      'doctor-patient-stay-seed': 0
      'doctor-visit-next-visit-seed': 0
      'doctor-visit-test-advise-seed': 0
      'doctor-advised-test-seed': 0
      'doctor-visit-examination-seed': 0
      'doctor-visit-identified-symptoms-seed': 1
      'doctor-visit-custom-symptoms-seed': 1
      'doctor-visit-custom-examination-seed': 1
      'anaesmon-record-seed': 0
      'history-physical-record-seed': 1
      'medication-record-seed': 0
      'favorite-medicine-seed': 0
      'favorite-investigation-seed': 0
      'vital-record-seed': 0
      'vital-comment-thread-seed': 0
      'vital-comment-message-seed': 0
      'custom-investigation-name-seed': 0
      'user-added-institution-list-seed': 0
      'attachment-record-seed': 0
      'user-setting-record-seed': 0
      'activity-seed': 0
      'invoice-seed': 1
      'diagnosis-seed': 1
      'visited-patient-log': 0
      'diag-patient-log': 0
      'org-role-item-log': 1
      'referral-seed': 1
      'inventory-seed': 1
      'third-party-user-seed': 1
      # 'investigation-price-list-seed': 1
      # 'service-price-list-seed': 1
      # 'supply-price-list-seed': 1
      # 'ambulance-price-list-seed': 1
      # 'package-price-list-seed': 1
      # 'other-price-list-seed': 1
      'price-list-seed': 1
    app.db.insert '--serial-generator', serialGenerator

    lib.tabStorage.setItem 'is-tab-authenticated', (lib.json.stringify true)

  skipWelcomePage: ->
    welcomePageViewed = lib.localStorage.getItem 'welcomePageViewed'
    if welcomePageViewed
      return true
    return false
  
  getDashboardMetrics: ->

    metrics = {}

    ## NOTE newPatientCount
    # patientList = app.db.find 'patient-list', ({createdDatetimeStamp})-> 
    #   lhs = lib.datetime.mkDate (new Date createdDatetimeStamp)
    #   rhs = lib.datetime.mkDate lib.datetime.now()
    #   return (lhs is rhs)
    # metrics.newPatientCount = patientList.length

    ## NOTE totalPatientCount
    # metrics.totalPatientCount = (app.db.find 'patient-list').length

    ## NOTE newVisitCount
    # metrics.newVisitCount = 0

    ## NOTE totalVisitCount
    # metrics.totalVisitCount = 0

    ## NOTE totalUnpaidInvoiceCount
    # metrics.totalUnpaidInvoiceCount = 0

    ## NOTE daysLeft
    user = (app.db.find 'user')[0]
    dt = new Date user.accountExpiresOnDate
    now = new Date lib.datetime.mkDate lib.datetime.now()
    metrics.daysLeft = Math.floor ((lib.datetime.diff dt, now) / 1000 / 60 / 60 / 24)

    return metrics

  getCurrentUser: -> (app.db.find 'user')[0]
  getCurrentUserSerial: -> (app.db.find 'user')[0].serial
  getCurrentOrganization: -> (app.db.find 'organization')[0]

  generateSerialForPatient: ->
    appIdentifier = 'U'
    itemType = 'P'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    patientSeed = serialGenerator['patient-seed']
    serialGenerator['patient-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + patientSeed)

  generateSerialForVisit: ->
    appIdentifier = 'U'
    itemType = 'V'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['doctor-visit-seed']
    serialGenerator['doctor-visit-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForRecord: ->
    appIdentifier = 'A'
    itemType = 'R'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['anaesmon-record-seed']
    serialGenerator['anaesmon-record-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForHistoryAndPhysical: ->
    appIdentifier = 'A'
    itemType = 'R'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['history-physical-record-seed']
    serialGenerator['history-physical-record-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    console.log (appIdentifier + userSerial + sessionSerial + itemType + seed)
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)


  generateSerialForPrescription: ->
    appIdentifier = 'U'
    itemType = 'PR'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['doctor-visit-prescription-seed']
    serialGenerator['doctor-visit-prescription-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForNote: ->
    appIdentifier = 'U'
    itemType = 'NT'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['doctor-visit-note-seed']
    serialGenerator['doctor-visit-note-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)


  generateSerialForPatientStay: ->
    appIdentifier = 'U'
    itemType = 'PS'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['doctor-patient-stay-seed']
    serialGenerator['doctor-patient-stay-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForNextVisit: ->
    appIdentifier = 'U'
    itemType = 'NV'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['doctor-visit-next-visit-seed']
    serialGenerator['doctor-visit-next-visit-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForTestAdvised: ->
    appIdentifier = 'U'
    itemType = 'TA'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['doctor-visit-test-advise-seed']
    serialGenerator['doctor-visit-test-advise-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForIdentifiedSymptoms: ->
    appIdentifier = 'U'
    itemType = 'SYMP'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['doctor-visit-identified-symptoms-seed']
    serialGenerator['doctor-visit-identified-symptoms-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForExamination: ->
    appIdentifier = 'U'
    itemType = 'EXM'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['doctor-visit-examination-seed']
    serialGenerator['doctor-visit-examination-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)
    

  generateSerialForCustomSymptoms: ->
    appIdentifier = 'U'
    itemType = 'CSYMP'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['doctor-visit-custom-symptoms-seed']
    serialGenerator['doctor-visit-custom-symptoms-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForCustomExamination: ->
    appIdentifier = 'U'
    itemType = 'CEXM'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['doctor-visit-custom-examination-seed']
    serialGenerator['doctor-visit-custom-examination-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForTestAdvisedInvestigation: ->
    appIdentifier = 'U'
    itemType = 'TST'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['doctor-visit-test-advise-seed']
    serialGenerator['doctor-visit-test-advise-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForCustomInvestigation: ->
    appIdentifier = 'U'
    itemType = 'TA'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['doctor-visit-test-advise-seed']
    serialGenerator['doctor-visit-test-advise-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForMedication: ->
    appIdentifier = 'U'
    itemType = 'M'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['medication-record-seed']
    serialGenerator['medication-record-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForFavoriteMedicine: ->
    appIdentifier = 'U'
    itemType = 'FM'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['favorite-medicine-seed']
    serialGenerator['favorite-medicine-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForFavoriteInvestigation: ->
    appIdentifier = 'U'
    itemType = 'FI'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['favorite-investigation-seed']
    serialGenerator['favorite-investigation-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForVitals: (forItem)->
    appIdentifier = 'U'
    itemType = 'V'
    forItem = forItem
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['vital-record-seed']
    serialGenerator['vital-record-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + forItem + seed)


  generateSerialForCommentMessage: (forItem)->
    appIdentifier = 'U'
    itemType = 'U'
    forItem = forItem
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['vital-comment-message-seed']
    serialGenerator['vital-comment-message-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + forItem + seed)


  generateSerialForUserAddedInstituion: (forItem)->
    appIdentifier = 'U'
    itemType = 'UI'
    forItem = forItem
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['user-added-institution-list-seed']
    serialGenerator['user-added-institution-list-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + forItem + seed)

  generateSerialForAttachmentBlob: ->
    appIdentifier = 'U'
    itemType = 'AttBlob'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['attachment-record-seed']
    serialGenerator['attachment-record-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)
  
  generateSerialForAttachmentSync: ->
    appIdentifier = 'U'
    itemType = 'AttSync'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['attachment-record-seed']
    serialGenerator['attachment-record-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForSettings: ->
    appIdentifier = 'U'
    itemType = 'STN'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['user-setting-record-seed']
    serialGenerator['user-setting-record-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForActivity: ->
    appIdentifier = 'U'
    itemType = 'Act'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['activity-seed']
    serialGenerator['activity-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)


  generateSerialForinvoice: ->
    appIdentifier = 'U'
    itemType = 'Inv'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['invoice-seed']
    serialGenerator['invoice-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForDiagnosis: ->
    appIdentifier = 'U'
    itemType = 'Dg'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['diagnosis-seed']
    serialGenerator['diagnosis-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForVisitedPatientLog: ->
    appIdentifier = 'U'
    itemType = 'VP'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['visited-patient-log']
    serialGenerator['visited-patient-log'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForOrgRole: ->
    appIdentifier = 'U'
    itemType = 'R'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['org-role-item-log']
    serialGenerator['org-role-item-log'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForPccRecord: ->
    appIdentifier = 'U'
    itemType = 'PCC'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['doctor-pcc-seed']
    console.log 'seed', seed
    serialGenerator['doctor-pcc-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForNdrRecord: ->
    appIdentifier = 'U'
    itemType = 'NDR'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['doctor-ndr-seed']
    console.log 'seed', seed
    serialGenerator['doctor-ndr-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForEmployeeLeaveData: ->
    appIdentifier = 'U'
    itemType = 'EL'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    return (appIdentifier + userSerial + itemType )


  generateSerialForReferral: ->
    appIdentifier = 'U'
    itemType = 'ref'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['referral-seed']
    serialGenerator['referral-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForInvoiceCategory: ()->
    appIdentifier = 'U'
    itemType = 'IC'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    return (appIdentifier + userSerial + itemType + 'only')

  generateSerialForThirdPartyUser: ->
    appIdentifier = 'U'
    itemType = 'TPU'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['third-party-user-seed']
    serialGenerator['third-party-user-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForInventoryItem: ->
    appIdentifier = 'U'
    itemType = 'Inventory'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['inventory-seed']
    serialGenerator['inventory-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)

  generateSerialForPriceListItem: (orgnizationId)->
    appIdentifier = 'U'
    itemType = 'PL'
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['price-list-seed']
    serialGenerator['price-list-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + orgnizationId + itemType + seed)
  
  generateSerialForInvestigationPriceList: (orgnizationId)->
    appIdentifier = 'U'
    itemType = 'InvP'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    return (appIdentifier + userSerial + itemType + orgnizationId)

  generateSerialDoctorFees: (orgnizationId)->
    appIdentifier = 'U'
    itemType = 'DocFeeP'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    return (appIdentifier + userSerial + itemType + orgnizationId)
  
  generateSerialForServicePriceList: (orgnizationId)->
    appIdentifier = 'U'
    itemType = 'SvcP'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    return (appIdentifier + userSerial + itemType + orgnizationId)

  generateSerialForAmbulancePriceList: (orgnizationId)->
    appIdentifier = 'U'
    itemType = 'AmbP'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    return (appIdentifier + userSerial + itemType + orgnizationId)

  generateSerialForPharmacyPriceList: (orgnizationId)->
    appIdentifier = 'U'
    itemType = 'PhaP'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    return (appIdentifier + userSerial + itemType + orgnizationId)

  generateSerialForSupplyPriceList: (orgnizationId)->
    appIdentifier = 'U'
    itemType = 'SupP'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    return (appIdentifier + userSerial + itemType + orgnizationId)

  generateSerialForPackagePriceList: (orgnizationId)->
    appIdentifier = 'U'
    itemType = 'PackP'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    return (appIdentifier + userSerial + itemType + orgnizationId)

  generateSerialForOtherPriceList: (orgnizationId)->
    appIdentifier = 'U'
    itemType = 'OP'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    return (appIdentifier + userSerial + itemType + orgnizationId)

  generateSerialCustomCategory: ()->
    appIdentifier = 'C'
    itemType = 'UC'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    return (appIdentifier + userSerial + itemType + 'only')

  generateSerialForOfflinePatient: ->
    appIdentifier = 'D'
    itemType = 'OFFPT'
    { serial: userSerial, sessionSerial } = (app.db.find 'user')[0]
    serialGenerator = (app.db.find '--serial-generator')[0]
    seed = serialGenerator['offline-patient-serial-seed']
    console.log 'seed', seed
    serialGenerator['offline-patient-serial-seed'] += 1
    app.db.update '--serial-generator', serialGenerator._id, serialGenerator
    return (appIdentifier + userSerial + sessionSerial + itemType + seed)



