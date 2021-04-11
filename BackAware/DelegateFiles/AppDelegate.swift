//
//  AppDelegate.swift
//  BackAware
//
//  Created by Muhammad Ali on 09/04/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setupNavigationAppearance()
        setupTabBarAppearance()
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
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppColors.labelColor!,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .bold)]
    }
    
    private func setupTabBarAppearance()
    {
        UITabBar.appearance().barTintColor = AppColors.tabBarTintColor
        UITabBar.appearance().tintColor = AppColors.tabTintColor
        UITabBar.appearance().isTranslucent = false
//        UITabBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    
}

