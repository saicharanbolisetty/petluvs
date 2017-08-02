/*
import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'dart:async';
import 'package:flutter/services.dart';



class CheckInPage extends StatefulWidget {
  CheckInPage({Key key}) : super(key: key);

  static const String routeName = "/CheckInPage";


//   static const String postRef = snapshot.key;


  @override
  CheckInPageState createState() => new CheckInPageState();
}

class CheckInPageState extends State<CheckInPage> {
  Map<String,double> _currentLocation;
  StreamSubscription<Map<String,double>> _locationSubscription;
  Location _location = new Location();

  bool currentWidget = true;

  Image image1;
  Image image2;


  @override
  initState() {
    super.initState();
    initPlatformState();
    _locationSubscription =
        _location.onLocationChanged.listen((Map<String,double> result) {
          setState(() {
            _currentLocation = result;
          });
        });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    Map<String,double> location;
    // Platform messages may fail, so we use a try/catch PlatformException.


    try {
      location = _location!=null?await _location.getLocation : null;
    } on PlatformException {
      location = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted)
      return;

    setState(() {
      _currentLocation = location;
      print(_currentLocation);
    });
  }

  @override
  Widget build(BuildContext context) {
    if(currentWidget){
      image1 = new Image.network("https://maps.googleapis.com/maps/api/staticmap?center=${_currentLocation["latitude"]},${_currentLocation["longitude"]}&zoom=18&size=640x400&key=AIzaSyAStllbBZ0-hVkiRp4MNapbv4Nq9_Tqgtg");
      currentWidget = !currentWidget;
    }else{
      image2 = new Image.network("https://maps.googleapis.com/maps/api/staticmap?center=${_currentLocation["latitude"]},${_currentLocation["longitude"]}&zoom=18&size=640x400&key=AIzaSyAStllbBZ0-hVkiRp4MNapbv4Nq9_Tqgtg");
      currentWidget = !currentWidget;
    }



//      if(_currentLocation==null ) {
      return new Container(
//        home: new Scaffold(
//            appBar: new AppBar(
//              title: new Text('Plugin example app'),
//            ),
            child:
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                image1!=null?
            new Stack(children: <Widget>[image1, image2])
              :new Text("please enable location"),
                _currentLocation!=null?
                new Center(child:new Text('$_currentLocation\n'))
                    :new Text("please enable location"),

              ],
            )

        );
//    }
//        else return new Container(child: new Text("Please enable location"),);
      }
  }





*/
