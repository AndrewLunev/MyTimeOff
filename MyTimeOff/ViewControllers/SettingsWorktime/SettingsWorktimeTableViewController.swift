//
//  SettingsWorktimeTableViewController.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 24/08/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import UIKit

enum WorktimePickerType: Int {
    case startWorktime = 1
    case endWorktime = 2
}

class SettingsWorktimeTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var isStartWorktimePickerHidden = true
    var isEndWorktimePickerHidden = true
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var startWorktimePicker: UIDatePicker!
    @IBOutlet weak var endWorktimePicker: UIDatePicker!
    @IBOutlet weak var startWorktimeLabel: UILabel!
    @IBOutlet weak var endWorktimeLabel: UILabel!
    
    
    
    // MARK: - IBActions
    
    @IBAction func datePickerValue(sender: UIDatePicker) {
        datePickerChanged(pickerType: .startWorktime)
    }
    
    @IBAction func fromDatePickerValue(_ sender: UIDatePicker) {
        datePickerChanged(pickerType: .endWorktime)
    }
    
    @IBAction func saveWorktime(_ sender: UIBarButtonItem) {
        
        ApplicationManager.settingsService.startWorktime = self.getDateFormatter(dateFormatterType: .time).string(from: self.startWorktimePicker.date)
        ApplicationManager.settingsService.endWorktime = self.getDateFormatter(dateFormatterType: .time).string(from: self.endWorktimePicker.date)

        self.performSegue(withIdentifier: "unwindToSettings", sender: nil)
    }
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureDatePickers()
        self.setData()
    }

}



// MARK: - Configure

extension SettingsWorktimeTableViewController {
    
    fileprivate func configureDatePickers() {
        
        let ruLocale = NSLocale.init(localeIdentifier: "ru_RU") as Locale as Locale
        
        self.startWorktimePicker.datePickerMode = .time
        self.startWorktimePicker.locale = ruLocale
        
        self.endWorktimePicker.datePickerMode = .time
        self.endWorktimePicker.locale = ruLocale
        
        datePickerChanged(pickerType: .startWorktime)
        datePickerChanged(pickerType: .endWorktime)
    }
    
    fileprivate func setData() {
        
        guard ApplicationManager.settingsService.startWorktime != nil, ApplicationManager.settingsService.endWorktime != nil else {
            return
        }
        
        self.startWorktimePicker.setDate(self.getDateFormatter(dateFormatterType: .time).date(from: ApplicationManager.settingsService.startWorktime!)!, animated: false)
        self.startWorktimeLabel.text = ApplicationManager.settingsService.startWorktime!
        
        self.endWorktimePicker.setDate(self.getDateFormatter(dateFormatterType: .time).date(from: ApplicationManager.settingsService.endWorktime!)!, animated: false)
        self.endWorktimeLabel.text = ApplicationManager.settingsService.endWorktime!
    }
}



// MARK: - UITableViewDelegate

extension SettingsWorktimeTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            switch indexPath.section {
            case 0:
                self.toggleDatepicker(pickerType: .startWorktime)
            case 1:
                self.toggleDatepicker(pickerType: .endWorktime)
            default:
                break
            }
        }
    }
}



// MARK: - UITableViewDataSource

extension SettingsWorktimeTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 1 {
            switch indexPath.section {
            case 0:
                if self.isStartWorktimePickerHidden {
                    return 0
                }
            case 1:
                if self.isEndWorktimePickerHidden {
                    return 0
                }
            default:
                return super.tableView(tableView, heightForRowAt: indexPath)
            }
            
        } else {
            
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}



// MARK: - DatePickers

extension SettingsWorktimeTableViewController {
    
    func datePickerChanged(pickerType: WorktimePickerType) {
        
        switch pickerType {
        case .startWorktime:
            self.startWorktimeLabel.text = self.getDateFormatter(dateFormatterType: .time).string(from: self.startWorktimePicker.date)
        case .endWorktime:
            self.endWorktimeLabel.text = self.getDateFormatter(dateFormatterType: .time).string(from: self.endWorktimePicker.date)
        }
    }
    
    func toggleDatepicker(pickerType: WorktimePickerType) {
        
        switch pickerType {
        case .startWorktime:
            self.isStartWorktimePickerHidden = !self.isStartWorktimePickerHidden
        case .endWorktime:
            self.isEndWorktimePickerHidden = !self.isEndWorktimePickerHidden
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}



// MARK: - DateFormatter

extension SettingsWorktimeTableViewController {
    
    fileprivate func getDateFormatter(dateFormatterType: DateFormatterType) -> DateFormatter {
        
        let dateFormatter = DateFormatter()
        
        switch dateFormatterType {
        case .date:
            dateFormatter.dateFormat = DateFormatterType.date.rawValue
        case .time:
            dateFormatter.dateFormat = DateFormatterType.time.rawValue
        case .dateTime:
            dateFormatter.dateFormat = DateFormatterType.dateTime.rawValue
        }
        
        return dateFormatter
    }
}
