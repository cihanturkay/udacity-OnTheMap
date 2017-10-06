//
//  StudentLocationsModel.swift
//  On The Map
//
//  Created by Cihan Turkay on 06.10.17.
//  Copyright © 2017 Cihan Turkay. All rights reserved.
//

import Foundation

class StudentLocationsModel {
    
    static let sharedInstance = StudentLocationsModel()
    
    let studentNotification = NSNotification(name: Notification.Name("StudentNotification"), object: nil)
    var studentLocations:[StudentLocation] = [] {
        didSet{
            NotificationCenter.default.post(name: Notification.Name("StudentNotification"), object: nil)
        }
    }
    
}


