//
//  Notifications.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/17/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import UserNotifications


struct LocalNotificationManager {
    
    static func requestPermission() -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true && error == nil {
                    // We have permission!
                }
        }
    }
    
    static func deleteNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }

    //Schedule Notification with weekly bases.
    //Ref: https://stackoverflow.com/questions/45061324/repeating-local-notifications-for-specific-days-of-week-swift-3-ios-10
    static func scheduleNotificationWeekly(time: RelativeTime, weekday: DayOfWeek, title: String, body: String) -> String {
        let id: String = UUID().uuidString
        let calendar = Calendar(identifier: .gregorian)
        var components = Calendar.current.dateComponents([.hour,.minute,.second], from: time.today)
        components.weekday = weekday.rawValue // sunday = 1 ... saturday = 7
        components.weekdayOrdinal = 10
        components.timeZone = .current

        let date = calendar.date(from: components)!
        
        let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute,.second,], from: date)

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "todoList"

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        //UNUserNotificationCenter.current().delegate = self
        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
        return id
    }
    
    // scheduleNotificationTimeInterval
    static func scheduleNotificationTimeInterval(time: TimeInterval, title: String, body: String) -> String {
        let id: String = UUID().uuidString
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "todoList"

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        //UNUserNotificationCenter.current().delegate = self
        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
        return id
            
    }
}
