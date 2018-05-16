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

    childOrganizationList: {
      type: Array,
      notify: true,
      value: []
    },

    loading: {
      type: Boolean,
      value: false
    },

    reportResults: {
      type: Array,
      value: []
    },

    totalCostByReport: {
      type: Number,
      notify: true,
      computed: '_getTotalCostByReport(reportResults)'
    },

    totalDrugCostByReport: {
      type: Number,
      notify: true,
      computed: '_getTotalCategoryCostByReport("Medicine", reportResults)'
    },

    totalInvestigationCostByReport: {
      type: Number,
      notify: true,
      computed: '_getTotalCategoryCostByReport("Investigation", reportResults)'
    },

    totalConsultancyCostByReport: {
      type: Number,
      notify: true,
      computed: '_getTotalCategoryCostByReport("Consultancy" ,reportResults)'
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
      this.set('organization', organizationList[0]);
      this._loadChildOrganizationList(this.organization.idOnServer)
    }

  },

  _loadChildOrganizationList(organizationIdentifier) {
    this.loading = true;
    const query = {
      apiKey: this.user.apiKey,
      organizationId: organizationIdentifier
    }
    this.callApi('/bdemr--get-child-organization-list', query, (err, response) => {
      this.loading = false;
      if (response.data.length) {
        this.set('childOrganizationList', response.data)
      } else {
        this.domHost.showToast('No Child Organization Found')
      }
    })
  },

  $formatDateTime(dateTime) {
    if (!dateTime) return;
    return lib.datetime.format((new Date(dateTime)), 'mmm d, yyyy h:MMTT')
  },

  organizationSelected(e) {
    const organizationId = e.detail.selected;
    this.set('selectedOrganizationId', organizationId)
    console.log(e.detail.selected)
  },

  filterByDateClicked(e) {
    const startDate = new Date(e.detail.startDate);
    startDate.setHours(0, 0, 0, 0);
    const endDate = new Date(e.detail.endDate);
    endDate.setHours(23, 59, 59, 999);
    this.set('dateCreatedFrom', (startDate.getTime()));
    this.set('dateCreatedTo', (endDate.getTime()));
  },

  filterByDateClearButtonClicked() {
    this.dateCreatedFrom = 0;
    this.dateCreatedTo = 0;
  },

  $getCategoryCost(category, invoice) {
    return invoice ? invoice.data.filter((invoiceItem) => category == invoiceItem.category).reduce((totalCost, invoiceItem) => totalCost + invoiceItem.price, 0) : 0
  },

  $getTotalCost(invoice) {
    return invoice ? invoice.totalBilled : 0
  },

  $computeAge(dateString) {
    if (!dateString) { return ""; }
    const today = new Date();
    const birthDate = new Date(dateString);
    let age = today.getFullYear() - birthDate.getFullYear();
    const m = today.getMonth() - birthDate.getMonth();
    if ((m < 0) || ((m === 0) && (today.getDate() < birthDate.getDate()))) {
      age--;
    }
    return age;
  },

  _getTotalCostByReport(reports) {
    return reports.reduce((total, item) => {
      return total + this.$getTotalCost(item.invoice)
    }, 0)
  },

  _getTotalCategoryCostByReport(category, reports) {
    return reports.reduce((total, item) => {
      return total + this.$getCategoryCost(category, item.invoice)
    }, 0)
  },

  resetButtonClicked() { return this.domHost.reloadPage(); },

  searchButtonClicked() {
    const query = {
      apiKey: this.user.apiKey,
      organizationId: this.selectedOrganizationId,
      searchParameters: {
        dateCreatedFrom: this.dateCreatedFrom || '',
        dateCreatedTo: this.dateCreatedTo || '',
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