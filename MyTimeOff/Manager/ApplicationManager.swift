//
//  ApplicationManager.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 28/08/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import Foundation

class ApplicationManager {
    
    static let sharedInstance = ApplicationManager()
    
    static let settingsService = ApplicationSettingsService()
    
    @available(iOS 10.0, *)
    static let localNotificationService = ApplicationLocalNotificationService()
    
    private init() { }
}
