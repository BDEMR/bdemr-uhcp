if (!app.behaviors.local['root-element']) {
  app.behaviors.local['root-element'] = {};
}
app.behaviors.local['root-element'].syncPriceListOnly = {

  _getLastSyncedDatetimeStampForPrice() { return parseInt(window.localStorage.getItem('priceListLastSyncedDatetimeStamp')) || 0; },

  _updateLastSyncedDatetimeStampForPrice() { return window.localStorage.setItem('priceListLastSyncedDatetimeStamp', lib.datetime.now()); },

  _getModifiedPriceDataFromDB(clientCollectionName, lastSyncedDatetimeStamp) {
    return new Promise((accept, reject) => {
      localforage.getItem(clientCollectionName)
        .then((collection) => {
          if (!collection || !lastSyncedDatetimeStamp) {
            return accept([]);
          }
          const docListWithClientCollectionName = collection.filter((item) => item && item.lastModifiedDatetimeStamp > lastSyncedDatetimeStamp).map(doc => {
            doc.clientCollectionName = clientCollectionName;
            return doc;
          });
          accept(docListWithClientCollectionName)
        }).catch((err) => reject(err))
    })

  },

  _updateLocalDBWithPriceData(serverPriceList, cbfn) {

    if (!serverPriceList.length) {
      return cbfn()
    }

    localforage.getItem('organization-price-list')
      .then((value) => {

        let localPriceList = value || [];

        if (localPriceList.length) {

          for (let item of serverPriceList) {
            delete item.collection;
            let index = localPriceList.findIndex((priceItem) => item._id == priceItem._id)
            if (index == -1) {
              localPriceList.push(item)
            } else {
              localPriceList.splice(index, 1, item);
            }
          }

        } else {
          localPriceList = serverPriceList
        }

        return localforage.setItem('organization-price-list', localPriceList)

      }).then((value) => {

        this._updateLastSyncedDatetimeStampForPrice();
        return cbfn();

      }).catch((err) => {
        return cbfn(err)
      })

  },


  _syncPriceListOnly(cbfn) {

    apiActionId = this.notifyApiAction('start', null);

    this.toggleModalLoader('Pricelist is syncing, please wait...');

    const lastSyncedDatetimeStamp = this._getLastSyncedDatetimeStampForPrice();
    const currentOrganizationId = this.getCurrentOrganization().idOnServer;
    const { apiKey } = this.getCurrentUser();
    let clientToServerDocListDataPromise, removedDocListDataPromise;

    if (currentOrganizationId == app.config.masterOrganizationId) {
      clientToServerDocListDataPromise = this._getModifiedPriceDataFromDB('organization-price-list', lastSyncedDatetimeStamp);
      removedDocListDataPromise = this._getModifiedPriceDataFromDB('organization-price-list--deleted', lastSyncedDatetimeStamp);
    }

    Promise.all([clientToServerDocListDataPromise, removedDocListDataPromise])
      .then(([clientToServerDocList, removedDocList]) => {

        if (clientToServerDocList && clientToServerDocList.length > 1000) {
          console.error('price list is too big', clientToServerDocList.length)
          clientToServerDocList = [];
        }

        const data = {
          apiKey,
          lastSyncedDatetimeStamp,
          organizationId: app.config.masterOrganizationId,
          clientToServerDocList: clientToServerDocList || [],
          removedDocList: removedDocList || [],
          client: 'uhcp'
        };

        this.callApi('/bdemr--price-list-sync', data, (err, response) => {

          this.notifyApiAction('done', null, apiActionId)

          this.toggleModalLoader()

          if (err) {
            return cbfn(err.message)
          }
          else if (response.hasError) {

            return cbfn(response.error.message);

          } else {

            this._updateLocalDBWithPriceData(response.data, cbfn)

          }

        });
      })

  }
};
