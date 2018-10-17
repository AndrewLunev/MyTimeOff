//
//  TimeOffTypeTableViewController.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 28/06/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import UIKit

enum TimeOffType: String {
    case fullPlus = "fullPlus"
    case fullMinus = "fullMinus"
    case halfMinus = "halfMinus"
}

class TimeOffTypeTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var typeTitle = ""
    var typeValue = ""
    var lastIndexPath: IndexPath = []
    
    
    
    // MARK: - Outlets
    
    
    
    // MARK: - IBActions
    
    @IBAction func doneType(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "unwindToAddTimeOff", sender: nil)
    }
    
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}



// MARK: - UITableViewDataSource

extension TimeOffTypeTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.cellForRow(at: indexPath)?.isSelected)! {
            if !self.lastIndexPath.isEmpty {
                tableView.cellForRow(at: self.lastIndexPath)?.accessoryType = .none
            }
            
            self.lastIndexPath = indexPath
            
            switch indexPath.row {
            case 0:
                self.typeValue = TimeOffType.fullPlus.rawValue
            case 1:
                self.typeValue = TimeOffType.fullMinus.rawValue
            case 2:
                self.typeValue = TimeOffType.halfMinus.rawValue
            default:
                break
            }
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            self.typeTitle = (tableView.cellForRow(at: indexPath)?.textLabel?.text)!
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}



// MARK: - Navigation

extension TimeOffTypeTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToAddTimeOff" {
            let viewController: AddDetailTableViewController = segue.destination as! AddDetailTableViewController
            viewController.typeTitle.text = self.typeTitle
            viewController.type = self.typeValue
        }
    }
}
