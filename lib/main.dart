import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'dart:math';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double speed = 0.0;
  double userSetSpeed = 80;
  Color textColor = Colors.green;
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      onAccelerate(event);
    });
    super.initState();
  }

  void playWarning() async {
    final cache = AudioCache();
    player = await cache.loop('beep-01a.mp3');
  }

  void stopWarning(){
    player?.stop();
  }

  bool playing = false;

  void onAccelerate(UserAccelerometerEvent event) {
    double newSpeed = sqrt(pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2));
    setState(() {
      speed = newSpeed;
    });
    bool isOverspeed = (speed>userSetSpeed);
    if(isOverspeed){
      if(!playing){
        playing = true;
        playWarning();
      }
      setState(() {
        textColor = Colors.red;
      });
    }
    else{
      playing = false;
      stopWarning();
      setState(() {
        textColor = Colors.green;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speedometer'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Speed limit:',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(
            width: 10.0,
          ),
          Container(
            width: 55.0,
            child: TextFormField(
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
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
          SizedBox(height: 30.0),
          Container(
              //color: containerColor,
              child: SfRadialGauge(
                  enableLoadingAnimation: true,
                  animationDuration: 1500,
                  axes: [
                RadialAxis(
                  minimum: 0,
                  maximum: 200,
                  ranges: [
                    GaugeRange(
                      startValue: 0,
                      endValue: userSetSpeed,
                      color: Colors.green,
                    ),
                    GaugeRange(
                        startValue: userSetSpeed,
                        endValue: 200,
                        color: Colors.red),
                  ],
                  pointers: [
                    NeedlePointer(
                      value: speed,
                      knobStyle: KnobStyle(
                          knobRadius: 10,
                          sizeUnit: GaugeSizeUnit.logicalPixel,
                          color: Colors.red),
                      enableAnimation: true,
                    ),
                  ],
                  annotations: [
                    GaugeAnnotation(
                      widget: Container(
                        child: Text(
                          '${speed.toInt()}',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: textColor),
                        ),
                      ),
                      angle: 90,
                      positionFactor: 1.0,
                    )
                  ],
                ),
              ])),
        ],
      ),
    );
  }
}
