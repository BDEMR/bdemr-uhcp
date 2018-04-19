Polymer({

  is: 'page-uhcp-all-visits-report',

  behaviors: [
    app.behaviors.dbUsing,
    app.behaviors.translating,
    app.behaviors.pageLike,
    app.behaviors.apiCalling
  ],

  properties: {

    user: {
      type: Object,
      notify: true,
      value: null
    },

    organization: {
      type: Object,
      notify: true,
      value: null
    },

    loading: {
      type: Boolean,
      value: false
    },

    reportResults: {
      type: Array,
      value: []
    },

    dateCreatedFrom: String,
    dateCreatedTo: String,
    selectedGender: String,
    selectedOrganizationId: String

  },


  navigatedIn() {
    this._loadUser()
    this._loadOrganization()
  },


  _loadUser() {
    const userList = app.db.find('user');
    if (userList.length == 1) this.set('user', userList[0]);
  },


  _loadOrganization() {
    const organizationList = app.db.find('organization');
    if (organizationList.length === 1) {
      return this.set('organization', organizationList[0]);
    }
  },

  $formatDateTime(dateTime) {
    if (!dateTime) return;
    return lib.datetime.format((new Date(dateTime)), 'mmm d, yyyy h:MMTT')
  },

  organizationSelected(e) {
    const orgnizationId = e.detail.selected
    this.set('selectedOrganizationId', organizationId)
  },

  genderSelected(e) {
    const index = e.detail.selected;
    const gender = (() => {
      switch (index) {
        case 1: return 'male';
        case 2: return 'female';
        default: return '';
      }
    })();
    return this.set('selectedGender', gender);
  },

  filterByDateClicked(e) {
    const startDate = new Date(e.detail.startDate);
    startDate.setHours(0, 0, 0, 0);
    const endDate = new Date(e.detail.endDate);
    endDate.setHours(23, 59, 59, 999);
    this.set('dateCreatedFrom', (startDate.getTime()));
    return this.set('dateCreatedTo', (endDate.getTime()));
  },

  filterByDateClearButtonClicked() {
    this.dateCreatedFrom = 0;
    return this.dateCreatedTo = 0;
  },

  resetButtonClicked() { return this.domHost.reloadPage(); },

  searchButtonClicked() {
    const query = {
      apiKey: this.user.apiKey,
      organizationId: this.organization.idOnServer,
      searchParameters: {
        dateCreatedFrom: this.dateCreatedFrom || '',
        dateCreatedTo: this.dateCreatedTo || '',
        gender: this.selectedGender || 'all'
      }
    }
    this.loading = true;
    this.callApi('/uhcp--get-visit-reports', query, (err, response) => {
      if (response.hasError) {
        this.domHost.showModalDialog(response.error.message);
        return this.loading = false;
      } else {
        this.set('reportResults', response.data);
        console.log(this.reportResults);
        return this.loading = false;
      }
    });
  }



});