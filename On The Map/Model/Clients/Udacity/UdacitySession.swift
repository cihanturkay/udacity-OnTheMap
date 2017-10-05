//
//  UdacitySession.swift
//  On The Map
//
//  Created by Cihan Turkay on 02.10.17.
//  Copyright © 2017 Cihan Turkay. All rights reserved.
//

struct UdacitySession {
    
    var id:String
    var expiration:String
    
    
    init(dictionary: [String:AnyObject]) {
        id = dictionary[UdacityClient.Session.id] as! String
        expiration = dictionary[UdacityClient.Session.expiration] as! String
    }
}
