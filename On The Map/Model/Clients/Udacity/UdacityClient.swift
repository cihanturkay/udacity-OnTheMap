//
//  UdacityClient.swift
//  On The Map
//
//  Created by Cihan Turkay on 02.10.17.
//  Copyright © 2017 Cihan Turkay. All rights reserved.
//
import Foundation

class UdacityClient: BaseClient {

    var udacitySession: UdacitySession?
    var udacityAccount: UdacityAccount?
    var currentUser: UdacityUser?
    
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
                if let parsedSession = results?[UdacityClient.ResponseKeys.Session] as? [String:AnyObject], let parsedAccount =  results?[UdacityClient.ResponseKeys.Account] as? [String:AnyObject] {
                    self.udacitySession = UdacitySession.init(dictionary: parsedSession)
                    self.udacityAccount = UdacityAccount.init(dictionary: parsedAccount)
                    DispatchQueue.main.async {
                        completionHandler(self.udacitySession,nil)
                    }
                } else {
                    let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrieve session for the user: '\(userName)'"]
                    DispatchQueue.main.async {
                        completionHandler(nil, NSError(domain: "getSession", code: BaseClient.ERROR_GENERAL, userInfo: userInfo))
                    }
                }
            }
        }
    }
    
    func deleteSession(completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        let request = NSMutableURLRequest(url: url(withPathExtension: Methods.Session))
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let _ = runRequest(request as URLRequest, ClientType.UDACITY) { (results, error) in
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    completionHandler(false, error)
                }
            } else {
                if let result = results?[UdacityClient.ResponseKeys.Session] as? [String:AnyObject] {
                    //when it is succeeded remove credentials
                    self.udacityAccount = nil
                    self.udacitySession = nil
                    self.currentUser = nil
                    print(result)
                    DispatchQueue.main.async {
                        completionHandler(true ,nil)
                    }
                } else {
                    let userInfo = [NSLocalizedDescriptionKey : "Couldn't logout"]
                    DispatchQueue.main.async {
                    completionHandler(false, NSError(domain: "getUser", code: BaseClient.ERROR_SPECIFIC, userInfo: userInfo))
                    }
                }
            }
        }
    }
    
    func getUser(completionHandler: @escaping (_ user: UdacityUser?, _ error: NSError?) -> Void){
        guard let userId = udacityAccount?.key else {
            let userInfo = [NSLocalizedDescriptionKey : "Please logout and try again."]
            completionHandler(nil, NSError(domain: "getUser", code: BaseClient.ERROR_SPECIFIC, userInfo: userInfo))
            return
        }
        
        let method = substituteKeyInMethod(Methods.Users, key: URLKeys.userId, value: userId)
        let request = NSMutableURLRequest(url: url(withPathExtension: method))
        
        let _ = runRequest(request as URLRequest, ClientType.UDACITY) { (results, error) in
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            } else {
                if let parsedData = results?[UdacityClient.ResponseKeys.User] as? [String:AnyObject] {
                    self.currentUser = UdacityUser.init(dictionary: parsedData)
                    DispatchQueue.main.async {
                        completionHandler(self.currentUser,nil)
                    }
                } else {
                    let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrieve user"]
                    DispatchQueue.main.async {
                        completionHandler(nil, NSError(domain: "getUser", code: BaseClient.ERROR_GENERAL, userInfo: userInfo))
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

