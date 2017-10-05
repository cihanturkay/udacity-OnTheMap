//
//  BaseClient.swift
//  On The Map
//
//  Created by Cihan Turkay on 02.10.17.
//  Copyright © 2017 Cihan Turkay. All rights reserved.
//

import Foundation

class BaseClient: NSObject {
    
    static let ERROR_GENERAL:Int = 1// Mostly :: Failed to connect server due to unknown error
    static let ERROR_SPECIFIC:Int = 0 // This will be shown to user
    
    enum ClientType {
        case UDACITY
        case PARSE
    }
    
    var session = URLSession.shared
    
    override init() {
        super.init()
    }
    
    func runRequest(_ request: URLRequest, _ type: ClientType, completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        /* Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String,_ code:Int) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: code, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError(error!.localizedDescription, BaseClient.ERROR_SPECIFIC)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!", BaseClient.ERROR_GENERAL)
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!", BaseClient.ERROR_GENERAL)
                return
            }
            
            self.convertDataWithCompletionHandler(data, type, completionHandlerForConvertData: completionHandler)
        }
        
        task.resume()
        
        return task
    }
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // given raw JSON, return a usable Foundation object
    func convertDataWithCompletionHandler(_ data: Data, _ type:ClientType, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        var data = data
        do {
            if type == ClientType.UDACITY{
                let range = Range(5..<data.count)
                data = data.subdata(in: range)
            }
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: BaseClient.ERROR_GENERAL, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
}
