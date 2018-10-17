//
//  HistoryTableViewCell.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 27/06/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    // MARK: - IBActions
    
    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelCreateDate: UILabel!

    
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}



// MARK: - UITableViewCellDelegate

extension HistoryTableViewCell {
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
