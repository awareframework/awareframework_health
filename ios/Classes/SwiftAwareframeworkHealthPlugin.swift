import Flutter
import UIKit
import SwiftyJSON
import com_awareframework_ios_sensor_healthkit
import com_awareframework_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkHealthPlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, HealthKitObserver{

    public func initializeSensor(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                let json = JSON.init(config)
                self.healthSensor = HealthKitSensor.init(HealthKitSensor.Config(json))
            }else{
                self.healthSensor = HealthKitSensor.init(HealthKitSensor.Config())
            }
            self.healthSensor?.CONFIG.sensorObserver = self
            self.healthSensor?.CONFIG.isHeartRateFetch = true
            // self.healthSensor?.CONFIG.fetchInterval = 1
            return self.healthSensor
        }else{
            return nil
        }
    }

    var healthSensor:HealthKitSensor?

    public override init() {
        super.init()
        super.initializationCallEventHandler = self
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftAwareframeworkHealthPlugin()
        super.setMethodChannel(with: registrar, instance: instance, channelName: "awareframework_health/method")
        super.setEventChannels(with: registrar, instance: instance, channelNames:
            ["awareframework_health/event",
             "awareframework_health/event_on_heart_rate_data_changed"])
    }

    
    public func onHealthKitAuthorizationStatusChanged(success: Bool, error: Error?) {
        if success {
            if let sensor = self.healthSensor {
                sensor.fetchHRData(sensor.lastHRSyncDate)
            }
        }
    }
    
    public func onHeartRateDataChanged(data: [HealthKitHeartRateData]) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_heart_rate_data_changed" {
                for hrData in data {
                    handler.eventSink(hrData.toDictionary())
                }
            }
        }
    }
}
