import Foundation
import UserNotifications
import SwiftUI

class NotificationsManager: ObservableObject {
    static let shared = NotificationsManager()
    
    init() {
        requestAuthorization()
    }
    
    /// Requests authorization for notifications.
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notifications authorization: \(error)")
            } else {
                print("Notifications authorization granted: \(granted)")
            }
        }
    }
    
    /// Schedules a local notification with a title, body, and a time interval trigger.
    func scheduleNotification(title: String, body: String, after interval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}
