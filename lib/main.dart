import 'dart:async';

import 'package:flutter/material.dart';
import 'package:digital_lcd/digital_lcd.dart';
import 'package:digital_lcd/hex_color.dart'; //if you want use Hex Color codes this is required
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
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _speed = 0;
  double _speedinkph = 0;
  double _from10to30TimeDiff = 0;
  double _from30to10TimeDiff = 0;
  DateTime inc10timestamp = null;
  DateTime inc30timestamp = null;
  DateTime dec10timestamp = null;
  DateTime dec30timestamp = null;

  StreamSubscription<Position> _positionStream;

  @override
  void initState() {
    super.initState();
    this._positionStream = new Geolocator()
        .getPositionStream(LocationOptions(
        accuracy: LocationAccuracy.high, distanceFilter: 0, timeInterval: 500))
        .listen((Position position) => {
          _speedinkph = (position.speed * 3600) / 1000, //convert the speed from mps to kph
          _handle10to30(_speed, _speedinkph, position.timestamp),
          _handle30to10(_speed, _speedinkph, position.timestamp),
          _setSpeed(_speedinkph),
        });
  }

  void _handle10to30(
      double prevSpeed, double currentSpeed, DateTime currentTimestamp) {
    if (prevSpeed <= 10 && currentSpeed >= 10) {
      inc10timestamp = currentTimestamp;
    }
    if (prevSpeed <= 30 && currentSpeed >= 30) {
      inc30timestamp = currentTimestamp;
    }
    if (inc10timestamp != null && inc30timestamp != null) {
      set10to30Time(inc30timestamp.difference(inc10timestamp));
      inc30timestamp = null;
      inc10timestamp = null;
    }
  }

  void _handle30to10(
      double prevSpeed, double currentSpeed, DateTime currentTimestamp) {
    if (prevSpeed >= 10 && currentSpeed <= 10) {
      dec10timestamp = currentTimestamp;
    }
    if (prevSpeed >= 30 && currentSpeed <= 30) {
      dec30timestamp = currentTimestamp;
    }
    if (dec10timestamp != null && dec30timestamp != null) {
      set30to10Time(dec10timestamp.difference(dec30timestamp));
      dec10timestamp = null;
      dec30timestamp = null;
    }
  }

  void _setSpeed(double speed) {
    if (speed != _speed) setState(() => {_speed = speed});
  }

  void set10to30Time(Duration duration) {
    if (duration.inSeconds.toDouble() != _from10to30TimeDiff) setState(() =>
    {_from10to30TimeDiff = duration.inSeconds.toDouble()});
  }

  void set30to10Time(Duration duration) {
    if (duration.inSeconds.toDouble() != _from30to10TimeDiff) setState(() =>
    {_from30to10TimeDiff = duration.inSeconds.toDouble()});
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Current Speed', style: TextStyle(fontSize: 35)),
            Lcd(context).Number(
              number: _speed.toInt(), //Your number variable
              digitCount: 2, //Each time this value is increased, the digits are shrinks for width.
              lcdPadding: EdgeInsets.symmetric(horizontal: 0), //this value only provides spaces to the left and right of the numbers. it also reduces proportionally the numbers
              digitAlignment: MainAxisAlignment.center, //if you have extra width, use it for better ui
              lcdWidth: MediaQuery.of(context).size.width, // numbers automatically fit to width by count of digit. if you only use this value, the height of the lcd is automatically adjusted
              lcdHeight: 120, // you may need to use scaleFactor if you use this value.
              scaleFactor: MediaQuery.of(context).size.height < MediaQuery.of(context).size.width ? 0.38 : 0.22, //if you use lcdHeight , set this value for better ui
              segmentWidth: 8, // Thickness of each segment default 10 , best value range 5-12
              lcdDecoration: BoxDecoration(//This is default decoration . not required
              ),
              activeColor: Colors.black.withOpacity(0.6), //This is default  . not required
              inactiveColor: Colors.grey.withOpacity(0.08),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Text('kmh', style: TextStyle(fontSize: 35)),
            ),
            Text('From 10 to 30', style: TextStyle(fontSize: 25)),
            Lcd(context).Number(
              number: _from10to30TimeDiff.toInt(), //Your number variable
              digitCount: 2, //Each time this value is increased, the digits are shrinks for width.
              lcdPadding: EdgeInsets.symmetric(horizontal: 0), //this value only provides spaces to the left and right of the numbers. it also reduces proportionally the numbers
              digitAlignment: MainAxisAlignment.center, //if you have extra width, use it for better ui
              lcdWidth: MediaQuery.of(context).size.width, // numbers automatically fit to width by count of digit. if you only use this value, the height of the lcd is automatically adjusted
              lcdHeight: 80, // you may need to use scaleFactor if you use this value.
              scaleFactor: MediaQuery.of(context).size.height < MediaQuery.of(context).size.width ? 0.4 : 0.18, //if you use lcdHeight , set this value for better ui
              segmentWidth: 7, // Thickness of each segment default 10 , best value range 5-12
              lcdDecoration: BoxDecoration(//This is default decoration . not required
              ),
              activeColor: Colors.black.withOpacity(0.6), //This is default  . not required
              inactiveColor: Colors.grey.withOpacity(0.08),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Text('Seconds', style: TextStyle(fontSize: 25)),
            ),
            Text(
              'From 30 to 10',
              style: TextStyle(fontSize: 25),
            ),
            Lcd(context).Number(
              number: _from30to10TimeDiff.toInt(), //Your number variable
              digitCount: 2, //Each time this value is increased, the digits are shrinks for width.
              lcdPadding: EdgeInsets.symmetric(horizontal: 0), //this value only provides spaces to the left and right of the numbers. it also reduces proportionally the numbers
              digitAlignment: MainAxisAlignment.center, //if you have extra width, use it for better ui
              lcdWidth: MediaQuery.of(context).size.width, // numbers automatically fit to width by count of digit. if you only use this value, the height of the lcd is automatically adjusted
              lcdHeight: 70, // you may need to use scaleFactor if you use this value.
              scaleFactor: MediaQuery.of(context).size.height < MediaQuery.of(context).size.width ? 0.4 : 0.18, //if you use lcdHeight , set this value for better ui
              segmentWidth: 7, // Thickness of each segment default 10 , best value range 5-12
              lcdDecoration: BoxDecoration(//This is default decoration . not required
              ),
              activeColor: Colors.black.withOpacity(0.6), //This is default  . not required
              inactiveColor: Colors.grey.withOpacity(0.08),
            ),
            Text('Seconds', style: TextStyle(fontSize: 25)),
          ],
        ),
      ),
    );
  }
}
