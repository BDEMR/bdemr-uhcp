
unless app.behaviors.local['root-element']
  app.behaviors.local['root-element'] = {}
app.behaviors.local['root-element'].patientsDataSync =

  _syncPatients: (params, cbfn)->

    {collectionName, deletedCollectionName, headerApi, dataApi} = params

    user = (app.db.find 'user')[0]
    doctorSerial = user.serial
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

    knownPatientList = app.db.find 'patient-list'
    knownPatientSerialList = (patient.serial for patient in knownPatientList)

    apiActionId = @notifySyncAction 'start', dataApi
    self = this
    # -------------- PHASE 1 -------------------

    rawList = app.db.find collectionName

    console.log collectionName, ': ', 'rawList', rawList

    headerMap = {}
    for item in rawList
      headerMap[item.serial] = item.lastModifiedDatetimeStamp

    console.log collectionName, ': ', 'headerMap', headerMap

    deletedRawList = app.db.find deletedCollectionName
    deletedSerialList = (item.serial for item in deletedRawList)

    @callApi headerApi, { apiKey, userId, doctorSerial, clientHeaderMap: headerMap, clientDeletedSerialList: deletedSerialList, knownPatientSerialList: knownPatientSerialList }, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        data = response.data

        console.log 'USER p1 HEADER DATA:', response.data

        console.log collectionName, ': ', 'phase1 response', data

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

        @callApi dataApi, { apiKey, userId, organizationId, userActiveRoleId, doctorSerial, clientToServerItemList, requestedServerToClientItemList }, (err, response)->
          if response.hasError
            @domHost.showModalDialog response.error.message
          else
            data = response.data

            console.log collectionName, ': ', 'phase2 response', data

            { serverToClientItemList } = data

            for item in serverToClientItemList
              app.db.upsert collectionName, item, ({serial})-> item.serial is serial

            if 'changeSerialMap' of data
              for oldSerial, newSerial of changeSerialMap
                docList = app.db.find collectionName, ({serial})-> oldSerial is serial
                if docList.length > 0
                  doc = docList[0]
                  doc.serial = newSerial
                app.db.upsert collectionName, doc, ({serial})-> oldSerial is serial

            self.notifySyncAction 'done', dataApi, apiActionId
            cbfn()