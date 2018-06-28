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

    categoryList: {
      type: Array,
      value() { return ['Symptoms', 'Diagnosis', 'Investigation', 'Medicine']; }
    },

    ageGroupList: {
      type: Array,
      value() {
        return [
          'All',
          '0 to 18',
          '18 to 25',
          '25 to 35',
          '35 to 50',
          '50 to above'
        ];
      }
    },

    salaryRangeList: {
      type: Array,
      value() {
        return [
          "All",
          "0 to 10,000",
          "10,000 to 20,000",
          "20,000 to 30,000",
          "30,000 to 40,000",
          "40,000 to 50,000",
          "50,000 to above"
        ];
      }
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

    totalContributionByReport: {
      type: Number,
      notify: true,
      computed: '_getTotalContributionByReport(reportResults)'
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
    this.organizationLoading = true;
    const query = {
      apiKey: this.user.apiKey,
      organizationId: organizationIdentifier
    }
    this.callApi('/bdemr--get-child-organization-list', query, (err, response) => {
      this.organizationLoading = false;
      const organizationList = response.data
      if (organizationList.length) {
        const mappedValue = organizationList.map((item) => {
          return { label: item.name, value: item._id }
        })
        mappedValue.unshift({ label: 'All', value: '' })
        this.set('childOrganizationList', mappedValue)
      } else {
        this.domHost.showToast('No Child Organization Found')
      }
    })
  },

  $getItemCounter(index) {
    return index + 1
  },

  $formatDateTime(dateTime) {
    if (!dateTime) return;
    return lib.datetime.format((new Date(dateTime)), 'mmm d, yyyy h:MMTT')
  },

  organizationSelected(e) {
    const organizationId = e.detail.value;
    this.set('selectedOrganizationId', organizationId)
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
    return invoice && invoice.data.length ? invoice.data.filter((invoiceItem) => category.toLowerCase() == invoiceItem.category.toLowerCase()).reduce((totalCost, invoiceItem) => totalCost + (invoiceItem.price ? (parseFloat(invoiceItem.price) * invoiceItem.qty) : 0), 0) : 0
  },

  $getTotalCost(invoice) {
    return invoice && invoice.totalBilled ? parseFloat(invoice.totalBilled) : 0
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

  totalContributionByReport(reports) {
    return reports.reduce((total, item) => {
      return total + item.chargedToWallet
    }, 0)
  },

  resetButtonClicked() { return this.domHost.reloadPage(); },

  genderSelected(e) {
    const index = e.detail.selected;
    let gender;
    if (index == 1) {
      gender = 'male'
    } else if (index == 2) {
      gender = 'female'
    } else {
      gender = ''
    }
    return this.set('selectedGender', gender);
  },

  _createAgeGroupFromString(ageGroupString) {
    const ageGroupStringArr = ageGroupString.split('to');
    const fromAge = parseInt(ageGroupStringArr[0]);
    const toAge = (isNaN(parseInt(ageGroupStringArr[1])) ? 999 : (parseInt(ageGroupStringArr[1])));
    return [fromAge, toAge];
  },

  ageGroupSelected(e) {
    const index = e.detail.selected;
    let selectedAgeGroup;
    if (index == 0) {
      // all selected
      selectedAgeGroup = []
    } else {
      let selectedAgeGroupString = this.ageGroupList[index];
      selectedAgeGroup = this._createAgeGroupFromString(selectedAgeGroupString);
    }
    return this.set('selectedAgeGroup', selectedAgeGroup);
  },


  _createSalarRangeFromString(salaryRangeString) {
    const salaryRangeStringArr = salaryRangeString.split('to');
    salaryRangeStringArr.splice(0, 1, (salaryRangeStringArr[0].split(",").join("")));
    salaryRangeStringArr.splice(1, 1, (salaryRangeStringArr[1].split(",").join("")));
    const fromSalary = (isNaN(parseInt(salaryRangeStringArr[0])) ? 0 : (parseInt(salaryRangeStringArr[0])));
    const toSalary = (isNaN(parseInt(salaryRangeStringArr[1])) ? 99999999999 : (parseInt(salaryRangeStringArr[1])));
    return [fromSalary, toSalary];
  },

  salaryRangeSelected(e) {
    const index = e.detail.selected;
    let selectedSalaryRange;
    if (index == 0) {
      // all selected
      selectedSalaryRange = []
    } else {
      let selectedSalaryRangeString = this.salaryRangeList[index];
      selectedSalaryRange = this._createSalarRangeFromString(selectedSalaryRangeString);
    }
    return this.set('selectedSalaryRange', selectedSalaryRange);
  },

  searchButtonClicked() {
    let query = {
      apiKey: this.user.apiKey,
      searchParameters: {
        dateCreatedFrom: this.dateCreatedFrom || '',
        dateCreatedTo: this.dateCreatedTo || '',
        searchString: this.searchString || '',
        gender: this.selectedGender || '',
        ageGroup: this.selectedAgeGroup || [],
        salaryRange: this.selectedSalaryRange || []
      }
    }
    // search parent+child when selecting all
    // if (!this.selectedOrganizationId) {
    //   organizationIdList = this.childOrganizationList.map(item => item.value);
    //   organizationIdList.splice(0, 1, this.organization.idOnServer)
    //   query.organizationIdList = organizationIdList
    // } else {
    //   query.organizationIdList = [this.selectedOrganizationId]
    // }
    if (this.selectedOrganizationId) {
      query.organizationIdList = [this.selectedOrganizationId]
    } else {
      query.organizationIdList = []
    }

    this.loading = true;
    this.callApi('/uhcp--get-visit-reports', query, (err, response) => {
      if (response.hasError) {
        this.domHost.showModalDialog(response.error.message);
        return this.loading = false;
      } else {
        this.set('reportResults', response.data);
        return this.loading = false;
      }
    });
  },

  _prepareJsonData(rawReport) {
    return rawReport.map((item) => {
      return {
        'EmployeeId': item.patientInfo ? item.patientInfo.employeeId : '',
        'Name': item.patientInfo ? item.patientInfo.name : '',
        'Age': item.patientInfo ? this.$computeAge(item.patientInfo.dateOfBirth) : '',
        'Gender': item.patientInfo ? item.patientInfo.gender : '',
        'Consultation Site': item.organizationInfo ? item.organizationInfo.name : '',
        'Visit Date': this.$formatDateTime(item.visit.createdDatetimeStamp),
        'Symptoms': item.symptoms ? item.symptoms.symptomsList.map(item => item.name) : '',
        'Diagnosis': item.diagnosis ? item.diagnosis.diagnosisList.map(item => item.name) : '',
        'Test Advise': item.advisedTests ? item.advisedTests.testAdvisedList.map(item => item.investigationName) : '',
        referral: `${item.referral ? item.referral.doctorName : ''} - ${item.referral ? item.referral.doctorName : ''}`,
        treatment: item.medication ? item.medication.map(item => item.data.brandName) : '',
        'Cost of Drug': this.$getCategoryCost('Medicine', item.invoice),
        'Cost of Investigation': this.$getCategoryCost('Investigation', item.invoice),
        'Cost of Consultancy': this.$getCategoryCost('Consultancy', item.invoice),
        'Total Cost': this.$getTotalCost(item.invoice)
      }
    })
  },

  downloadCsv(csv) {
    var exportedFilenmae = 'uhcp-visit-report-export.csv';
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
    if (!this.reportResults.length) return this.domHost.showModalDialog('Search for a Report First')
    const preppedData = this._prepareJsonData(this.reportResults);
    const csvString = Papa.unparse(preppedData);
    this.downloadCsv(csvString)
  }

});