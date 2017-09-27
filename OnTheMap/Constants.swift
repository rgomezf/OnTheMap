//
//  Constants.swift
//  OnTheMap
//
//  Created by Ramon Gomez on 8/9/17.
//  Copyright © 2017 Ramon's. All rights reserved.
//

import Foundation
import UIKit

struct Constants {

    // MARKS: API Key
    static let ParseApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    
    // MARK: URLs
    static let ApiScheme = "https"
    static let ApiHost = "www.udacity.com"
    static let ApiPath = "/api"
    static let AuthorizationURL = "https://www.udacity.com/api/session"
    static let UdacityBaseURL = "https://www.udacity.com/api"
    static let ParseBaseURL = "https://parse.udacity.com/parse/classes"
    static let ParseHost = "parse.udacity.com"
    static let ParsePath = "/parse/classes"

    // MARK: Parameter Keys
    struct ParameterKeys {
        
        static let Username = "username"
        static let Password = "password"
        static let ApplicationIdString = "X-Parse-Application-Id"
        static let RestApiString = "X-Parse-REST-API-Key"
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        static let Query = "where"
        static let Unique = "uniqueKey"
    }

    // MARK: Methods
    struct Methods {
        
        // MARK: Authentication
        static let AuthenticationSessionNew = "/session"
        static let StudentLocation = "/StudentLocation"
        static let UpdateStudentLocation = "/StudentLocation/{objectId}"
        static let Users = "/users"
        static let MethodType = "POST"
        static let MethodParsePut = "PUT"
        static let MethodParseGet = "GET"
        static let LogOut = "DELETE"
    }

    // MARK: JSONBodyKeys {
    struct JSONBodyKeys {
        static let Client = "udacity"
        static let Username = "username"
        static let Password = "password"
        
        // Parse JSONBodyKeys
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        static let ACL = "ACL"
    }

    // MARK: JSONResponseKeys
    struct JSONResponseKeys {
        
        static let UserSession = "session"
        
        // Account
        static let UserAccount = "account"
        static let UniqueKey = "key"
        static let SessionID = "id"
        
        static let User = "user"
        
        // Student Locations
        static let Locations = "results"
        static let CreatedAt = "createdAt"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectID = "objectId"
        static let UpdatedAt = "updatedAt"
    }
}
