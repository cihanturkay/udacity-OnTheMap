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
        if(isEmailAndPasswordPresented()){
            setUIEnabled(enabled: false)
            UdacityClient.sharedInstance().postSession(userName: emailField.text!, password: passwordField.text!) { (session, error) in
                if let error = error {
                    print(error)
                } else if let session = session {
                    print(session)
                }
                self.setUIEnabled(enabled: true)
            }
        } else {
            print("email or/and password are empty")
        }
    }
    
    @IBAction func signup(_ sender: Any) {
        
    }
    
    private func isEmailAndPasswordPresented() -> Bool {
        if let email = emailField.text, email.count > 3, let password = passwordField.text, password.count > 3 {
            return true
        } else {
            return false
        }
    }
    
    private func setUIEnabled(enabled:Bool){
        DispatchQueue.main.async {
            if(enabled) {
                self.activityIndicator.stopAnimating()
                self.loginButton.alpha = 1
            } else {
                self.activityIndicator.startAnimating()
                self.loginButton.alpha = 0
            }
            self.loginButton.isEnabled = enabled
            self.signUpButton.isEnabled = enabled
            self.emailField.isEnabled = enabled
            self.passwordField.isEnabled = enabled
        }
    }
    
}

