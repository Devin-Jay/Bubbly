//
//  BubblyApp.swift
//  Bubbly
//
//  Created by Devin Jay on 9/5/26.
//

import SwiftUI
import UserNotifications
import Foundation

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
//                print("IM DIRNKING")
                // schedule the next reminder (using correct interval)
                schedule(schedulingInterval: UserDefaults.standard.double(forKey: "interval"))
                break
            case "DELAY_ACTION":
//                print("DELAY IT")
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
let bubblyReminderCategory = UNNotificationCategory(identifier: "BUBBLYREMINDER",
                                                    actions: [drinkingAction, delayAction],
                                                    intentIdentifiers: [],
                                                    hiddenPreviewsBodyPlaceholder: "",
                                                    options: .customDismissAction)
let content = UNMutableNotificationContent()

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

// schedules the next notification (schedulingInterval is assumed to be in minutes)
func schedule(schedulingInterval: Double)
{
    // get start and end times (with same days, months, years as now for easy comparison)
    let now = Date.now
    let start = getNormalizedDate(dateToChange: UserDefaults.standard.object(forKey: "startTime") as! Date, now: now)
    let end = getNormalizedDate(dateToChange: UserDefaults.standard.object(forKey: "endTime") as! Date, now: now)
    
    
    // calculate time next notification was scheduled for
    let nextTime = now.addingTimeInterval(schedulingInterval * 60)
//    print("Current: \(now.formatted()), Next reminder: \(nextTime.formatted())")
    
    let trigger: UNNotificationTrigger

    // if next reminder is between user's selected start and end times
    if nextTime > start && nextTime < end
    {
        // schedule request as normal
//        print("Between interval; scheduling in \(schedulingInterval) minutes")
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: schedulingInterval * 60, repeats: false)
    }
    // otherwise, assume next reminder scheduled outside of zone
    else
    {
        // initialize calendar trigger
        var components = Calendar.current.dateComponents([.year, .month, .day], from: nextTime)
        components.hour = Calendar.current.component(.hour, from: start)
        components.minute = Calendar.current.component(.minute, from: start)

        // check if before midnight
        if nextTime > end && Calendar.current.component(.hour, from: nextTime) < 23
        {
            // schedule for next day at start time
            components.day? += 1
//            print("Outside interval; scheduling for next day: \(String(describing: Calendar.current.date(from: components)?.formatted()))")
        }
        // otherwise, assume after midnight
//        else
//        {
//            print("Outside interval; scheduling for  current day: \(String(describing: Calendar.current.date(from: components)?.formatted()))")
//            // schedule for currect day at start time
//        }

        trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    }

    notifCenter.add(UNNotificationRequest(identifier: notifIdentifier, content: content, trigger: trigger))
}

// supporting function to get date to just compare time
// basically just sets the date to current days date but keeps the times
func getNormalizedDate(dateToChange : Date, now : Date) -> Date
{
    // get new components with current day's components
    var components = Calendar.current.dateComponents(in: TimeZone.current, from: now)
    
    // set new components with dateToChange time
    components.hour = Calendar.current.component(.hour, from: dateToChange)
    components.minute = Calendar.current.component(.minute, from: dateToChange)
    
    // create and return new normalized date
    return Calendar.current.date(from: components)!
}
