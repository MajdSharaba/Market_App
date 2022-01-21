//@dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:market_app/chats/rooms.dart';
import 'package:market_app/constants.dart';
import 'package:market_app/models/language.dart';
import 'package:market_app/models/product.dart';
import 'package:market_app/models/service.dart';
import 'package:market_app/pages/store.dart';
import 'package:market_app/process/DBProvider.dart';
import 'package:market_app/process/payment.dart';
import 'package:market_app/translate/app_localizations.dart';
import 'package:market_app/widgets/CustomToast.dart';
import 'package:market_app/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:market_app/pages/auth/loginPage.dart';
import 'package:market_app/pages/profile.dart';
import 'package:market_app/pages/services.dart';
import 'package:market_app/pages/shopLocation.dart';
import 'package:market_app/pages/watch_details.dart';

import '../main.dart';

class CartPage extends StatefulWidget {

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<CartPage> {
  List services = [
    Service(0, 'name', 'from', Icons.domain),
    Service(0, 'name', 'from', Icons.domain),
  ];
  ZoomDrawerController controller = ZoomDrawerController();
  final _advancedDrawerController = AdvancedDrawerController();
  List<Language> languages = Language.languageList();
  List<bool> isSelected;
  SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeServices.init();
    Future.delayed(Duration.zero,() async {
      prefs = await SharedPreferences.getInstance();
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {

    if(AppLocalizations.of(context).locale.languageCode.toUpperCase()=="EN")
      setState(() {
        isSelected=[true,false];
      });
    else
      setState(() {
        isSelected=[false,true];
      });

    return AdvancedDrawer(
      backdropColor: Colors.blueGrey,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: (AppLocalizations.of(context).locale.languageCode.toUpperCase()=="EN") ? false : true,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 0.0,
        //   ),
        // ],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            AppLocalizations.getTranslated(context, 'cart'),//cart
            style: TextStyle(
              height: 2.5,
              fontSize: 28.0,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey,
            ),
          ),
        ),
        body: Container(
          // color: Colors.red,
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: FutureBuilder<List>(
                  future: DBProvider.db.getProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data.length != 0) {
                      return ListView.builder(
                        padding: EdgeInsets.all(10),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return serviceItem(snapshot.data[index]);
                        },
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return SpinKitCubeGrid(
                        color: Constants.primaryColor,
                      );
                    return Center(
                      child: Text('Your Cart is Empty!'),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 10,
          child: Icon(Icons.payment),
          onPressed: () async{
            var calcTotal = await DBProvider.db.countTotalProducts();
            if (calcTotal[0]['Total'] > 0){
              print('test total ${calcTotal[0]['Total'] >= 0}');
              var total = calcTotal[0]['Total'];
              var response = await StripeServices.payNowHandler(
                  amount: '$total', currency: 'USD');
              print('response message ${response.message}');
              if (response.message == 'Transaction succeful') {
                await DBProvider.db.emptyCart();

                showToastWidget(
                    BannerToastWidget.success(
                        msg: AppLocalizations.getTranslated(context, 'success')),
                    context: context,
                    animation: StyledToastAnimation.slideFromTop,
                    // reverseAnimation: StyledToastAnimation.slideToTop,
                    position: StyledToastPosition.top,
                    animDuration: Duration(seconds: 1),
                    duration: Duration(seconds: 4),
                    curve: Curves.elasticOut,
                    reverseCurve: Curves.fastOutSlowIn);
              }
              else {
                showToastWidget(
                    BannerToastWidget.fail(
                        msg: AppLocalizations.getTranslated(
                            context, 'somethingWrong')),
                    context: context,
                    animation: StyledToastAnimation.slideFromTop,
                    // reverseAnimation: StyledToastAnimation.slideToTop,
                    position: StyledToastPosition.top,
                    animDuration: Duration(seconds: 1),
                    duration: Duration(seconds: 4),
                    curve: Curves.elasticOut,
                    reverseCurve: Curves.fastOutSlowIn);
              }
            }
            else{
              showToastWidget(
                  BannerToastWidget.fail(
                      msg: AppLocalizations.getTranslated(
                          context, 'cartEmpty')),
                  context: context,
                  animation: StyledToastAnimation.slideFromTop,
                  // reverseAnimation: StyledToastAnimation.slideToTop,
                  position: StyledToastPosition.top,
                  animDuration: Duration(seconds: 1),
                  duration: Duration(seconds: 4),
                  curve: Curves.elasticOut,
                  reverseCurve: Curves.fastOutSlowIn);
            }
          },
        ),
      ),
      drawer: MainDrawer(),

    );
  }

  void _changeLanguage(Language language) async {
    Locale _locale = await Constants().setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  Widget serviceItem(product) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              topRight: Radius.circular(30))),
      child: ExpansionTile(

        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Image.network(product['image'] , fit: BoxFit.fill,),
            title: Text(product['name']),
          ),
        ),
        children: [
          ListTile(
            leading: Icon(Icons.description_outlined),
            title: Text(product['description'] , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 16),),
            subtitle: Text('${product['category']}'),
          ),
          InkWell(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                topRight: Radius.circular(30)),
            onTap: (){},
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                shape: BoxShape.rectangle,
                color: Constants.primaryColor,

              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('ر.ع ' ,
                      style: TextStyle(
                          fontSize: 14 ,
                          fontWeight: FontWeight.bold ,
                          color: Colors.white),),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${product['price']}' ,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                            fontSize: 16
                        ),)
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
