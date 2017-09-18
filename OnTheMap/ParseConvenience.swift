//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Ramon Gomez on 9/15/17.
//  Copyright © 2017 Ramon's. All rights reserved.
//

import UIKit
import Foundation
import MapKit

extension ParseClient {

    func getLocationFromParse(_ completionHandler: @escaping (_ results: [StudentInformation]?, _ error: String?) -> Void) {
        
        let parameters: [String: AnyObject] = [
            Constants.ParameterKeys.Limit: 200 as AnyObject,
            Constants.ParameterKeys.Skip: 400 as AnyObject,
            Constants.ParameterKeys.Order: "-updateAT" as AnyObject
        ]
        
        let _ = taskForGetMethod(Constants.Methods.StudentLocation, parameters: parameters) { (jsonData, error) in
            
            if let error = error {
                completionHandler(nil, error.localizedDescription)
            }
            
            if let locations = jsonData?[Constants.JSONResponseKeys.Locations] as? [[String: AnyObject]] {
                StudentData.sharedInstance().StudentArray = StudentData.studentsFromResults(locations)
                
                completionHandler(StudentData.sharedInstance().StudentArray, nil)
            } else {
                completionHandler(nil, error?.localizedDescription)
            }
        }
    }
    
    func postNewLocation(userId: String, firstName: String, lastName: String, mediaUrl: String, mapString: String,
                         _ completionHandler: @escaping (_ success: Bool, _ error: String)  -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(mapString) { (placemarks, error) -> Void in
            
            if let placemark = placemarks?.first {
                
                let coordinate: CLLocationCoordinate2D = (placemark.location?.coordinate)!
                let lat = coordinate.latitude
                let long = coordinate.longitude
                
                let json: [String: AnyObject] = [
                
                    Constants.JSONBodyKeys.UniqueKey: userId as AnyObject,
                    Constants.JSONBodyKeys.FirstName: firstName as AnyObject,
                    Constants.JSONBodyKeys.LastName: lastName as AnyObject,
                    Constants.JSONBodyKeys.Latitude: lat as AnyObject,
                    Constants.JSONBodyKeys.Longitude: long as AnyObject,
                    Constants.JSONBodyKeys.MediaURL: mediaUrl as AnyObject,
                    Constants.JSONBodyKeys.MapString: mapString as AnyObject
                ]
                
                let _ = self.taskForPostMethod(Constants.Methods.StudentLocation, jsonObject: json, completionHandlerForPost: { (result, error) in
                    
                    if let error = error {
                        completionHandler(false, error.localizedDescription)
                    }
                    
                    guard let createdAt = result?[Constants.JSONResponseKeys.CreatedAt] as? String else {
                        print("Could not find key: '\(Constants.JSONResponseKeys.CreatedAt)' in \(result!)")
                        return
                    }
                    
                    guard let objectID = result?[Constants.JSONResponseKeys.objectID] as? String else {
                        print("Could not find key: '\(Constants.JSONResponseKeys.objectID)' in \(result!)")
                        return
                    }
                    
                    // TODO: Identify where to store user info
                    
                    print("ObjectID: \(objectID)")
                    completionHandler(true, "Success! for the Post Method.")
                })
            }
        }
    }
}