//
//  NotificationService.swift
//  BackAware
//
//  Created by Muhammad Ali on 22/04/2021.
//

import UserNotifications
final class NotificationService{
    private let userNotificationCenter = UNUserNotificationCenter.current()
    static let shared = NotificationService()
    private init(){}
    func requestNotificationAuthorization(delegate:AppDelegate) {
        // Code here
        userNotificationCenter.delegate = delegate
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    func sendNotification(title:String = "",body:String = "",timeDuration: TimeInterval = 60,repeats:Bool = false) {
        // Code here
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.badge = nil
        
        if let url = Bundle.main.url(forResource: "dune",
                                     withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "dune",
                                                              url: url,
                                                              options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeDuration,
                                                        repeats: repeats)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
