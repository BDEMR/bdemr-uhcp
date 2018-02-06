
unless app.behaviors.local['root-element']
  app.behaviors.local['root-element'] = {}


app.behaviors.local['root-element'].userDataSync =

  _syncUser: (params, cbfn)->

    {collectionName, deletedCollectionName, headerApi, dataApi} = params

    user = (app.db.find 'user')[0]
    createdByUserSerial = user.serial
    userId = user.idOnServer
    apiKey = user.apiKey

    organization = (app.db.find 'organization')[0]
    if organization
      organizationId = organization.idOnServer
      if organization.isCurrentUserAnAdmin
        userActiveRoleId = 'root-user'
      else
        if organization.hasOwnProperty('userActiveRole')
          userActiveRoleId = organization.userActiveRole.serial
        else
          userActiveRoleId = 'root-user'

    # apiActionId = @notifySyncAction 'start', dataApi

    self = this

    # -------------- PHASE 1 -------------------

    rawList = app.db.find collectionName

    # console.log 'rawList', rawList

    headerMap = {}
    for item in rawList
      headerMap[item.serial] = item.lastModifiedDatetimeStamp

    # console.log 'headerMap', headerMap

    deletedRawList = app.db.find deletedCollectionName
    deletedSerialList = (item.serial for item in deletedRawList)

    @callApi headerApi, { apiKey, userId, createdByUserSerial, clientHeaderMap: headerMap, clientDeletedSerialList: deletedSerialList }, (err, response)=>
      if response.hasError
        self.showModalDialog response.error.message
      else
        data = response.data

        
        console.log 'phase1 response', data

        # ----- del -----
        { clientNeedsToDelete, serverHasDeleted } = data

        list = app.db.find deletedCollectionName, ({serial})-> serial in serverHasDeleted
        for item in list
          app.db.remove deletedCollectionName, item._id

        list = app.db.find collectionName, ({serial})-> serial in clientNeedsToDelete
        for item in list
          app.db.remove collectionName, item._id


        # -------------- PHASE 2 -------------------

        requestedServerToClientItemList = data.serverHasLatestList

        clientToServerItemList = app.db.find collectionName, ({serial})-> serial in data.clientHasLatestList

        @callApi dataApi, { organizationId, userActiveRoleId, apiKey, userId, createdByUserSerial, clientToServerItemList, requestedServerToClientItemList }, (err, response)->
          if response.hasError
            self.showModalDialog response.error.message
          else
            data = response.data

            console.log 'phase2 response', data

            { serverToClientItemList } = data

            for item in serverToClientItemList
              app.db.upsert collectionName, item, ({serial})-> item.serial is serial

            # self.notifySyncAction 'done', dataApi, apiActionId
            cbfn()
