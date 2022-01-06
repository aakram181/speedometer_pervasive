
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

const LocationSettings locationSettings = LocationSettings(
  accuracy: LocationAccuracy.best,
  distanceFilter: 3,
);

const TextStyle mainText = TextStyle(
  fontSize: 30.0,
  fontWeight: FontWeight.bold,
);