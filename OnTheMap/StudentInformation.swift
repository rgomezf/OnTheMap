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
        
        if let createdAt = dictionary[Constants.JSONBodyKeys.CreatedAt] as? String {
            self.createdAt = createdAt
        }
        
        if let firstName = dictionary[Constants.JSONBodyKeys.FirstName] as? String {
            self.firstName = firstName
        }
        
        if let lastName  = dictionary[Constants.JSONBodyKeys.LastName] as? String {
            self.lastName = lastName
        }
        
        if let latitude  = dictionary[Constants.JSONBodyKeys.Latitude] as? Double {
            self.latitude = latitude
        }
        
        if let longitude = dictionary[Constants.JSONBodyKeys.Longitude] as? Double {
            self.longitude = longitude
        }
        
        if let mapString = dictionary[Constants.JSONBodyKeys.MapString] as? String {
            self.mapString = mapString
        }
        
        if let mediaURL  = dictionary[Constants.JSONBodyKeys.MediaURL] as? String {
            self.mediaURL = mediaURL
        }
        
        if let objectId  = dictionary[Constants.JSONBodyKeys.ObjectId] as? String {
            self.objectId = objectId
        }
        
        if let uniqueKey = dictionary[Constants.JSONBodyKeys.UniqueKey] as? String {
            self.uniqueKey = uniqueKey
        }
        
        if let updatedAt = dictionary[Constants.JSONBodyKeys.UpdatedAt] as? String {
            self.updatedAt = updatedAt
        }
    }
}

