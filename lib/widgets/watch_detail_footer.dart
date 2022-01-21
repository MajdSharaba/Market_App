import 'package:flutter/material.dart';
import 'package:market_app/constants.dart';

class WatchDetailFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.only(right: 15.0),
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: Color.fromRGBO(230, 230, 230, 1),
              ),
            ),
            child: Icon(
              Icons.favorite_border,
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(right: 15.0),
              height: 60.0,
              padding: EdgeInsets.symmetric(
                horizontal: 32.0,
              ),
              decoration: BoxDecoration(
                color: Constants.primaryColor,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Color.fromRGBO(230, 230, 230, 1),
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
    );
  }
}
