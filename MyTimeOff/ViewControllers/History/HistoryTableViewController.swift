//
//  HistoryTableViewController.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 27/06/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class HistoryTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var timeOffs = [Detail]()
    var index: Int!
    
    
    
    // MARK: - Outlets

    
    
    // MARK: - IBActions
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        tableView.register(UINib(nibName: "HistoryTableCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Загрузка...")
        refreshControl.addTarget(self, action: #selector(self.getMyTimeOffs), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        self.getMyTimeOffs(refreshControl: refreshControl)
    }
}



// MARK: - Help Methods

extension HistoryTableViewController {
    
    @objc func getMyTimeOffs(refreshControl: UIRefreshControl) {
        
        let urlString = URLType.detailURL.rawValue + "?email=" + ApplicationManager.settingsService.account!
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString {
            response in switch response.response?.statusCode {
            case 200:
                
                print(response)
                
                self.timeOffs = try! JSONDecoder().decode([Detail].self, from: response.data!)
                print(self.timeOffs)
                self.tableView.reloadData()
                refreshControl.endRefreshing()
                
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

extension HistoryTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
        self.performSegue(withIdentifier: "detailTimeOffSeague", sender: nil)
    }
}



// MARK: - UITableViewDataSource

extension HistoryTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timeOffs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath as IndexPath) as! HistoryTableViewCell
        
        cell.labelTitle.text = self.timeOffs[self.timeOffs.count-indexPath.row-1].Detail_Title
        cell.labelCreateDate.text = "Дата создания - " + self.timeOffs[self.timeOffs.count-indexPath.row-1].Detail_CreateDate
        
        switch self.timeOffs[self.timeOffs.count-indexPath.row-1].Detail_Type {
        case 4:
            //fullPlus
            cell.imgType.backgroundColor = UIColor.green
        case 1:
            //fullMinus
            cell.imgType.backgroundColor = UIColor.red
        case 2:
            //halfMinus
            cell.imgType.backgroundColor = UIColor.orange
        default:
            break
        }
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0;
    }
}



// MARK: - Navigation

extension HistoryTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailTimeOffSeague" {
            let viewController: DetailTableViewController = segue.destination as! DetailTableViewController
            viewController.timeOff = self.timeOffs[self.timeOffs.count-self.index-1]
        }
    }
}
