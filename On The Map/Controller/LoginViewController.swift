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
    
    @IBAction func login(_ sender: Any) {
        if(isEmailAndPasswordPresented()){
            setUIEnabled(enabled: false)
            UdacityClient.sharedInstance().postSession(userName: emailField.text!, password: passwordField.text!) { (session, error) in
                if let error = error {
                    print(error)
                    self.showError(error)
                } else if let session = session {
                    print(session)
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "LocationNavigationController") as! UINavigationController
                    self.present(controller, animated: true, completion: nil)
                }
                self.setUIEnabled(enabled: true)
            }
        } else {
            print("email or/and password are empty")
            let userInfo = [NSLocalizedDescriptionKey:"Email and Password cannot be empty"]
            showError(NSError(domain: "login", code: 2, userInfo: userInfo))
        }
    }
    
    func showError(_ error:NSError){
        var errorText:String = ""
        if (error.code == BaseClient.ERROR_GENERAL) {
             errorText = "Wrong email or password"
        } else {
             errorText = error.localizedDescription
        }
        alert(message: errorText)
        setUIEnabled(enabled: true)
    }
    
    @IBAction func signup(_ sender: Any) {
        if let url = URL(string: "https://auth.udacity.com/sign-up") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func isEmailAndPasswordPresented() -> Bool {
        if let email = emailField.text, email.count > 0, let password = passwordField.text, password.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    private func setUIEnabled(enabled:Bool){
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

extension UIViewController {
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

