//
//  ProgressViewController.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 18/09/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import MBProgressHUD

// MARK: - MBProgressHUD

extension UIViewController {
    
    func startProgressHUD() {
        
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        self.makeProgressHUD(loadingNotification)
    }
    
    func makeProgressHUD(_ loadingNotification: MBProgressHUD) {
        
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.isUserInteractionEnabled = false
        loadingNotification.bezelView.color = UIColor.black
        loadingNotification.contentColor = UIColor.white
        loadingNotification.bezelView.style = .solidColor
        loadingNotification.backgroundView.blurEffectStyle = .extraLight
    }
    
    func hideProgressHUD() {
        
        MBProgressHUD.hide(for: view, animated: true)
    }
}
