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
                Object.keys(predictionMap).map(function(key, index) {
                    for(prediction of predictionMap[key]){
                        if(prediction['isIdentical'] === true){
                            positiveImagesConfidenceList.push(prediction['confidence']);
                            if(prediction['confidence'] > imageWithHighestAccuracy['accuracy']){
                                imageWithHighestAccuracy['image'] = sightedPerson['images'][index];
                                imageWithHighestAccuracy['accuracy'] = prediction['confidence'];
                            }
                        }
                    }
                  });

                  let accuracy = 0;
                  for(acc of positiveImagesConfidenceList){
                      accuracy += acc;
                  }
                  let avgAccuracy = 0;
                  if(positiveImagesConfidenceList.length !== 0){
                    avgAccuracy = accuracy/positiveImagesConfidenceList.length;
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
