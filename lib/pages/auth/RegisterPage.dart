import 'dart:convert';
import 'dart:io';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_app/pages/auth/verifyAccount.dart';
import 'package:market_app/pages/store.dart';
import 'package:market_app/process/apiCalls.dart';
import 'package:market_app/translate/app_localizations.dart';
import 'package:market_app/widgets/TextField.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:market_app/constants.dart';
import '../../models/Customer.dart';
import 'loginPage.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String domain = 'https://transferproject17.000webhostapp.com/api';

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  TextEditingController nameCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isObsecure = true;
  late File _image;

  bool isloading = false;
  bool userValid = false , buyer = false;
  List<bool> isSelected = [true,false];


  late String _email;

  late String _password;

  late String _name;

  ImagePicker _picker = ImagePicker();
  XFile _imageFile = XFile('');

  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // Navigator.pop(context);
    return Scaffold(
      appBar: AppBar(
        // titleSpacing: 30,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 75),
          child: Text(
            AppLocalizations.getTranslated(context, 'register'),
            style: TextStyle(
              height: 2.5,
              fontSize: 28.0,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ),
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(18.0),
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                regScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  regScreen() {
    return Container(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Padding(
              padding: EdgeInsets.only(top: 14.0),
              child: GestureDetector(
                onTap: () {
                  final action = CupertinoActionSheet(
                    title: Text(AppLocalizations.getTranslated(context, 'Photo')),
                    message: Text('Choose a Profile Photo'),
                    actions: <Widget>[
                      CupertinoActionSheetAction(
                        onPressed: () => pickImage(ImageSource.camera),
                        child: Text('Camera'),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () => pickImage(ImageSource.gallery),
                        child: Text('Gallery'),
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  );
                  showCupertinoModalPopup(
                      context: context, builder: (context) => action);
                },
                child: _imageFile.path != ''
                    ? PhysicalModel(
                        color: Colors.transparent,
                        elevation: 10,
                        shape: BoxShape.circle,
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Colors.grey,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                image: DecorationImage(
                                    image:
                                        Image.file(File(_imageFile.path)).image,
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      )
                    : PhysicalModel(
                        color: Colors.transparent,
                        elevation: 10,
                        shape: BoxShape.circle,
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Constants.primaryColor,
                          child: Center(
                              child: Icon(
                            Icons.person,
                            color: Colors.blueGrey,
                          )),
                        ),
                      ),
              ),
            ),
            ListTile(
              onTap: () {},
              title:  Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ToggleButtons(
                    constraints: BoxConstraints(minWidth: 50, minHeight: 30),
                    renderBorder: true,
                    fillColor: Colors.blueGrey,
                    borderWidth: 2,
                    selectedBorderColor: Colors.blueGrey,
                    selectedColor: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          AppLocalizations.getTranslated(context, 'Seller'),//+' '+languages[0].name,
                          style: TextStyle(fontSize: 16 , fontFamily: 'sans'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          AppLocalizations.getTranslated(context, 'Buyer'),//+' '+languages[1].name,
                          style: TextStyle(fontSize: 16, fontFamily: 'sans'),
                        ),
                      ),
                    ],
                    onPressed: (int index) async {

                      setState(() {
                        print('resr togle $index -- $buyer');
                        buyer = !buyer;
                        for (int i = 0; i < isSelected.length; i++) {
                          isSelected[i] = i == index;
                        }
                        setState(() {

                        });

                      });
                    }, isSelected: isSelected,

                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: TextFieldItem(
                  labelText: 'Name',
                  controller: nameCont,
                )
                // TextFormField(
                //   onSaved: (_input) {
                //     setState(() {
                //       _name = _input!;
                //     });
                //   },
                //   validator: (_input) {
                //     return _input!.length != 0 ? null : 'Please Enter a Name';
                //   },
                //   controller: nameCont,
                //   decoration: InputDecoration(
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(13.0),
                //       ),
                //       prefixIcon: Icon(Icons.near_me),
                //       hintText: 'Name',
                //       labelText: 'Name'),
                // ),
                ),
            Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: TextFieldItem(
                  labelText: 'Phone',
                  controller: phoneCont,
                  type: 'phone',
                )
                // TextFormField(
                //   onSaved: (_input) {
                //     setState(() {
                //       _name = _input!;
                //     });
                //   },
                //   validator: (_input) {
                //     return _input!.length != 0 ? null : 'Please Enter phone number';
                //   },
                //   controller: phoneCont,
                //   decoration: InputDecoration(
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(13.0),
                //       ),
                //       prefixIcon: Icon(Icons.phone_rounded),
                //       hintText: 'Phone',
                //       labelText: 'Phone'),
                // ),
                ),
            Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: TextFieldItem(
                  labelText: 'Email',
                  controller: emailCont,
                  type: 'email',
                )
                // TextFormField(
                //   validator: (_input) {
                //     return _input!.contains('@') && _input.length > 8
                //         ? null
                //         : 'Enter a Valid Email';
                //   },
                //   onSaved: (_input) {
                //     setState(() {
                //       _email = _input!;
                //     });
                //   },
                //   controller: emailCont,
                //   decoration: InputDecoration(
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(13.0),
                //       ),
                //       prefixIcon: Icon(Icons.email),
                //       hintText: 'Email',
                //       labelText: 'Email'),
                // ),
                ),
            Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: TextFieldItem(
                  labelText: 'Password',
                  controller: passCont,
                  type: 'password',
                )
                // TextFormField(
                //   validator: (_input) {
                //     return null;
                //   },
                //   onSaved: (_input) {
                //     setState(() {
                //       _password = _input!;
                //     });
                //   },
                //   obscureText: isObsecure,
                //   controller: passCont,
                //   decoration: InputDecoration(
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(13.0),
                //       ),
                //       prefixIcon: Icon(Icons.lock),
                //       suffixIcon: GestureDetector(
                //         child: Icon(
                //             isObsecure ? Icons.visibility : Icons.visibility_off),
                //         onTap: () {
                //           setState(() {
                //             isObsecure = !isObsecure;
                //           });
                //         },
                //       ),
                //       hintText: 'Password',
                //       labelText: 'Password'),
                // ),
                ),

            Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: MaterialButton(
                color: Constants.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                onPressed: () async {
                  print('$buyer');
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SpinKitCubeGrid(
                          color: Constants.primaryColor,
                        );
                      },
                    );

                    String result = await APICalls(context).signUp(
                        nameCont.text,
                        phoneCont.text,
                        emailCont.text,
                        _imageFile,
                        passCont.text, buyer ? 'buyer' :'seller');
                    print(result);
                    Navigator.pop(context);
                    if (result == "success") {

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Store()
                          // VerifyAccount(phone: phoneCont.text)
                        ),
                      );
                    }

                  }
                },
                child: isloading
                    ? CupertinoActivityIndicator()
                    : Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(AppLocalizations.getTranslated(
                            context, 'register')),
                      ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.getTranslated(context, 'haveAccount')),
                  ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          elevation: MaterialStateProperty.all(0.0),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login(),
                            ),
                          ),
                      child: Text(
                       AppLocalizations.getTranslated(context, 'login'),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Constants.primaryColor),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  pickImage(source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
      );
      setState(() {
        _imageFile = pickedFile!;
      });
      Navigator.pop(context);
    } catch (e) {
      print('pickImage catch $e');
    }
  }
}

class CustomerProvider with ChangeNotifier, DiagnosticableTreeMixin {
  Customer _customer = new Customer(
    0,
    '',
    '',
    '',
    '',
    '','',''
  );

  Customer get customer => _customer;

  void update(Customer customer) {
    _customer = customer;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('customer', customer));
  }

  void updateImageUrl(String url) {
    _customer.photo = url;
    notifyListeners();
  }
}
