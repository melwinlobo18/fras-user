const functions = require('firebase-functions');
const admin = require("firebase-admin");
const axios = require('axios');

admin.initializeApp({
    credential: admin.credential.applicationDefault()
});

exports.onSightedPersonReported = functions.firestore
    .document('sightings/{documentId}')
    .onCreate(async (snap, context) => {

        const sightedPerson = snap.data();
        console.log(sightedPerson);
        console.log(sightedPerson['images'][0]);

        let predictionMap = {};
        let promises = [];

        const docInnerRef = admin.firestore().collection('missing_persons').doc(sightedPerson['missingPersonId']);
        const missingPersonSnapshot = await docInnerRef.get();
        const missingPerson = missingPersonSnapshot.data();
        if (missingPerson !== undefined) {
            console.log("Missing Person", missingPerson);
            console.log("Images", missingPerson);
            /* eslint-disable no-await-in-loop */
            for (image of sightedPerson['images']) {
                let index = sightedPerson['images'].indexOf(image);
                predictionMap[index] = [];
                let data = JSON.stringify({
                    url: image
                })
                promises.push(axios
                    .post('https://southeastasia.api.cognitive.microsoft.com/face/v1.0/detect?returnFaceId=true&returnFaceLandmarks=false&recognitionModel=recognition_02&returnRecognitionModel=false&detectionModel=detection_02',
                        data,
                        {
                            headers: { 'Content-Type': 'application/json', 'Ocp-Apim-Subscription-Key': 'e466501640774684ab08c3283e58243e' }
                        }).then(async res => {
                            console.log(res.data);
                            for (result of res.data) {
                                console.log("Missing person faceId", missingPerson['faceId']);
                                console.log("Sighted person faceId", result['faceId']);
                                let data = JSON.stringify({
                                    faceId1: missingPerson['faceId'],
                                    faceId2: result['faceId'],
                                })
                                // let compareResult = 
                                await axios
                                    .post('https://southeastasia.api.cognitive.microsoft.com/face/v1.0/verify',
                                        data,
                                        {
                                            headers: { 'Content-Type': 'application/json', 'Ocp-Apim-Subscription-Key': 'e466501640774684ab08c3283e58243e' }
                                        })
                                    .then(res => {
                                        console.log("Data", res.data);
                                        predictionMap[index].push(res.data);
                                        console.log("Prediction Map" + index, predictionMap[index]);
                                        return;
                                    })
                                    .catch(error => {
                                        console.error(error)
                                    });
                            }
                            return;
                        })
                    .catch(error => {
                        console.error(error)
                    }));
            }
            /* eslint-disable no-await-in-loop */

            Promise.all(promises).then(async res => {
                let imageWithHighestAccuracy = {
                    image: '',
                    accuracy: 0
                };
                let positiveImagesConfidenceList = [];
                Object.keys(predictionMap).map(function (key, index) {
                    for (prediction of predictionMap[key]) {
                        if (prediction['isIdentical'] === true) {
                            positiveImagesConfidenceList.push(prediction['confidence']);
                            if (prediction['confidence'] > imageWithHighestAccuracy['accuracy']) {
                                imageWithHighestAccuracy['image'] = sightedPerson['images'][index];
                                imageWithHighestAccuracy['accuracy'] = prediction['confidence'];
                            }
                        }
                    }
                });

                let accuracy = 0;
                for (acc of positiveImagesConfidenceList) {
                    accuracy += acc;
                }
                let avgAccuracy = 0;
                if (positiveImagesConfidenceList.length !== 0) {
                    avgAccuracy = accuracy / positiveImagesConfidenceList.length;
                }

                await admin.firestore().collection("sightings").doc(snap.id).set({
                    'predictions': predictionMap,
                    'accuracy': avgAccuracy,
                    'imageWithHighestAccuracy': imageWithHighestAccuracy,
                }, { merge: true });
                return;
            }).catch(error => {
                console.error(error)
            });
        }
    });

exports.populateData = functions.https.onRequest((req, res) => {
    let data = [{
        "faceId": "0c9a3361-9398-45e3-91ff-59b71013788d",
        "name": "Melwin Lobo",
        "issueNumber": 1,
        "missingDate": new Date('March 11, 2020 00:00:00').toISOString(),
        "missingFrom": "Koppa, Chikmagalur",
        "age": 20,
        "sex": "M",
        "race": "Indian",
        "hairColor": "Black",
        "eyeColor": "Black",
        "height": 5.4,
        "weight": 60,
        "imageUrl": "https://firebasestorage.googleapis.com/v0/b/ifra-3d775.appspot.com/o/missing_persons%2FMelwin%20(2).jpg?alt=media&token=4807891c-d590-4d78-a493-5d1d825e8d4e",
        "lat": 13.532658,
        "lng": 75.3557927
    }, {
        "faceId": "9416d4e3-56e0-4256-bf27-ba8d9270ca2e",
        "name": "Shreyas Baliga",
        "issueNumber": 2,
        "missingDate": new Date('March 15, 2020 00:00:00').toISOString(),
        "missingFrom": "Urwa, Mangaluru",
        "age": 20,
        "sex": "M",
        "race": "Indian",
        "hairColor": "Black",
        "eyeColor": "Black",
        "height": 5.4,
        "weight": 60,
        "imageUrl": "https://firebasestorage.googleapis.com/v0/b/ifra-3d775.appspot.com/o/missing_persons%2Fshreyas.jpg?alt=media&token=ab419344-de35-408f-89b1-4714cde461b0",
        "lat": 12.8967709,
        "lng": 74.8346296
    }, {
        "faceId": "ec4989c0-836e-4418-9307-35ea839c9aed",
        "name": "Adithya M Suvarna",
        "issueNumber": 3,
        "missingDate": new Date('March 11, 2019 00:00:00').toISOString(),
        "missingFrom": "Mannagudda, Mangaluru",
        "age": 20,
        "sex": "M",
        "race": "Indian",
        "hairColor": "Black",
        "eyeColor": "Black",
        "height": 5.4,
        "weight": 60,
        "imageUrl": "https://firebasestorage.googleapis.com/v0/b/ifra-3d775.appspot.com/o/missing_persons%2Fadi.jpg?alt=media&token=87e8f950-496a-425c-a94d-b7ae77c35239",
        "lat": 12.9127339,
        "lng": 74.85610919999999
    }];
    let promises = [];
    data.forEach((entry) => {
        promises.push(admin.firestore().collection("missing_persons").doc(`${data.indexOf(entry) + 1}`).set(entry, { merge: true }));
    });
    Promise.all(promises).then(result => {
        res.send("Successful");
        return;
    }).catch(error => {
        console.error(error)
    });
});
