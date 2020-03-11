'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "/assets\AssetManifest.json": "2efbb41d7877d10aac9d091f58ccd7b9",
"/assets\assets\fonts\Consolas-Bold.ttf": "a029870eeb5b0f5978e4efa1008d239b",
"/assets\assets\fonts\Consolas.ttf": "44799a64a98468667480348bcab0de9a",
"/assets\FontManifest.json": "01700ba55b08a6141f33e168c4a6c22f",
"/assets\fonts\MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"/assets\LICENSE": "ed348051ca14f8d29da23994579e34b3",
"/assets\packages\cupertino_icons\assets\CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"/assets\packages\rflutter_alert\assets\images\2.0x\close.png": "abaa692ee4fa94f76ad099a7a437bd4f",
"/assets\packages\rflutter_alert\assets\images\2.0x\icon_error.png": "2da9704815c606109493d8af19999a65",
"/assets\packages\rflutter_alert\assets\images\2.0x\icon_info.png": "612ea65413e042e3df408a8548cefe71",
"/assets\packages\rflutter_alert\assets\images\2.0x\icon_success.png": "7d6abdd1b85e78df76b2837996749a43",
"/assets\packages\rflutter_alert\assets\images\2.0x\icon_warning.png": "e4606e6910d7c48132912eb818e3a55f",
"/assets\packages\rflutter_alert\assets\images\3.0x\close.png": "98d2de9ca72dc92b1c9a2835a7464a8c",
"/assets\packages\rflutter_alert\assets\images\3.0x\icon_error.png": "15ca57e31f94cadd75d8e2b2098239bd",
"/assets\packages\rflutter_alert\assets\images\3.0x\icon_info.png": "e68e8527c1eb78949351a6582469fe55",
"/assets\packages\rflutter_alert\assets\images\3.0x\icon_success.png": "1c04416085cc343b99d1544a723c7e62",
"/assets\packages\rflutter_alert\assets\images\3.0x\icon_warning.png": "e5f369189faa13e7586459afbe4ffab9",
"/assets\packages\rflutter_alert\assets\images\close.png": "13c168d8841fcaba94ee91e8adc3617f",
"/assets\packages\rflutter_alert\assets\images\icon_error.png": "f2b71a724964b51ac26239413e73f787",
"/assets\packages\rflutter_alert\assets\images\icon_info.png": "3f71f68cae4d420cecbf996f37b0763c",
"/assets\packages\rflutter_alert\assets\images\icon_success.png": "8bb472ce3c765f567aa3f28915c1a8f4",
"/assets\packages\rflutter_alert\assets\images\icon_warning.png": "ccfc1396d29de3ac730da38a8ab20098",
"/icons\Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"/icons\Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"/index.html": "cc00b0fbc3da189c8742f0dea80fdeaf",
"/main.dart.js": "447f7359c16686495673348a311a77a3",
"/manifest.json": "6d602f34e8743279799c8a0af9ed7da8"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request, {
          credentials: 'include'
        });
      })
  );
});
