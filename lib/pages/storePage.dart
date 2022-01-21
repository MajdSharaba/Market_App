// //@dart=2.9
// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:market_app/models/product.dart';
// import 'package:market_app/pages/watch_details.dart';
// import 'package:market_app/translate/app_localizations.dart';
// import 'package:market_app/widgets/addProductDialog.dart';
//
// import '../constants.dart';
//
// class StorePage extends StatefulWidget {
//   const StorePage({Key key}) : super(key: key);
//
//   @override
//   _StorePageState createState() => _StorePageState();
// }
//
// class _StorePageState extends State<StorePage> {
//
//   final List<Product> watches = [
//     Product(
//       brand: "Everlance",
//       name: "Pants",
//       image: "assets/images/item1.png",
//       model: "Long",
//       price: 79.99,
//       category: "Men's Cloth",
//       description:
//       "Combining functionality with timeless style. Explore the Rolex® collection and find the watch is that was made for you.",
//     ),
//     Product(
//       brand: "UpWest",
//       name: "Sweater",
//       image: "assets/images/item2.png",
//       price: 79.99,
//       category: "Men's Cloth",
//       model: "BLue Long",
//       description:
//       "Combining functionality with timeless style. Explore the Rolex® collection and find the watch is that was made for you.",
//     ),
//     Product(
//       brand: "Everlance",
//       name: "Pants",
//       image: "assets/images/item3.png",
//       model: "Jeans",
//       price: 79.99,
//       category: "Men's Cloth",
//       description:
//       "Combining functionality with timeless style. Explore the Rolex® collection and find the watch is that was made for you.",
//     ),
//     Product(
//       brand: "Nike",
//       name: "Shoes",
//       image: "assets/images/item5.png",
//       model: "Cheek",
//       price: 79.99,
//       category: "Men's Cloth",
//       description:
//       "Combining functionality with timeless style. Explore the Rolex® collection and find the watch is that was made for you.",
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return  Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // MainAppBar(drawer: controller),
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //   children: [
//           //     IconButton(
//           //       onPressed: _handleMenuButtonPressed,
//           //       icon: ValueListenableBuilder<AdvancedDrawerValue>(
//           //         valueListenable: _advancedDrawerController,
//           //         builder: (_, value, __) {
//           //           return AnimatedSwitcher(
//           //             duration: Duration(milliseconds: 250),
//           //             child:  value.visible ?Icon(
//           //               Icons.clear ,
//           //               key: ValueKey<bool>(value.visible),
//           //             )
//           //                 : SvgPicture.asset(
//           //               "assets/svg/menu.svg",
//           //               width: 12.0,
//           //               height: 12.0,
//           //               key:  ValueKey<bool>(value.visible),
//           //             ),
//           //           );
//           //         },
//           //       ),
//           //     ),
//           //     IconButton(
//           //       icon: Icon(Icons.search),
//           //       onPressed: () {
//           //         Navigator.of(context).push(
//           //           MaterialPageRoute(
//           //             builder: (BuildContext context) {
//           //               return ShopLocation();
//           //             },
//           //           ),
//           //         );
//           //
//           //       },
//           //     ),
//           //     // IconButton(
//           //     //   icon: SvgPicture.asset(
//           //     //     "assets/svg/hamburger.svg",
//           //     //     width: 16.0,
//           //     //     height: 16.0,
//           //     //   ),
//           //     //   onPressed: () {},
//           //     // ),
//           //   ],
//           // ),
//           // IconButton(
//           //   icon: SvgPicture.asset(
//           //     "assets/svg/menu.svg",
//           //     width: 12.0,
//           //     height: 12.0,
//           //   ),
//           //   onPressed: () {
//           //     controller.open;
//           //   },
//           // ),
//           // SizedBox(
//           //   height: 50.0,
//           // ),
//           // RichText(
//           //   textAlign: TextAlign.left,
//           //   text: TextSpan(
//           //     children: [
//           //       TextSpan(
//           //         text: AppLocalizations.getTranslated(context, 'key'),
//           //         style: TextStyle(
//           //           height: 2.5,
//           //           fontSize: 28.0,
//           //           fontWeight: FontWeight.w600,
//           //           color: Color.fromRGBO(34, 34, 34, 1),
//           //         ),
//           //       ),
//           //       TextSpan(
//           //         text: "of luxury",
//           //         style: TextStyle(
//           //           fontSize: 28.0,
//           //           color: Color.fromRGBO(34, 34, 34, 1),
//           //         ),
//           //       ),
//           //     ],
//           //   ),
//           // ),
//           Padding(
//             padding: const EdgeInsets.only(right: 8.0, left: 8.0),
//             child: Text(AppLocalizations.getTranslated(context, 'products'),
//               style: TextStyle(
//                 height: 2.5,
//                 fontSize: 28.0,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.blueGrey,
//               ),),
//           ),
//           SizedBox(
//             height: 50.0,
//           ),
//           // HomeOptions(),
//           // SizedBox(
//           //   height: 30.0,
//           // ),
//           Flexible(
//             child: StaggeredGridView.countBuilder(
//               physics: NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               crossAxisCount: 4,
//               itemCount: watches.length,
//               itemBuilder: (BuildContext context, int index) =>
//                   ZoomIn(
//
//                     child: Hero(
//                       tag: "watch-$index",
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (BuildContext context) {
//                                 return WatchDetails(
//                                   watch: this.watches[index],
//                                   tag: "watch-$index",
//                                 );
//                               },
//                             ),
//                           );
//                         },
//                         child: Directionality(
//                           textDirection: TextDirection.ltr,
//                           child: Container(
//                             padding: EdgeInsets.only(left: 15.0,top: 15.0),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                             child: Column(
//                               children: [
//                                 Expanded(
//                                   child: Image.asset(watches[index].image),
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Column(
//                                       children: [
//                                         Text(
//                                           watches[index].brand,
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                               fontSize: 14.0,
//                                               color: Constants.primaryColor
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 3.0,
//                                         ),
//                                         Text(
//                                           watches[index].name,
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                               fontSize: 14.0,
//                                               color: Colors.blueGrey
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Container(
//                                       decoration: BoxDecoration(
//                                           color: Constants.primaryColor,
//                                           borderRadius: BorderRadius.only(topLeft: Radius.circular(40) , bottomRight: Radius.circular(8))
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(15.0),
//                                         child: Row(
//                                           children: [
//                                             Text('ر.ع   ' ,
//                                               style: TextStyle(
//                                                   fontSize: 14 ,
//                                                   fontWeight: FontWeight.bold ,
//                                                   color: Colors.blueGrey),),
//                                             Text('${watches[index].price}' , style: TextStyle(fontSize: 12),),
//                                           ],
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//               staggeredTileBuilder: (int index) =>
//               new StaggeredTile.count(2, index.isEven ? 3 : 2),
//               mainAxisSpacing: 10.0,
//               crossAxisSpacing: 10.0,
//             ),
//           )
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor:  Constants.primaryColor,
//         child: Icon(Icons.add),
//         onPressed: (){
//           // showAddProductDialog();
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (BuildContext context) {
//                 return AddProduct();
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
