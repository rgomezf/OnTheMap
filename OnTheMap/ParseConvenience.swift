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
            Constants.ParameterKeys.Limit: 100 as AnyObject,
            Constants.ParameterKeys.Order: "-updatedAt" as AnyObject
        ]
        
        let _ = taskForParseGetMethod(Constants.Methods.StudentLocation, parameters: parameters) { (jsonData, error) in
            
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
                
                let _ = self.taskForParsePostMethod(Constants.Methods.StudentLocation, jsonObject: json, completionHandlerForPost: { (jsonData, error) in
                    
                    if let error = error {
                        completionHandler(false, error.localizedDescription)
                    } else {
                        
                        guard let _ = jsonData?[Constants.JSONResponseKeys.CreatedAt] as? String else {
                            print("Could not find key: '\(Constants.JSONResponseKeys.CreatedAt)' in \(jsonData!)")
                            return
                        }
                        
                        guard let objectId = jsonData?[Constants.JSONResponseKeys.ObjectID] as? String else {
                            print("Could not find key: '\(Constants.JSONResponseKeys.ObjectID)' in \(jsonData!)")
                            return
                        }
                        
                        // Store user info
                        userInfo.objectId = objectId
                        print("ObjectId: \(userInfo.objectId!)")
                        completionHandler(true, "Success! for the Post Method.")
                    }
                })
            }
        }
    }
    func getParseOjectId(uniqueKey: String, _ completionHandler: @escaping(_ success: Bool, _ errorString: String?) -> Void) {
        
        let parameters: [String: AnyObject] = [
            "order": "-createdAt" as AnyObject,
            "where": "{\"\(Constants.JSONBodyKeys.UniqueKey)\":\"\(userInfo.uniqueKey!)\"}" as AnyObject
        ]
        let _ = getStudentLocationsFromParse(Constants.Methods.StudentLocation, parameters: parameters) { (jsonData, error) in
            
            if let error = error {
                
                completionHandler(false,"Could not get ObjectId, \(error)")
            } else {
                
                guard let results = jsonData?["results"] as? [[String: AnyObject]] else {
                    print("could not find results in \(jsonData!)")
                    return
                }
                
                let studentLocation = results[results.count-1]
                print("Location: \(studentLocation)")
                
                guard let objectId = studentLocation[Constants.JSONResponseKeys.ObjectID] as? String else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.ObjectID)' in \(studentLocation)")
                    completionHandler(false, "No ObjectId was found.")
                    return
                }
                userInfo.objectId = objectId
                print("ObjectId was found: \(userInfo.objectId!)")
                completionHandler(true, nil)
            }
        }
    }
    func updateCurrentLocation( objectId: String, firstName: String, lastName: String, mediaURL: String, mapString: String,
                                _ completionHandler: @escaping (_ succes: Bool, _ error: String?) -> Void) {
        
        let json: [String: AnyObject] = [
            Constants.JSONBodyKeys.ObjectId: objectId as AnyObject,
            Constants.JSONBodyKeys.FirstName: firstName as AnyObject,
            Constants.JSONBodyKeys.LastName: lastName as AnyObject,
            Constants.JSONBodyKeys.MediaURL: mediaURL as AnyObject,
            Constants.JSONBodyKeys.MapString: mapString as AnyObject
        ]
        
        let _ = self.taskForParsePutMethod(Constants.Methods.UpdateStudentLocation, objectId: userInfo.objectId!, jsonObject: json) { (jsonData, error) in
            
            if let error = error {
                
                print(error)
                completionHandler(false, "Failed to change location!")
            } else {
                
                guard (jsonData as? [String: AnyObject]) != nil else {
                    
                    completionHandler(false, "No data was found")
                    return
                }
                print("Success!! Location updated!")
                completionHandler(true, nil)
            }
        }
    }
}
