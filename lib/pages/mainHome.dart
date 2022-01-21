// //@dart=2.9
// import 'package:flutter/material.dart';
// import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
//
// class MainHome extends StatefulWidget {
//   const MainHome({Key key}) : super(key: key);
//
//   @override
//   _MainHomeState createState() => _MainHomeState();
// }
//
// class _MainHomeState extends State<MainHome> {
//   List<MenuItem> mainMenu = [
//     MenuItem(tr("payment"), Icons.payment, 0),
//     MenuItem(tr("promos"), Icons.card_giftcard, 1),
//     MenuItem(tr("notifications"), Icons.notifications, 2),
//     MenuItem(tr("help"), Icons.help, 3),
//     MenuItem(tr("about_us"), Icons.info_outline, 4),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return ZoomDrawer(
//       controller: controller,
//       style: DrawerStyle.DefaultStyle,
//       menuScreen: MenuScreen(
//         mainMenu,
//         callback: _updatePage,
//         current: _currentPage,
//       ),
//       mainScreen: ListView(
//         shrinkWrap: true,
//         children: [
//           Text('test mainScreen')
//         ],
//       ),
//       borderRadius: 24.0,
//       showShadow: true,
//       angle: -12.0,
//       backgroundColor: Colors.grey[300],
//       slideWidth: MediaQuery.of(context).size.width*.65,
//       openCurve: Curves.fastOutSlowIn,
//       closeCurve: Curves.bounceIn,
//     );
//   }
//
// }
