import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:digital_lcd/digital_lcd.dart';
import 'package:digital_lcd/hex_color.dart';   //if you want use Hex Color codes this is required
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Speedometer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
//  void getCurrentLocation() {
//    var geolocator = Geolocator();
//    var locationOptions = LocationOptions(
//        accuracy: LocationAccuracy.high, distanceFilter: 10);
//
//    StreamSubscription<Position> positionStream = geolocator.getPositionStream(
//        locationOptions).listen(
//            (Position position) {
//          print(position == null ? 'Unknown' : position.latitude.toString() +
//              ', ' + position.longitude.toString());
//        });
//  }
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double speed = 100 ;

  var geolocator = Geolocator();
  var options = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   print("Bara el init");
    geolocator.getPositionStream(options).listen((position) {
      this.speed = position.speed; // this is your speed
      print("speed");
      print(this.speed);
    });
//    location.onLocationChanged().listen((value) {
//      print(value["latitude"].toString());
//      setState(() {
//        currentLocation = value;
//
//      });
//    });
  }

  Future<double> getCurrentSpeed()async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var geolocator = Geolocator();
    var options = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    geolocator.getPositionStream(options).listen((position) {
      this.speed = position.speed; // this is your speed
      print("speed");
      print(this.speed);
    });
    return this.speed;
    //    Map<String, double> cr = await location.getLocation();
//        setState (() {
//
//      currentLocation = cr;
//    });
//
//    print("Current Loc");
//    print(currentLocation);
//    print(cr);

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current Speed',
              style: TextStyle(fontSize: 35)
            ),
//            currentLocation == null
//                ? CircularProgressIndicator()
//                : Text("Location:" + currentLocation["latitude"].toString() + " " + currentLocation["longitude"].toString()),
            Lcd(context).Number(
              number: 123, //Your number variable
              digitCount:2, //Each time this value is increased, the digits are shrinks for width.
              lcdPadding: EdgeInsets.symmetric(horizontal:0),//this value only provides spaces to the left and right of the numbers. it also reduces proportionally the numbers
              digitAlignment: MainAxisAlignment.center, //if you have extra width, use it for better ui
              lcdWidth: MediaQuery.of(context).size.width,// numbers automatically fit to width by count of digit. if you only use this value, the height of the lcd is automatically adjusted
              lcdHeight:120 , // you may need to use scaleFactor if you use this value.
              scaleFactor :MediaQuery.of(context).size.height < MediaQuery.of(context).size.width ? 0.38: 0.22,//if you use lcdHeight , set this value for better ui
              segmentWidth : 8,// Thickness of each segment default 10 , best value range 5-12
              lcdDecoration: BoxDecoration(  //This is default decoration . not required
              ),
              activeColor: Colors.green.withOpacity(0.6),  //This is default  . not required
              inactiveColor: Colors.lightGreen.withOpacity(0.08),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom:40),
              child:Text(
                  'kmh',
                  style: TextStyle(fontSize: 35)
                ),
            ),
            Text(
              'From 10 to 30',
              style: TextStyle(fontSize: 25)
            ),
            Lcd(context).Number(
              number: 123, //Your number variable
              digitCount:2, //Each time this value is increased, the digits are shrinks for width.
              lcdPadding: EdgeInsets.symmetric(horizontal:0),//this value only provides spaces to the left and right of the numbers. it also reduces proportionally the numbers
              digitAlignment: MainAxisAlignment.center, //if you have extra width, use it for better ui
              lcdWidth: MediaQuery.of(context).size.width,// numbers automatically fit to width by count of digit. if you only use this value, the height of the lcd is automatically adjusted
              lcdHeight:80 , // you may need to use scaleFactor if you use this value.
              scaleFactor :MediaQuery.of(context).size.height < MediaQuery.of(context).size.width ? 0.4: 0.18,//if you use lcdHeight , set this value for better ui
              segmentWidth : 7,// Thickness of each segment default 10 , best value range 5-12
              lcdDecoration: BoxDecoration(  //This is default decoration . not required
              ),
              activeColor: Colors.green.withOpacity(0.6),  //This is default  . not required
              inactiveColor: Colors.lightGreen.withOpacity(0.08),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom:40),
              child:Text(
                  'Seconds',
                  style: TextStyle(fontSize: 25)
                ),
            ),
             Text(
               'From 30 to 10',
               style: TextStyle(fontSize: 25),
             ),
            Lcd(context).Number(
              number: 123, //Your number variable
              digitCount:2, //Each time this value is increased, the digits are shrinks for width.
              lcdPadding: EdgeInsets.symmetric(horizontal:0),//this value only provides spaces to the left and right of the numbers. it also reduces proportionally the numbers
              digitAlignment: MainAxisAlignment.center, //if you have extra width, use it for better ui
              lcdWidth: MediaQuery.of(context).size.width,// numbers automatically fit to width by count of digit. if you only use this value, the height of the lcd is automatically adjusted
              lcdHeight:70 , // you may need to use scaleFactor if you use this value.
              scaleFactor :MediaQuery.of(context).size.height < MediaQuery.of(context).size.width ? 0.4: 0.18,//if you use lcdHeight , set this value for better ui
              segmentWidth : 7,// Thickness of each segment default 10 , best value range 5-12
              lcdDecoration: BoxDecoration(  //This is default decoration . not required
              ),
              activeColor: Colors.green.withOpacity(0.6),  //This is default  . not required
              inactiveColor: Colors.lightGreen.withOpacity(0.08),
            ),
            Text(
              'Seconds',
              style: TextStyle(fontSize: 25)
            ),
          ],
        ),
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: getCurrentLocation,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
     // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
