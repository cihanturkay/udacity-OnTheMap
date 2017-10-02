//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Cihan Turkay on 02.10.17.
//  Copyright © 2017 Cihan Turkay. All rights reserved.
//

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    // MARK: Methods
    struct Methods {
        //post-delete session
        static let Session = "/session"
        //GET public user data
        static let Users = "/users/{id}"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let userId = "id"
    }
    
    // MARK: StudentLocation
    struct Session {
        static let id = "id"
        static let expiration = "expiration"
    }
    
    struct Account {
        static let registered = "registered"
        static let key = "key"
    }
    
    struct ResponseKeys {
        static let Session = "session"
        static let Account = "account"
    }
}

