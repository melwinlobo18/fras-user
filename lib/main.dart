import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:ifrauser/ui/splash_screen.dart';

void main() {
  try {
    fb.initializeApp(
        apiKey: 'AIzaSyDQtZa0Ju73LC5s9ZMD4CoSPoF43Yw_rLc',
        projectId: 'ifra-3d775',
        storageBucket: 'ifra-3d775.appspot.com',
        databaseURL: "https://ifra-3d775.firebaseio.com");
    runApp(MyApp());
  } on fb.FirebaseJsNotLoadedException catch (e) {
    print(e);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BotToastInit(
      child: MaterialApp(
        title: 'IFRA',
        navigatorObservers: [BotToastNavigatorObserver()],
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
