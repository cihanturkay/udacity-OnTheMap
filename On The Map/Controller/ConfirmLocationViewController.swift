//
//  ConfirmLocationViewController.swift
//  On The Map
//
//  Created by Cihan Turkay on 05.10.17.
//  Copyright © 2017 Cihan Turkay. All rights reserved.
//
import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var activityIndicator: CustomActivityIndicator!
    @IBOutlet weak var errorMessage: UILabel!
    
    var coordinate:CLLocationCoordinate2D?
    let annotationIdentifier = "annotationIdentifier"
    var mediaUrl:String?
    var mapString:String?
    var studentLocation:StudentLocation?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let coordinate = coordinate, let mediaUrl = mediaUrl {
            var region = MKCoordinateRegion()
            region.center = coordinate
            region.span.longitudeDelta = 0.003
            region.span.latitudeDelta = 0.003
            mapView.setRegion(region, animated: true)
            
            let annotaion = MKPointAnnotation()
            annotaion.coordinate = coordinate
            let name = [UdacityClient.sharedInstance().currentUser?.firstName, UdacityClient.sharedInstance().currentUser?.lastName].flatMap{$0}.joined(separator: " ")
            annotaion.title = name
            annotaion.subtitle = mediaUrl
            mapView.addAnnotation(annotaion)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            view.canShowCallout = true
        }
        return view
    }
    
    @IBAction func finish(_ sender: Any) {
        setUIEnabled(enabled: false)
        if let mapString = mapString, let mediaUrl = mediaUrl, let lat = coordinate?.latitude, let long = coordinate?.longitude {
            if let location = studentLocation {
                //update
                ParseClient.sharedInstance().updateStudentLocation(objectID: location.objectID , mapString:mapString, url: mediaUrl, long: long, lat: lat, completionHandler: { (error) in
                    if let error = error {
                        self.showError(error)
                    }else {
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    }
                })
            } else {
                //create
                ParseClient.sharedInstance().postStudentLocation(mapString: mapString, url: mediaUrl, long: long, lat: lat, completionHandler: { (error) in
                    if let error = error {
                        self.showError(error)
                    }else {
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    func showError(_ error:NSError){
        var errorText:String?
        if (error.code == BaseClient.ERROR_GENERAL) {
            errorText = "Failed to update location. Try again"
        } else {
            errorText = error.localizedDescription
        }
        errorMessage.text = errorText
        errorMessage.alpha = 1
    }
    
    func hideError(){
        errorMessage.alpha = 0
    }
    
    private func setUIEnabled(enabled:Bool){
        if(enabled) {
            self.activityIndicator.stopAnimating()
        } else {
            self.activityIndicator.startAnimating()
        }
        overlay.isHidden = enabled
    }
    
}
