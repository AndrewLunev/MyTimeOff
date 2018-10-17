//
//  AlerViewController.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 18/09/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import UIKit

// MARK: - AlertController

extension UIViewController {
    
    func getAlert(title: String, message: String, statusCode: Int) -> UIAlertController {
        
        hideProgressHUD()
        
        return makeAlertController(title: title, message: message, statusCode: statusCode)
    }
    
    func makeAlertController(title: String, message: String, statusCode: Int) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }
        }))
        
        return alert;
    }
}
