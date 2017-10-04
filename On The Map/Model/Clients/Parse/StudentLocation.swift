//
//  StudentLocation.swift
//  On The Map
//
//  Created by Cihan Turkay on 02.10.17.
//  Copyright © 2017 Cihan Turkay. All rights reserved.
//
import Foundation
import MapKit

class StudentLocation: NSObject, MKAnnotation {
    
    var objectID:String
    var uniqueKey:String?
    var firstName:String?
    var lastName:String?
    var mapString:String?
    var mediaUrl:String?
    var latitude:Double?
    var longitude:Double?
    var createdAt:String?
    var updatedAt:String?
    var mapLocation:CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    init(dictionary: [String:AnyObject]) {
        objectID = dictionary[ParseClient.StudentLocationKeys.ObjectID] as! String
        uniqueKey = dictionary[ParseClient.StudentLocationKeys.UniqueKey] as? String
        firstName = dictionary[ParseClient.StudentLocationKeys.FirstName] as? String
        lastName = dictionary[ParseClient.StudentLocationKeys.LastName] as? String
        mapString = dictionary[ParseClient.StudentLocationKeys.MapString] as? String
        mediaUrl = dictionary[ParseClient.StudentLocationKeys.MediaUrl] as? String
        latitude = dictionary[ParseClient.StudentLocationKeys.Latitude] as? Double
        longitude = dictionary[ParseClient.StudentLocationKeys.Longitude] as? Double
        createdAt = dictionary[ParseClient.StudentLocationKeys.CreatedAt] as? String
        updatedAt = dictionary[ParseClient.StudentLocationKeys.UpdatedAt] as? String
        if let lat = self.latitude, let long = self.longitude{
            mapLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
    }
    
    static func locationsFromResult(_ results: [[String:AnyObject]]) -> [StudentLocation] {
        
        var locations = [StudentLocation]()
        
        for result in results {
            locations.append(StudentLocation(dictionary: result))
        }
        
        return locations
    }
    
    var coordinate: CLLocationCoordinate2D {
        return mapLocation
    }
    
    
    
}

