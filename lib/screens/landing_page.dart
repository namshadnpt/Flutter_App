import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/screens/home_page.dart';
import 'package:flutter_app/screens/login_page.dart';

class Lasndingpage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        //if snapshot has error
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error : ${snapshot.error}"),
            ),
          );
        }

        //Connection initialized - firebase App is running..
        if (snapshot.connectionState == ConnectionState.done) {
          //StreamBuilder can check login state live
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot){
              //if streamSnapshot has error
              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error : ${streamSnapshot.error}"),
                  ),
                );
              }

              //connection State is Active to the user login check inside
              //the if statement
              if(streamSnapshot.connectionState == ConnectionState.active){
                //get the user
                User _user = streamSnapshot.data;

                //if user is null - cannot loged in
                if(_user == null){
                  //user not loggrd in - head to login page
                  return LoginPage();
                }else{
                  //user is logged in - head to homepage
                  return HomePage();
                }

              }

              //Checking the State - loading..
              return Scaffold(
                body: Center(
                  child: Text(
                    "Checking Authentication ..",
                    style: Constants.regularHeading,
                  ),
                ),
              );
            },
          );
        }


        //Connecting to firebase loading..
        return Scaffold(
          body: Center(
            child: Text(
              "Initializing App...",
                style: Constants.regularHeading,
            ),
          ),
        );
      },
    );
  }
}
