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
    
    private static let shamelessPlug = "Visit 5playapps.com and download our other mobile apps!"
    private let reminderHours: TimeInterval = 12
    
    private let randomFactoids: [String] = [
        NotificationsManager.shamelessPlug,
        "Venus is the hottest planet in the solar system. Tap to learn more.",
        "Mars has 2 moons, Phobos and Deimos. Tap to learn more.",
        "The Milky Way is a whopping 105,700 light years in diameter! Tap to learn more.",
        "Uranus spins sideways probably due to a titanic collision. Tap to learn more.",
        NotificationsManager.shamelessPlug,
        "Mars has a volcano larger than the state of Hawaii. Tap to learn more.",
        "Spacecrafts have visited every planet in our Solar System. Tap to learn more.",
        "Our moon drifts farther and farther away each day. Tap to learn more.",
        "Jupiter's great red spot is shrinking. Tap to learn more.",
        "Saturn has a raging six-sided storm nicknamed \"the hexagon\".",
        NotificationsManager.shamelessPlug,
        "The Sun's atmosphere is millions of degrees hotter than its surface.",
        "One million Earths could fit inside the Sun. Tap to learn more.",
        "If you could fly a plane to Pluto, it would take over 800 years!",
        "The sunset on Mars appears blue. Tap to learn more.",
        "There are more stars in the universe than grains of sand on Earth!",
        NotificationsManager.shamelessPlug,
        "Earth's moon is the reason why we have tides. Tap to learn more.",
        "95% of the universe is invisible. Tap to learn more.",
        "The Fermi Paradox posits that we are indeed alone in the universe.",
        "A supermassive black hole exists at the center of our galaxy named Sagittarius A*." //This is the longest string allowed without truncation
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
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: reminderHours * 60 * 60, repeats: true)
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
