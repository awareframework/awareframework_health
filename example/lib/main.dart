import 'package:flutter/material.dart';

import 'package:awareframework_health/awareframework_health.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  HealthSensor sensor;
  HealthSensorConfig config;

  @override
  void initState() {
    super.initState();

    config = HealthSensorConfig()
      ..debug = true;

    sensor = new HealthSensor(config);

    sensor.start();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('Plugin Example App'),
          ),
          body: new HealthCard(sensor: sensor)
      ),
    );
  }
}
