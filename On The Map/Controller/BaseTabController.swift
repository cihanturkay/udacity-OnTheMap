//
//  BaseTabController.swift
//  On The Map
//
//  Created by Cihan Turkay on 04.10.17.
//  Copyright © 2017 Cihan Turkay. All rights reserved.
//

import UIKit


class BaseTabController: UIViewController {
    
    @IBOutlet weak var errorMessage: UILabel!

    var studentLocations:[StudentLocation] = []
    var activityIndicator: CustomActivityIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = CustomActivityIndicator(image: #imageLiteral(resourceName: "loading"))
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        parent!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        let rightButtonItmes:[UIBarButtonItem] = [UIBarButtonItem(image: #imageLiteral(resourceName: "icon_addpin"), style: .plain, target: self, action: #selector(addPin)),
                                                  UIBarButtonItem(image: #imageLiteral(resourceName: "icon_refresh"), style: .plain, target: self, action: #selector(refresh))]
        parent!.navigationItem.rightBarButtonItems = rightButtonItmes
         loadLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func logout(){
        print("logout")
    }
    
    @objc func addPin(){
        print("addPin")
    }
    
    @objc func refresh(){
        loadLocations()
    }
    
    func hideError(){
        errorMessage.isHidden = true
    }
    
    func loadLocations(){
        showProgress()
        hideError()
        ParseClient.sharedInstance().getStudentLocations { ( studentLocations , error) in
            if let error = error {
                print(error)
                self.showError(error)
            } else if let locations = studentLocations {
                //print(locations)
                self.onStudentLocationsLoaded(locations)
            }
            self.hideProgress()
        }
    }
    
    private func showError(_ error:NSError){
        var errorText:String?
        if(error.code == 0){
            errorText = error.localizedDescription
        }else {
            errorText = "Couldn't load data. Try again."
        }
        print("error \(String(describing: errorText))")
        errorMessage.text = errorText
        errorMessage.isHidden = false
    }
    
    func onStudentLocationsLoaded(_ locations:[StudentLocation]){
        self.studentLocations = locations
    }
    
    func showProgress(){
        activityIndicator.startAnimating()
    }
    
    func hideProgress(){
        activityIndicator.stopAnimating()
    }
    
    
    
    
}
