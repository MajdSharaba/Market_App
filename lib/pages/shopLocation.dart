//@dart=2.9
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/place_picker.dart';
import 'package:place_picker/widgets/place_picker.dart';

class ShopLocation extends StatefulWidget {
  const ShopLocation({Key key}) : super(key: key);

  @override
  _ShopLocationState createState() => _ShopLocationState();
}

class _ShopLocationState extends State<ShopLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Text(''),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        getCurrentLocation().then((value) async {
        print('resr  ${value.longitude}');
        LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                PlacePicker("AIzaSyA96H2vAsbNLTnrajzN0l0_9HWcuh-_I4Y",
                  displayLocation: LatLng(value.latitude, value.longitude),
                )));
        });
        },
        child: Icon(Icons.ac_unit),
      ),
    );
  }


}

  Future<LocationData> getCurrentLocation() async{
    LocationData data;
    var _permissionGranted = await Location().hasPermission();
    if(_permissionGranted == PermissionStatus.denied)
      _permissionGranted = await Location().requestPermission();

    data = await Location().getLocation();
    // _currentPosition = Position(longitude: data.longitude , latitude: data.latitude);
    print('${data.longitude}   ${data.latitude}');

    return data;
  }
