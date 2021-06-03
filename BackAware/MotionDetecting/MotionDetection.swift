//
//  MotionDetection.swift
//  BackAware
//
//  Created by Muhammad Ali on 29/04/2021.
//

import CoreMotion
import CoreLocation
import UIKit
final class MotionDetection{
    static let instance = MotionDetection()
    private init(){
        
    }
    private var motionManager: CMMotionManager!
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    func configure(){
        motionManager = CMMotionManager()
        
        // How frequently to read accelerometer updates, in seconds
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates()
    }
    
    
    func startTrackingActivityType(queue:OperationQueue = .main) {
        
      activityManager.startActivityUpdates(to: queue) {
          [weak self] (activity: CMMotionActivity?) in

          guard let activity = activity else { return }
          DispatchQueue.main.async {
              if activity.walking {
                 print("Walking")
              } else if activity.stationary {
                  print("Stationary")
              } else if activity.running {
                  print("Running")
              } else if activity.automotive {
                   print("Automotive")
              }
          }
      }
    }
    
    func startGettingUpdate()
    {
        motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
            // Handle acceleration update
            print(data?.acceleration.x,data?.acceleration.y)
        }
    }
}



class LocationManager: NSObject, CLLocationManagerDelegate {

    static let shared = LocationManager()
    private var locationManager: CLLocationManager = CLLocationManager()
    var requestLocationAuthorizationCallback: ((CLAuthorizationStatus) -> Void)?

    public func requestLocationAuthorization() {
        self.locationManager.delegate = self
        let currentStatus = CLLocationManager.authorizationStatus()

        // Only ask authorization if it was never asked before
        guard currentStatus == .notDetermined else { return }

        // Starting on iOS 13.4.0, to get .authorizedAlways permission, you need to
        // first ask for WhenInUse permission, then ask for Always permission to
        // get to a second system alert
        if #available(iOS 13.4, *) {
            self.requestLocationAuthorizationCallback = { status in
                if status == .authorizedWhenInUse {
                    self.locationManager.requestAlwaysAuthorization()
                }
            }
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    // MARK: - CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {
        self.requestLocationAuthorizationCallback?(status)
    }
}
