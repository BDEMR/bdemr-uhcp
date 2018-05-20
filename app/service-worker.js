/**
 * Copyright 2016 Google Inc. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/

// DO NOT EDIT THIS GENERATED OUTPUT DIRECTLY!
// This file should be overwritten as part of your build process.
// If you need to extend the behavior of the generated service worker, the best approach is to write
// additional code and include it using the importScripts option:
//   https://github.com/GoogleChrome/sw-precache#importscripts-arraystring
//
// Alternatively, it's possible to make changes to the underlying template file and then use that as the
// new base for generating output, via the templateFilePath option:
//   https://github.com/GoogleChrome/sw-precache#templatefilepath-string
//
// If you go that route, make sure that whenever you update your sw-precache dependency, you reconcile any
// changes made to this original template file with your modified copy.

// This generated service worker JavaScript will precache your site's resources.
// The code needs to be saved in a .js file at the top-level of your site, and registered
// from your pages in order to be used. See
// https://github.com/googlechrome/sw-precache/blob/master/demo/app/js/service-worker-registration.js
// for an example of how you can register this script and handle various service worker events.

/* eslint-env worker, serviceworker */
/* eslint-disable indent, no-unused-vars, no-multiple-empty-lines, max-nested-callbacks, space-before-function-paren, quotes, comma-spacing */
'use strict';

