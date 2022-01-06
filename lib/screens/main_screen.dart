import 'package:sensors/sensors.dart';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:speedometer_pervasive/utils/myaudio_player.dart';
import 'package:speedometer_pervasive/utils/permissions_checker.dart';
import '../widgets/speed_gauge.dart';
import '../utils/constants.dart';
import '../utils/permissions_checker.dart';

class MainScreen extends StatefulWidget {
const MainScreen({Key? key}) : super(key: key);

@override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  double speed = 0.0;
  double acceleration = 0.0;
  double userSetSpeed = 80;
  bool playing = false;
  Color textColor = Colors.green;
  MyAudioPlayer player = MyAudioPlayer();



  @override
  void initState() {
    PermissionsChecker.checkLocPerm(); // check user permissions

    Geolocator.getPositionStream(locationSettings: locationSettings,).listen((Position position){
      updateSpeed(position);
    });

    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      onAccelerate(event);
    });

    super.initState();
  }


  void updateSpeed(Position position){
    double newSpeed = position.speed * 3.6; // m/s to km/h
    setState(() {
      speed = newSpeed;
    });
    bool isOverspeed = (speed>userSetSpeed);
    if(isOverspeed){

      player.playWarning();
      setState(() {
        textColor = Colors.red;
      });
    }
    else{

      player.stopWarning();
      setState(() {
        textColor = Colors.green;
      });
    }
  }


  void onAccelerate(UserAccelerometerEvent event) {
    double newAcceleration = sqrt(pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2));
    setState(() {
      acceleration = newAcceleration;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Speedometer'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Speed limit:',
              style: mainText),
          SizedBox(
            width: 10.0,
          ),
          Container(
            width: 55.0,
            child: TextFormField(
                initialValue: '80',
                onFieldSubmitted: (value) {
                  if (value == '') {
                    userSetSpeed = 1.0;
                  } else
                    userSetSpeed = double.parse(value);
                },
                decoration: InputDecoration(
                  counterText: '',
                ),
                keyboardType: TextInputType.numberWithOptions(),
                maxLength: 3,
                style: mainText),
          ),
          SizedBox(height: 30.0),
          SpeedGauge(userSetSpeed: userSetSpeed, speed: speed, textColor: textColor),
          SizedBox(height: 30.0),

          //Text('Acceleration: ${acceleration.toInt()}m/s',
          //style: mainText),

        ],
      ),
    );
  }
}

