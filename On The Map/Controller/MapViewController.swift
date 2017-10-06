//
//  ViewController.swift
//  On The Map
//
//  Created by Cihan Turkay on 29.09.17.
//  Copyright © 2017 Cihan Turkay. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseTabController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let annotationIdentifier = "annotationIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self        
    }
    
    override func onStudentLocationsLoaded() {
        DispatchQueue.main.async {
            if(self.mapView != nil){
                //remove old pins
                self.mapView.removeAnnotations(self.mapView.annotations)
                //add new pins
                self.mapView.addAnnotations(StudentLocationsModel.sharedInstance.studentLocations)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? StudentLocation {
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                view.canShowCallout = true
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(calloutTapped))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func calloutTapped(sender:UITapGestureRecognizer) {
        guard let annotation = (sender.view as? MKAnnotationView)?.annotation as? StudentLocation else { return }
        openURL(mediaUrl: annotation.mediaUrl)
    }
}
