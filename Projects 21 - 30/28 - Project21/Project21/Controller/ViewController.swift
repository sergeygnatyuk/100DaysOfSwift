//
//  ViewController.swift
//  Project21
//
//  Created by Гнатюк Сергей on 24.05.2021.
//

import UserNotifications
import UIKit

final class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(scheduleLocal))
    }
    
    // MARK: - @objc methods
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Yay!")
            } else {
                print("D'oh!")
            }
        }
    }
    // project21 challenge 2
    @objc func scheduleLocal() {
        triggeredActive(timeInterval: 8)
    }
    
    // MARK: - Private
    
    private func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        // project21 challenge 2
        let remind = UNNotificationAction(identifier: "remind", title: "Remind me letter...")
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remind], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    // project21 challenge 2
    private func triggeredActive(timeInterval: TimeInterval) {
        registerCategories()
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        //   let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    // MARK: - Public
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // project21 challenge 1
                showAlertController(message: "Default identifier")
            case "show":
                // project21 challenge 1
                showAlertController(message: "Show more information...")
            // project21 challenge 2
            case "remind":
                triggeredActive(timeInterval: 86400)
            default:
                break
            }
        }
        completionHandler()
    }
    // project21 challenge 1
    private func showAlertController(message: String) {
        let alertController = UIAlertController(title: "ActionIdentifier Message", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alertController, animated: true)
    }
}





