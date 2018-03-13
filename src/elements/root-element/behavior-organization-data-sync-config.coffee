unless app.behaviors.local['root-element']
  app.behaviors.local['root-element'] = {}
app.behaviors.local['root-element'].organizationDataSyncConfig =

  syncOrganizationPriceList:
    collectionName: 'organization-price-list'
    deletedCollectionName: 'organization-price-list--deleted'
    headerApi: '/bdemr--sync--organization-price-list--exchange-headers'
    dataApi: '/bdemr--sync--organization-price-list--exchange-data'

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


  