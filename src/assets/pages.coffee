
###
  app.pages
###

app.pages = {}

app.pages.pageList = [
 {
    name: 'dashboard'
    element: 'page-dashboard'
    windowTitlePostfix: 'Dashboard'
    headerTitle: 'Dashboard'
    preload: true
    hrefList: [ '/', 'dashboard' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsDetails: false
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'none'
    hideAd: true
  }
  {
    name: 'my-wallet'
    element: 'page-my-wallet'
    windowTitlePostfix: 'my-wallet'
    headerTitle: 'My Wallet'
    preload: true
    hrefList: [ 'wallet' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPrintButton: false
    accessId: 'none'
    showToolbar: true
  }
  {
    name: 'internal'
    element: 'page-internal'
    windowTitlePostfix: 'internal'
    headerTitle: 'Internal'
    preload: true
    hrefList: [ 'internal' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPrintButton: false
    accessId: 'none'
    showToolbar: true
  }
  {
    name: 'send-feedback'
    element: 'page-send-feedback'
    windowTitlePostfix: 'Feedback Section'
    headerTitle: 'Feedback Section'
    preload: true
    hrefList: [ 'send-feedback' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsName: false
    accessId: 'U00020'
    showToolbar: true
  }
  {
    name: 'activate'
    element: 'page-activate'
    windowTitlePostfix: 'Activate'
    headerTitle: 'Activate Code'
    preload: true
    hrefList: [ 'activate' ]
    requireAuthentication : false
    headerType: 'modal'
    leftMenuEnabled: false
    showPatientsDetails: false
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'none'
  }
  {
    name: 'select-organization'
    element: 'page-select-organization'
    windowTitlePostfix: 'Select Organization'
    headerTitle: 'Select Organization'
    preload: true
    hrefList: [ '/', 'select-organization' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: false
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'none'
  }
  {
    name: 'login'
    element: 'page-login'
    windowTitlePostfix: 'Login'
    headerTitle: 'UHCP App'
    preload: true
    hrefList: [ 'login' ]
    requireAuthentication : false
    headerType: 'normal'
    leftMenuEnabled: false
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
  }
  {
    name: 'patient-signup'
    element: 'page-patient-signup'
    windowTitlePostfix: 'patient-signup'
    headerTitle: 'Patient Signup'
    preload: true
    hrefList: [ 'patient-signup' ]
    requireAuthentication : false
    headerType: 'modal'
    leftMenuEnabled: false
    showPatientsDetails: false
    showToolbar: true
    hideHeaderTitle: false
  }
  {
    name: 'patient-manager'
    element: 'page-patient-manager'
    windowTitlePostfix: 'Patient Manager'
    headerTitle: 'Patient Manager'
    preload: true
    hrefList: [ 'patient-manager' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsDetails: false
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'U00023'
  }

  {
    name: 'organization-manage-foc'
    element: 'page-organization-manage-foc'
    windowTitlePostfix: 'Free Of Charge Management'
    headerTitle: 'Free Of Charge Management'
    preload: true
    hrefList: [ 'organization-manage-foc' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: false
    showOrganizationsName: true
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'U0005'
  }
  {
    name: 'chamber-manager'
    element: 'page-chamber-manager'
    windowTitlePostfix: 'Chamber Manager'
    headerTitle: 'Chamber Manager'
    preload: true
    hrefList: [ 'chamber-manager' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsDetails: false
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'D003' 
  }

  {
    name: 'assistant-manager'
    element: 'page-assistant-manager'
    windowTitlePostfix: 'Assistant Manager'
    headerTitle: 'Assistant Manager'
    preload: true
    hrefList: [ 'assistant-manager' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsDetails: false
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'D005'
  }
  {
    name: 'search-record'
    element: 'page-search-record'
    windowTitlePostfix: 'Search Record (Visit)'
    headerTitle: 'Search Record (Visit)'
    preload: true
    hrefList: [ 'search-record' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showPatientsName: false
    accessId: 'D006'
    showToolbar: true
  }
  {
    name: 'booking'
    element: 'page-booking'
    windowTitlePostfix: 'Booking and Services'
    headerTitle: 'Booking and Services'
    preload: true
    hrefList: [ 'booking' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsDetails: false
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'D009'
  }
  {
    name: 'chamber'
    element: 'page-chamber'
    windowTitlePostfix: 'Chamber'
    headerTitle: 'Chamber'
    preload: true
    hrefList: [ 'chamber' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showPatientsDetails: false
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'D003'
  }
  {
    name: 'chamber-patients'
    element: 'page-chamber-patients'
    windowTitlePostfix: 'Chamber: Patients'
    headerTitle: 'Chamber: Patients'
    preload: true
    hrefList: [ 'chamber-patients' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showPatientsDetails: false
    showToolbar: true
    accessId: 'D003'
  }
  {
    name: 'organization-manager'
    element: 'page-organization-manager'
    windowTitlePostfix: 'Organization Manager'
    headerTitle: 'Organization Manager'
    preload: true
    hrefList: [ 'organization-manager' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsDetails: false
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'U0005'
  }
  {
    name: 'organization-records'
    element: 'page-organization-records'
    windowTitlePostfix: 'Organization Records'
    headerTitle: 'Organization Records'
    preload: true
    hrefList: [ 'organization-records' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: false
    showOrganizationsName: true
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'U0005'
  }
  {
    name: 'organization-medicine-sales-statistics'
    element: 'page-organization-medicine-sales-statistics'
    windowTitlePostfix: 'Medicine Sales Statistics'
    headerTitle: 'Medicine Sales Statistics'
    preload: true
    hrefList: [ 'organization-medicine-sales-statistics' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: false
    showOrganizationsName: true
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'U0005'
  }
  {
    name: 'organization-editor'
    element: 'page-organization-editor'
    windowTitlePostfix: 'Organization Editor'
    headerTitle: 'Organization Editor'
    preload: true
    hrefList: [ 'organization-editor' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: true
    showOrganizationsName: true
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'U0005'
  }

  {
    name: 'organization-manage-patient'
    element: 'page-organization-manage-patient'
    windowTitlePostfix: 'Organization Manage Patient'
    headerTitle: 'Organization Manage Patient'
    preload: true
    hrefList: [ 'organization-manage-patient' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: false
    showOrganizationsName: true
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'U0005'
  }

  {
    name: 'organization-manage-users'
    element: 'page-organization-manage-users'
    windowTitlePostfix: 'Organization Manage Users'
    headerTitle: 'Organization Manage Users'
    preload: true
    hrefList: [ 'organization-manage-users' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: false
    showOrganizationsName: true
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'U0005'
  }

  {
    name: 'reports-manager'
    element: 'page-reports-manager'
    windowTitlePostfix: 'Patient Reports'
    headerTitle: 'Patient Reports'
    preload: true
    hrefList: [ 'reports-manager' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsDetails: false
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'D002'
  }

  {
    name: 'uhcp-summary-report'
    element: 'page-uhcp-summary-report'
    windowTitlePostfix: 'UHCP Summary Reports'
    headerTitle: 'UHCP Summary Reports'
    preload: true
    hrefList: [ 'uhcp-summary-report' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsDetails: false
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'U0001'
  }

  {
    name: 'uhcp-all-visits-report'
    element: 'page-uhcp-all-visits-report'
    windowTitlePostfix: 'UHCP Visits Reports'
    headerTitle: 'UHCP Visits Reports'
    preload: true
    hrefList: [ 'uhcp-all-visits-report' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsDetails: false
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'U0002'
  }

  {
    name: 'uhcp-factory-member-list'
    element: 'page-uhcp-factory-member-list'
    windowTitlePostfix: 'UHCP Factory Members List'
    headerTitle: 'UHCP Factory Members List'
    preload: true
    hrefList: [ 'uhcp-factory-member-list' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsDetails: false
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'U0003'
  }

  {
    name: 'upload-organization-patient-list'
    element: 'page-upload-organization-patient-list'
    windowTitlePostfix: 'UHCP Upload Patient List'
    headerTitle: 'UHCP Upload Patient List'
    hrefList: [ 'upload-organization-patient-list' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    hideHeaderTitle: false
    showToolbar: true
  }

  {
    name: 'review-report'
    element: 'page-review-report'
    windowTitlePostfix: 'Review Report'
    headerTitle: 'Review Report'
    preload: true
    hrefList: [ 'review-report' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: false
    showPatientsDetails: false
    hideAd: false
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'D002'
  }

  {
    name: 'pending-report'
    element: 'page-pending-report'
    windowTitlePostfix: 'Pending Report'
    headerTitle: 'Pending Report'
    preload: true
    hrefList: [ 'pending-report' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: false
    showPatientsDetails: false
    hideAd: false
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'D002'
  }
  {
    name: 'patient-editor'
    element: 'page-patient-editor'
    windowTitlePostfix: 'Patient Profile'
    headerTitle: 'Patient Profile'
    preload: true
    hrefList: [ 'patient-editor' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: true
    showPatientsDetails: false
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'U0006'
    # showPrintButton: true
  }

  {
    name: 'patient-viewer'
    element: 'page-patient-viewer'
    windowTitlePostfix: 'Patient'
    headerTitle: 'Patient'
    preload: true
    hrefList: [ 'patient-viewer' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: true
    showToolbar: true
    showTallToolbar: true
    hideHeaderTitle: true
    accessId: 'U0006'
  }

  {
    name: 'medicine-dispension'
    element: 'page-medicine-dispension'
    windowTitlePostfix: 'Medicine Dispension'
    headerTitle: 'Medicine Dispension'
    preload: true
    hrefList: [ 'medicine-dispension' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showPatientsDetails: false
    hideHeaderTitle: false
    accessId: 'D004'
    showToolbar: true
  }

  {
    name: 'print-record'
    element: 'page-print-record'
    windowTitlePostfix: 'Print Record'
    headerTitle: 'Print Record'
    preload: true
    hrefList: [ 'print-record' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: true
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'print-diagnosis'
    element: 'page-print-diagnosis'
    windowTitlePostfix: 'Print Diagnosis'
    headerTitle: 'Print Diagnosis'
    preload: true
    hrefList: [ 'print-diagnosis' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: true
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'print-full-visit'
    element: 'page-print-full-visit'
    windowTitlePostfix: 'Print Full Visit'
    headerTitle: 'Print Full Visit'
    preload: true
    hrefList: [ 'page-print-full-visit' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: true
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'print-anaesmon-record'
    element: 'page-print-anaesmon-record'
    windowTitlePostfix: 'Print Record'
    headerTitle: 'Print Record'
    preload: true
    hrefList: [ 'print-anaesmon-record' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: true
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'print-test-adviced'
    element: 'page-print-test-adviced'
    windowTitlePostfix: 'Print Test Adviced'
    headerTitle: 'Print Test Adviced'
    preload: true
    hrefList: [ 'print-test-adviced' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: true
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'print-test-result-from-clinic-app'
    element: 'page-print-test-result-from-clinic-app'
    windowTitlePostfix: 'Print Test Result'
    headerTitle: 'Print Test Result'
    preload: true
    hrefList: [ 'print-test-result' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: true
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }


  {
    name: 'page-print-current-medicine'
    element: 'page-print-current-medicine'
    windowTitlePostfix: 'Print Current Medicine'
    headerTitle: 'Print Current Medicine'
    preload: true
    hrefList: [ 'print-current-medicine' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: false
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'organization-manage-patient-stay'
    element: 'page-organization-manage-patient-stay'
    windowTitlePostfix: 'Organization Manage Patient Stay'
    headerTitle: 'Organization Manage Patient Stay'
    preload: true
    hrefList: [ 'organization-manage-patient-stay' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: true
    showOrganizationsName: true
    hideHeaderTitle: false
    accessId: 'U0005'
    showToolbar: true
  }
  {
    name: 'organization-manage-waitlist'
    element: 'page-organization-manage-waitlist'
    windowTitlePostfix: 'Organization Manage Waitlist'
    headerTitle: 'Organization Manage Waitlist'
    preload: true
    hrefList: [ 'organization-manage-waitlist' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: false
    showOrganizationsName: true
    hideHeaderTitle: false
    accessId: 'U0005'
    showToolbar: true
  }
  {
    name: 'page-print-old-medicine'
    element: 'page-print-old-medicine'
    windowTitlePostfix: 'Print Old Medicine'
    headerTitle: 'Print Old Medicine'
    preload: true
    hrefList: [ 'print-old-medicine' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: false
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }


  {
    name: 'page-print-both-medicine'
    element: 'page-print-both-medicine'
    windowTitlePostfix: 'Print Both Medicine'
    headerTitle: 'Print Both Medicine'
    preload: true
    hrefList: [ 'print-both-medicine' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: false
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'page-print-vital-bp'
    element: 'page-print-vital-bp'
    windowTitlePostfix: 'Print Vital Blood Pressure'
    headerTitle: 'Print Vital Blood Pressure'
    preload: true
    hrefList: [ 'print-vital-bp' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: false
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'page-print-vital-pr'
    element: 'page-print-vital-pr'
    windowTitlePostfix: 'Print Vital Pulse Rate'
    headerTitle: 'Print Vital Pulse Rate'
    preload: true
    hrefList: [ 'print-vital-pr' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: false
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'page-print-vital-bmi'
    element: 'page-print-vital-bmi'
    windowTitlePostfix: 'Print Vital BMI'
    headerTitle: 'Print Vital BMI'
    preload: true
    hrefList: [ 'print-vital-bmi' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: false
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'page-print-vital-rr'
    element: 'page-print-vital-rr'
    windowTitlePostfix: 'Print Vital RR'
    headerTitle: 'Print Vital RR'
    preload: true
    hrefList: [ 'print-vital-rr' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: false
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'page-print-vital-spo2'
    element: 'page-print-vital-spo2'
    windowTitlePostfix: 'Print Vital spo2'
    headerTitle: 'Print Vital spo2'
    preload: true
    hrefList: [ 'print-vital-spo2' ]
    requireAuthentication : true
    showPatientsDetails: false
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'page-print-vital-temp'
    element: 'page-print-vital-temp'
    windowTitlePostfix: 'Print Vital Temperature'
    headerTitle: 'Print Vital Temperature'
    preload: true
    hrefList: [ 'print-vital-temp' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: false
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'page-print-test-blood-sugar'
    element: 'page-print-test-blood-sugar'
    windowTitlePostfix: 'Print Blood Sugar'
    headerTitle: 'Print Blood Sugar'
    preload: true
    hrefList: [ 'print-blood-sugar' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: false
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'page-print-test-other-test'
    element: 'page-print-test-other-test'
    windowTitlePostfix: 'Print Other Test'
    headerTitle: 'Print Other Test'
    preload: true
    hrefList: [ 'print-other-test' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: false
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'print-history-and-physical-record'
    element: 'page-print-history-and-physical-record'
    windowTitlePostfix: 'Print History and Physical'
    headerTitle: 'Print History and Physical'
    preload: true
    hrefList: [ 'print-history-and-physical-record' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: true
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'record-history-and-physical'
    element: 'page-record-history-and-physical'
    windowTitlePostfix: 'History and Physical'
    headerTitle: 'History and Physical'
    preload: true
    hrefList: [ 'record-history-and-physical' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: true
    showPrintButton: true
    showPatientsDetails: false
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'visit-editor'
    element: 'page-visit-editor'
    windowTitlePostfix: 'Visit'
    headerTitle: 'Visit'
    preload: true
    hrefList: [ 'visit-editor' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: false
    showPatientsDetails: true
    hideAd: false
    showPrintButton: false
    showToolbar: true
    showTallToolbar: true
    hideHeaderTitle: true
    accessId: 'U0007'
  }

  {
    name: 'visit-preview'
    element: 'page-visit-preview'
    windowTitlePostfix: 'Visit Preview'
    headerTitle: 'Visit Preview'
    preload: true
    hrefList: [ 'visit-preview' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: true
    hideAd: false
    showPrintButton: true
    showToolbar: true
    hideHeaderTitle: true
    accessId: 'U0007'
  }

  {
    name: 'test-other'
    element: 'page-test-other-editor'
    windowTitlePostfix: 'Other Test'
    headerTitle: 'Other Test'
    preload: true
    hrefList: [ 'other-test' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: false
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'U00012'
  }

  {
    name: 'test-blood-sugar'
    element: 'page-test-blood-sugar-editor'
    windowTitlePostfix: 'Blood Sugar'
    headerTitle: 'Blood Sugar'
    preload: true
    hrefList: [ 'test-blood-sugar' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: false
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'U00012'
  }

  {
    name: 'settings'
    element: 'page-settings'
    windowTitlePostfix: 'Settings'
    headerTitle: 'Settings'
    preload: true
    hrefList: [ 'settings' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: true
    showPatientsDetails: false
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'U00021'
  }

  {
    name: 'next-visit'
    element: 'page-visit-next-visit-editor'
    windowTitlePostfix: 'Next Visit'
    headerTitle: 'Next Visit'
    preload: true
    hrefList: [ 'next-visit' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: true
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'patient-vitals-editor'
    element: 'page-patient-vitals-editor'
    windowTitlePostfix: 'Vitals'
    headerTitle: 'Vitals'
    preload: true
    hrefList: [ 'patient-vitals-editor' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: false
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'U0009'
  }

  {
    name: 'page-attachement-preview'
    element: 'page-attachement-preview'
    windowTitlePostfix: 'Test Results'
    headerTitle: 'Test Results'
    preload: true
    hrefList: [ 'attachement-preview' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: true
    hideAd: true
    showPatientsDetails: false
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'U00014'
  }

  {
    name: 'notification-panel'
    element: 'page-notification-panel'
    windowTitlePostfix: 'Notfication Panel'
    headerTitle: 'Notfication Panel'
    preload: true
    hrefList: [ 'notification-panel' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    hideHeaderTitle: false
    accessId: 'D011'
    showToolbar: true
  }

  {
    name: 'create-invoice'
    element: 'page-create-invoice'
    windowTitlePostfix: 'Visit Invoice'
    headerTitle: 'Invoice'
    preload: true
    hrefList: [ 'create-invoice' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: false
    showToolbar: true
    hideHeaderTitle: false
    accessId: 'U00011'
  }

  {
    name: 'invoice-report'
    element: 'page-invoice-report'
    windowTitlePostfix: 'Invoice Report'
    headerTitle: 'Invoice Report'
    preload: true
    hrefList: [ 'invoice-report' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showSaveButton: false
    showPatientsDetails: false
    hideHeaderTitle: false
    accessId: 'U00018'
    showToolbar: true
  }

  {
    name: 'pending-invoice'
    element: 'page-pending-invoice'
    windowTitlePostfix: 'Pending Invoices'
    headerTitle: 'Pending Invoices'
    preload: true
    hrefList: [ 'pending-invoice' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showSaveButton: false
    showPatientsDetails: false
    hideHeaderTitle: false
    accessId: 'U00018'
    showToolbar: true
  }

  {
    name: 'print-invoice'
    element: 'page-print-invoice'
    windowTitlePostfix: 'print Invoice'
    headerTitle: 'Invoice'
    preload: true
    hrefList: [ 'print-invoice' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: false
    hideHeaderTitle: false
    accessId: 'U00018'
    showToolbar: true
  }

  {
    name: 'welcome'
    element: 'page-welcome'
    windowTitlePostfix: 'Welcome'
    headerTitle: 'Welcome'
    preload: true
    hrefList: [ 'welcome' ]
    requireAuthentication : false
    headerType: 'normal'
    leftMenuEnabled: false
    showPatientsDetails: false
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }
  {
    name: 'welcome-internal'
    element: 'page-welcome-internal'
    windowTitlePostfix: 'Welcome'
    headerTitle: 'Welcome'
    preload: true
    hrefList: [ 'welcome-internal' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showPatientsDetails: false
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'dev-tools'
    element: 'dev-tools'
    windowTitlePostfix: 'Dev Tools'
    headerTitle: 'Dev Tools'
    preload: true
    hrefList: [ 'dev-tools' ]
    requireAuthentication : false
    headerType: 'normal'
    showPatientsDetails: false
    leftMenuEnabled: false
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'print-preview'
    element: 'page-print-preview'
    windowTitlePostfix: 'Print Preview'
    headerTitle: 'Print Preview'
    preload: true
    hrefList: [ 'print-preview' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: false
    hideAd: false
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'set-unit-price'
    element: 'page-set-unit-price'
    windowTitlePostfix: 'set-unit-price'
    headerTitle: 'Set Price for Unit'
    preload: true
    hrefList: [ 'set-unit-price' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: true
    showPatientsDetails: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'manage-price-list'
    element: 'page-manage-price-list'
    windowTitlePostfix: 'manage-price-list'
    headerTitle: 'Manage Price List'
    preload: true
    hrefList: [ 'manage-price-list' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showSaveButton: true
    showPatientsDetails: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'set-package'
    element: 'page-set-package'
    windowTitlePostfix: 'set-package'
    headerTitle: 'Create Package'
    preload: true
    hrefList: [ 'set-package' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: false
    accessId: 'none'
    showToolbar: true
  }

  {
    name: 'pharmacy-manager'
    element: 'page-pharmacy-manager'
    windowTitlePostfix: 'Pharmacy Manager'
    headerTitle: 'Pharmacy Manager'
    preload: true
    hrefList: [ 'pharmacy-manager' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showSaveButton: false
    showOrganizationsName: true
    accessId: 'D020'
    showToolbar: true
  }

  {
    name: 'print-symptoms'
    element: 'page-print-symptoms'
    windowTitlePostfix: 'Print Symptoms'
    headerTitle: 'Print Symptoms'
    preload: true
    hrefList: [ 'print-symptoms' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: false
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: true
  }

]

app.pages.error404 = {
  name: '404'
  element: 'page-error-404'
  windowTitlePostfix: 'Not Found'
  headerTitle: '404 Not Found'
  preload: true
  href: [ '/404' ]
  requireAuthentication : false
  headerType: 'normal'
  leftMenuEnabled: true
}

app.pages.accessDenied = {
  name: 'access-denied'
  element: 'page-access-denied'
  windowTitlePostfix: 'Access Denied'
  headerTitle: 'Access Denied'
  preload: true
  href: [ '/access-denied' ]
  requireAuthentication : false
  headerType: 'normal'
  leftMenuEnabled: true
}
