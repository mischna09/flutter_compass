import CoreLocation
import CoreMotion
import Flutter
import simd
import UIKit

public class SwiftFlutterCompassPlugin: NSObject, FlutterPlugin, FlutterStreamHandler, CLLocationManagerDelegate {
    private var eventSink: FlutterEventSink?
    private var location: CLLocationManager = .init()
    private var motion: CMMotionManager = .init()

    init(channel: FlutterEventChannel) {
        super.init()
        location.delegate = self
        location.headingFilter = 0.1
        channel.setStreamHandler(self)

        motion.deviceMotionUpdateInterval = 1.0 / 30.0
        motion.startDeviceMotionUpdates(using: CMAttitudeReferenceFrame.xMagneticNorthZVertical)
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterEventChannel(name: "hemanthraj/flutter_compass", binaryMessenger: registrar.messenger())
        _ = SwiftFlutterCompassPlugin(channel: channel)
    }

    public func onListen(withArguments _: Any?,
                         eventSink: @escaping FlutterEventSink) -> FlutterError?
    {
        self.eventSink = eventSink
        location.startUpdatingHeading()
        return nil
    }

    public func onCancel(withArguments _: Any?) -> FlutterError? {
        eventSink = nil
        location.stopUpdatingHeading()
        return nil
    }

    public func locationManager(_: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        eventSink?([newHeading.trueHeading,0.0,0.0])
    }
}
