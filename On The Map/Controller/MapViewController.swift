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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.addAnnotations(studentLocations)
    }

    override func onStudentLocationsLoaded(_ locations: [StudentLocation]) {
        mapView.removeAnnotations(studentLocations)
        super.onStudentLocationsLoaded(locations)
        mapView.addAnnotations(studentLocations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? StudentLocation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
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