var precacheConfig = [["all.js","5a4d3ebcb6f8a6146e842f54ecfd6c9d"],["assets/app.coffee","133a1103a5cdcbdff23811ceded29078"],["assets/app.coffee-compiled.js","550e0b7f1bb16f030a94f9b27844246a"],["assets/app.coffee-compiled.js.map","22e8db2de0af7e2bde710554fcd1b9fd"],["assets/config-production.coffee","c2e71a73176610b1cc1e3badfd6cdbae"],["assets/config-production.coffee-compiled.js","4076da6206aaad1b9978691c8ece2789"],["assets/config-production.coffee-compiled.js.map","7c9aa8ec1fc22b38db8129c06952f14c"],["assets/config.coffee","64b1c388dab0ec6a321e7e77d3606e6a"],["assets/config.coffee-compiled.js","0f592e725438fa4c75d6e69b08ee01a2"],["assets/config.coffee-compiled.js.map","9cf5816929960ba09964a6657473a726"],["assets/db.coffee","ec79ca98524edf6b86589e43ea324a36"],["assets/db.coffee-compiled.js","bf62aca84b1e12b35991a8ab406fa15e"],["assets/db.coffee-compiled.js.map","3093b01dce91252417d1c4406cb5484c"],["assets/favicon.png","13020daf91411dc3576c2367e78a9edd"],["assets/global.css","ee5cfcf57aa6f8e1e1b6c345582fd10e"],["assets/img/graph-a-end.png","9724351cd78d8655903758a9a81e31da"],["assets/img/graph-a-start.png","6985be4ce3e4b0e833a5e01e874bb732"],["assets/img/graph-bpd.png","87478882c208fb6aacb5112735e551e9"],["assets/img/graph-bps.png","d3eecc254cf6ed47d5b810bb488613ec"],["assets/img/graph-s-end.png","48bf8305855d58213778101ef95a9c4e"],["assets/img/graph-s-start.png","b7f5b9f642df2e14e9991670cf732d21"],["assets/img/partners/badas.jpg","263a25ff95f8ad6ec5668fe234d50dbf"],["assets/img/partners/badas_logo.png","6896e980481efef845c6c0513b85ff9f"],["assets/img/partners/uhcp.jpg","a4843f913b8a302367d36b8264d7a15b"],["assets/img/partners/wof.jpg","c9d219cfa022c956ca2167cfb30b56cc"],["assets/img/preconception/badas-logo-tab.png","a438aa36ee3eaed1b2909f4256ccfd09"],["assets/img/preconception/endocrine_socity_tab_logo.png","e2014be6a44c62381b559b067e174d8e"],["assets/img/preconception/gov-logo.png","4cfadfad21dc9c375a48eda2239eab5c"],["assets/img/preconception/safe-pregnancy.png","bba8374298f59caffdd558d61779fbec"],["assets/lang.coffee","44ffb066992f0c5e8cae1dbdc271a2cf"],["assets/lang.coffee-compiled.js","da4b4cf04b8db1ac3a5a9be0b7414d49"],["assets/lang.coffee-compiled.js.map","01f28aa69edc56ae64cde05c2f8c9344"],["assets/lib.coffee","adaf59f7adcb5ba39fd7db20461986db"],["assets/lib.coffee-compiled.js","0eefd71d843dd9541840cb93f2d41b30"],["assets/lib.coffee-compiled.js.map","644d22cffed6f7c87a83ed87a0a510bd"],["assets/loader/elements.html","dd8b21af0ab50764bae5a23b5c5466bd"],["assets/loader/loader.js","ea7e3194a688947df4fd952b98fe2f33"],["assets/loader/logo-doctor-app.png","02fa7238c0febf867c2c879820f9cb0b"],["assets/loading.gif","babaf30a6b335ad3dad8568e6250a7c1"],["assets/no-preview.png","55fee5baa214cfaa09f7e0eed2894d6a"],["assets/not-found.png","2251b368dd22f7e2432fa7504a3fdb51"],["assets/notification.mp3","913c37e88e2939122d763361833efd24"],["assets/notification.ogg","4a5734c78be4539541d809ebc1b2d6d1"],["assets/pages.coffee","0f73e6c225b37750c9b5f5d483db038a"],["assets/pages.coffee-compiled.js","25d59e92919fafcc54719ecfbb6ee471"],["assets/pages.coffee-compiled.js.map","11aad2cf078bf4c54968412e2508d23b"],["assets/placeholdit.png","3c4de7b3bc69e92d657c47b0457141dc"],["bower-assets/webcomponentsjs/webcomponents-lite.min.js","b302282329b23c129971c9d7937b14e4"],["elements/custom-autocomplete/custom-autocomplete.html","e2cbd1782a3d78fc420bdaeb7ee00bd8"],["elements/custom-graph/custom-graph.html","96ccf8c7e5fabba9c2dd300695e96e94"],["elements/custom-vital-search/custom-vital-search.html","92aee09aca157f5b534ca3c1c9ec4ed5"],["elements/dev-tools/dev-tools.html","2f487070d254182119ace3e17a51e77a"],["elements/dynamic-element-root/dynamic-element-root.html","2e7914f934d4de6953f94a9cbef17240"],["elements/dynamic-elements/de-all.html","3357a4539c9e73d98148953f7edb25d0"],["elements/dynamic-elements/de-array-declarative.html","1a81e2aeacc5faf1334861ff78c6e818"],["elements/dynamic-elements/de-array.html","380fb99afb93851ca6c11d2444011110"],["elements/dynamic-elements/de-category.html","6a7fdd1b02f57948c87fc26e9ffc2340"],["elements/dynamic-elements/de-collection.html","6c9f00ddfd308bfa2f670378e6e71faf"],["elements/html-block/html-block.html","2ec1fc50e836bebb2e1764ce8852089d"],["elements/page-activate/page-activate.html","10e6cf212864d09f1693cdbf95c03b26"],["elements/page-assistant-manager/page-assistant-manager.html","6b344dd1bc860105237ed799ef7ec939"],["elements/page-attachement-preview/page-attachement-preview.html","f2d2ed6e353ac754ec763d05416c0940"],["elements/page-booking/page-booking.html","01ef86776e9683ad8b4ecd1deeaaebb3"],["elements/page-chamber-manager/page-chamber-manager.html","41f67d4c99c1b2c9e70a65928f6cb395"],["elements/page-chamber-patients/page-chamber-patients.html","63256e41f5e19194284478e407a45140"],["elements/page-chamber/page-chamber.html","7318d3c0d383634c2bd2a4f7db33bd87"],["elements/page-clinic-invoice-manager/page-invoice-manager.html","b25a7e7753f3af10dee49c7f8e63b325"],["elements/page-clinic-print-invoice/page-clinic-print-invoice.html","aa7d81c69f5ac7ec0fd22eba7a553f63"],["elements/page-create-invoice/page-create-invoice.html","93f58541723bcbe9ebbf2762215b92bd"],["elements/page-dashboard/page-dashboard.html","d68331b08678aa7e9526fc16f8d70f00"],["elements/page-diabetes-record/page-diabetes-record.html","3a18721b6c32cab4d2bac520287bec0c"],["elements/page-error-404/page-error-404.html","55292f0f410b7b5516ca850db2d2e0e8"],["elements/page-internal/page-internal.html","adab254257becb32fed29b8267c72896"],["elements/page-invoice-manager/page-invoice-manager.html","f21e5156b4949e4b657367fb92f715da"],["elements/page-login/page-login.html","a0163e092d9b0ee1ea58a831e7ed33cd"],["elements/page-manage-price-list/page-manage-price-list.html","d51a01f8dfaa2572c4a278a38ed306bd"],["elements/page-medicine-dispension/page-medicine-dispension.html","f576d855fd6d4ff05ebbfc9bd1bbad59"],["elements/page-medicine-editor/page-medicine-editor.html","2cb641d95615981ca25dd2459d6e907f"],["elements/page-my-wallet/page-my-wallet.html","5f44291edd4e312e5b38534d7f55aff6"],["elements/page-ndr-editor/page-ndr-editor.html","fafbbbe286ac7a7bd87f2910802e242e"],["elements/page-notification-panel/page-notification-panel.html","d6bfc4068a793fc73790f362fdc474f9"],["elements/page-organization-editor/page-organization-editor.html","37a8e50c556b7fb4ce94353986dbe517"],["elements/page-organization-manage-foc/page-organization-manage-foc.html","ec3a639e2d3ee182ac11536ac7ec399d"],["elements/page-organization-manage-patient-stay/page-organization-manage-patient-stay.html","36a4b6da94c1bb7d61caf84367203ff3"],["elements/page-organization-manage-patient/page-organization-manage-patient.html","bcbe5db0895ef6cac1566cca9404134e"],["elements/page-organization-manage-users/page-organization-manage-users.html","c395388ddcb027b2eccc810055109389"],["elements/page-organization-manage-waitlist/page-organization-manage-waitlist.html","b2e9eb52f4e1d933ed63b54db0168ac2"],["elements/page-organization-manager/page-organization-manager.html","4838a0bfa0b202bd6108db03ed316b0b"],["elements/page-organization-medicine-sales-statistics/page-organization-medicine-sales-statistics.html","fd3e1031ebcf0212a79ccda8901af864"],["elements/page-organization-records/page-organization-records.html","7baa0afdbfbe6f4154b3b89d282da14b"],["elements/page-patient-editor/page-patient-editor.html","a0c20fff02fd7ea3b5c015429fe0d074"],["elements/page-patient-manager/page-patient-manager.html","1cba7c4313124c0c63c78b9c53945128"],["elements/page-patient-signup/page-patient-signup.html","58603c1bbaaa2efdb7c96de8ea5129f7"],["elements/page-patient-viewer/page-patient-viewer.html","c7057f492012f9fdc77c42b7386d43d7"],["elements/page-patient-vitals-editor/page-patient-vitals-editor.html","36babe40866814b371d688ea5e641927"],["elements/page-pending-report/page-pending-report.html","e3316532976e7595aadf5723ca69b9ab"],["elements/page-pharmacy-manager/page-pharmacy-manager.html","0b42d35622e63c2d246dd566be3ef7a0"],["elements/page-preconception-record/page-preconception-record.html","b011f8ee77e1d3561d674aa3a68e7c26"],["elements/page-preview-preconception-record/page-preview-preconception-record.html","25514236603c38f7ca95a8015d10d675"],["elements/page-print-anaesmon-record/page-print-anaesmon-record.html","aa1753bec27592df7b60147112160f04"],["elements/page-print-both-medicine/page-print-both-medicine.html","576d1835d9f1b58e7ab1e500872d031f"],["elements/page-print-current-medicine/page-print-current-medicine.html","5b2f8c9956d0231aa75ba1d97f7c90a9"],["elements/page-print-diagnosis/page-print-diagnosis.html","09089d898c1f5a9bd54d84a8e26a90bb"],["elements/page-print-history-and-physical-record/page-print-history-and-physical-record.html","e54a5dde107ae060f73ab596493bd8f5"],["elements/page-print-invoice/page-print-invoice.html","5604509dbb3f3f5d604c43105870e6be"],["elements/page-print-old-medicine/page-print-old-medicine.html","8810a6d342a8b6683af7d22691194e7e"],["elements/page-print-patient-stay/page-print-patient-stay.html","aa46d53f980cfc3f955dfb4a20c9a24d"],["elements/page-print-preview/page-print-preview.html","4074e33f7b6a0350ebdaa0f5298f023c"],["elements/page-print-record/page-print-record.html","ccad9e31438a1ac7f6f55c2c7b7f3105"],["elements/page-print-test-adviced/page-print-test-adviced.html","5f9d05436cfd1a6f30c1d560656821a6"],["elements/page-print-test-blood-sugar/page-print-test-blood-sugar.html","159d57e3584365a886a09d85a84dd8f7"],["elements/page-print-test-other-test/page-print-test-other-test.html","47ccaf88125f15c5fe80677302f3eab2"],["elements/page-print-test-result-from-clinic-app/page-print-test-result-from-clinic-app.html","04b4d2684788dbe079ae6f445601772d"],["elements/page-print-vital-bmi/page-print-vital-bmi.html","d71524c6728062723092c2be4abc6390"],["elements/page-print-vital-bp/page-print-vital-bp.html","f5403d169141fd1ee416da86130f5239"],["elements/page-print-vital-pr/page-print-vital-pr.html","f746d4e47d9eabf36d26339cbdf11ed4"],["elements/page-print-vital-rr/page-print-vital-rr.html","199978f1e21b88295577f59fe21b87c8"],["elements/page-print-vital-spo2/page-print-vital-spo2.html","bc0de013ad8a3feeeddafb714d8dd9e4"],["elements/page-print-vital-temp/page-print-vital-temp.html","8d53780b8d106f7579cd778da4f88472"],["elements/page-record-history-and-physical/page-record-history-and-physical.html","630f17b9ae5bb58801fd1b218311b9b9"],["elements/page-reports-manager/page-reports-manager.html","8d29f9552b8326fbeeba4767e3647fca"],["elements/page-review-report/page-review-report.html","33c536656a193dfa70582c3d3b425843"],["elements/page-search-record/page-search-record.html","0f1da9d68c917362321a1bfc6dac2764"],["elements/page-select-organization/page-select-organization.html","94b2594f4cb3b88747cd5c8c44d4ba29"],["elements/page-send-feedback/page-send-feedback.html","13747c17c9577f95880446e3a66a0966"],["elements/page-set-package/page-set-package.html","342b05bc82996936b2aa75dc22d37f80"],["elements/page-settings/page-settings.html","e3d3e1c76b77043e544f0df576fe0ed3"],["elements/page-test-blood-sugar-editor/page-test-blood-sugar-editor.html","3211f7d6f54430061e5fa604be1b50b3"],["elements/page-test-other-editor/page-test-other-editor.html","97acaca5cc7e7466678f0d386f2acbd9"],["elements/page-uhcp-all-visits-report/page-uhcp-all-visits-report.html","66f3052d311f77f2bb5f628dd9c565e9"],["elements/page-uhcp-summary-report/page-uhcp-summary-report.html","33d88d51cbf5bf904c6efc6b37456ae6"],["elements/page-upload-organization-patient-list/page-upload-organization-patient-list.html","c4f8549ec3c73a8f54749511e1c395cc"],["elements/page-visit-editor/page-visit-editor.html","a7372e3dfdf6dc8654df73f30cab7b28"],["elements/page-visit-invoice/page-visit-invoice.html","1036fa2424fa3fa25c5f45b98d407371"],["elements/page-visit-preview/page-visit-preview.html","b5e2c7d27493012bfbf1d0abc7e51aae"],["elements/page-welcome-internal/page-welcome-internal.html","aa00c45df5eeb23708f2d0272821d306"],["elements/page-welcome/page-welcome.html","49e5f55f64a7c89f929e8d0811950959"],["elements/root-element/root-element.html","8e6049ad763426c32a3ed8b0c5513fa1"],["favicon.png","9de49541e75a4ba0af40b34a2489dae9"],["images/avatar.png","27badd064b48485b2ab9f582a9c35969"],["images/bdemr_logo.png","433cb465a98a744a3ce1ac20505276eb"],["images/bdemr_logo_small.png","b8be59b7cec216a929e98ca429b427dc"],["images/icons/ico_add_funds_b.png","7c6656e0308ddeb2aeff872e6b5bb71e"],["images/icons/ico_blood_pressure.png","c8113b68e70ef097a99adbb43fa08e76"],["images/icons/ico_blood_sugar.png","0f3506e1a7bd71099714db8cfad19a5c"],["images/icons/ico_body_shape.png","bdbe494b3d85ea4c16d1c92fea32ea9d"],["images/icons/ico_calander_time.png","f4f561f98993801b4511d6652b73c3b1"],["images/icons/ico_heart-with-lifeline-variant.png","af340a447b29aecdf832b1c43191ca0d"],["images/icons/ico_height.png","eb7ccb6e898d2cc94a03e51b4b01a89e"],["images/icons/ico_history_and_physical.png","545859ae71b2b65c98b354a941339f75"],["images/icons/ico_invoice.png","91ae8a6364eae42160c7dac2ef25c65f"],["images/icons/ico_lungs.png","4050b8c8e801831694448e75f025b979"],["images/icons/ico_medical_records.png","33e5d9557f03efc68f052f35a6ae8272"],["images/icons/ico_medicine.png","5595a16658e20f500eb0176121de1526"],["images/icons/ico_medicine_1.png","d37b0e2a5ab4cd8c167330a4b662b16d"],["images/icons/ico_medicine_flask.png","29c34783b87085274eb150cdf8086ab5"],["images/icons/ico_notes.png","635a6f77e0a49857fdbfeba0335e6db3"],["images/icons/ico_patient_b.png","50292c423f16bfd6e2f63043fc8c89c3"],["images/icons/ico_patient_medication.png","7a79af5bda715296b81626eefd10d293"],["images/icons/ico_patient_stay.png","70de1c09f42fb02885babba759dd5c50"],["images/icons/ico_pulse_rate.png","d8adb7ab263762b599fc9af50cecfdce"],["images/icons/ico_report.png","02199e671fbd37c4d2e012883de5cb2c"],["images/icons/ico_stethoscope.png","1b673663393c6f4a56ff0cf124fab78f"],["images/icons/ico_symptoms.png","bd91a07368300b5f0a2ccf4ca4e4a570"],["images/icons/ico_thermometer.png","a4d7e83143ed16a9d6f9d272d397a3eb"],["images/icons/ico_weight.png","cc2aeb5412ca298f13c8e85024b1a88c"],["images/icons/medical-assistance-symbol.png","92f362185f9a7bbc920b6243a4c9a244"],["images/icons/medical-kit.png","da88a3aef9fe4e99c7377450c7c72987"],["images/icons/oxygen-symbol.png","95b875740474bfea0c1b123876214af3"],["index.html","a8951930e67cecbf9e6a569ac7ee04c8"]];
var cacheName = 'sw-precache-v3--' + (self.registration ? self.registration.scope : '');


