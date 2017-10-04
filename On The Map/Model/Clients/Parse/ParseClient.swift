//
//  ParseClient.swift
//  On The Map
//
//  Created by Cihan Turkay on 29.09.17.
//  Copyright © 2017 Cihan Turkay. All rights reserved.
//

import Foundation


class ParseClient: BaseClient {
    
    override init() {
        super.init()
    }
    
    
    // MARK: GET STUDENT LOCATIONS
    
    func getStudentLocations(_ completionHandler: @escaping (_ studentLocations: [StudentLocation]?, _ error: NSError?) -> Void) {
        
        var parameters = [String:AnyObject]()
        //predefined specifications
        parameters[ParseClient.ParameterKeys.Limit] = 100 as AnyObject
        parameters[ParseClient.ParameterKeys.Order] = "-updatedAt" as AnyObject
        
        let request = authenticateRequest(NSMutableURLRequest(url: urlFromParameters(parameters, withPathExtension: Methods.StudentLocation)))
        
        let _ = runRequest(request as URLRequest, ClientType.PARSE) { (results, error) in
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            } else {
                if let result = results?[ParseClient.ResponseKeys.Result] as? [[String:AnyObject]] {
                    let locations = StudentLocation.locationsFromResult(result)
                    DispatchQueue.main.async {
                        completionHandler(locations, nil)
                    }
                } else {
                    print("Couldn't parse locations")
                    DispatchQueue.main.async {
                        completionHandler(nil, NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                    }
                }
            }
        }
    }
    
    
    func getStudentLocation(_uniqueKey:String, _ completionHandler: @escaping (_ studentLocations: StudentLocation?, _ error: NSError?) -> Void) {
        
        var parameters = [String:AnyObject]()
        //predefined specifications
        parameters[ParseClient.ParameterKeys.Where] = "{\"uniqueKey\":\"\(_uniqueKey)\"}" as AnyObject
        let request = authenticateRequest(NSMutableURLRequest(url: urlFromParameters(parameters, withPathExtension: Methods.StudentLocation)))
        
        let _ = runRequest(request as URLRequest, ClientType.PARSE) { (results, error) in
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            } else {
                if let result = results?[ParseClient.ResponseKeys.Result] as? [[String:AnyObject]] {
                    let locations = StudentLocation.locationsFromResult(result)
                    DispatchQueue.main.async {
                        if(locations.count > 0) {
                            completionHandler(locations[0], nil)
                        } else {
                            completionHandler(nil, NSError(domain: "getStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not get getStudentLocation"]))
                        }
                    }
                } else {
                    print("Couldn't parse locations")
                    DispatchQueue.main.async {
                        completionHandler(nil, NSError(domain: "getStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocation"]))
                    }
                }
            }
        }
    }
    
    //MARK: HELPERS
    
    private func authenticateRequest(_ request:NSMutableURLRequest) -> NSMutableURLRequest {
        request.addValue(Constants.AppID, forHTTPHeaderField: HeaderKeys.ApplicationID)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: HeaderKeys.APIKey)
        return request
    }
    
    // create a URL from parameters
    func urlFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
