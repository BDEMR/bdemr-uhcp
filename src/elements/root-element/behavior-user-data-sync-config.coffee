unless app.behaviors.local['root-element']
  app.behaviors.local['root-element'] = {}
app.behaviors.local['root-element'].userDataSyncConfig =

  syncSettings:
    collectionName: 'settings'
    deletedCollectionName: 'settings--deleted'
    headerApi: '/bdemr-doctor-app--sync--settings--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--settings--exchange-data'
    
  syncDoctorFavoriteMedicationConfig:
    collectionName: 'favorite-medicine-list'
    deletedCollectionName: 'favorite-medicine-list--deleted'
    headerApi: '/bdemr-doctor-app--sync--doctor-favorite-medications--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--doctor-favorite-medications--exchange-data'

  syncFavoriteAdvisedTestConfig:
    collectionName: 'favorite-advised-test'
    deletedCollectionName: 'favorite-advised-test--deleted'
    headerApi: '/bdemr-doctor-app--sync--favorite-advised-test--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--favorite-advised-test--exchange-data'

  syncUserAddedCustomSymptomsConfig:
    collectionName: 'custom-symptoms-list'
    deletedCollectionName: 'custom-symptoms-list--deleted'
    headerApi: '/bdemr-doctor-app--sync--user-custom-symptoms-list--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--user-custom-symptoms-list--exchange-data'

  syncUserAddedCustomExaminationConfig:
    collectionName: 'custom-examination-list'
    deletedCollectionName: 'custom-examination-list--deleted'
    headerApi: '/bdemr-doctor-app--sync--user-custom-examination-list--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--user-custom-examination-list--exchange-data'

  syncVisitedPatientLogConfig:
    collectionName: 'visited-patient-log'
    deletedCollectionName: 'visited-patient-log--deleted'
    headerApi: '/bdemr-doctor-app--sync--visited-patient-log--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--visited-patient-log--exchange-data'
