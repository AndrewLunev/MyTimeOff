//
//  ViewController.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 05/06/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

enum URLType: String {
    case loginURL = "http://13.94.153.86:80/Account/Login"
    case timeoffsURL = "http://13.94.153.86:80/api/TimeOffs"
    case detailURL = "http://13.94.153.86:80/api/Details"
}

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    var showKeyboard = false
    var hasLogin = false
    
    var backgroundView: UIView? = nil
    
    weak var loginEmbedViewController: LoginEmbedViewController?
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var LoginView: UIView!
    
    
    
    // MARK: - IBActions
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        
        _ = ApplicationManager.settingsService.actionKeychain(withType: .remove)
        ApplicationManager.settingsService.removeUserData()
        
        guard self.backgroundView != nil else {
            return
        }

        self.view.subviews[self.view.subviews.index(of: self.backgroundView!)!].isHidden = true
    }
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NOTE: - Это тест метода для будущего функционала
        /*
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss dd-MM-yyyy"
        
        let date1 = formatter.date(from: "22:31:00 06/08/2018")
        let date2 = formatter.date(from: "21:00:00 21/08/2018")
        
        let diff = self.interval(ofComponent: .day, fromDate: date1!, toDate: date2!)
        */
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginEmbedViewController") as! LoginEmbedViewController
        
        viewController.loginEmbedDelegate = self
        
        self.loginEmbedViewController = viewController
        
        addChildViewController(loginEmbedViewController!)
        
        self.LoginView.addSubview((self.loginEmbedViewController?.view)!)
        viewController.view.frame = view.bounds
        viewController.view.frame = CGRect(x:0, y: 0, width:self.LoginView.frame.width, height:198)

        loginEmbedViewController?.didMove(toParentViewController: self)
        view.bringSubview(toFront: LoginView)
        
        self.LoginView.layer.shadowColor = UIColor.black.cgColor
        self.LoginView.layer.shadowOffset = CGSize(width: 0.5, height: 3.0)
        self.LoginView.layer.masksToBounds = false
        self.LoginView.layer.shadowRadius = 3.0
        self.LoginView.layer.shadowOpacity = 0.75
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard ApplicationManager.settingsService.actionKeychain(withType: .read)?.password != nil
            else {
                return
        }
        
        self.setBackgroundView()
        super.viewWillAppear(true)
        
        self.loginPressed(login: ApplicationManager.settingsService.account!,
                          password: (ApplicationManager.settingsService.actionKeychain(withType: .read)?.password)!)
    }
}



// MARK: - DateTime Help Methods
// это на будущий функционал метод
/*
extension LoginViewController {
    
    func interval(ofComponent comp: Calendar.Component, fromDate fDate: Date, toDate tDate: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: fDate) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: tDate) else { return 0 }
        
        return end - start
    }
}
*/



// MARK: - Private Methods

extension LoginViewController {
    
    fileprivate func setBackgroundView() {
        
        let image = UIImage(named: "background")
        self.backgroundView = UIImageView(image: image)
        self.backgroundView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(self.backgroundView!)
    }
}



// MARK: - LoginEmbedDelegate

extension LoginViewController: LoginEmbedDelegate {
    
    func loginPressed(login: String, password: String) {
        
        UIButton.animate(withDuration: 0.05,
                         animations: {
                            self.loginEmbedViewController?.btnLogin.transform = CGAffineTransform(scaleX: 0.95, y: 0.9) },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.05, animations: {
                                self.loginEmbedViewController?.btnLogin.transform = CGAffineTransform.identity
                                self.startProgressHUD()
                            })
        })
        
        self.loginRequest(login: login, password: password)
    }
}



// MARK: - HTTP Requests

extension LoginViewController {
    
    // NOTE: - GET
    
    fileprivate func loginRequest(login: String, password: String) {
        
        Alamofire.request(URLType.loginURL.rawValue, method: .post, parameters: ["Email": login, "Password": password],encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in switch response.response?.statusCode {
            case 200:
                
                print(response)
                
                ApplicationManager.settingsService.account = login
                _ = ApplicationManager.settingsService.actionKeychain(password, withType: .save)
                
                MBProgressHUD.hide(for: self.view, animated: true)
                self.performSegue(withIdentifier: "LoginToMainSeague", sender: nil)
                break
                
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



// MARK: - Keyboard

extension LoginViewController {

    @objc func keyboardWillShow(notification: NSNotification) {
        if self.showKeyboard == false {
            self.view.frame.origin.y -= 90
            self.showKeyboard = true
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.showKeyboard == true {
            self.view.frame.origin.y += 90
            self.showKeyboard = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
