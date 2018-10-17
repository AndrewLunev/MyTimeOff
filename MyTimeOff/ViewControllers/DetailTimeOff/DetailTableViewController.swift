//
//  DetailTableViewController.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 28/06/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var timeOff: Detail!
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var timeOffDate: UILabel!
    @IBOutlet weak var fromDate: UILabel!
    @IBOutlet weak var toDate: UILabel!
    @IBOutlet weak var tvComment: UITextView!
    @IBOutlet weak var createDate: UILabel!
    
    
    
    // MARK: - IBActions
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setDetailData()
    }
}



// MARK: - Private

extension DetailTableViewController {
    
    fileprivate func setDetailData() {
        
        self.labelTitle.text = self.timeOff.Detail_Title
        self.timeOffDate.text = self.timeOff.Detail_TimeOffDate
        self.fromDate.text = self.timeOff.Detail_FromDate
        self.toDate.text = self.timeOff.Detail_ToDate
        self.tvComment.text = self.timeOff.Detail_Comment
        self.createDate.text = self.timeOff.Detail_CreateDate
    }
}
