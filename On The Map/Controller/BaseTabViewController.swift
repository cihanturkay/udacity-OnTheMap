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
    @IBOutlet weak var activityIndicator: CustomActivityIndicator!
    @IBOutlet weak var overlay: UIView!
    
    var locationBarController: LocationTabBarController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationBarController = tabBarController as! LocationTabBarController
        
        parent?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(logout))
        let rightButtonItmes:[UIBarButtonItem] = [UIBarButtonItem(image: #imageLiteral(resourceName: "icon_addpin"), style: .plain, target: self, action: #selector(addPin)),
                                                  UIBarButtonItem(image: #imageLiteral(resourceName: "icon_refresh"), style: .plain, target: self, action: #selector(refresh))]
        parent?.navigationItem.rightBarButtonItems = rightButtonItmes
        parent?.navigationController?.view.backgroundColor = UIColor.white
        
        if self.locationBarController.studentLocations.count == 0 {
            loadLocations()
        }        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func logout(){
        showProgress()
        UdacityClient.sharedInstance().deleteSession { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else if let error = error {
                self.showError(error)
            }
            self.hideProgress()
        }      
    }
    
    @objc func addPin(){
        showProgress()
        if let key = UdacityClient.sharedInstance().udacityAccount?.key {
            ParseClient.sharedInstance().getStudentLocation(_uniqueKey: key) { (location, error) in
                if let error = error {
                    print(error)
                    self.showError(error)
                } else if let location = location {
                    //user wants to override location
                    let alert = UIAlertController(title: "", message: "You have already posted a student location. Would you like to overwrite it ?", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default, handler: { (action) in
                        self.getUser(location: location)
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
                        self.hideProgress()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    print(location)
                } else {
                    //haven't set the location for this user
                    self.getUser(location: nil)
                }
                
            }
        } else {
            let userInfo = [NSLocalizedDescriptionKey:"Cannot get data. Please logout and try again"]
            showError(NSError(domain: "addpin", code: BaseClient.ERROR_SPECIFIC, userInfo: userInfo))
        }
    }
    
    private func getUser(location:StudentLocation?){
        UdacityClient.sharedInstance().getUser { (user, error) in
            if let error = error{
                self.showError(error)
            } else {
                self.openAddPinController(location: location)
            }
            self.hideProgress()
        }
    }
    
    private func openAddPinController(location:StudentLocation?){
        let storyboard = UIStoryboard(name: "AddPin", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "AddLocationController") as? UINavigationController {
            let rootViewController = controller.viewControllers.first as! AddLocationViewController
            rootViewController.studentLocation = location
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func refresh(){
        loadLocations()
    }
    
    func openURL(mediaUrl:String?) {
        if let mediaUrl = mediaUrl, let url = URL(string: mediaUrl) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func loadLocations(){
        showProgress()
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
    
    func onStudentLocationsLoaded(_ locations:[StudentLocation]){
        self.locationBarController.studentLocations = locations
    }
    
    private func showError(_ error:NSError){
        var errorText:String?
        if(error.code == BaseClient.ERROR_SPECIFIC){
            errorText = error.localizedDescription
        } else {
            errorText = "Couldn't load data. Try again."
        }
        print("error \(String(describing: errorText))")
        errorMessage.text = errorText
        errorMessage.isHidden = false
    }
    
    func hideError(){
        errorMessage.isHidden = true
    }
    
    func showProgress(){
        hideError()
        activityIndicator.startAnimating()
        setUIEnabled(false)
    }
    
    func hideProgress(){
        activityIndicator.stopAnimating()
        setUIEnabled(true)
    }
    
    
    func setUIEnabled(_ enabled:Bool){
        overlay.isHidden = enabled
        parent!.navigationItem.leftBarButtonItem?.isEnabled = enabled
        if let buttons = parent!.navigationItem.rightBarButtonItems{
            for rightButton in buttons  {
                rightButton.isEnabled = enabled
            }
        }
    }
    
    
    
}
