(function(){var e=[].indexOf||function(e){for(var r=0,t=this.length;r<t;r++)if(r in this&&this[r]===e)return r;return-1};app.behaviors.local["root-element"]||(app.behaviors.local["root-element"]={}),app.behaviors.local["root-element"].patientsDataSync={_syncPatients:function(r,t){var i,a,n,o,l,s,d,p,c,u,f,h,v,g,m,b,S,A,y,L,D,I,M;for(n=r.collectionName,l=r.deletedCollectionName,c=r.headerApi,o=r.dataApi,D=app.db.find("user")[0],p=D.serial,M=D.idOnServer,a=D.apiKey,b=app.db.find("organization")[0],b&&(S=b.idOnServer,I=b.isCurrentUserAnAdmin?"root-user":b.hasOwnProperty("userActiveRole")?b.userActiveRole.serial:"root-user"),v=app.db.find("patient-list"),g=function(){var e,r,t;for(t=[],e=0,r=v.length;e<r;e++)A=v[e],t.push(A.serial);return t}(),i=this.notifySyncAction("start",o),L=this,y=app.db.find(n),u={},f=0,m=y.length;f<m;f++)h=y[f],u[h.serial]=h.lastModifiedDatetimeStamp;return s=app.db.find(l),d=function(){var e,r,t;for(t=[],e=0,r=s.length;e<r;e++)h=s[e],t.push(h.serial);return t}(),this.callApi(c,{apiKey:a,userId:M,doctorSerial:p,clientHeaderMap:u,clientDeletedSerialList:d,knownPatientSerialList:g},function(r){return function(s,d){var c,u,f,v,g,m,b,A,y,D;if(d.hasError)return r.domHost.showModalDialog(d.error.message);for(f=d.data,c=f.clientNeedsToDelete,D=f.serverHasDeleted,A=app.db.find(l,function(r){var t;return t=r.serial,e.call(D,t)>=0}),v=0,m=A.length;v<m;v++)h=A[v],app.db.remove(l,h._id);for(A=app.db.find(n,function(r){var t;return t=r.serial,e.call(c,t)>=0}),g=0,b=A.length;g<b;g++)h=A[g],app.db.remove(n,h._id);return y=f.serverHasLatestList,u=app.db.find(n,function(r){var t;return t=r.serial,e.call(f.clientHasLatestList,t)>=0}),r.callApi(o,{apiKey:a,userId:M,organizationId:S,userActiveRoleId:I,doctorSerial:p,clientToServerItemList:u,requestedServerToClientItemList:y},function(e,r){var a,l,s,d,p,c,u;if(r.hasError)return this.domHost.showModalDialog(r.error.message);for(f=r.data,u=f.serverToClientItemList,s=0,d=u.length;s<d;s++)h=u[s],app.db.upsert(n,h,function(e){var r;return r=e.serial,h.serial===r});if("changeSerialMap"in f)for(c in changeSerialMap)p=changeSerialMap[c],l=app.db.find(n,function(e){var r;return r=e.serial,c===r}),l.length>0&&(a=l[0],a.serial=p),app.db.upsert(n,a,function(e){var r;return r=e.serial,c===r});return L.notifySyncAction("done",o,i),t()})}}(this))}}}).call(this);
//# sourceMappingURL=behavior-patients-data-sync.coffee-compiled.js.map