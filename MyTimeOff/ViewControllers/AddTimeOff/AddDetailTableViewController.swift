//
//  AddDetailTableViewController.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 25/06/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

enum PickerType: Int {
    case date = 1
    case fromDate = 2
    case toDate = 3
    case endDate = 4
}

enum DateFormatterType: String {
    case time = "HH:mm"
    case dateTime = "HH:mm:ss dd-MM-yyyy"
    case date = "dd-MM-yyyy"
}

class AddDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    weak var timeOffTypeTableViewController: TimeOffTypeTableViewController?
    
    var isDatePickerHidden = true
    var isFromDatePickerHidden = true
    var isToDatePickerHidden = true
    var isEndDatePickerHidden = true
    
    var isPeriodDateHidden = true
    
    var keyboardHeight = 0
    var showKeyboard = false
    
    var type = ""
    var create = false
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var textViewCommentary: UITextView!
    
    @IBOutlet weak var typeTitle: UILabel!
    
    @IBOutlet weak var dateDetailLabel: UILabel!
    @IBOutlet weak var dateDetail: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var endDatePeriod: UILabel!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBOutlet weak var fromDateDetail: UILabel!
    @IBOutlet weak var fromDate: UIDatePicker!
    
    @IBOutlet weak var toDateDetail: UILabel!
    @IBOutlet weak var toDate: UIDatePicker!
    
    
    
    // MARK: - IBActions
    
    @IBAction func datePickerValue(sender: UIDatePicker) {
        datePickerChanged(pickerType: .date)
    }
    
    @IBAction func fromDatePickerValue(_ sender: UIDatePicker) {
        datePickerChanged(pickerType: .fromDate)
    }
    
    @IBAction func toDatePickerValue(_ sender: UIDatePicker) {
        datePickerChanged(pickerType: .toDate)
    }
    
    @IBAction func endDatePickerValue(_ sender: UIDatePicker) {
        datePickerChanged(pickerType: .endDate)
    }
    
    @IBAction func unwindToAddTimeOff(segue: UIStoryboardSegue) {
        
        setTextViewColor(isValid: true)
        self.isFullTimeOff()
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func createTimeOff(_ sender: UIBarButtonItem) {
        
        guard
            !self.type.isEmpty
            else {
                setTextViewColor(isValid: false)
                return
        }
        
        self.create = true
        
        self.view.endEditing(true)
        
        self.createTimeOff()
    }
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextView()
        configureDatePickers()
        configureKeyboard()
    }
}



// MARK: - Configure

extension AddDetailTableViewController {
    
    fileprivate func configureTextView() {
        
        self.textViewCommentary.isEditable = true
    }
    
    fileprivate func configureDatePickers() {
        
        let ruLocale = NSLocale.init(localeIdentifier: "ru_RU") as Locale as Locale
        
        self.datePicker.datePickerMode = .date
        self.datePicker.locale = ruLocale
        
        self.endDatePicker.datePickerMode = .date
        self.endDatePicker.locale = ruLocale
        
        self.fromDate.datePickerMode = .time
        self.fromDate.locale = ruLocale
        
        self.toDate.datePickerMode = .time
        self.toDate.locale = ruLocale
        
        datePickerChanged(pickerType: .date)
        datePickerChanged(pickerType: .fromDate)
        datePickerChanged(pickerType: .toDate)
        datePickerChanged(pickerType: .endDate)
    }
    
    fileprivate func configureKeyboard() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}



// MARK: - Private

extension AddDetailTableViewController {
    
    fileprivate func isFullTimeOff() {
        
        if self.type == "fullMinus" {
            self.fromDateDetail.text = ApplicationManager.settingsService.startWorktime
            self.toDateDetail.text = ApplicationManager.settingsService.endWorktime
        }
    }
}



// MARK: - HTTP Requests

extension AddDetailTableViewController {
    
    // NOTE: - POST
    
