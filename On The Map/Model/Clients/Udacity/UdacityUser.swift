//
//  UdacityUser.swift
//  On The Map
//
//  Created by Cihan Turkay on 05.10.17.
//  Copyright © 2017 Cihan Turkay. All rights reserved.
//

struct UdacityUser {
    
    var firstName: String?
    var lastName: String?
    
    init(dictionary: [String:AnyObject]) {
        firstName = dictionary[UdacityClient.User.firstName] as? String
        lastName = dictionary[UdacityClient.User.lastName] as? String
    }
    
}
