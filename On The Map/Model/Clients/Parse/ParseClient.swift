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
                        completionHandler(nil, NSError(domain: "getStudentLocations parsing", code: BaseClient.ERROR_GENERAL, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                    }
                }
            }
        }
    }
    
    
    func getStudentLocation(_uniqueKey:String, _ completionHandler: @escaping (_ studentLocations: StudentLocation?, _ error: NSError?) -> Void) {
        
        var parameters = [String:AnyObject]()

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
                            completionHandler(nil, nil)
                        }
                    }
                } else {
                    print("Couldn't parse locations")
                    DispatchQueue.main.async {
                        completionHandler(nil, NSError(domain: "getStudentLocation parsing", code: BaseClient.ERROR_GENERAL, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocation"]))
                    }
                }
            }
        }
    }
    
    
    func postStudentLocation(mapString:String, url:String, long:Double, lat:Double, completionHandler: @escaping (_ error: NSError?) -> Void) {
        let parameters = [String:AnyObject]()
        let request = authenticateRequest(NSMutableURLRequest(url: urlFromParameters(parameters, withPathExtension: Methods.StudentLocation)))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let firstName = UdacityClient.sharedInstance().currentUser?.firstName ?? ""
        let lastName = UdacityClient.sharedInstance().currentUser?.lastName ?? ""
        let uniqueKey = UdacityClient.sharedInstance().udacityAccount?.key ?? ""
        let body = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(url)\", \"latitude\": \(lat), \"longitude\": \(long)}".data(using: String.Encoding.utf8)
        request.httpBody = body
        
        let _ = runRequest(request as URLRequest, ClientType.PARSE) { (results, error) in
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    completionHandler(error)
                }
            } else {
                DispatchQueue.main.async {
                     completionHandler(nil)
                }
            }
        }
    }
    
    func updateStudentLocation(objectID:String,mapString:String, url:String, long:Double, lat:Double, completionHandler: @escaping (_ error: NSError?) -> Void) {
        let parameters = [String:AnyObject]()
        let request = authenticateRequest(NSMutableURLRequest(url: urlFromParameters(parameters, withPathExtension: Methods.StudentLocation + "/\(objectID)")))
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let firstName = UdacityClient.sharedInstance().currentUser?.firstName ?? ""
        let lastName = UdacityClient.sharedInstance().currentUser?.lastName ?? ""
        let uniqueKey = UdacityClient.sharedInstance().udacityAccount?.key ?? ""
        let body = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(url)\", \"latitude\": \(lat), \"longitude\": \(long)}".data(using: String.Encoding.utf8)
        request.httpBody = body
        
        let _ = runRequest(request as URLRequest, ClientType.PARSE) { (results, error) in
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    completionHandler(error)
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(nil)
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
