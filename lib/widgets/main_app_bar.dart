//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class MainAppBar extends StatelessWidget {
  final ZoomDrawerController drawer;

  const MainAppBar({Key key, this.drawer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: SvgPicture.asset(
            "assets/svg/menu.svg",
            width: 12.0,
            height: 12.0,
          ),
          onPressed: () {
            drawer.open();
          },
        ),
        IconButton(
          icon: SvgPicture.asset(
            "assets/svg/hamburger.svg",
            width: 16.0,
            height: 16.0,
          ),
          onPressed: () {},
        )
      ],
    );
  }
}
