//@dart=2.9
import 'dart:convert';
import 'dart:typed_data';

import 'package:connectivity/connectivity.dart';
import 'package:cross_file/src/types/interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart';
import 'package:market_app/models/Customer.dart';
import 'package:market_app/models/product.dart';
import 'package:market_app/pages/auth/loginPage.dart';
import 'package:market_app/widgets/CustomToast.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:shared_preferences/shared_preferences.dart';

class APICalls{

  final BuildContext context;

  String domain = 'https://transferproject17.000webhostapp.com/api';

  APICalls(this.context);

  Future addProduct(product,  imageFile) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (await Connectivity().checkConnectivity() != ConnectivityResult.none) {
      try {
        // ByteData byteData = (await imageFile.readAsBytes()) as ByteData;
        List<int> imageData = await imageFile.readAsBytes();//byteData.buffer.asUint8List();
        String base64Image = base64Encode(imageData);
        print('addProduct $base64Image');

        var url = Uri.parse("$domain/marketproject/addProduct.php");
        final response = await post(url,
            body: {
              "seller_id": prefs.get('passenger_id').toString(),
              "name": product.name,
              "brand": product.brand,
              "category": product.category,
              "price": product.price.toString(),
              "model": product.model,
              "description": product.description,
              "image": base64Image,
        }).timeout(const Duration(seconds: 15));

        print('addProduct ${response.statusCode}');
        print('addProduct ${response.body}');

        if (response.statusCode >= 200 && response.statusCode < 299) {
          print('addProduct success');
          final jsonData = (json.decode(response.body));
          final error = jsonData['error'];

          if (!error) {
            showToastWidget(BannerToastWidget.success(msg: 'تمت العملية بنجاح'),
                context: context,
                animation: StyledToastAnimation.slideFromTop,
                // reverseAnimation: StyledToastAnimation.slideToTop,
                position: StyledToastPosition.top,
                animDuration: Duration(seconds: 1),
                duration: Duration(seconds: 4),
                curve: Curves.elasticOut,
                reverseCurve: Curves.fastOutSlowIn);

            return 'success';
          }
        } else if (response.statusCode == 401) {
          showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
              context: context,
              animation: StyledToastAnimation.slideFromTop,
              // reverseAnimation: StyledToastAnimation.slideToTop,
              position: StyledToastPosition.top,
              animDuration: Duration(seconds: 1),
              duration: Duration(seconds: 4),
              curve: Curves.elasticOut,
              reverseCurve: Curves.fastOutSlowIn);
          print('addProduct error 401 ');
        } else {
          showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
              context: context,
              animation: StyledToastAnimation.slideFromTop,
              // reverseAnimation: StyledToastAnimation.slideToTop,
              position: StyledToastPosition.top,
              animDuration: Duration(seconds: 1),
              duration: Duration(seconds: 4),
              curve: Curves.elasticOut,
              reverseCurve: Curves.fastOutSlowIn);
          print('addProduct error ');
          return 'error';
        }
      } catch (e) {
        showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
            context: context,
            animation: StyledToastAnimation.slideFromTop,
            // reverseAnimation: StyledToastAnimation.slideToTop,
            position: StyledToastPosition.top,
            animDuration: Duration(seconds: 1),
            duration: Duration(seconds: 4),
            curve: Curves.elasticOut,
            reverseCurve: Curves.fastOutSlowIn);
        print('addProduct catch $e');

        return 'catch';
      }
    }
    else {
      showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
          context: context,
          animation: StyledToastAnimation.slideFromTop,
          // reverseAnimation: StyledToastAnimation.slideToTop,
          position: StyledToastPosition.top,
          animDuration: Duration(seconds: 1),
          duration: Duration(seconds: 4),
          curve: Curves.elasticOut,
          reverseCurve: Curves.fastOutSlowIn);
      print('addProduct no connection');

      return 'no connection';
    }

  }

  Future<List> getProduct() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List products = [];

    if (await Connectivity().checkConnectivity() != ConnectivityResult.none) {
      try {
        var url = Uri.parse("$domain/marketproject/getProduct.php");
        final response = await get(url).timeout(const Duration(seconds: 15));

        print('getProduct ${response.statusCode}');
        print('getProduct ${response.body}');

        if (response.statusCode >= 200 && response.statusCode < 299) {
          print('getProduct success');
          final jsonData = (json.decode(response.body));
          final error = jsonData['error'];


          if (!error) {

            var getproducts = jsonData['products'];

            for(var product in getproducts){
              products.add(Product(
                id: product['id'].toString(),
                name: product['name'],
                description: product['description'],
                model: product['model'],
                image: product['image'],
                price: double.parse(product['price']),
                brand: product['brand'],
                category: product['category'],
                sellerName: product['seller_name'],
              ));
            }



            return products;
          }
        } else if (response.statusCode == 401) {
          // showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
          //     context: context,
          //     animation: StyledToastAnimation.slideFromTop,
          //     // reverseAnimation: StyledToastAnimation.slideToTop,
          //     position: StyledToastPosition.top,
          //     animDuration: Duration(seconds: 1),
          //     duration: Duration(seconds: 4),
          //     curve: Curves.elasticOut,
          //     reverseCurve: Curves.fastOutSlowIn);
          print('getProduct error 401 ');
          return [];
        } else {
          // showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
          //     context: context,
          //     animation: StyledToastAnimation.slideFromTop,
          //     // reverseAnimation: StyledToastAnimation.slideToTop,
          //     position: StyledToastPosition.top,
          //     animDuration: Duration(seconds: 1),
          //     duration: Duration(seconds: 4),
          //     curve: Curves.elasticOut,
          //     reverseCurve: Curves.fastOutSlowIn);
          print('getProduct error ');
          return [];
        }
      } catch (e) {
        // showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
        //     context: context,
        //     animation: StyledToastAnimation.slideFromTop,
        //     // reverseAnimation: StyledToastAnimation.slideToTop,
        //     position: StyledToastPosition.top,
        //     animDuration: Duration(seconds: 1),
        //     duration: Duration(seconds: 4),
        //     curve: Curves.elasticOut,
        //     reverseCurve: Curves.fastOutSlowIn);
        print('getProduct catch $e');

        return [];
      }
    }
    else {
      // showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
      //     context: context,
      //     animation: StyledToastAnimation.slideFromTop,
      //     // reverseAnimation: StyledToastAnimation.slideToTop,
      //     position: StyledToastPosition.top,
      //     animDuration: Duration(seconds: 1),
      //     duration: Duration(seconds: 4),
      //     curve: Curves.elasticOut,
      //     reverseCurve: Curves.fastOutSlowIn);
      print('getProduct no connection');

      return [];
    }

  }

 Future<List> getSellerProduct() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List products = [];

    if (await Connectivity().checkConnectivity() != ConnectivityResult.none) {
      try {
        var url = Uri.parse("$domain/marketproject/getSellerProduct.php");
        final response = await post(url , body: {'seller_id': prefs.get('passenger_id').toString()}).timeout(const Duration(seconds: 15));

        print('getSellerProduct ${response.statusCode}');
        print('getSellerProduct ${response.body}');

        if (response.statusCode >= 200 && response.statusCode < 299) {
          print('getSellerProduct success');
          final jsonData = (json.decode(response.body));
          final error = jsonData['error'];


          if (!error) {

            var getproducts = jsonData['products'];

            for(var product in getproducts){
              products.add(Product(
                id: product['id'],
                name: product['name'],
                description: product['description'],
                model: product['model'],
                image: product['image'],
                price: double.parse(product['price']),
                brand: product['brand'],
                category: product['category'],
              ));
            }



            return products;
          }
        } else if (response.statusCode == 401) {

          print('getSellerProduct error 401 ');
          return [];
        } else {

          print('getSellerProduct error ');
          return [];
        }
      } catch (e) {

        print('getSellerProduct catch $e');

        return [];
      }
    }
    else {

      print('getSellerProduct no connection');

      return [];
    }

  }

  Future<Customer> getUserInfo({id}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List products = [];

    if (await Connectivity().checkConnectivity() != ConnectivityResult.none) {
      try {
        var url = Uri.parse("$domain/marketproject/getUserInfo.php");
        final response = await post(url,body: {'id': id != null ? id.toString() : prefs.get('passenger_id').toString()}).timeout(const Duration(seconds: 15));

        print('getUserInfo ${response.statusCode}');
        print('getUserInfo ${response.body}');

        if (response.statusCode >= 200 && response.statusCode < 299) {
          print('getUserInfo success');
          final jsonData = (json.decode(response.body));
          final error = jsonData['error'];


          if (!error) {

            var user = jsonData['user'];


              var userInfo = Customer((user['id']), user['name'], '', user['phone'], user['email'], user['image'],user['type'],user['password'],);




            return userInfo;
          }
        } else if (response.statusCode == 401) {
          // showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
          //     context: context,
          //     animation: StyledToastAnimation.slideFromTop,
          //     // reverseAnimation: StyledToastAnimation.slideToTop,
          //     position: StyledToastPosition.top,
          //     animDuration: Duration(seconds: 1),
          //     duration: Duration(seconds: 4),
          //     curve: Curves.elasticOut,
          //     reverseCurve: Curves.fastOutSlowIn);
          print('getUserInfo error 401 ');
          return null;
        } else {
          // showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
          //     context: context,
          //     animation: StyledToastAnimation.slideFromTop,
          //     // reverseAnimation: StyledToastAnimation.slideToTop,
          //     position: StyledToastPosition.top,
          //     animDuration: Duration(seconds: 1),
          //     duration: Duration(seconds: 4),
          //     curve: Curves.elasticOut,
          //     reverseCurve: Curves.fastOutSlowIn);
          print('getUserInfo error ');
          return null;
        }
      } catch (e) {
        // showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
        //     context: context,
        //     animation: StyledToastAnimation.slideFromTop,
        //     // reverseAnimation: StyledToastAnimation.slideToTop,
        //     position: StyledToastPosition.top,
        //     animDuration: Duration(seconds: 1),
        //     duration: Duration(seconds: 4),
        //     curve: Curves.elasticOut,
        //     reverseCurve: Curves.fastOutSlowIn);
        print('getUserInfo catch $e');

        return null;
      }
    }
    else {
      // showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
      //     context: context,
      //     animation: StyledToastAnimation.slideFromTop,
      //     // reverseAnimation: StyledToastAnimation.slideToTop,
      //     position: StyledToastPosition.top,
      //     animDuration: Duration(seconds: 1),
      //     duration: Duration(seconds: 4),
      //     curve: Curves.elasticOut,
      //     reverseCurve: Curves.fastOutSlowIn);
      print('getUserInfo no connection');

      return null;
    }

  }

  Future<String> signUp ( String name,String phone ,String email, imageFile ,  String pass , String type) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String base64Image;
    String passengerToken = '';

    try {
    // ByteData byteData = (await imageFile.readAsBytes()) as ByteData;

    if (imageFile.path != '') {
      List<int> imageData = await imageFile.readAsBytes();
      base64Image = base64Encode(imageData);
    }else base64Image = '';




       FirebaseMessaging.instance.getToken().then((token){
        print('token $token');
        passengerToken = token;
      });
    } on Exception catch (e) {
      // TODO
      print('exp  $e');
    }

    // if (connectivityResult != ConnectivityResult.none) {
      try {
        final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: pass,

        );
        var url = Uri.parse("$domain/marketproject/auth/signup.php");

        print("$name --- $email -- $pass -- $phone --$type    end");
        var response;
        if (base64Image != '') {
           response = await post(url, body: {
            "username": name,
            "email": email,
            "password": pass,
            "phone": phone,
            "image": base64Image,
            "type": type,
          })
              .timeout(const Duration(seconds: 30));
        }else
           response = await post(url, body: {
            "username": name,
            "email": email,
            "password": pass,
            "phone": phone,
            "type": type,
          })
              .timeout(const Duration(seconds: 30));

        print('SignUp ${response.statusCode}');
        print('SignUp ${response.body}');

        if (response.statusCode >= 200 && response.statusCode < 299) {
          print('SignUp success');
          final jsonData = (json.decode(response.body));
          final data = jsonData['error'];
          // pr.hide();
          if (!data) {
            final customer = jsonData['customer'];

            prefs.setInt('passenger_id', int.parse(customer['id'].toString()));
            prefs.setString('user_type', customer['type'].toString());


            await FirebaseChatCore.instance.createUserInFirestore(
              types.User(
                firstName: name,
                id: credential.user.uid,
                imageUrl: customer['image'],
                lastName: '',
              ),
            ).onError((error, stackTrace) {print('createUserInFirestore error $error');});


            /* context.read<CustomerProvider>().update(new Customer(
                int.parse(customer['id'].toString()),
                customer['username']
                    .toString()
                    .substring(0, customer['username'].toString().indexOf('#')),
                customer['username']
                    .toString()
                    .substring(customer['username'].toString().indexOf('#')),
                customer['phone'].toString(),
                customer['email'].toString(),
                customer['locationLat'],
                customer['locationLong'],
                '',
                0.0,
                []));*/






            print('finish');
            showToastWidget(BannerToastWidget.success(msg: 'تمت العملية بنجاح'),
                context: context,
                animation: StyledToastAnimation.slideFromTop,
                // reverseAnimation: StyledToastAnimation.slideToTop,
                position: StyledToastPosition.top,
                animDuration: Duration(seconds: 1),
                duration: Duration(seconds: 4),
                curve: Curves.elasticOut,
                reverseCurve: Curves.fastOutSlowIn);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => VerifyAccount(phone.text)),
            // );

            return 'success';
          } else if (jsonData['message'].toString() ==
              'User already registered') {
            showToastWidget(
                BannerToastWidget.fail(msg: 'هذا الحساب موجود مسبقاً'),
                context: context,
                animation: StyledToastAnimation.slideFromTop,
                // reverseAnimation: StyledToastAnimation.slideToTop,
                position: StyledToastPosition.top,
                animDuration: Duration(seconds: 1),
                duration: Duration(seconds: 4),
                curve: Curves.elasticOut,
                reverseCurve: Curves.fastOutSlowIn);
          } else {
            showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
                context: context,
                animation: StyledToastAnimation.slideFromTop,
                // reverseAnimation: StyledToastAnimation.slideToTop,
                position: StyledToastPosition.top,
                animDuration: Duration(seconds: 1),
                duration: Duration(seconds: 4),
                curve: Curves.elasticOut,
                reverseCurve: Curves.fastOutSlowIn);
          }

          return 'error';
        } else if (response.statusCode == 401) {
          showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
              context: context,
              animation: StyledToastAnimation.slideFromTop,
              reverseAnimation: StyledToastAnimation.slideToTop,
              position: StyledToastPosition.top,
              animDuration: Duration(seconds: 1),
              duration: Duration(seconds: 4),
              curve: Curves.elasticOut,
              reverseCurve: Curves.fastOutSlowIn);
          print('login error 401 ');
          return 'error';
        } else {
          showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
              context: context,
              animation: StyledToastAnimation.slideFromTop,
              // reverseAnimation: StyledToastAnimation.slideToTop,
              position: StyledToastPosition.top,
              animDuration: Duration(seconds: 1),
              duration: Duration(seconds: 4),
              curve: Curves.elasticOut,
              reverseCurve: Curves.fastOutSlowIn);
          print('login error ');
          return 'error';
        }
      } catch (e) {
        showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
            context: context,
            animation: StyledToastAnimation.slideFromTop,
            // reverseAnimation: StyledToastAnimation.slideToTop,
            position: StyledToastPosition.top,
            animDuration: Duration(seconds: 1),
            duration: Duration(seconds: 4),
            curve: Curves.elasticOut,
            reverseCurve: Curves.fastOutSlowIn);
        print('login catch $e');
        return 'error';
      }
    // }
    // else {
    //   showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
    //       context: context,
    //       animation: StyledToastAnimation.slideFromTop,
    //       // reverseAnimation: StyledToastAnimation.slideToTop,
    //       position: StyledToastPosition.top,
    //       animDuration: Duration(seconds: 1),
    //       duration: Duration(seconds: 4),
    //       curve: Curves.elasticOut,
    //       reverseCurve: Curves.fastOutSlowIn);
    //   print('login no connection');
    //
    //   return 'error';
    // }
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////
  Future<String> login (String phone, String pass) async {


    var connectivityResult = await (Connectivity().checkConnectivity());
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Customer customer;
    if (connectivityResult != ConnectivityResult.none) {
      try {
        var url = Uri.parse("$domain/marketproject/auth/login.php");
        final response = await post(url,
            body: {"phone": phone.replaceFirst('+', ''), "password": pass})
            .timeout(const Duration(seconds: 15));

        print('login ${response.statusCode}');
        print('login ${response.body}');

        if (response.statusCode >= 200 && response.statusCode < 299) {
          print('login success');
          final jsonData = (json.decode(response.body));
          final data = jsonData['error'];

          if (!data) {
            final customer = jsonData['user'];

            prefs.setInt('passenger_id', int.parse(customer['id'].toString()));
            prefs.setString('user_type', customer['type'].toString());

            await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: customer['email'],
              password: pass,
            );

            //  prefs.setInt('passenger_id', int.parse(customer['id'].toString()));
            showToastWidget(BannerToastWidget.success(msg: 'تمت العملية بنجاح'),
                context: context,
                animation: StyledToastAnimation.slideFromTop,
                // reverseAnimation: StyledToastAnimation.slideToTop,
                position: StyledToastPosition.top,
                animDuration: Duration(seconds: 1),
                duration: Duration(seconds: 4),
                curve: Curves.elasticOut,
                reverseCurve: Curves.fastOutSlowIn);
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => MainHomePage()),
            // );
            return 'success';
          } else if (jsonData['message'].toString().contains('Invalid')) {
            showToastWidget(
                BannerToastWidget.fail(
                    msg: 'الرجاء إدخال رقم وكلمة مرور صحيحين'),
                context: context,
                animation: StyledToastAnimation.slideFromTop,
                // reverseAnimation: StyledToastAnimation.slideToTop,
                position: StyledToastPosition.top,
                animDuration: Duration(seconds: 1),
                duration: Duration(seconds: 4),
                curve: Curves.elasticOut,
                reverseCurve: Curves.fastOutSlowIn);
            return 'Invalid';
          } else if (jsonData['message'].toString().contains('Not Verified')) {
            return 'Not Verified';
          }
        } else if (response.statusCode == 401) {
          showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
              context: context,
              animation: StyledToastAnimation.slideFromTop,
              // reverseAnimation: StyledToastAnimation.slideToTop,
              position: StyledToastPosition.top,
              animDuration: Duration(seconds: 1),
              duration: Duration(seconds: 4),
              curve: Curves.elasticOut,
              reverseCurve: Curves.fastOutSlowIn);
          print('login error 401 ');
          return 'login error 401';
        } else {
          showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
              context: context,
              animation: StyledToastAnimation.slideFromTop,
              // reverseAnimation: StyledToastAnimation.slideToTop,
              position: StyledToastPosition.top,
              animDuration: Duration(seconds: 1),
              duration: Duration(seconds: 4),
              curve: Curves.elasticOut,
              reverseCurve: Curves.fastOutSlowIn);
          print('login error ');
          return 'error';
        }
      } catch (e) {
        showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
            context: context,
            animation: StyledToastAnimation.slideFromTop,
            // reverseAnimation: StyledToastAnimation.slideToTop,
            position: StyledToastPosition.top,
            animDuration: Duration(seconds: 1),
            duration: Duration(seconds: 4),
            curve: Curves.elasticOut,
            reverseCurve: Curves.fastOutSlowIn);
        print('login catch $e');

        return 'catch';
      }
      return 'error';

    } else {
      showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
          context: context,
          animation: StyledToastAnimation.slideFromTop,
          // reverseAnimation: StyledToastAnimation.slideToTop,
          position: StyledToastPosition.top,
          animDuration: Duration(seconds: 1),
          duration: Duration(seconds: 4),
          curve: Curves.elasticOut,
          reverseCurve: Curves.fastOutSlowIn);
      print('login no connection');

      return 'no connection';
    }

  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////
  Future<bool> confirmAccount(String phone) async {
    //verify_account
    var connectivityResult = await (Connectivity().checkConnectivity());
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print('phone test   $phone');
    if (connectivityResult != ConnectivityResult.none) {
      try {
        var url = Uri.parse("$domain/marketproject/auth/verify_account.php");
        final response =
        await post(url, body: {
          "phone": phone.replaceFirst('+', ''),
        }).timeout(const Duration(seconds: 15));

        print('confirmAccount ${response.statusCode}');
        print('confirmAccount ${response.body}');

        if (response.statusCode >= 200 && response.statusCode < 299) {
          print('confirmAccount success');
          prefs.setInt('state', 1);
          final jsonData = (json.decode(response.body));
          final hasError = jsonData['error'];

          if (hasError) {
            return false;
          }

          showToastWidget(
              BannerToastWidget.success(msg: 'تمت تأكيد الحساب بنجاح'),
              context: context,
              animation: StyledToastAnimation.slideFromTop,
              // reverseAnimation: StyledToastAnimation.slideToTop,
              position: StyledToastPosition.top,
              animDuration: Duration(seconds: 1),
              duration: Duration(seconds: 4),
              curve: Curves.elasticOut,
              reverseCurve: Curves.fastOutSlowIn);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Login(),
              ));

          return true;
        } else if (response.statusCode == 401) {
          showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
              context: context,
              animation: StyledToastAnimation.slideFromTop,
              // reverseAnimation: StyledToastAnimation.slideToTop,
              position: StyledToastPosition.top,
              animDuration: Duration(seconds: 1),
              duration: Duration(seconds: 4),
              curve: Curves.elasticOut,
              reverseCurve: Curves.fastOutSlowIn);
          return false;
        } else {
          showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
              context: context,
              animation: StyledToastAnimation.slideFromTop,
              // reverseAnimation: StyledToastAnimation.slideToTop,
              position: StyledToastPosition.top,
              animDuration: Duration(seconds: 1),
              duration: Duration(seconds: 4),
              curve: Curves.elasticOut,
              reverseCurve: Curves.fastOutSlowIn);
          return false;
        }
      } catch (e) {
        print('confirmAccount catch $e');
        showToastWidget(BannerToastWidget.fail(msg: 'فشل الاتصال'),
            context: context,
            animation: StyledToastAnimation.slideFromTop,
            // reverseAnimation: StyledToastAnimation.slideToTop,
            position: StyledToastPosition.top,
            animDuration: Duration(seconds: 1),
            duration: Duration(seconds: 4),
            curve: Curves.elasticOut,
            reverseCurve: Curves.fastOutSlowIn);
        return false;
      }
    } else {
      return false;
    }
  }


}