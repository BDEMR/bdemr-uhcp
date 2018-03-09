unless app.behaviors.local['root-element']
  app.behaviors.local['root-element'] = {}
app.behaviors.local['root-element'].organizationDataSyncConfig =

  syncInvestigationPriceList:
    collectionName: 'investigation-price-list'
    deletedCollectionName: 'investigation-price-list--deleted'
    headerApi: '/bdemr-clinic-app--sync--investigation-price-list--exchange-headers'
    dataApi: '/bdemr-clinic-app--sync--investigation-price-list--exchange-data'

  syncDoctorFeesPriceList:
    collectionName: 'doctor-fees-price-list'
    deletedCollectionName: 'doctor-fees-price-list--deleted'
    headerApi: '/bdemr-clinic-app--sync--doctor-fees-price-list--exchange-headers'
    dataApi: '/bdemr-clinic-app--sync--doctor-fees-price-list--exchange-data'
  
  syncServicesPriceList:
    collectionName: 'service-price-list'
    deletedCollectionName: 'service-price-list--deleted'
    headerApi: '/bdemr-clinic-app--sync--service-price-list--exchange-headers'
    dataApi: '/bdemr-clinic-app--sync--service-price-list--exchange-data'

  syncPharmacyPriceList:
    collectionName: 'pharmacy-price-list'
    deletedCollectionName: 'pharmacy-price-list--deleted'
    headerApi: '/bdemr-clinic-app--sync--pharmacy-price-list--exchange-headers'
    dataApi: '/bdemr-clinic-app--sync--pharmacy-price-list--exchange-data'

  syncSupplyPriceList:
    collectionName: 'supply-price-list'
    deletedCollectionName: 'supply-price-list--deleted'
    headerApi: '/bdemr-clinic-app--sync--supply-price-list--exchange-headers'
    dataApi: '/bdemr-clinic-app--sync--supply-price-list--exchange-data'

  syncAmbulancePriceList:
    collectionName: 'ambulance-price-list'
    deletedCollectionName: 'ambulance-price-list--deleted'
    headerApi: '/bdemr-clinic-app--sync--ambulance-price-list--exchange-headers'
    dataApi: '/bdemr-clinic-app--sync--ambulance-price-list--exchange-data'

  syncPackageList:
    collectionName: 'package-price-list'
    deletedCollectionName: 'package-price-list--deleted'
    headerApi: '/bdemr-clinic-app--sync--package-price-list--exchange-headers'
    dataApi: '/bdemr-clinic-app--sync--package-price-list--exchange-data'

  syncOtherPriceList:
    collectionName: 'other-price-list'
    deletedCollectionName: 'other-price-list--deleted'
    headerApi: '/bdemr-clinic-app--sync--other-price-list--exchange-headers'
    dataApi: '/bdemr-clinic-app--sync--other-price-list--exchange-data'

  syncInventoryList:
    collectionName: 'organization-inventory'
    deletedCollectionName: 'organization-inventory--deleted'
    headerApi: '/bdemr-clinic-app--sync--organization-inventory--exchange-headers'
    dataApi: '/bdemr-clinic-app--sync--organization-inventory--exchange-data'

  syncInvoiceCategoryList:
    collectionName: 'invoice-category-list'
    deletedCollectionName: 'invoice-category-list--deleted'
    headerApi: '/bdemr-clinic-app--sync--invoice-category-list--exchange-headers'
    dataApi: '/bdemr-clinic-app--sync--invoice-category-list--exchange-data'

  syncCustomInvestigationConfig:
    collectionName: 'custom-investigation-list'
    deletedCollectionName: 'custom-investigation-list--deleted'
    headerApi: '/bdemr-doctor-app--sync--custom-investigation-list--exchange-headers'
    dataApi: '/bdemr-doctor-app--sync--custom-investigation-list--exchange-data'

  syncThirdPartyUserList:
    collectionName: 'third-party-user-list'
    deletedCollectionName: 'third-party-user-list--deleted'
    headerApi: '/bdemr-clinic-app--sync--third-party-user-list--exchange-headers'
    dataApi: '/bdemr-clinic-app--sync--third-party-user-list--exchange-data'


  