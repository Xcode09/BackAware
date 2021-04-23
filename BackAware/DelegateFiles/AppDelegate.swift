//
//  AppDelegate.swift
//  BackAware
//
//  Created by Muhammad Ali on 09/04/2021.
//

import UIKit
import UserNotifications
import FirebaseCore
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setupNavigationAppearance()
        setupTabBarAppearance()
        NotificationService.shared.requestNotificationAuthorization(delegate: self)
        
        FirebaseApp.configure()
        //FirebaseDataService.instance.getData()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
       
    }
    
    
    


    private func setupNavigationAppearance()
    {
//        UINavigationBar.appearance().barTintColor = AppColors.navBarColor
//        UINavigationBar.appearance().tintColor = AppColors.navBarColor
       UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppColors.labelColor!,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
    }
    
    private func setupTabBarAppearance()
    {
        UITabBar.appearance().barTintColor = AppColors.tabBarTintColor
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().unselectedItemTintColor = AppColors.labelColor
        UITabBar.appearance().tintColor = AppColors.tabTintColor
        UITabBar.appearance().isTranslucent = false
//        UITabBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    
}

extension AppDelegate:UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
