(function(){app.pages={},app.pages.pageList=[{name:"dashboard",element:"page-dashboard",windowTitlePostfix:"Dashboard",headerTitle:"Dashboard",preload:!0,hrefList:["/","dashboard"],requireAuthentication:!0,headerType:"normal",leftMenuEnabled:!0,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"none",hideAd:!0,accessId:"none"},{name:"my-wallet",element:"page-my-wallet",windowTitlePostfix:"my-wallet",headerTitle:"My Wallet",preload:!0,hrefList:["wallet"],requireAuthentication:!0,headerType:"normal",leftMenuEnabled:!0,showPrintButton:!1,accessId:"none",showToolbar:!0},{name:"internal",element:"page-internal",windowTitlePostfix:"internal",headerTitle:"Internal",preload:!0,hrefList:["internal"],requireAuthentication:!0,headerType:"normal",leftMenuEnabled:!0,showPrintButton:!1,accessId:"none",showToolbar:!0},{name:"send-feedback",element:"page-send-feedback",windowTitlePostfix:"Feedback Section",headerTitle:"Feedback Section",preload:!0,hrefList:["send-feedback"],requireAuthentication:!0,headerType:"normal",leftMenuEnabled:!0,showPatientsName:!1,accessId:"D012",showToolbar:!0},{name:"activate",element:"page-activate",windowTitlePostfix:"Activate",headerTitle:"Activate Code",preload:!0,hrefList:["activate"],requireAuthentication:!1,headerType:"modal",leftMenuEnabled:!1,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"none"},{name:"select-organization",element:"page-select-organization",windowTitlePostfix:"Select Organization",headerTitle:"Select Organization",preload:!0,hrefList:["/","select-organization"],requireAuthentication:!0,headerType:"normal",leftMenuEnabled:!1,showPatientsDetails:!1,showToolbar:!1,hideHeaderTitle:!1,accessId:"none"},{name:"login",element:"page-login",windowTitlePostfix:"Login",headerTitle:"UHCP App",preload:!0,hrefList:["login"],requireAuthentication:!1,headerType:"normal",leftMenuEnabled:!1,showPatientsDetails:!1,showToolbar:!1,hideHeaderTitle:!1},{name:"patient-signup",element:"page-patient-signup",windowTitlePostfix:"patient-signup",headerTitle:"Patient Signup",preload:!0,hrefList:["patient-signup"],requireAuthentication:!1,headerType:"modal",leftMenuEnabled:!1,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1},{name:"patient-manager",element:"page-patient-manager",windowTitlePostfix:"Patient Manager",headerTitle:"Patient Manager",preload:!0,hrefList:["patient-manager"],requireAuthentication:!0,headerType:"normal",leftMenuEnabled:!0,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"D001"},{name:"organization-manage-foc",element:"page-organization-manage-foc",windowTitlePostfix:"Free Of Charge Management",headerTitle:"Free Of Charge Management",preload:!0,hrefList:["organization-manage-foc"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!0,showSaveButton:!1,showOrganizationsName:!0,showToolbar:!0,hideHeaderTitle:!1,accessId:"D010"},{name:"chamber-manager",element:"page-chamber-manager",windowTitlePostfix:"Chamber Manager",headerTitle:"Chamber Manager",preload:!0,hrefList:["chamber-manager"],requireAuthentication:!0,headerType:"normal",leftMenuEnabled:!0,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"D003"},{name:"assistant-manager",element:"page-assistant-manager",windowTitlePostfix:"Assistant Manager",headerTitle:"Assistant Manager",preload:!0,hrefList:["assistant-manager"],requireAuthentication:!0,headerType:"normal",leftMenuEnabled:!0,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"D005"},{name:"search-record",element:"page-search-record",windowTitlePostfix:"Search Record (Visit)",headerTitle:"Search Record (Visit)",preload:!0,hrefList:["search-record"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showPatientsName:!1,accessId:"D006",showToolbar:!0},{name:"booking",element:"page-booking",windowTitlePostfix:"Booking and Services",headerTitle:"Booking and Services",preload:!0,hrefList:["booking"],requireAuthentication:!0,headerType:"normal",leftMenuEnabled:!0,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"D009"},{name:"chamber",element:"page-chamber",windowTitlePostfix:"Chamber",headerTitle:"Chamber",preload:!0,hrefList:["chamber"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"D003"},{name:"chamber-patients",element:"page-chamber-patients",windowTitlePostfix:"Chamber: Patients",headerTitle:"Chamber: Patients",preload:!0,hrefList:["chamber-patients"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showPatientsDetails:!1,showToolbar:!0,accessId:"D003"},{name:"organization-manager",element:"page-organization-manager",windowTitlePostfix:"Organization Manager",headerTitle:"Organization Manager",preload:!0,hrefList:["organization-manager"],requireAuthentication:!0,headerType:"normal",leftMenuEnabled:!0,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"D010"},{name:"organization-records",element:"page-organization-records",windowTitlePostfix:"Organization Records",headerTitle:"Organization Records",preload:!0,hrefList:["organization-records"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!0,showSaveButton:!1,showOrganizationsName:!0,showToolbar:!0,hideHeaderTitle:!1,accessId:"D010"},{name:"organization-medicine-sales-statistics",element:"page-organization-medicine-sales-statistics",windowTitlePostfix:"Medicine Sales Statistics",headerTitle:"Medicine Sales Statistics",preload:!0,hrefList:["organization-medicine-sales-statistics"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!0,showSaveButton:!1,showOrganizationsName:!0,showToolbar:!0,hideHeaderTitle:!1,accessId:"D010"},{name:"organization-editor",element:"page-organization-editor",windowTitlePostfix:"Organization Editor",headerTitle:"Organization Editor",preload:!0,hrefList:["organization-editor"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!0,showSaveButton:!0,showOrganizationsName:!0,showToolbar:!0,hideHeaderTitle:!1,accessId:"D010"},{name:"organization-manage-patient",element:"page-organization-manage-patient",windowTitlePostfix:"Organization Manage Patient",headerTitle:"Organization Manage Patient",preload:!0,hrefList:["organization-manage-patient"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!0,showSaveButton:!1,showOrganizationsName:!0,showToolbar:!0,hideHeaderTitle:!1,accessId:"D010"},{name:"organization-manage-users",element:"page-organization-manage-users",windowTitlePostfix:"Organization Manage Users",headerTitle:"Organization Manage Users",preload:!0,hrefList:["organization-manage-users"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!0,showSaveButton:!1,showOrganizationsName:!0,showToolbar:!0,hideHeaderTitle:!1,accessId:"D010"},{name:"reports-manager",element:"page-reports-manager",windowTitlePostfix:"Patient Reports",headerTitle:"Patient Reports",preload:!0,hrefList:["reports-manager"],requireAuthentication:!0,headerType:"normal",leftMenuEnabled:!0,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"D002"},{name:"uhcp-summary-report",element:"page-uhcp-summary-report",windowTitlePostfix:"UHCP Summary Reports",headerTitle:"UHCP Summary Reports",preload:!0,hrefList:["uhcp-summary-report"],requireAuthentication:!0,headerType:"normal",leftMenuEnabled:!0,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"R001"},{name:"uhcp-all-visits-report",element:"page-uhcp-all-visits-report",windowTitlePostfix:"UHCP Visits Reports",headerTitle:"UHCP Visits Reports",preload:!0,hrefList:["uhcp-all-visits-report"],requireAuthentication:!0,headerType:"normal",leftMenuEnabled:!0,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"R002"},{name:"upload-organization-patient-list",element:"page-upload-organization-patient-list",windowTitlePostfix:"UHCP Upload Patient List",headerTitle:"UHCP Upload Patient List",hrefList:["upload-organization-patient-list"],requireAuthentication:!0,headerType:"normal",leftMenuEnabled:!0,hideHeaderTitle:!1,showToolbar:!0},{name:"review-report",element:"page-review-report",windowTitlePostfix:"Review Report",headerTitle:"Review Report",preload:!0,hrefList:["review-report"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPrintButton:!1,showPatientsDetails:!1,hideAd:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"D002"},{name:"pending-report",element:"page-pending-report",windowTitlePostfix:"Pending Report",headerTitle:"Pending Report",preload:!0,hrefList:["pending-report"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPrintButton:!1,showPatientsDetails:!1,hideAd:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"D002"},{name:"patient-editor",element:"page-patient-editor",windowTitlePostfix:"Patient Profile",headerTitle:"Patient Profile",preload:!0,hrefList:["patient-editor"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!0,showSaveButton:!0,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"D001"},{name:"ndr-editor",element:"page-ndr-editor",windowTitlePostfix:"NDR",headerTitle:"NDR Form",preload:!0,hrefList:["ndr"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!0,showSaveButton:!1,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"D001"},{name:"preconception-record",element:"page-preconception-record",windowTitlePostfix:"Preconception Record",headerTitle:"PCC Record",preload:!0,hrefList:["preconception-record"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!0,showSaveButton:!1,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"none",showPrintButton:!1,hideAd:!1},{name:"patient-viewer",element:"page-patient-viewer",windowTitlePostfix:"Patient",headerTitle:"Patient",preload:!0,hrefList:["patient-viewer"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPatientsDetails:!0,showToolbar:!0,showTallToolbar:!0,hideHeaderTitle:!0,accessId:"D014"},{name:"medicine-dispension",element:"page-medicine-dispension",windowTitlePostfix:"Medicine Dispension",headerTitle:"Medicine Dispension",preload:!0,hrefList:["medicine-dispension"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!0,showPatientsDetails:!1,hideHeaderTitle:!1,accessId:"D004",showToolbar:!0},{name:"print-record",element:"page-print-record",windowTitlePostfix:"Print Record",headerTitle:"Print Record",preload:!0,hrefList:["print-record"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPrintButton:!0,showPatientsDetails:!0,hideAd:!0,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"print-diagnosis",element:"page-print-diagnosis",windowTitlePostfix:"Print Diagnosis",headerTitle:"Print Diagnosis",preload:!0,hrefList:["print-diagnosis"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPrintButton:!0,showPatientsDetails:!0,hideAd:!0,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"print-full-visit",element:"page-print-full-visit",windowTitlePostfix:"Print Full Visit",headerTitle:"Print Full Visit",preload:!0,hrefList:["page-print-full-visit"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPrintButton:!0,showPatientsDetails:!0,hideAd:!0,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"print-anaesmon-record",element:"page-print-anaesmon-record",windowTitlePostfix:"Print Record",headerTitle:"Print Record",preload:!0,hrefList:["print-anaesmon-record"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPrintButton:!0,showPatientsDetails:!0,hideAd:!0,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"print-test-adviced",element:"page-print-test-adviced",windowTitlePostfix:"Print Test Adviced",headerTitle:"Print Test Adviced",preload:!0,hrefList:["print-test-adviced"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPrintButton:!0,showPatientsDetails:!0,hideAd:!0,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"print-test-result-from-clinic-app",element:"page-print-test-result-from-clinic-app",windowTitlePostfix:"Print Test Result",headerTitle:"Print Test Result",preload:!0,hrefList:["print-test-result"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPrintButton:!0,showPatientsDetails:!0,hideAd:!0,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"page-print-current-medicine",element:"page-print-current-medicine",windowTitlePostfix:"Print Current Medicine",headerTitle:"Print Current Medicine",preload:!0,hrefList:["print-current-medicine"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPrintButton:!0,showPatientsDetails:!1,hideAd:!0,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"organization-manage-patient-stay",element:"page-organization-manage-patient-stay",windowTitlePostfix:"Organization Manage Patient Stay",headerTitle:"Organization Manage Patient Stay",preload:!0,hrefList:["organization-manage-patient-stay"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!0,showSaveButton:!0,showOrganizationsName:!0,hideHeaderTitle:!1,accessId:"D010",showToolbar:!0},{name:"organization-manage-waitlist",element:"page-organization-manage-waitlist",windowTitlePostfix:"Organization Manage Waitlist",headerTitle:"Organization Manage Waitlist",preload:!0,hrefList:["organization-manage-waitlist"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!0,showSaveButton:!1,showOrganizationsName:!0,hideHeaderTitle:!1,accessId:"D010",showToolbar:!0},{name:"page-print-old-medicine",element:"page-print-old-medicine",windowTitlePostfix:"Print Old Medicine",headerTitle:"Print Old Medicine",preload:!0,hrefList:["print-old-medicine"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPrintButton:!0,showPatientsDetails:!1,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"page-print-both-medicine",element:"page-print-both-medicine",windowTitlePostfix:"Print Both Medicine",headerTitle:"Print Both Medicine",preload:!0,hrefList:["print-both-medicine"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPrintButton:!0,showPatientsDetails:!1,hideAd:!0,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"page-print-vital-bp",element:"page-print-vital-bp",windowTitlePostfix:"Print Vital Blood Pressure",headerTitle:"Print Vital Blood Pressure",preload:!0,hrefList:["print-vital-bp"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPrintButton:!0,showPatientsDetails:!1,hideAd:!0,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"page-print-vital-pr",element:"page-print-vital-pr",windowTitlePostfix:"Print Vital Pulse Rate",headerTitle:"Print Vital Pulse Rate",preload:!0,hrefList:["print-vital-pr"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPrintButton:!0,showPatientsDetails:!1,hideAd:!0,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"page-print-vital-bmi",element:"page-print-vital-bmi",windowTitlePostfix:"Print Vital BMI",headerTitle:"Print Vital BMI",preload:!0,hrefList:["print-vital-bmi"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPrintButton:!0,showPatientsDetails:!1,hideAd:!0,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"page-print-vital-rr",element:"page-print-vital-rr",windowTitlePostfix:"Print Vital RR",headerTitle:"Print Vital RR",preload:!0,hrefList:["print-vital-rr"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPrintButton:!0,showPatientsDetails:!1,hideAd:!0,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"page-print-vital-spo2",element:"page-print-vital-spo2",windowTitlePostfix:"Print Vital spo2",headerTitle:"Print Vital spo2",preload:!0,hrefList:["print-vital-spo2"],requireAuthentication:!0,showPatientsDetails:!1,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPrintButton:!0,hideAd:!0,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"page-print-vital-temp",element:"page-print-vital-temp",windowTitlePostfix:"Print Vital Temperature",headerTitle:"Print Vital Temperature",preload:!0,hrefList:["print-vital-temp"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPrintButton:!0,showPatientsDetails:!1,hideAd:!0,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"page-print-test-blood-sugar",element:"page-print-test-blood-sugar",windowTitlePostfix:"Print Blood Sugar",headerTitle:"Print Blood Sugar",preload:!0,hrefList:["print-blood-sugar"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPrintButton:!0,showPatientsDetails:!1,hideAd:!0,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"page-print-test-other-test",element:"page-print-test-other-test",windowTitlePostfix:"Print Other Test",headerTitle:"Print Other Test",preload:!0,hrefList:["print-other-test"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPrintButton:!0,showPatientsDetails:!1,hideAd:!0,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"print-history-and-physical-record",element:"page-print-history-and-physical-record",windowTitlePostfix:"Print History and Physical",headerTitle:"Print History and Physical",preload:!0,hrefList:["print-history-and-physical-record"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPrintButton:!0,showPatientsDetails:!0,hideAd:!0,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"record-history-and-physical",element:"page-record-history-and-physical",windowTitlePostfix:"History and Physical",headerTitle:"History and Physical",preload:!0,hrefList:["record-history-and-physical"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!0,showSaveButton:!0,showPrintButton:!0,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"none"},{name:"visit-editor",element:"page-visit-editor",windowTitlePostfix:"Visit",headerTitle:"Visit",preload:!0,hrefList:["visit-editor"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!0,showSaveButton:!1,showPatientsDetails:!0,hideAd:!1,showPrintButton:!1,showToolbar:!0,showTallToolbar:!0,hideHeaderTitle:!0,accessId:"D014"},{name:"visit-preview",element:"page-visit-preview",windowTitlePostfix:"Visit Preview",headerTitle:"Visit Preview",preload:!0,hrefList:["visit-preview"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPatientsDetails:!0,hideAd:!1,showPrintButton:!0,showToolbar:!0,hideHeaderTitle:!0,accessId:"D014"},{name:"test-other",element:"page-test-other-editor",windowTitlePostfix:"Other Test",headerTitle:"Other Test",preload:!0,hrefList:["other-test"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"none"},{name:"test-blood-sugar",element:"page-test-blood-sugar-editor",windowTitlePostfix:"Blood Sugar",headerTitle:"Blood Sugar",preload:!0,hrefList:["test-blood-sugar"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"none"},{name:"settings",element:"page-settings",windowTitlePostfix:"Settings",headerTitle:"Settings",preload:!0,hrefList:["settings"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!0,showSaveButton:!0,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"none"},{name:"next-visit",element:"page-visit-next-visit-editor",windowTitlePostfix:"Next Visit",headerTitle:"Next Visit",preload:!0,hrefList:["next-visit"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPatientsDetails:!0,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"patient-vitals-editor",element:"page-patient-vitals-editor",windowTitlePostfix:"Vitals",headerTitle:"Vitals",preload:!0,hrefList:["patient-vitals-editor"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"none"},{name:"page-attachement-preview",element:"page-attachement-preview",windowTitlePostfix:"Test Results",headerTitle:"Test Results",preload:!0,hrefList:["attachement-preview"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPrintButton:!0,showPatientsDetails:!0,hideAd:!0,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"none"},{name:"notification-panel",element:"page-notification-panel",windowTitlePostfix:"Notfication Panel",headerTitle:"Notfication Panel",preload:!0,hrefList:["notification-panel"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,hideHeaderTitle:!1,accessId:"D011",showToolbar:!0},{name:"visit-invoice",element:"page-visit-invoice",windowTitlePostfix:"Visit Invoice",headerTitle:"Invoice",preload:!0,hrefList:["visit-invoice"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"none"},{name:"create-invoice",element:"page-create-invoice",windowTitlePostfix:"Visit Invoice",headerTitle:"Invoice",preload:!0,hrefList:["create-invoice"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPatientsDetails:!1,showToolbar:!0,hideHeaderTitle:!1,accessId:"none"},{name:"invoice-manager",element:"page-invoice-manager",windowTitlePostfix:"Invoice Manager",headerTitle:"Invoice Manager",preload:!0,hrefList:["invoice-manager"],requireAuthentication:!0,headerType:"normal",leftMenuEnabled:!0,showSaveButton:!1,showPatientsDetails:!1,hideHeaderTitle:!1,accessId:"D007",showToolbar:!0},{name:"print-invoice",element:"page-print-invoice",windowTitlePostfix:"print Invoice",headerTitle:"Invoice",preload:!0,hrefList:["print-invoice"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPatientsDetails:!1,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"welcome",element:"page-welcome",windowTitlePostfix:"Welcome",headerTitle:"Welcome",preload:!0,hrefList:["welcome"],requireAuthentication:!1,headerType:"normal",leftMenuEnabled:!1,showPatientsDetails:!1,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"welcome-internal",element:"page-welcome-internal",windowTitlePostfix:"Welcome",headerTitle:"Welcome",preload:!0,hrefList:["welcome-internal"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showPatientsDetails:!1,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"dev-tools",element:"dev-tools",windowTitlePostfix:"Dev Tools",headerTitle:"Dev Tools",preload:!0,hrefList:["dev-tools"],requireAuthentication:!1,headerType:"normal",showPatientsDetails:!1,leftMenuEnabled:!1,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"print-preview",element:"page-print-preview",windowTitlePostfix:"Print Preview",headerTitle:"Print Preview",preload:!0,hrefList:["print-preview"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPatientsDetails:!1,hideAd:!1,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"preview-preconception-record",element:"page-preview-preconception-record",windowTitlePostfix:"Preview Preconception Record",headerTitle:"Preview Preconception Record",preload:!0,hrefList:["preview-preconception-record"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPatientsDetails:!1,hideAd:!1,hideHeaderTitle:!1,accessId:"none",showToolbar:!0},{name:"set-unit-price",element:"page-set-unit-price",windowTitlePostfix:"set-unit-price",headerTitle:"Set Price for Unit",preload:!0,hrefList:["set-unit-price"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!0,showPatientsDetails:!1,accessId:"none",showToolbar:!0},{name:"manage-price-list",element:"page-manage-price-list",windowTitlePostfix:"manage-price-list",headerTitle:"Manage Price List",preload:!0,hrefList:["manage-price-list"],requireAuthentication:!0,headerType:"normal",leftMenuEnabled:!0,showSaveButton:!0,showPatientsDetails:!1,accessId:"none",showToolbar:!0},{name:"set-package",element:"page-set-package",windowTitlePostfix:"set-package",headerTitle:"Create Package",preload:!0,hrefList:["set-package"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPatientsDetails:!1,accessId:"none",showToolbar:!0},{name:"pharmacy-manager",element:"page-pharmacy-manager",windowTitlePostfix:"Pharmacy Manager",headerTitle:"Pharmacy Manager",preload:!0,hrefList:["pharmacy-manager"],requireAuthentication:!0,headerType:"normal",leftMenuEnabled:!0,showSaveButton:!1,showOrganizationsName:!0,accessId:"D020",showToolbar:!0},{name:"print-symptoms",element:"page-print-symptoms",windowTitlePostfix:"Print Symptoms",headerTitle:"Print Symptoms",preload:!0,hrefList:["print-symptoms"],requireAuthentication:!0,headerType:"modal",leftMenuEnabled:!1,showSaveButton:!1,showPrintButton:!0,showPatientsDetails:!1,hideAd:!0,hideHeaderTitle:!1,accessId:"none",showToolbar:!0}],app.pages.error404={name:"404",element:"page-error-404",windowTitlePostfix:"Not Found",headerTitle:"404 Not Found",preload:!0,href:["/404"],requireAuthentication:!1,headerType:"normal",leftMenuEnabled:!0}}).call(this);
//# sourceMappingURL=pages.coffee-compiled.js.map