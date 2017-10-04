//
//  UdacityClient.swift
//  On The Map
//
//  Created by Cihan Turkay on 02.10.17.
//  Copyright © 2017 Cihan Turkay. All rights reserved.
//

import Foundation

class UdacityClient: BaseClient {
    
    static let SESSION_URL = "https://www.udacity.com/api/session"
    
    var udacitySession:UdacitySession?
    
    override init() {
        super.init()
    }
    
    func postSession(userName:String, password:String, completionHandler: @escaping (_ session: UdacitySession?, _ error: NSError?) -> Void) {
        let request = NSMutableURLRequest(url: url(withPathExtension: Methods.Session))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        let _ = runRequest(request as URLRequest, ClientType.UDACITY) { (results, error) in
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            } else {
                if let parsedSession = results?[UdacityClient.ResponseKeys.Session] as? [String:AnyObject] {
                    self.udacitySession = UdacitySession.init(dictionary: parsedSession)
                    DispatchQueue.main.async {
                        completionHandler(self.udacitySession,nil)
                    }
                } else {
                    let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrieve session for the user: '\(userName)'"]
                    DispatchQueue.main.async {
                        completionHandler(nil, NSError(domain: "getSession", code: 1, userInfo: userInfo))
                    }
                }
            }
        }
    }
    
    
    func url(withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (withPathExtension ?? "")
        return components.url!
    }
    
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}

