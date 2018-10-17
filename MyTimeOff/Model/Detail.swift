//
//  Detail.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 27/06/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import Foundation

struct Detail: Codable {
    
    var Detail_ID: Int
    var Detail_TimeOffID: Int
    var Detail_Title: String
    var Detail_Type: Int
    var Detail_Comment: String?
    var Detail_CreateDate: String
    var Detail_TimeOffDate: String
    var Detail_FromDate: String
    var Detail_ToDate: String

}
