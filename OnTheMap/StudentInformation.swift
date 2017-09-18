//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Ramon Gomez on 8/15/17.
//  Copyright © 2017 Ramon's. All rights reserved.
//

import UIKit

class StudentInformation: NSObject {

    var createdAt: String? = ""
    var firstName: String? = ""
    var lastName: String? = ""
    var latitude: Double = 0.00
    var longitude: Double = 0.00
    var mapString: String? = ""
    var mediaURL: String? = ""
    var objectId: String? = ""
    var uniqueKey: String? = ""
    var updatedAt: String? = ""

    init(dictionary: [String: AnyObject]) {
        
        if let createdAt = dictionary[Constants.JSONResponseKeys.CreatedAt] as? String {
            self.createdAt = createdAt
        }
        
        if let firstName = dictionary[Constants.JSONResponseKeys.FirstName] as? String {
            self.firstName = firstName
        }
        
        if let lastName  = dictionary[Constants.JSONResponseKeys.LastName] as? String {
            self.lastName = lastName
        }
        
        if let latitude  = dictionary[Constants.JSONResponseKeys.latitude] as? Double {
            self.latitude = latitude
        }
        
        if let longitude = dictionary[Constants.JSONResponseKeys.longitude] as? Double {
            self.longitude = longitude
        }
        
        if let mapString = dictionary[Constants.JSONResponseKeys.mapString] as? String {
            self.mapString = mapString
        }
        
        if let mediaURL  = dictionary[Constants.JSONResponseKeys.mediaURL] as? String {
            self.mediaURL = mediaURL
        }
        
        if let objectId  = dictionary[Constants.JSONResponseKeys.objectID] as? String {
            self.objectId = objectId
        }
        
        if let uniqueKey = dictionary[Constants.JSONResponseKeys.uniqueKey] as? String {
            self.uniqueKey = uniqueKey
        }
        
        if let updatedAt = dictionary[Constants.JSONResponseKeys.updatedAt] as? String {
            self.updatedAt = updatedAt
        }
    }
}

