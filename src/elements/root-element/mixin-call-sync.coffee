unless app.behaviors.local['root-element']
  app.behaviors.local['root-element'] = {} 
app.behaviors.local['root-element'].syncCall = 

  _syncOnlyPatientTestResults: (cbfn)->
      @_sync cbfn

  _syncOnlyPatientGallery: (cbfn)->
    @_sync cbfn

  _syncUserSettings: (cbfn)->
    @_sync cbfn

  _syncOnlyInvoice: (cbfn)->
    @_sync cbfn

  _syncOnlyPriceList: (cbfn)=>
    @_sync cbfn

  _sync: (navigateToAfterSyncing = null)->
    console.group 'Sync'
    @$$('#sync-dialog').toggle()

    @_syncTemporaryOfflinePccPatients =>

      collector1 = new lib.util.Collector 43

      @_syncUser @syncDoctorFavoriteMedicationConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncUser @syncSettings, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncUser @syncFavoriteAdvisedTestConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncUser @syncUserAddedInstitutionConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncUser @syncVisitedPatientLogConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncUser @syncUserAddedCustomSymptomsConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncUser @syncUserAddedCustomExaminationConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        

      # @_syncPatients @syncPatientListConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        

      @_syncPatients @syncVisitConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncPatients @syncPrescriptionConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncPatients @syncPatientMedicationConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncPatients @syncDoctorNotesConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncPatients @syncNextVisitConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncPatients @syncTestAdvisedConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncPatients @syncExaminationConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncPatients @syncIdentifiedSymptomsConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncPatients @syncCustomInvestigationConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        

      @_syncPatients @syncAnaesmonRecordConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        

      
      @_syncPatients @syncPatientTestResultsConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncPatients @syncPatientStayConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncPatients @syncHistoryAndPhysicalConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncPatients @syncDiagnosisConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncPatients @syncReferral, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncPatients @syncEmployeeLeaveData, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncPatients @syncVitalBloodPressureConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncPatients @syncVitalBMIConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncPatients @syncVitalPulseRateConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncPatients @syncVitalRespiratoryRateConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncPatients @syncVitalSpO2Config, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncPatients @syncVitalTemperatureConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        

      @_syncPatients @syncTestBloodSugarConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncPatients @syncOtherTestConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      
      @_syncPatients @syncCommentPatientConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncPatients @syncCommentDoctorConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        

      @_syncPatients @syncPatientGalleryAttachmentConfig, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        

      @_syncPatients @syncActivityLog, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        

      @_syncPatients @syncVisitInvoice, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        

      @_syncPatients @syncVisitDiagnosis, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        

      @_syncPatients @syncPccRecords, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncPatients @syncNdrRecords, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        

      # Invoice Related data
      @_syncOrganizationData @syncOrganizationPriceList, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncOrganizationData @syncInventoryList, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncOrganizationData @syncThirdPartyUserList, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      @_syncOrganizationData @syncInvoiceCategoryList, ()=> 
        @syncCompleted++
        collector1.collect 'A1', null
        
      collector1.finally =>
        console.groupEnd()
        @async =>
          @$$('#sync-dialog').close()
          @syncCompleted = 0
          window.localStorage.setItem 'lastSyncedDatetimeStamp', lib.datetime.now()
          @reloadPage()