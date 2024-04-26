//
//  NotificationsManager.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 4/26/24.
//  Copyright © 2024 Eddie Char. All rights reserved.
//

import UserNotifications

class NotificationsManager {
    
    // MARK: - Properties
    
    static var shared: NotificationsManager {
        let manager = NotificationsManager()
        
        // add'l setup if needed
        
        return manager
    }
    
    private let randomFactoids: [String] = [
        "Venus is the hottest planet in the solar system. Tap to learn more...",
        "Mars has 2 moons, Phobos and Deimos. Tap to learn more...",
        "The Milky Way is 105,700 light years in diameter. Tap to learn more..."
    ]
    
    
    // MARK: - Initialization
    
    init() {
        //Initialization
    }
    
    
    // MARK: - Functions
    
    func requestNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Notifications Granted!")
            }
            else {
                print("Notifications have been denied :(")
            }
        }
    }
    
    /**
     Triggers a Notification message to the device after a certain amount of time has elapsed, i.e. to keep playing.
     - parameters:
        - title: the title of the Notification
        - duration: amount of time required before the Notification is triggered
        - repeats: determines if Notification should trigger repeatedly or not
     */
    func repeatNotifications() {
        let content = UNMutableNotificationContent()
        content.title = "Pocket PlanetARium"
        content.body = randomFactoids.randomElement() ?? "Tap to learn more about our amazing universe!"
        content.categoryIdentifier = "alert"
        content.sound = .none
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 24 * 60 * 60, repeats: true)
        let request = UNNotificationRequest.init(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    /**
     Just like the function says - it removes/cancels all delivered and pending Notifications.
     */
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