var ignoreUrlParametersMatching = [/^utm_/];



var addDirectoryIndex = function (originalUrl, index) {
    var url = new URL(originalUrl);
    if (url.pathname.slice(-1) === '/') {
      url.pathname += index;
    }
    return url.toString();
  };

var cleanResponse = function (originalResponse) {
    // If this is not a redirected response, then we don't have to do anything.
    if (!originalResponse.redirected) {
      return Promise.resolve(originalResponse);
    }

    // Firefox 50 and below doesn't support the Response.body stream, so we may
    // need to read the entire body to memory as a Blob.
    var bodyPromise = 'body' in originalResponse ?
      Promise.resolve(originalResponse.body) :
      originalResponse.blob();

    return bodyPromise.then(function(body) {
      // new Response() is happy when passed either a stream or a Blob.
      return new Response(body, {
        headers: originalResponse.headers,
        status: originalResponse.status,
        statusText: originalResponse.statusText
      });
    });
  };

var createCacheKey = function (originalUrl, paramName, paramValue,
                           dontCacheBustUrlsMatching) {
    // Create a new URL object to avoid modifying originalUrl.
    var url = new URL(originalUrl);

    // If dontCacheBustUrlsMatching is not set, or if we don't have a match,
    // then add in the extra cache-busting URL parameter.
    if (!dontCacheBustUrlsMatching ||
        !(url.pathname.match(dontCacheBustUrlsMatching))) {
      url.search += (url.search ? '&' : '') +
        encodeURIComponent(paramName) + '=' + encodeURIComponent(paramValue);
    }

    return url.toString();
  };

