import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';


class SpeedGauge extends StatelessWidget {
  const SpeedGauge({
    Key? key,
    required this.userSetSpeed,
    required this.speed,
    required this.textColor,
  }) : super(key: key);

  final double userSetSpeed;
  final double speed;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        '${speed.toInt()} km/h',
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
            ]));
  }
}
