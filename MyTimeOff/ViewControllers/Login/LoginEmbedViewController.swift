//
//  LoginEmbedViewController.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 21/06/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import UIKit

// MARK: - Protocols

protocol LoginEmbedDelegate: class {
    func loginPressed(login :String, password :String)
}

class LoginEmbedViewController: UITableViewController {
    
    // MARK: - Properties
    
    weak var loginEmbedDelegate: LoginEmbedDelegate?
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var tfLogin: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    
    
    // MARK: - IBActions
    
    @IBAction func loginTapped(_ sender: UIButton) {
        loginEmbedDelegate?.loginPressed(login: self.tfLogin.text!, password: self.tfPassword.text!)
    }
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.configureLoginPassTestMethod()
        self.configureButtonLogin()
    }
}



// MARK: - Configure

extension LoginEmbedViewController {
    
    fileprivate func configureButtonLogin() {
        
        self.btnLogin.layer.cornerRadius = 7
        
        self.btnLogin.layer.shadowColor = UIColor.black.cgColor
        self.btnLogin.layer.shadowOffset = CGSize(width: 0.5, height: 3.0)
        self.btnLogin.layer.masksToBounds = false
        self.btnLogin.layer.shadowRadius = 3.0
        self.btnLogin.layer.shadowOpacity = 0.75
    }
    
    fileprivate func configureLoginPassTestMethod() {
        
        self.tfLogin.text = "test@mail.ru"
        self.tfPassword.text = "!Admin123"
    }
}