var isPathWhitelisted = function (whitelist, absoluteUrlString) {
    // If the whitelist is empty, then consider all URLs to be whitelisted.
    if (whitelist.length === 0) {
      return true;
    }

    // Otherwise compare each path regex to the path of the URL passed in.
    var path = (new URL(absoluteUrlString)).pathname;
    return whitelist.some(function(whitelistedPathRegex) {
      return path.match(whitelistedPathRegex);
    });
  };

var stripIgnoredUrlParameters = function (originalUrl,
    ignoreUrlParametersMatching) {
    var url = new URL(originalUrl);
    // Remove the hash; see https://github.com/GoogleChrome/sw-precache/issues/290
    url.hash = '';

    url.search = url.search.slice(1) // Exclude initial '?'
      .split('&') // Split into an array of 'key=value' strings
      .map(function(kv) {
        return kv.split('='); // Split each 'key=value' string into a [key, value] array
      })
      .filter(function(kv) {
        return ignoreUrlParametersMatching.every(function(ignoredRegex) {
          return !ignoredRegex.test(kv[0]); // Return true iff the key doesn't match any of the regexes.
        });
      })
      .map(function(kv) {
        return kv.join('='); // Join each [key, value] array into a 'key=value' string
      })
      .join('&'); // Join the array of 'key=value' strings into a string with '&' in between each

    return url.toString();
  };


