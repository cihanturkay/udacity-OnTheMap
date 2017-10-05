//
//  UdacityAccount.swift
//  On The Map
//
//  Created by Cihan Turkay on 05.10.17.
//  Copyright © 2017 Cihan Turkay. All rights reserved.
//

struct UdacityAccount {
    
    var registered:Bool
    var key:String
    
    
    init(dictionary: [String:AnyObject]) {
        registered = dictionary[UdacityClient.Account.registered] as! Bool
        key = dictionary[UdacityClient.Account.key] as! String
    }
}
