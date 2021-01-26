

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp/flutter_otp.dart' as otp;

var flutterOtp = otp.FlutterOtp();
String phoneNumber;

int randomGen(min, max) {
  var random = Random();

  // the nextDouble() method returns a random number between 0 and 1
  var x = random.nextDouble() * (max - min) + min;

  // If you don't want to return an integer, just remove the floor() method
  return x.floor();
}

Widget otpSend (BuildContext context, phoneNumber){
  String message ,countryCode;
  int min = 1000,max = 9999;
  flutterOtp.sendOtp(
      phoneNumber,
      message = "OTP for Heartfulness App: " + randomGen(min, max).toString(),
      min,
      max,
      countryCode = '+91',
    //default country code is +91
  );
  return new CupertinoAlertDialog(
    title: new Text("OTP sent!"),
    content: new Text("Verify with the OTP sent to the phone number"),
    actions: <Widget>[
      CupertinoDialogAction(
        isDestructiveAction: true,
        isDefaultAction: true,
        child: Text("Ok"),
        onPressed: (){
          Navigator.pop(context);
          print("Should be popping this idk m8");
        },
      ),
    ],
  );
  print("OTP sent to phoneNumber");
}

Widget otpCheck(BuildContext context, int inputOtp) {
  bool check = flutterOtp.resultChecker(inputOtp);
  if (check) {
    return new CupertinoAlertDialog(
      title: new Text("Success!"),
      content: new Text("User Verified!"),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text("Ok"),
          onPressed: () {},
        ),
      ],
    );
    print("Success!");
  } else{
    return new CupertinoAlertDialog(
      title: new Text("Verification failed"),
      content: new Text("User Not Verified!"),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text("Retry"),
          onPressed: () {
            otpSend(context, phoneNumber);
            otpCheck(context, inputOtp);
            Navigator.pop(context);
          },
        ),
      ],
    );
    print("Invalid Otp entered please retry!");
  }
}