var hashParamName = '_sw-precache';
var urlsToCacheKeys = new Map(
  precacheConfig.map(function(item) {
    var relativeUrl = item[0];
    var hash = item[1];
    var absoluteUrl = new URL(relativeUrl, self.location);
    var cacheKey = createCacheKey(absoluteUrl, hashParamName, hash, false);
    return [absoluteUrl.toString(), cacheKey];
  })
);

function setOfCachedUrls(cache) {
  return cache.keys().then(function(requests) {
    return requests.map(function(request) {
      return request.url;
    });
  }).then(function(urls) {
    return new Set(urls);
  });
}

self.addEventListener('install', function(event) {
  event.waitUntil(
    caches.open(cacheName).then(function(cache) {
      return setOfCachedUrls(cache).then(function(cachedUrls) {
        return Promise.all(
          Array.from(urlsToCacheKeys.values()).map(function(cacheKey) {
            // If we don't have a key matching url in the cache already, add it.
            if (!cachedUrls.has(cacheKey)) {
              var request = new Request(cacheKey, {credentials: 'same-origin'});
              return fetch(request).then(function(response) {
                // Bail out of installation unless we get back a 200 OK for
                // every request.
                if (!response.ok) {
                  throw new Error('Request for ' + cacheKey + ' returned a ' +
                    'response with status ' + response.status);
                }

                return cleanResponse(response).then(function(responseToCache) {
                  return cache.put(cacheKey, responseToCache);
                });
              });
            }
          })
        );
      });
    }).then(function() {
      
      // Force the SW to transition from installing -> active state
      return self.skipWaiting();
      
    })
  );
});

