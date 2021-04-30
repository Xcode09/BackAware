//
//  MotionDetection.swift
//  BackAware
//
//  Created by Muhammad Ali on 29/04/2021.
//

import CoreMotion
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
