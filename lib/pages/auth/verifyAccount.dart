import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart';
import 'package:market_app/process/apiCalls.dart';
import 'package:market_app/translate/app_localizations.dart';
import 'package:market_app/widgets/TextField.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../widgets/CustomToast.dart';
import 'loginPage.dart';

class VerifyAccount extends StatefulWidget {
 final String? phone;

  const VerifyAccount({Key? key, this.phone}) : super(key: key);

  @override
  _VerifyAccountState createState() => _VerifyAccountState();
}

class _VerifyAccountState extends State<VerifyAccount> {
  String domain = 'https://transferproject17.000webhostapp.com/api';

  final _formKey = GlobalKey<FormState>();
  late String code;

  late String verifyID;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController codeCont = TextEditingController();
  //TextEditingController passCont = TextEditingController();
  bool isObsecure = true;
  bool isloading = false;
  bool userIsValid = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    sendCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        // titleSpacing: 30,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 100),
          child: Text(
            AppLocalizations.getTranslated(context, 'verify'),
            style: TextStyle(
              height: 2.5,
              fontSize: 28.0,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(30.0),
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  VerfiScreen(),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }

  VerfiScreen() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 23.0),
            child: TextFieldItem(controller: codeCont, labelText: 'Code', type: 'smsCode',)

          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: MaterialButton(
              onPressed:(){
                checkCode(codeCont.text);
              },
              color: Constants.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: isloading
                  ? CupertinoActivityIndicator()
                  : Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text('Check'),
                  ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 13.0),
            child: FlatButton(
              onPressed: (){
                sendCode();
              },
//              => Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => Registration(),
//                ),
//              ),
              child: Text('Resend Code'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendCode() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+963930232949',//widget.phone!,
      verificationCompleted: (PhoneAuthCredential credential) {
       FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print('FirebaseAuthException : $e');
      },
      codeSent: (String verificationId, int? resendToken) {
        verifyID = verificationId;
    },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void checkCode(String code) {
    FirebaseAuth.instance.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verifyID,
            smsCode: code)).then((value) async {
              if(value.user != null){
                await APICalls(context).confirmAccount(widget.phone!);
                print('verify succrss!!!!1');
                //TODO change verified value in database and show toast and go to home
              }
              else{
                print('verify succrss!!!!1');


              }
    });
  }



}