self.addEventListener('activate', function(event) {
  var setOfExpectedUrls = new Set(urlsToCacheKeys.values());

  event.waitUntil(
    caches.open(cacheName).then(function(cache) {
      return cache.keys().then(function(existingRequests) {
        return Promise.all(
          existingRequests.map(function(existingRequest) {
            if (!setOfExpectedUrls.has(existingRequest.url)) {
              return cache.delete(existingRequest);
            }
          })
        );
      });
    }).then(function() {
      
      return self.clients.claim();
      
    })
  );
});


self.addEventListener('fetch', function(event) {
  if (event.request.method === 'GET') {
    // Should we call event.respondWith() inside this fetch event handler?
    // This needs to be determined synchronously, which will give other fetch
    // handlers a chance to handle the request if need be.
    var shouldRespond;

    // First, remove all the ignored parameters and hash fragment, and see if we
    // have that URL in our cache. If so, great! shouldRespond will be true.
    var url = stripIgnoredUrlParameters(event.request.url, ignoreUrlParametersMatching);
    shouldRespond = urlsToCacheKeys.has(url);

    // If shouldRespond is false, check again, this time with 'index.html'
    // (or whatever the directoryIndex option is set to) at the end.
    var directoryIndex = '';
    if (!shouldRespond && directoryIndex) {
      url = addDirectoryIndex(url, directoryIndex);
      shouldRespond = urlsToCacheKeys.has(url);
    }

    // If shouldRespond is still false, check to see if this is a navigation
    // request, and if so, whether the URL matches navigateFallbackWhitelist.
    var navigateFallback = '/index.html';
    if (!shouldRespond &&
        navigateFallback &&
        (event.request.mode === 'navigate') &&
        isPathWhitelisted(["\\/[^\\/\\.]*(\\?|$)"], event.request.url)) {
      url = new URL(navigateFallback, self.location).toString();
      shouldRespond = urlsToCacheKeys.has(url);
    }

    // If shouldRespond was set to true at any point, then call
    // event.respondWith(), using the appropriate cache key.
    if (shouldRespond) {
      event.respondWith(
        caches.open(cacheName).then(function(cache) {
          return cache.match(urlsToCacheKeys.get(url)).then(function(response) {
            if (response) {
              return response;
            }
            throw Error('The cached response that was expected is missing.');
          });
        }).catch(function(e) {
          // Fall back to just fetch()ing the request if some unexpected error
          // prevented the cached response from being valid.
          console.warn('Couldn\'t serve response for "%s" from cache: %O', event.request.url, e);
          return fetch(event.request);
        })
      );
    }
  }
});







