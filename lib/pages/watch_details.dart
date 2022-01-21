//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:market_app/chats/chat.dart';
import 'package:market_app/constants.dart';
import 'package:market_app/models/product.dart';
import 'package:market_app/process/DBProvider.dart';
import 'package:market_app/process/payment.dart';
import 'package:market_app/widgets/main_app_bar.dart';
import 'package:market_app/widgets/watch_detail_footer.dart';
import 'package:market_app/widgets/watch_detail_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;


class WatchDetails extends StatefulWidget {
  final Product watch;
  final String tag;

  WatchDetails({this.watch, this.tag});

  @override
  _WatchDetailsState createState() => _WatchDetailsState();
}

class _WatchDetailsState extends State<WatchDetails> {
  int cartItemCount = 1;
  SharedPreferences preferences;
  types.User user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeServices.init();
    getSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    // print(preferences.getString('user_type'));
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Expanded(
                          child: Container(
                            color: Constants.primaryColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // MainAppBar(),
                        SizedBox(
                          height: 50.0,
                        ),
                        WatchDetailImage(
                          image: this.widget.watch.image,
                          tag: this.widget.tag,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: this.widget.watch.brand,
                                      style: TextStyle(
                                        height: 2.5,
                                        fontSize: 28.0,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(34, 34, 34, 1),
                                      ),
                                    ),
                                    TextSpan(
                                      text: " " +
                                          this.widget.watch.name +
                                          " - " +
                                          this.widget.watch.model,
                                      style: TextStyle(
                                        fontSize: 28.0,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  this.widget.watch.category,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Constants.primaryColor,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  this.widget.watch.description,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                    height: 1.40,
                                  ),
                                ),
                              ),
                              (preferences != null && preferences.getString('user_type') == 'buyer')
                              ?ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(40))),
                                title: Text('By'),
                                  subtitle: Text(widget.watch.sellerName),
                                trailing: IconButton(
                                  onPressed: () async {
                                    final room = await FirebaseChatCore.instance.createRoom(user);
                                    print('${user.firstName} --${user.imageUrl} --${user.id}  --');
                                    print('${room.type} --${room.name} --${room.id}  --');
                                    Navigator.of(context).pop();
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          room: room,
                                        ),
                                      ),
                                    );
                                  },
                                    icon: Icon(Icons.chat , size: 35,color: Constants.primaryColor,)
                                ),
                              )
                              : SizedBox(),
                              Container(
                                height: 90.0,
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 15.0),
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                          color:
                                              Color.fromRGBO(230, 230, 230, 1),
                                        ),
                                      ),
                                      child:
                                     (preferences != null && preferences.getString('user_type') == 'buyer')
                                          ? Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      cartItemCount += 1;
                                                    });
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 90.0,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 16.0,
                                                    ),
                                                    child: Text(
                                                      "+",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 24.0,
                                                        color: Color.fromRGBO(
                                                            34, 34, 34, 1),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 16.0,
                                                  ),
                                                  child: Text(
                                                    "${this.cartItemCount}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 24.0,
                                                      color: Color.fromRGBO(
                                                          34, 34, 34, 1),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      cartItemCount =
                                                          cartItemCount > 2
                                                              ? cartItemCount -
                                                                  1
                                                              : 1;
                                                    });
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 90.0,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 16.0,
                                                    ),
                                                    child: Text(
                                                      "-",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 24.0,
                                                        color: Color.fromRGBO(
                                                            34, 34, 34, 1),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : SizedBox(),
                                    ),
                                    Text(' ر.ع  ',  style: TextStyle(color: Colors.blueGrey , fontWeight: FontWeight.bold)),
                                    Text(
                                      "${(this.widget.watch.price * this.cartItemCount).toStringAsFixed(2)}",

                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24.0,
                                        color: Color.fromRGBO(34, 34, 34, 1),
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 10.0,
                              ),

                              (preferences != null && preferences.getString('user_type') != 'seller')
                              ? Row(
                                children: [
                                  // InkWell(
                                  //   onTap: () {},
                                  //   child: Container(
                                  //     margin: EdgeInsets.only(right: 15.0),
                                  //     width: 60.0,
                                  //     height: 60.0,
                                  //     decoration: BoxDecoration(
                                  //       borderRadius:
                                  //           BorderRadius.circular(8.0),
                                  //       border: Border.all(
                                  //         color:
                                  //             Color.fromRGBO(230, 230, 230, 1),
                                  //       ),
                                  //     ),
                                  //     child: Icon(
                                  //       Icons.favorite_border,
                                  //     ),
                                  //   ),
                                  // ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        DBProvider.db.newProduct(
                                            Product(
                                              id: widget.watch.id.toString(),
                                              name: widget.watch.name ,
                                              price: widget.watch.price ,
                                              image: widget.watch.image ,
                                              brand: widget.watch.brand ,
                                              category: widget.watch.category ,
                                            description: widget.watch.description,
                                            model: widget.watch.model,
                                            ));

                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 15.0),
                                        height: 60.0,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 32.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Constants.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          border: Border.all(
                                            color: Color.fromRGBO(
                                                230, 230, 230, 1),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Add to Cart",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                              : SizedBox(),

                              // WatchDetailFooter(),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getSharedPreferences() async {
    preferences = await SharedPreferences.getInstance();
    FirebaseChatCore.instance.users().forEach((element) {
      for(var e in element) {
        print('test  ${e.id}---${e.firstName}--${widget.watch.sellerName}-');
        if(e.firstName == widget.watch.sellerName) {
          user = e;
          setState(() {});
          break;
        }
      }
    });
    setState(() {

    });
  }
}
