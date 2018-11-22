import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';

/// init sensor
class HealthSensor extends AwareSensorCore {
  static const MethodChannel _healthMethod = const MethodChannel('awareframework_health/method');
  static const EventChannel  _healthStream  = const EventChannel('awareframework_health/event');

  static const EventChannel  _healthKitHRStream  = const EventChannel('awareframework_health/event_on_heart_rate_data_changed');

  /// Init Health Sensor with HealthSensorConfig
  HealthSensor(HealthSensorConfig config):this.convenience(config);
  HealthSensor.convenience(config) : super(config){
    /// Set sensor method & event channels
    super.setSensorChannels(_healthMethod, _healthStream);
  }

  /// A sensor observer instance
  Stream<Map<String,dynamic>> get onDataChanged {
     return super.receiveBroadcastStream("on_data_changed").map((dynamic event) => Map<String,dynamic>.from(event));
  }

  Stream<Map<String,dynamic>> get onHealtKitHRChanged {
    return _healthKitHRStream.receiveBroadcastStream(["on_heart_rate_data_changed"]).map((dynamic event) => Map<String,dynamic>.from(event));
  }
}

class HealthSensorConfig extends AwareSensorConfig{
  HealthSensorConfig();

  /// TODO

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}

/// Make an AwareWidget
class HealthCard extends StatefulWidget {
  HealthCard({Key key, @required this.sensor}) : super(key: key);

  HealthSensor sensor;

  @override
  HealthCardState createState() => new HealthCardState();
}


class HealthCardState extends State<HealthCard> {

  List<LineSeriesData> dataLine1 = List<LineSeriesData>();
  List<LineSeriesData> dataLine2 = List<LineSeriesData>();
  List<LineSeriesData> dataLine3 = List<LineSeriesData>();
  int bufferSize = 299;

  @override
  void initState() {

    super.initState();
    // set observer
    widget.sensor.onHealtKitHRChanged.listen((event) {
      setState((){
        if(event!=null){
          DateTime.fromMicrosecondsSinceEpoch(event['timestamp']);
          StreamLineSeriesChart.add(data:event['heartrate'], into:dataLine1, id:"heartrate", buffer: bufferSize);
        }
      });
    }, onError: (dynamic error) {
        print('Received error: ${error.message}');
    });
    print(widget.sensor);
  }


  @override
  Widget build(BuildContext context) {
    return new AwareCard(
      contentWidget: SizedBox(
          height:250.0,
          width: MediaQuery.of(context).size.width*0.8,
          child: new StreamLineSeriesChart(StreamLineSeriesChart.createTimeSeriesData(dataLine1, dataLine2, dataLine3)),
        ),
      title: "Health",
      sensor: widget.sensor
    );
  }

}
