Polymer({

  is: 'page-uhcp-factory-member-list',

  behaviors: [
    app.behaviors.dbUsing,
    app.behaviors.translating,
    app.behaviors.pageLike,
    app.behaviors.apiCalling,
    app.behaviors.commonComputes
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

    factoryList: {
      type: Array,
      notify: true,
      value: ["Abloom Design Ltd."]
    },

    factoryMemberList: {
      type: Array,
      notify: true,
      value: []
    },

    loading: {
      type: Boolean,
      value: false
    },

    selectedFactoryId: String

  },


  navigatedIn() {
    this._loadUser()
  },


  _loadUser() {
    const userList = app.db.find('user');
    if (userList.length == 1) this.set('user', userList[0]);
  },

  $getItemCounter(index) {
    return index + 1
  },

  calculateContribution(wallet, balance) {
    return this.$toTwoDecimalPlace(((wallet - balance) * 5) / 100)
  },


  factorySelected(e) {
    const factoryId = e.detail.value;
    this.set('selectedFactoryId', factoryId);
  },


  resetButtonClicked() { return this.domHost.reloadPage(); },

  searchButtonClicked(e) {

    if (!this.selectedFactoryId) {
      this.domHost.showWarningToast('SELECT A FACTORY PLEASE!');
      return;
    }

    let query = {
      apiKey: this.user.apiKey,
      institutionName: this.selectedFactoryId,
    }

    this.loading = true;
    this.callApi('/bdemr--get-user-by-institution-name', query, (err, response) => {
      if (response.hasError) {
        this.domHost.showModalDialog(response.error.message);
        return this.loading = false;
      } else {
        this.set('factoryMemberList', response.data);
        console.log("factory member list", this.factoryMemberList);
        return this.loading = false;
      }
    });
  },

  _prepareJsonData(rawReport) {
    return rawReport.map((item) => {
      return {
        'Employee Id': item.employeeId || '',
        'Name': item.name || '',
        'Age': item.age || '',
        'Gender': item.gender || '',
        'Factory Name': item.factoryName || '',
        'Department': item.department || '',
        'Wallet': item.walletAmount || 0,
        'Remaining Balance': item.remainingBalance || 0,
        'Worker Contribution (5%)': this.calculateContribution(item.walletAmount, item.remainingBalance)
      }
    })
  },

  downloadCsv(csv) {
    var exportedFilenmae = `uhcp-factory-member-list-export-${Date.now()}.csv`
    var blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
    var link = document.createElement("a");
    var url = URL.createObjectURL(blob);
    link.setAttribute("href", url);
    link.setAttribute("download", exportedFilenmae);
    link.style.visibility = 'hidden';
    link.target = '_blank'
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);

  },

  exportButtonClicked() {
    if (!this.factoryMemberList.length) return this.domHost.showModalDialog('No Report')
    const preppedData = this._prepareJsonData(this.factoryMemberList);
    const csvString = Papa.unparse(preppedData);
    this.downloadCsv(csvString)
  }

});