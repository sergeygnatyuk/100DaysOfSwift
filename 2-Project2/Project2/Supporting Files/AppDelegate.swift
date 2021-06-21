//
//  AppDelegate.swift
//  Project2
//
//  Created by Гнатюк Сергей on 01.04.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerLocal()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        triggeredActive()
    }
    
    public func triggeredActive() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Want to have fun?"
        content.body = "Time to play with world flags!"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "flaggame"]
        content.sound = .default
        var dateComponents = DateComponents()
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 10
        //   let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    private func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Yay!")
            } else {
                print("D'oh!")
            }
        }
    }
    
    public func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        // project21 challenge 2
        let launch = UNNotificationAction(identifier: "Launch", title: "Go to flag game!")
        let category = UNNotificationCategory(identifier: "alarm", actions: [launch], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

