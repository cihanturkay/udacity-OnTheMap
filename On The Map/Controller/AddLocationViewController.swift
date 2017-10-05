//
//  AddLocationController.swift
//  On The Map
//
//  Created by Cihan Turkay on 05.10.17.
//  Copyright © 2017 Cihan Turkay. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    //This has a seperated storyboard to be able to seperate storyboards and keep it clean.
    //I think using seperated storyboards for different flows is better approach espceially when working in team regarding version control issues.
    //Please correct me if I am wrong.
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var webSiteField: UITextField!
    @IBOutlet weak var activityIndicator: CustomActivityIndicator!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var findLocation: StyledButton!
    
    var studentLocation:StudentLocation?
    
    @IBAction func dismis(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        
        guard let address = locationField.text, address.count > 0 else {
            let userInfo = [NSLocalizedDescriptionKey:"Please enter a location"]
            showError(NSError(domain: "addLocation", code: BaseClient.ERROR_SPECIFIC, userInfo: userInfo))
            return
        }
        
        guard let website = webSiteField.text, website.count > 0 else {
            let userInfo = [NSLocalizedDescriptionKey:"Please enter a website"]
            showError(NSError(domain: "addLocation", code: BaseClient.ERROR_SPECIFIC, userInfo: userInfo))
            return
        }
        
        if(isValidWebsite(website)){
            getLocationFromText(address, website)
        } else {
            let userInfo = [NSLocalizedDescriptionKey:"Please enter a valid website"]
            showError(NSError(domain: "addLocation", code: BaseClient.ERROR_SPECIFIC, userInfo: userInfo))
        }
    }
    
    private func isValidWebsite(_ website:String) -> Bool{
        if let url = URL(string: website) {
            if UIApplication.shared.canOpenURL(url) {
                return true
            }
        }
        return false
    }
    
    private func getLocationFromText(_ address:String, _ mediaUrl:String) {
        showProgress()
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                print("location found \(location)")
                //location found start confirmation controller
                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmLocationViewController") as? ConfirmLocationViewController {
                    controller.coordinate = location.coordinate
                    controller.mapString = address
                    controller.mediaUrl = mediaUrl
                    controller.studentLocation = self.studentLocation
                    self.navigationController?.pushViewController(controller, animated: true)
                }
                self.hideProgress()
            } else {
                self.hideProgress()
                let alert = UIAlertController(title: "Error", message: "Couldn't find a location for \(address)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
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
        errorMessage.alpha = 1
    }
    
    func hideError(){
        errorMessage.alpha = 0
    }
    
    func showProgress(){
        hideError()
        activityIndicator.startAnimating()
        setUIEnabled(enabled: false)
    }
    
    func hideProgress(){
        activityIndicator.stopAnimating()
        setUIEnabled(enabled: true)
    }
    
    
    private func setUIEnabled(enabled:Bool){
        if(enabled) {
            self.activityIndicator.stopAnimating()
            self.findLocation.alpha = 1
        } else {
            self.activityIndicator.startAnimating()
            self.findLocation.alpha = 0
        }
        self.findLocation.isEnabled = enabled
        self.webSiteField.isEnabled = enabled
        self.locationField.isEnabled = enabled
    }
    
    
    
}
