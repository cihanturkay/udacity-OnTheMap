//
//  ViewController.swift
//  On The Map
//
//  Created by Cihan Turkay on 29.09.17.
//  Copyright © 2017 Cihan Turkay. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: CustomActivityIndicator!
    @IBOutlet weak var loginButton: StyledButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ParseClient.sharedInstance().getStudentLocations { ( studentLocations , error) in
            if let error = error {
                print(error)
            } else if let locations = studentLocations {
                //print(locations)
                if let key = locations[0].uniqueKey {
                    ParseClient.sharedInstance().getStudentLocation(_uniqueKey: key, { (location, error) in
                        if let location = location {
                            print(location)
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func login(_ sender: Any) {
        setUIEnabled(enabled: false)
        UdacityClient.sharedInstance().postSession(userName: emailField.text!, password: passwordField.text!) { (session, error) in
            if let error = error {
                print(error)
            } else if let session = session {
                print(session)
            }
        }
    }
    
    @IBAction func signup(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setUIEnabled(enabled:Bool){
        if(enabled) {
            activityIndicator.stopAnimating()
            loginButton.alpha = 1
        } else {
            activityIndicator.startAnimating()
            loginButton.alpha = 0
        }
        loginButton.isEnabled = enabled
        signUpButton.isEnabled = enabled
        emailField.isEnabled = enabled
        passwordField.isEnabled = enabled
    }
    
}

