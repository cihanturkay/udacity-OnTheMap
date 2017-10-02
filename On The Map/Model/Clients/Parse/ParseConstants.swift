//
//  ParseConstants.swift
//  On The Map
//
//  Created by Cihan Turkay on 29.09.17.
//  Copyright © 2017 Cihan Turkay. All rights reserved.
//

extension ParseClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Key
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
    }
    
    // MARK: Headers
    struct HeaderKeys {
        static let ApplicationID = "X-Parse-Application-Id"
        static let APIKey = "X-Parse-REST-API-Key"
    }
    
    // MARK: Methods
    struct Methods {
    
        // MARK: Student Locations
        static let StudentLocation = "/StudentLocation"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let ObjectId = "objectId"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        static let Where = "where"
    }
    
    // MARK: StudentLocation
    struct StudentLocationKeys {
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaUrl = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
    }
    
    
    struct ResponseKeys {
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        //MARK: Data
        static let Result = "results"
    }
   
    
    
}
