//
//  ApplicationSettingsService.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 28/08/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import Foundation

enum KeychainType: String {
    case save = "Save"
    case remove = "Remove"
    case read = "Read"
}

class ApplicationSettingsService {
    
    // MARK: - Constants
    
    fileprivate enum Keys {
        
        static let service = String(describing: ApplicationSettingsService.self)

        static let appVersion = service + ".appVersion"
        
        static let account = service + ".account"
        static let name = service + ".name"
        static let timeOffLeft = service + ".timeOffLeft"
        
        static let startWorktime = service + ".startWorktime"
        static let endWorktime = service + ".endWorktime"
        
        static let userHash = service + ".userHash"
        static let didDisplayPushNotificationsRequest = service + ".didDisplayPushNotificationsRequest"
        static let userLocalNotificationIdentifiers = service + ".userLocalNotificationIdentifiers"

    }
    
    fileprivate enum KeychainConfiguration {
        
        static let keychainService = Bundle.main.bundleIdentifier!
        static let accessGroup: String? = nil
        
    }
    
    
    
    // MARK: - Private properties
    
    fileprivate let userDefaults: UserDefaults
    
    fileprivate var appVersion: String? {
        get {
            return userDefaults.string(forKey: Keys.appVersion)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.appVersion)
            userDefaults.synchronize()
        }
    }
    
    
    
    // MARK: - Public properties
    
    var didDisplayPushNotificationsRequest: Bool {
        get { return userDefaults.bool(forKey: Keys.didDisplayPushNotificationsRequest) }
        set {
            userDefaults.set(newValue, forKey: Keys.didDisplayPushNotificationsRequest)
            userDefaults.synchronize()
        }
    }
    
    var userLocalNotificationIdentifiers: [String]? {
        get { return userDefaults.object(forKey: Keys.userLocalNotificationIdentifiers) as? [String] }
        set {
            userDefaults.set(newValue, forKey: Keys.userLocalNotificationIdentifiers)
            userDefaults.synchronize()
        }
    }

    var userHash: String? {
        get { return userDefaults.string(forKey: Keys.userHash)}
        set {
            userDefaults.set(newValue, forKey: Keys.userHash)
            userDefaults.synchronize()
        }
    }
    
    var account: String? {
        get {
            return userDefaults.string(forKey: Keys.account)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.account)
            userDefaults.synchronize()
        }
    }
    
    var name: String? {
        get { return userDefaults.string(forKey: Keys.name)}
        set {
            userDefaults.set(newValue, forKey: Keys.name)
            userDefaults.synchronize()
        }
    }
    
    var timeOffLeft: String? {
        get { return userDefaults.string(forKey: Keys.timeOffLeft)}
        set {
            userDefaults.set(newValue, forKey: Keys.timeOffLeft)
            userDefaults.synchronize()
        }
    }
    
    var startWorktime: String? {
        get { return userDefaults.string(forKey: Keys.startWorktime)}
        set {
            userDefaults.set(newValue, forKey: Keys.startWorktime)
            userDefaults.synchronize()
        }
    }
    
    var endWorktime: String? {
        get { return userDefaults.string(forKey: Keys.endWorktime)}
        set {
            userDefaults.set(newValue, forKey: Keys.endWorktime)
            userDefaults.synchronize()
        }
    }
    
    
    
    // MARK: - Инициализация
    
    init()
    {
        userDefaults = UserDefaults.standard
        reconfigureSettings()
    }
    
    
    
    // MARK: - Публичные методы
    
    
    
    // MARK: - Приватные методы
    
    /**
     Метод переконфигурирует настройки приложения.
     Вызывается при инициализации сервиса.
     */
    fileprivate func reconfigureSettings()
    {
        cleanKeychainIfFirstRun()
        
        reconfigureSavedAppVersion()
    }
    
    /**
     Удаляет старые ключи из Keychain, если это первый запуск после установки.
     */
    fileprivate func cleanKeychainIfFirstRun()
    {
        let isFirstRun = (appVersion == nil || appVersion?.isEmpty == true)
        
        if isFirstRun {
            do {
               _ = actionKeychain(withType: .remove)
            } catch {
                
            }
        }
     }
    
    /**
     Метод сохраняет текущую версию приложения в настройки.
     */
    fileprivate func reconfigureSavedAppVersion()
    {
        appVersion = currentAppVersion()
    }
    
    /**
     Метод проверяет изменилась ли версия приложения.
     
     - returns:
     true, если версия приложения изменилась,
     false, в противном случае.
     */
    fileprivate func applicationVersionChanged() -> Bool
    {
        return appVersion != currentAppVersion()
    }
    
    /**
     Метод возвращает текущую версию приложения.
     
     - returns: версия приложения в формате 1.3(8)
     */
    fileprivate func currentAppVersion() -> String
    {
        let version = Bundle.main
            .object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build = Bundle.main
            .object(forInfoDictionaryKey: "CFBundleVersion") as! String
        return version + "(\(build))"
    }
}

// MARK: - Keychain Methods

extension ApplicationSettingsService {
    
    func actionKeychain(_ password: String? = nil, withType keychainType: KeychainType) -> (isEmpty: Bool, password: String?)? {
        
        guard account != nil
            else { return (false, nil) }
        
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.keychainService,
                                                    account: account!,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
            switch keychainType.rawValue {
            case "Save":
                try passwordItem.savePassword(password!)
            case "Remove":
                try passwordItem.deleteItem()
            case "Read":
                let pass = try passwordItem.readPassword()
                return (true, pass)
            default:
                break
            }
            
        } catch {
            print("Error \(keychainType.rawValue) keychain - \(error)")
            return (false, nil)
        }
        
        return (false, nil)
    }
}


// MARK: - Help Methods

extension ApplicationSettingsService {
    
    func removeUserData()
    {
        account = nil
        name = nil
        timeOffLeft = nil
        startWorktime = nil
        endWorktime = nil
        userHash = nil
        didDisplayPushNotificationsRequest = false
        userLocalNotificationIdentifiers = nil
    }
}
