//
//  SettingsTableViewController.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 22/06/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var textNameLabel: UILabel!
    @IBOutlet weak var textEMailLabel: UILabel!
    @IBOutlet weak var textWorktimeLabel: UILabel!
    @IBOutlet weak var notifySwitch: UISwitch!
    
    
    
    // MARK: - IBActions
    
    @IBAction func unwindToSettings(segue: UIStoryboardSegue) {
        self.setSetiings()
    }
    
    @IBAction func changeSwitch(_ sender: UISwitch) {
        
        guard ApplicationManager.settingsService.startWorktime != nil,
            ApplicationManager.settingsService.endWorktime != nil else {
                //self.view.layer.removeAllAnimations()
                self.notifySwitch.isOn = false
            return
        }
        
        if self.notifySwitch.isOn {
            if #available(iOS 10.0, *) {
                ApplicationManager.localNotificationService.enableNotifications()
            } else {
                // Fallback on earlier versions
            }
        }
        else {
            if #available(iOS 10.0, *) {
                ApplicationManager.localNotificationService.disableNotifications()
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setSetiings()
    }
}



// MARK: - Configure

extension SettingsTableViewController {
    
    fileprivate func setSetiings() {
        
        self.textNameLabel.text = ApplicationManager.settingsService.name
        self.textEMailLabel.text = ApplicationManager.settingsService.account
        self.notifySwitch.isOn = ApplicationManager.settingsService.didDisplayPushNotificationsRequest
    }
}
