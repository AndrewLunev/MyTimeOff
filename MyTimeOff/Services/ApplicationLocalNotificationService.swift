//
//  ApplicationLocalNotificationService.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 30/08/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import Foundation
import UserNotifications

fileprivate struct Constants {
    static let requestIdentifier = "MyTimeOff_Local_Notification_"
}

@available(iOS 10.0, *)
class ApplicationLocalNotificationService {
    
    // MARK: - Public Methods
    
    func enableNotifications() {
        self.initNotifications()
        ApplicationManager.settingsService.didDisplayPushNotificationsRequest = true
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    
    func disableNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ApplicationManager.settingsService.userLocalNotificationIdentifiers!)
        ApplicationManager.settingsService.userLocalNotificationIdentifiers = nil
        ApplicationManager.settingsService.didDisplayPushNotificationsRequest = false
    }
    
    
    
    // MARK: - Private Methods
    
    fileprivate func initNotifications() {
        
        let weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "EveryHour"]
        
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    self.scheduleLocalNotification(weekdays: weekdays)
                })
            case .authorized:
                self.scheduleLocalNotification(weekdays: weekdays)
            case .denied:
                print("Application Not Allowed to Display Notifications")
            case .provisional:
                self.scheduleLocalNotification(weekdays: weekdays)
            }
        }
    }
    
    fileprivate func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    }
    
    fileprivate func scheduleLocalNotification(weekdays: [String]) {
        
        var identifiers: [String] = []
        
        for weekday in weekdays {
            
            switch weekday {
            case "Sunday":
                identifiers.append(configureRequest(weekday: 1,
                                                    hour: 21,
                                                    title: "Мои отгула",
                                                    body: "У тебя есть еще " + ApplicationManager.settingsService.timeOffLeft! + " отгула. Может поспишь завтра?"))
                
            case "Monday":
                identifiers.append(configureRequest(weekday: 2,
                                                    hour: Int(ApplicationManager.settingsService.startWorktime!.dropLast(3))!,
                                                    title: "Мои отгула",
                                                    body: "У тебя есть еще " + ApplicationManager.settingsService.timeOffLeft! + " отгула. Может поспишь?"))
                
            case "Tuesday"  : break
            case "Wednesday":
                identifiers.append(configureRequest(weekday: 4,
                                                    hour: Int(ApplicationManager.settingsService.startWorktime!.dropLast(3))!,
                                                    title: "Мои отгула",
                                                    body: "У тебя есть еще " + ApplicationManager.settingsService.timeOffLeft! + " отгула. Может поспишь?"))
                
            case "Thursday":
                identifiers.append(configureRequest(weekday: 5,
                                                    hour: Int(ApplicationManager.settingsService.startWorktime!.dropLast(3))!,
                                                    title: "Мои отгула",
                                                    body: "У тебя есть еще " + ApplicationManager.settingsService.timeOffLeft! + " отгула. Может поспишь?"))
                
            case "Friday"   : break
            case "Saturday" : break
            case "EveryHour" :
                let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600,
                                                                                          repeats: true)
                
                let notificationContent = UNMutableNotificationContent()
                
                notificationContent.title = "Мои отгула"
                notificationContent.body = "У тебя есть еще " + ApplicationManager.settingsService.timeOffLeft! + " отгула. Может поспишь?"
                notificationContent.badge = 1
                notificationContent.sound = UNNotificationSound.default()
                
                let notificationRequest = UNNotificationRequest(identifier: Constants.requestIdentifier + String(describing: weekday),
                                                                content: notificationContent,
                                                                trigger: notificationTrigger)
                
                UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                    if let error = error {
                        print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
                    }
                }
                identifiers.append(Constants.requestIdentifier + String(describing: weekday))
                
            default:
                break
            }
        }
        
        ApplicationManager.settingsService.userLocalNotificationIdentifiers = identifiers
    }
}



// MARK: - Configure Methods

@available(iOS 10.0, *)
extension ApplicationLocalNotificationService {
    
    fileprivate func configureContent(title: String, body: String) -> UNMutableNotificationContent {
        
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = title
        //notificationContent.subtitle = "Пора поспать!"
        notificationContent.body = body
        notificationContent.badge = 1
        notificationContent.sound = UNNotificationSound.default()
        
        return notificationContent
    }
    
    fileprivate func configureDateComponents(weekday: Int, hour: Int) -> DateComponents {
        
        var components = DateComponents()
        
        components.weekday = weekday
        components.hour = hour
        
        return components
    }
    
    fileprivate func configureRequest(weekday: Int, hour: Int, title: String, body: String) -> String {
        
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: configureDateComponents(weekday: weekday, hour: hour), repeats: true)
        
        let notificationRequest = UNNotificationRequest(identifier: Constants.requestIdentifier + String(describing: weekday),
                                                        content: configureContent(title: title, body: body),
                                                        trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
        
        return Constants.requestIdentifier + String(describing: weekday)
    }
}
