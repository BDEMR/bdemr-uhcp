unless app.behaviors.local['root-element']
  app.behaviors.local['root-element'] = {}
app.behaviors.local['root-element'].patientsDataSyncConfig =



  # syncPatientListConfig:
  #   collectionName: 'patient-list'
  #   deletedCollectionName: 'patient-list--deleted'
  #   headerApi: '/bdemr-doctor-app--sync--patient-list--exchange-headers'
  #   dataApi: '/bdemr-doctor-app--sync--patient-list--exchange-data'


  syncVisitConfig:
    collectionName: 'doctor-visit'
    deletedCollectionName: 'doctor-visit--deleted'
    headerApi: '/bdemr-doctor-app--sync--doctor-visit--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--doctor-visit--exchange-data'

  syncPrescriptionConfig:
    collectionName: 'visit-prescription'
    deletedCollectionName: 'visit-prescription--deleted'
    headerApi: '/bdemr-doctor-app--sync--visit-prescription--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--visit-prescription--exchange-data'

  syncPatientMedicationConfig:
    collectionName: 'patient-medications'
    deletedCollectionName: 'patient-medications--deleted'
    headerApi: '/bdemr-doctor-app--sync--medications--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--medications--exchange-data'


  syncDoctorNotesConfig:
    collectionName: 'visit-note'
    deletedCollectionName: 'visit-note--deleted'
    headerApi: '/bdemr-doctor-app--sync--doctor-notes--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--doctor-notes--exchange-data'

  syncNextVisitConfig:
    collectionName: 'visit-next-visit'
    deletedCollectionName: 'visit-next-visit--deleted'
    headerApi: '/bdemr-doctor-app--sync--visit-next-visit--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--visit-next-visit--exchange-data'

  syncTestAdvisedConfig:
    collectionName: 'visit-advised-test'
    deletedCollectionName: 'visit-advised-test--deleted'
    headerApi: '/bdemr-doctor-app--sync--visit-advised-test--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--visit-advised-test--exchange-data'

  syncExaminationConfig:
    collectionName: 'visit-examination'
    deletedCollectionName: 'visit-examination--deleted'
    headerApi: '/bdemr-doctor-app--sync--visit-examination--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--visit-examination--exchange-data'

  syncIdentifiedSymptomsConfig:
    collectionName: 'visit-identified-symptoms'
    deletedCollectionName: 'visit-identified-symptoms--deleted'
    headerApi: '/bdemr-doctor-app--sync--visit-identified-symptoms--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--visit-identified-symptoms--exchange-data'

  syncCustomInvestigationConfig:
    collectionName: 'custom-investigation-list'
    deletedCollectionName: 'custom-investigation-list--deleted'
    headerApi: '/bdemr-doctor-app--sync--custom-investigation-list--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--custom-investigation-list--exchange-data'

  syncUserAddedInstitutionConfig:
    collectionName: 'user-added-institution-list'
    deletedCollectionName: 'user-added-institution-list--deleted'
    headerApi: '/bdemr-doctor-app--sync--user-added-institution-list--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--user-added-institution-list--exchange-data'

  syncPatientTestResultsConfig:
    collectionName: 'patient-test-results'
    deletedCollectionName: 'patient-test-results--deleted'
    headerApi: '/bdemr-doctor-app--sync--patient-test-results--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--patient-test-results--exchange-data'

  syncPatientStayConfig:
    collectionName: 'visit-patient-stay'
    deletedCollectionName: 'visit-patient-stay--deleted'
    headerApi: '/bdemr-doctor-app--sync--patient-stay--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--patient-stay--exchange-data'


  syncHistoryAndPhysicalConfig:
    collectionName: 'history-and-physical-record'
    deletedCollectionName: 'history-and-physical-record--deleted'
    headerApi: '/bdemr-doctor-app--sync--history-and-physical-record--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--history-and-physical-record--exchange-data'

  syncDiagnosisConfig:
    collectionName: 'diagnosis-record'
    deletedCollectionName: 'diagnosis-record--deleted'
    headerApi: '/bdemr-doctor-app--sync--diagnosis-record--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--diagnosis-record--exchange-data'


  syncVitalBloodPressureConfig:
    collectionName: 'patient-vitals-blood-pressure'
    deletedCollectionName: 'patient-vitals-blood-pressure--deleted'
    headerApi: '/bdemr-doctor-app--sync--vital-blood-pressure--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--vital-blood-pressure--exchange-data'

  syncVitalBMIConfig:
    collectionName: 'patient-vitals-bmi'
    deletedCollectionName: 'patient-vitals-bmi--deleted'
    headerApi: '/bdemr-doctor-app--sync--vital-bmi--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--vital-bmi--exchange-data'

  syncVitalPulseRateConfig:
    collectionName: 'patient-vitals-pulse-rate'
    deletedCollectionName: 'patient-vitals-pulse-rate--deleted'
    headerApi: '/bdemr-doctor-app--sync--vital-pulse-rate--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--vital-pulse-rate--exchange-data'

  syncVitalRespiratoryRateConfig:
    collectionName: 'patient-vitals-respiratory-rate'
    deletedCollectionName: 'patient-vitals-respiratory-rate--deleted'
    headerApi: '/bdemr-doctor-app--sync--vital-respiratory-rate--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--vital-respiratory-rate--exchange-data'

  syncVitalSpO2Config:
    collectionName: 'patient-vitals-spo2'
    deletedCollectionName: 'patient-vitals-spo2--deleted'
    headerApi: '/bdemr-doctor-app--sync--vital-spo2--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--vital-spo2--exchange-data'

  syncVitalTemperatureConfig:
    collectionName: 'patient-vitals-temperature'
    deletedCollectionName: 'patient-vitals-temperature--deleted'
    headerApi: '/bdemr-doctor-app--sync--vital-temperature--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--vital-temperature--exchange-data'






  syncTestBloodSugarConfig:
    collectionName: 'patient-test-blood-sugar'
    deletedCollectionName: 'patient-test-blood-sugar--deleted'
    headerApi: '/bdemr-doctor-app--sync--test-blood-sugar--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--vital-blood-sugar--exchange-data'

  syncOtherTestConfig:
    collectionName: 'patient-test-other'
    deletedCollectionName: 'patient-test-other--deleted'
    headerApi: '/bdemr-doctor-app--sync--other-test--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--other-test--exchange-data'






  syncCommentPatientConfig:
    collectionName: 'comment-patient'
    deletedCollectionName: 'comment-patient--deleted'
    headerApi: '/bdemr-doctor-app--sync--comment-patient--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--comment-patient--exchange-data'

  syncCommentDoctorConfig:
    collectionName: 'comment-doctor'
    deletedCollectionName: 'comment-doctor--deleted'
    headerApi: '/bdemr-doctor-app--sync--comment-doctor--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--comment-doctor--exchange-data'


  syncPatientGalleryAttachmentConfig:
    collectionName: 'patient-gallery--online-attachment'
    deletedCollectionName: 'patient-gallery--online-attachment--deleted'
    headerApi: '/bdemr-doctor-app--sync--patient-gallery--online-attachment--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--patient-gallery--online-attachment--exchange-data'


  # Anaesmon Record Sync
  syncAnaesmonRecordConfig:
    collectionName: 'anaesmon-record'
    deletedCollectionName: 'anaesmon-record--deleted'
    headerApi: '/bdemr-doctor-app--sync--anaesmon-record--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--anaesmon-record--exchange-data'

  syncAnaesmonProgressNoteConfig:
    collectionName: 'progress-note-record'
    deletedCollectionName: 'progress-note-record--deleted'
    headerApi: '/bdemr-doctor-app--sync--progress-note-record--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--progress-note-record--exchange-data'
  
  # Sync Activity Log
  syncActivityLog:
    collectionName: 'activity'
    deletedCollectionName: 'activity--deleted'
    headerApi: '/bdemr-doctor-app--sync--user-activity-log--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--user-activity-log--exchange-data'

  syncVisitInvoice:
    collectionName: 'visit-invoice'
    deletedCollectionName: 'visit-invoice--deleted'
    headerApi: '/bdemr-doctor-app--sync--visit-invoice--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--visit-invoice--exchange-data'

  syncVisitDiagnosis:
    collectionName: 'visit-diagnosis'
    deletedCollectionName: 'visit-diagnosis--deleted'
    headerApi: '/bdemr-doctor-app--sync--visit-diagnosis--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--visit-diagnosis--exchange-data'

  syncPccRecords:
    collectionName: 'pcc-records'
    deletedCollectionName: 'pcc-records--deleted'
    headerApi: '/bdemr-doctor-app--sync--pcc-records--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--pcc-records--exchange-data'

  