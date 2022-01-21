//@dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:market_app/chats/rooms.dart';
import 'package:market_app/models/language.dart';
import 'package:market_app/pages/auth/loginPage.dart';
import 'package:market_app/pages/cart.dart';
import 'package:market_app/pages/profile.dart';
import 'package:market_app/pages/services.dart';
import 'package:market_app/pages/store.dart';
import 'package:market_app/process/DBProvider.dart';
import 'package:market_app/translate/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../main.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  ZoomDrawerController controller = ZoomDrawerController();
  List<Language> languages = Language.languageList();
  List<bool> isSelected;
  SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero,() async {
      prefs = await SharedPreferences.getInstance();
      setState(() {

      });
    });

  }

  @override
  Widget build(BuildContext context) {
    if (AppLocalizations.of(context).locale.languageCode.toUpperCase() == "EN")
      setState(() {
        isSelected = [true, false];
      });
    else
      setState(() {
        isSelected = [false, true];
      });

    return SafeArea(
      child: Container(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            children: [
              Container(
                width: 128.0,
                height: 128.0,
                margin: const EdgeInsets.only(
                  top: 24.0,
                  bottom: 64.0,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/market.png',
                  fit: BoxFit.cover,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return Store();
                        //RegisterPage();
                      },
                    ),
                  );
                },
                leading: Icon(Icons.home),
                title: Text(AppLocalizations.getTranslated(context, 'home')),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return ProfilePage();
                      },
                    ),
                  );
                },
                leading: Icon(Icons.account_circle_rounded),
                title: Text(AppLocalizations.getTranslated(context, 'profile')),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return RoomsPage();
                        //RegisterPage();
                      },
                    ),
                  );
                },
                leading: Icon(Icons.chat),
                title: Text('Chats'
                    //AppLocalizations.getTranslated(context, 'profile')
                    ),
              ),
              prefs != null && prefs.get('user_type') == 'seller'
                  ? ListTile(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return //RoomsPage();
                                  Services();
                            },
                          ),
                        );
                      },
                      leading: Icon(Icons.miscellaneous_services_rounded),
                      title: Text('Services'
                          //AppLocalizations.getTranslated(context, 'profile')
                          ),
                    )
                  : SizedBox(),
              prefs != null && prefs.get('user_type') == 'buyer'
                  ? ListTile(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return //RoomsPage();
                                  CartPage();
                            },
                          ),
                        );
                      },
                      leading: Icon(Icons.add_shopping_cart),
                      title: Text('Cart'
                          //AppLocalizations.getTranslated(context, 'profile')
                          ),
                    )
                  : SizedBox(),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.language),
                title:
                    Text(AppLocalizations.getTranslated(context, 'language')),
                trailing: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ToggleButtons(
                    constraints: BoxConstraints(minWidth: 50, minHeight: 30),
                    renderBorder: true,
                    fillColor: Color(0xff0EB7A8),
                    borderWidth: 2,
                    selectedBorderColor: Color(0xff0EB7A8),
                    selectedColor: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    children: <Widget>[
                      Text(
                        languages[0].flag, //+' '+languages[0].name,
                        style: TextStyle(fontSize: 16, fontFamily: 'sans'),
                      ),
                      Text(
                        languages[1].flag, //+' '+languages[1].name,
                        style: TextStyle(fontSize: 16, fontFamily: 'sans'),
                      ),
                    ],
                    onPressed: (int index) async {
                      setState(() {
                        for (int i = 0; i < isSelected.length; i++) {
                          isSelected[i] = i == index;
                          if (isSelected[0]) {
                            _changeLanguage(languages[index]);
                          }
                          if (isSelected[1]) {
                            _changeLanguage(languages[index]);
                          }
                        }
                      });
                    },
                    isSelected: isSelected,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        content: Text(AppLocalizations.getTranslated(
                            context, 'easyLogin')),
                        actions: [
                          ElevatedButton(
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(10),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(70))))),
                            onPressed: () {
                              prefs.setInt(
                                  'bindDevice', prefs.getInt('passenger_id'));
                              Navigator.pop(context);
                            },
                            child: Text(
                                AppLocalizations.getTranslated(context, 'ok')),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red),
                                elevation: MaterialStateProperty.all(10),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(70))))),
                            onPressed: () {
                              prefs.remove('bindDevice');
                              Navigator.pop(context);
                            },
                            child: Text(AppLocalizations.getTranslated(
                                context, 'cancel')),
                          ),
                        ],
                      );
                    },
                  );
                },
                leading: Icon(Icons.link),
                title:
                    Text(AppLocalizations.getTranslated(context, 'saveDevice')
                        //AppLocalizations.getTranslated(context, 'profile')
                        ),
              ),
              ListTile(
                onTap: () {
                  int id;
                  if (prefs.containsKey('bindDevice'))
                    id = prefs.getInt('bindDevice');
                  prefs.clear();

                  if (id != null) prefs.setInt('bindDevice', id);
                  DBProvider.db.emptyCart();
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                    builder: (BuildContext context) {
                      return //RoomsPage();
                          Login();
                    },
                  ), (Route<dynamic> route) => false);
                },
                leading: Icon(Icons.logout),
                title: Text(AppLocalizations.getTranslated(context, 'logout')),
              ),
              Spacer(),
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: Text('Terms of Service | Privacy Policy'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeLanguage(Language language) async {
    Locale _locale = await Constants().setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }
}
