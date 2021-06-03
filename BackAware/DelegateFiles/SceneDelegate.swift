//
//  SceneDelegate.swift
//  BackAware
//
//  Created by Muhammad Ali on 09/04/2021.
//

import UIKit
import CoreLocation
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    fileprivate func checkUserActivity(path:String,
                                       _ window: UIWindow) {
        FirebaseDataService.instance.checkUserSession(withPath: path) { (result) in
            switch result{
            case .success(let uid):
                // Go to Tab Bar
                currentUserId = uid
                FirebaseDataService.instance.configureReference()
                window.rootViewController = TabBarVC()
                window.makeKeyAndVisible()
                break
            case .failure:
                // Go to Authentication Screen
                let verifyVc = VerifyPhoneNumber(nibName: "VerifyPhoneNumber", bundle: nil)
                window.rootViewController = UINavigationController(rootViewController: verifyVc)
                window.makeKeyAndVisible()
                break
                
            }
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        mainWindow = window
        
        if let pricvySelected = UserDefaults.standard.value(forKey: "Pi") as? Bool, pricvySelected == true {
            
            if let userAlreadyLogin = UserDefaults.standard.value(forKey: "login") as? String
            {
                LocationManager.shared.requestLocationAuthorization()
                LocationManager.shared.requestLocationAuthorizationCallback = {
                    [weak self] status in
                    
                    self?.checkUserActivity(path: userAlreadyLogin, window)
                }
            }else
            {
                LocationManager.shared.requestLocationAuthorization()
                LocationManager.shared.requestLocationAuthorizationCallback = {
                    [weak self] status in
                    let verifyVc = VerifyPhoneNumber(nibName: "VerifyPhoneNumber", bundle: nil)
                    window.rootViewController = UINavigationController(rootViewController: verifyVc)
                    window.makeKeyAndVisible()
                }
            }
            
        }
        else{
            let alert = CustomPrivacyAlert(nibName: "CustomPrivacyAlert", bundle: nil)
            alert.delegate = self
            window.rootViewController = alert
            window.makeKeyAndVisible()
        }
        
        //checkUserActivity(window)
        
        
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
        Timer.scheduledTimer(withTimeInterval: 60*60, repeats: true) { (_) in
            if let isTrue = UserDefaults.standard.value(forKey: "1") as? String,isTrue == "true"
            {
                NotificationService.shared.sendNotificationWithCategory(title: "Microbreak!", body: "Have you stood up for one minute this hour?", timeDuration:1, repeats: false)
            }
        }
    }
    
    //    private func configureLocationPermissions(){
    //        let locationManager = CLLocationManager()
    //        locationManager.delegate = self
    //
    //        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    //        if CLLocationManager.locationServicesEnabled() {
    //            locationManager.requestAlwaysAuthorization()
    //            locationManager.requestWhenInUseAuthorization()
    //        }else{
    //            print("No Location Service Enable")
    //        }
    //
    //
    //    }
    
    
}


//extension SceneDelegate:CLLocationManagerDelegate{
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .authorizedAlways:
//            checkUserActivity(self.window ?? UIWindow())
//        case .authorizedWhenInUse:
//           checkUserActivity(self.window ?? UIWindow())
//        case .denied:
//            checkUserActivity(self.window ?? UIWindow())
//        case .notDetermined:
//            checkUserActivity(self.window ?? UIWindow())
//        case .restricted:
//            checkUserActivity(self.window ?? UIWindow())
//        default:
//            checkUserActivity(self.window ?? UIWindow())
//        }
//    }
//}

extension SceneDelegate:CustomPrivacyAlertDelegate{
    func didTappedNo() {
        print("Error")
    }
    
    func didTappedYes() {
        if let window = self.window{
            if let userAlreadyLogin = UserDefaults.standard.value(forKey: "login") as? String
            {
                LocationManager.shared.requestLocationAuthorization()
                LocationManager.shared.requestLocationAuthorizationCallback = {
                    [weak self] status in
                    UserDefaults.standard.setValue(true, forKey: "Pi")
                    UserDefaults.standard.synchronize()
                    self?.checkUserActivity(path: userAlreadyLogin, window)
                }
            }else
            {
                LocationManager.shared.requestLocationAuthorization()
                LocationManager.shared.requestLocationAuthorizationCallback = {
                    status in
                    let verifyVc = VerifyPhoneNumber(nibName: "VerifyPhoneNumber", bundle: nil)
                    window.rootViewController = UINavigationController(rootViewController: verifyVc)
                    UserDefaults.standard.setValue(true, forKey: "Pi")
                    UserDefaults.standard.synchronize()
                    window.makeKeyAndVisible()
                }
            }
        }
        
        //configureLocationPermissions()
    }
    
}
