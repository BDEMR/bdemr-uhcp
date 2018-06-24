if (!app.behaviors.local['root-element']) {
  app.behaviors.local['root-element'] = {};
}
app.behaviors.local['root-element']._syncPriceListOnly = {

  _getLastSyncedDatetimeStamp() { return parseInt(window.localStorage.getItem('priceListLastSyncedDatetimeStamp')) || 0; },

  _updateLastSyncedDatetimeStamp() { return window.localStorage.setItem('priceListLastSyncedDatetimeStamp', lib.datetime.now()); },

  _getModifiedDataFromDB(collectionNameList, lastSyncedDatetimeStamp) {
    return new Promise((accept, reject) => {
      let promiseList = []
      collectionNameList.forEach((clientCollectionName) => {
        promiseList.push(new Promise((accept, reject) => {
          localforage.getItem(clientCollectionName)
            .then((collection) => {
              if (!collection) {
                return accept([]);
              }
              const docListWithClientCollectionName = collection.filter((item) => {
                return (item && item.lastModifiedDatetimeStamp > lastSyncedDatetimeStamp) ? true : false;
              }).map(doc => {
                doc.clientCollectionName = clientCollectionName;
                return doc;
              });
              accept(docListWithClientCollectionName)
            }).catch((err) => reject(err))
        }))
      })
      Promise.all(promiseList)
        .then((values) => {
          let flattenedArr = values.reduce((list, currentList) => {
            return list.concat(currentList);
          }, []);
          accept(flattenedArr);
        })

    })
  },

  _updateLocalDBWithResponse(serverPriceList, cbfn) {

    localforage.getItem('organization-price-list')

      .then((value) => {

        let localPriceList = value || [];

        for (let item of serverPriceList) {

          if (item.clientCollectionName !== 'organization-price-list') {
            continue;
          }

          delete item.collection;

          if (localPriceList.length) {

            let index = localPriceList.findIndex((priceItem) => item._id == priceItem._id)
            if (index == -1) {
              localPriceList.push(item)
            } else {
              localPriceList.splice(index, 1, item);
            }
          } else {
            localPriceList.push(item)
          }
        }

        return localforage.setItem('organization-price-list', localPriceList)


      }).then((value) => {
        console.log(value)
        this._updateLastSyncedDatetimeStamp();
        return cbfn();

      }).catch((err) => {
        return cbfn(err)
      })

  },


  _syncPriceListOnly(cbfn) {

    apiActionId = this.notifyApiAction('start', null);

    this.toggleModalLoader('Pricelist is syncing, please wait...');

    const collectionNameMap = {
      'bdemr--organization-price-list': 'organization-price-list'
    };

    const deleteCollectionNameMap = {
      'bdemr--organization-price-list--deleted': 'organization-price-list--deleted'
    }

    const lastSyncedDatetimeStamp = this._getLastSyncedDatetimeStamp();
    const currentOrganizationId = this.getCurrentOrganization().idOnServer;
    const { apiKey } = this.getCurrentUser();
    let clientToServerDocListDataPromise, removedDocListDataPromise;

    const collectionNameList = Object.keys(collectionNameMap).map(serverCollectionName => collectionNameMap[serverCollectionName]);
    const deletedCollectionNameList = Object.keys(deleteCollectionNameMap).map(serverCollectionName => deleteCollectionNameMap[serverCollectionName]);

    if (currentOrganizationId == app.config.masterOrganizationId) {
      clientToServerDocListDataPromise = this._getModifiedDataFromDB(collectionNameList, lastSyncedDatetimeStamp);
      removedDocListDataPromise = this._getModifiedDataFromDB(deletedCollectionNameList, lastSyncedDatetimeStamp);
    }

    Promise.all([clientToServerDocListDataPromise, removedDocListDataPromise])
      .then(([clientToServerDocList, removedDocList]) => {

        const data = {
          apiKey,
          lastSyncedDatetimeStamp,
          organizationId: app.config.masterOrganizationId,
          knownPatientSerialList: [],
          clientToServerDocList: clientToServerDocList || [],
          removedDocList: removedDocList || [],
          client: 'uhcp'
        };

        this.callApi('/bdemr--sync', data, (err, response) => {

          this.notifyApiAction('done', null, apiActionId)

          this.toggleModalLoader()

          if (err) {
            return cbfn(err.message)
          }
          else if (response.hasError) {

            return cbfn(response.error.message);

          } else {

            this._updateLocalDBWithResponse(response.data, cbfn)

          }

        });
      })

  }
};
