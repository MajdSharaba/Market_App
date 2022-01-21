import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:market_app/translate/app_localizations.dart';
import 'package:market_app/widgets/customClipper.dart';

import 'home.dart';

class AppLock extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<AppLock> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not s';
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason: 'Authentication method',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    setState(() {
      _authorized = authenticated ? 'Authorized' : 'Not Authorized';
      if (authenticated)
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Home();
            },
          ),
        );
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason:
              'Scan your fingerprint (or face or whatever) to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  void _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 200),
          child: Text(
            AppLocalizations.getTranslated(context, 'welcome'),
            style: TextStyle(
              height: 2.5,
              fontSize: 28.0,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(75),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "${AppLocalizations.getTranslated(context, 'authenticate')} \n",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
                "${AppLocalizations.getTranslated(context, 'authenticate_desc')} \n",
                textAlign: TextAlign.center),

            (_isAuthenticating)
                ? ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(30))))),
                    onPressed: _cancelAuthentication,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Cancel Authentication"),
                          Icon(Icons.cancel),
                        ],
                      ),
                    ),
                  )
                : ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))))),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Authenticate'),
                          Icon(Icons.perm_device_information),
                        ],
                      ),
                    ),
                    onPressed: _authenticate,
                  ),
            // ListView(
            //   padding: const EdgeInsets.only(top: 30),
            //   children: [
            //     Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         if (_supportState == _SupportState.unknown)
            //           CircularProgressIndicator()
            //         else if (_supportState == _SupportState.supported)
            //           Text("This device is supported")
            //         else
            //           Text("This device is not supported"),
            //         Divider(height: 100),
            //         Text('Can check biometrics: $_canCheckBiometrics\n'),
            //         ElevatedButton(
            //           child: const Text('Check biometrics'),
            //           onPressed: _checkBiometrics,
            //         ),
            //         Divider(height: 100),
            //         Text('Available biometrics: $_availableBiometrics\n'),
            //         ElevatedButton(
            //           child: const Text('Get available biometrics'),
            //           onPressed: _getAvailableBiometrics,
            //         ),
            //         Divider(height: 100),
            //         Text('Current State: $_authorized\n'),
            //         (_isAuthenticating)
            //             ? ElevatedButton(
            //           onPressed: _cancelAuthentication,
            //           child: Row(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Text("Cancel Authentication"),
            //               Icon(Icons.cancel),
            //             ],
            //           ),
            //         )
            //             : Column(
            //           children: [
            //             ElevatedButton(
            //               child: Row(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   Text('Authenticate'),
            //                   Icon(Icons.perm_device_information),
            //                 ],
            //               ),
            //               onPressed: _authenticate,
            //             ),
            //             ElevatedButton(
            //               child: Row(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   Text(_isAuthenticating
            //                       ? 'Cancel'
            //                       : 'Authenticate: biometrics only'),
            //                   Icon(Icons.fingerprint),
            //                 ],
            //               ),
            //               onPressed: _authenticateWithBiometrics,
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
