import Foundation
import UserNotifications
import UIKit

class Notifications: NSObject {
    
    
    let notificationsCenter = UNUserNotificationCenter.current()
    
    
    func requestAutorization() {
        notificationsCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, Error in
            guard granted else {return}
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        notificationsCenter.getNotificationSettings { setting in
            print(setting)
        }
    }
    
    func sheduleDateNitification(date: Date, id: String) {
        
        let content = UNMutableNotificationContent()
        content.title = "WORKOUT"
        content.body = "Today you have training"
        content.sound = .default
        content.badge = 1
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        var triggerDate = calendar.dateComponents([.year, .month, .day], from: date)
        triggerDate.hour = 15
        triggerDate.minute = 10
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        notificationsCenter.add(request) { error in
            print("Errorr \(error?.localizedDescription ?? "error")")
        }
    }
}

extension Notifications: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        notificationsCenter.removeAllDeliveredNotifications()
    }
}
