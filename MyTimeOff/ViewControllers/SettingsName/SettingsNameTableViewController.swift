//
//  SettingsNameTableViewController.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 24/08/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import UIKit

class SettingsNameTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var textNameLabel: UITextField!
    
    
    
    // MARK: - IBActions
    
    @IBAction func saveName(_ sender: UIBarButtonItem) {
        
        ApplicationManager.settingsService.name = self.textNameLabel.text
        self.performSegue(withIdentifier: "unwindToSettings", sender: nil)
    }
    
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setData()
    }
}

// MARK: - Configure

extension SettingsNameTableViewController {
    
    fileprivate func setData() {
        self.textNameLabel.text = ApplicationManager.settingsService.name
    }
}
