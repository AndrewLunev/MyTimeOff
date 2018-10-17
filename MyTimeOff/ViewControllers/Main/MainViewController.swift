//
//  MainViewController.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 05/06/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import UserNotifications

class MainViewController: UIViewController {
    
    // MARK: - Properties
    

    
    // MARK: - Outlets
    
    @IBOutlet weak var btnFullPlus: UIButton!
    @IBOutlet weak var btnFullMinus: UIButton!
    @IBOutlet weak var textViewTimeOffs: UILabel!
    
    
    
    // MARK: - IBActions
    
    @IBAction func btnPlusClick(_ sender: UIButton) {
        self.performSegue(withIdentifier: "AddDetailSeague", sender: nil)
    }
    
    @IBAction func btnMinusClick(_ sender: UIButton) {
        self.performSegue(withIdentifier: "AddDetailSeague", sender: nil)
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        self.getMyTimeOffs()
    }
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getMyTimeOffs()
        
        /*guard ApplicationManager.settingsService.didDisplayPushNotificationsRequest != false else {
            return
        }
        
        if #available(iOS 10.0, *) {
            ApplicationManager.localNotificationService.enableNotifications()
        } else {
            // Fallback on earlier versions
        }*/
    }
}



// MARK: - Private

extension MainViewController {
    
    fileprivate func getMyTimeOffs() {
        
        startProgressHUD()
        
        let urlString = URLType.timeoffsURL.rawValue + "?email=" + ApplicationManager.settingsService.account!
        
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString {
            response in switch response.response?.statusCode {
            case 200:
                
                print(response)
                //let timeoff = TimeOff(json: response.result.value as! [String : Any])
                let timeoff = try! JSONDecoder().decode(TimeOff.self, from: response.data!)
                self.textViewTimeOffs.text = String(format:"%.1f", (timeoff.TimeOff_Count))
                
                ApplicationManager.settingsService.timeOffLeft = String(timeoff.TimeOff_Count)
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
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



// MARK: - UserLocalNotificationConfigure
// NOTE: - Полезная ссылка с методом как залупить нотификейшоны по дням
// NOTE: - https://stackoverflow.com/questions/41493722/scheduling-local-notifications-inside-for-loop
// MARK: - UNUserNotificationCenterDelegate

@available(iOS 10.0, *)
extension MainViewController {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
}