    fileprivate func createTimeOff() {
        
        self.startProgressHUD()
        
        let urlString = URLType.timeoffsURL.rawValue + "?email=" + ApplicationManager.settingsService.account! + "&type=" + self.type
        
        Alamofire.request(urlString, method: .put,
                          parameters: ["Detail_TimeOffDate": "00:00:00 " + self.dateDetail.text!,
                                       "Detail_CreateDate":  self.getDateFormatter(dateFormatterType: .dateTime).string(from: Date()),
                                       "Detail_FromDate":  self.getDateFormatter(dateFormatterType: .dateTime).string(from: self.fromDate.date),
                                       "Detail_ToDate":  self.getDateFormatter(dateFormatterType: .dateTime).string(from: self.toDate.date),
                                       "Detail_Comment": self.textViewCommentary.text], encoding: JSONEncoding.default, headers: nil).responseJSON {
                                        
                                        response in switch response.response?.statusCode {
                                            
                                        case 200:
                                            
                                            print(response)
                                            self.create = false
                                            self.present(self.getAlert(title: "Данные добавлены.", message: "", statusCode: (response.response?.statusCode)!), animated: true, completion: nil)
                                            
                                        case 500:
                                            print("Error 500")
                                            self.present(self.getAlert(title: "Ошибка 500", message: "", statusCode: (response.response?.statusCode)!), animated: true, completion: nil)
                                        case .none:
                                            print("Error none")
                                            self.present(self.getAlert(title: "Ошибка неизвестна", message: "", statusCode: (response.response?.statusCode)!), animated: true, completion: nil)
                                        case .some(_):
                                            print("Error some")
                                            self.present(self.getAlert(title: "Еще какая-то ошибка", message: "", statusCode: (response.response?.statusCode)!), animated: true, completion: nil)
                                        }
        }
    }
}



// MARK: - UITableViewDelegate

extension AddDetailTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            switch indexPath.section {
            case 0:
                self.performSegue(withIdentifier: "SelectTypeSeague", sender: nil)
            case 1:
                self.toggleDatepicker(pickerType: .date)
            case 2:
                if self.type != "fullMinus" {
                    self.toggleDatepicker(pickerType: .fromDate)
                }
            case 3:
                if self.type != "fullMinus" {
                    self.toggleDatepicker(pickerType: .toDate)
                }
            default:
                break
            }
        } else if indexPath.row == 1 {
            switch indexPath.section {
            case 0:
                if (tableView.cellForRow(at: indexPath)?.isSelected)! {
                    if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
                        tableView.cellForRow(at: indexPath)?.accessoryType = .none
                        self.dateDetailLabel.text = "Дата"
                        self.isPeriodDateHidden = true
                        tableView.beginUpdates()
                        tableView.endUpdates()
                    } else {
                        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                        self.dateDetailLabel.text = "С"
                        self.isPeriodDateHidden = false
                        tableView.beginUpdates()
                        tableView.endUpdates()
                    }
                }
            default:
                break
            }
        } else if indexPath.row == 2 {
            switch indexPath.section {
            case 1:
                self.toggleDatepicker(pickerType: .endDate)
            default:
                break
            }
        }
    }
}



// MARK: - UITableViewDataSource

extension AddDetailTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            switch indexPath.row {
            case 2:
                if self.isPeriodDateHidden {
                    return 0
                }
            case 3:
                if self.isEndDatePickerHidden {
                    return 0
                }
            default:
                break
            }
        }
        
        if indexPath.row == 1 {
            switch indexPath.section {
            case 1:
                if self.isDatePickerHidden {
                    return 0
                }
            case 2:
                if self.isFromDatePickerHidden {
                    return 0
                }
            case 3:
                if self.isToDatePickerHidden {
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



// MARK: - Keyboard

extension AddDetailTableViewController {
    
    //NOTE: Можно так:
 
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.showKeyboard == false {
            self.view.frame.origin.y -= 0
            self.showKeyboard = true
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.showKeyboard == true {
            self.view.frame.origin.y += 0
            self.showKeyboard = false
        }
    }
}



// MARK: - DateFormatter

extension AddDetailTableViewController {
    
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



// MARK: - DatePickers

extension AddDetailTableViewController {
    
    func datePickerChanged(pickerType: PickerType) {
        
        switch pickerType {
        case .date:
            self.dateDetail.text = self.getDateFormatter(dateFormatterType: .date).string(from: self.datePicker.date)
        case .endDate:
            self.endDatePeriod.text = self.getDateFormatter(dateFormatterType: .date).string(from: self.endDatePicker.date)
        case .fromDate:
            self.fromDateDetail.text = self.getDateFormatter(dateFormatterType: .time).string(from: self.fromDate.date)
        case .toDate:
            self.toDateDetail.text = self.getDateFormatter(dateFormatterType: .time).string(from: self.toDate.date)
        }
    }
    
    func toggleDatepicker(pickerType: PickerType) {
        
        switch pickerType {
        case .date:
            self.isDatePickerHidden = !self.isDatePickerHidden
        case .endDate:
            self.isEndDatePickerHidden = !self.isEndDatePickerHidden
        case .fromDate:
            self.isFromDatePickerHidden = !self.isFromDatePickerHidden
        case .toDate:
            self.isToDatePickerHidden = !self.isToDatePickerHidden
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}



// MARK: - Text validation

extension AddDetailTableViewController {
    
    fileprivate func setTextViewColor(isValid: Bool) {
        self.typeTitle.textColor = isValid ? UIColor.black : UIColor.red
    }
}

