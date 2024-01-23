//
//  NotificationManager.swift
//  FinalApplication
//
//  Created by Admin on 22.01.24.
//

import UIKit
import UserNotifications

protocol NotificationManagerDelegate: AnyObject {
    func didReceiveNotification(withText text: String)
}

class NotificationManager: NSObject {
    static let shared = NotificationManager()
    weak var delegate: NotificationManagerDelegate?
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .badge]) { (isAuthorized, error) in
            if isAuthorized {
                print("დაეთანხმა")
            } else {
                print("არ დაეთანხმა")
            }
        }
    }
    
    func createAndScheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "message".localized
        content.body = "თქვენ წარმატებით შეიძინეთ პროდუქტები."
        content.sound = .default
        
        let defaults = UserDefaults.standard
        let currentBadgeCount = defaults.integer(forKey: UserDefaultsKeys.badgeCount)
        let newBadgeCount = currentBadgeCount + 1
        defaults.set(newBadgeCount, forKey: UserDefaultsKeys.badgeCount)
        
        UNUserNotificationCenter.current().setBadgeCount(newBadgeCount) { error in
            if let error = error {
                print("Error setting badge count: \(error)")
            }
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(5), repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error adding notification request: \(error)")
            }
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            
            completionHandler([.banner, .sound])
        }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let defaults = UserDefaults.standard
        var currentBadgeCount = defaults.integer(forKey: UserDefaultsKeys.badgeCount)
        currentBadgeCount = max(currentBadgeCount - 1, 0)
        defaults.set(currentBadgeCount, forKey: UserDefaultsKeys.badgeCount)
        UNUserNotificationCenter.current().setBadgeCount(currentBadgeCount) { error in
            if let error = error {
                print("Error updating badge count: \(error)")
            }
        }
        
        completionHandler()
    }
}

struct UserDefaultsKeys {
    static let badgeCount = "badgeCount"
}

