//
//  BubblyApp.swift
//  Bubbly
//
//  Created by Devin Jay on 9/5/26.
//

import SwiftUI
import SwiftData
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        switch response.actionIdentifier
        {
            case UNNotificationDefaultActionIdentifier:
                // schedule the next reminder (using correct interval)
                schedule(schedulingInterval: UserDefaults.standard.double(forKey: "interval"))
            case UNNotificationDismissActionIdentifier:
                // schedule the next reminder (using correct interval)
                schedule(schedulingInterval: UserDefaults.standard.double(forKey: "interval"))
            case "DRINKING_ACTION":
                print("IM DIRNKING")
                // schedule the next reminder (using correct interval)
                schedule(schedulingInterval: UserDefaults.standard.double(forKey: "interval"))
                break
            case "DELAY_ACTION":
                print("DELAY IT")
                // delay current reminder
                schedule(schedulingInterval: 5)
                break
            default:
                break
        }
        
        completionHandler()
    }
}

let notifIdentifier = "bubblynotif"
let notifCenter = UNUserNotificationCenter.current()
let drinkingAction = UNNotificationAction(identifier: "DRINKING_ACTION",
                                          title: "I'm drinking!",
                                          options: [])
let delayAction = UNNotificationAction(identifier: "DELAY_ACTION",
                                          title: "Give me 5 minutes!",
                                          options: [])
@main
struct BubblyApp: App
{
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
        }
    }
}

func schedule(schedulingInterval: Double)
{
    print("scheduling notification in \(schedulingInterval)")
    let bubblyReminderCategory = UNNotificationCategory(identifier: "BUBBLYREMINDER",
                                                        actions: [drinkingAction, delayAction],
                                                        intentIdentifiers: [],
                                                        hiddenPreviewsBodyPlaceholder: "",
                                                        options: .customDismissAction)
    notifCenter.setNotificationCategories([bubblyReminderCategory])

    let content = UNMutableNotificationContent()
    content.title = "BUBBLY"
    content.body = "DRINK UP"
    content.sound = UNNotificationSound.default
    content.categoryIdentifier = "BUBBLYREMINDER"
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: schedulingInterval, repeats: false)
    let request = UNNotificationRequest(identifier: notifIdentifier, content: content, trigger: trigger)
    notifCenter.add(request)
}
