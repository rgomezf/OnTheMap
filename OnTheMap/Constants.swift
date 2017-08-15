//
//  Constants.swift
//  OnTheMap
//
//  Created by Ramon Gomez on 8/9/17.
//  Copyright © 2017 Ramon's. All rights reserved.
//

// MARK: - UdacityClient (Constants)
extension UdacityClient {
 
    struct Constants {
    
        // MARKS: API Key
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        static let AuthorizationURL = "https://www.udacity.com/api/session"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Authentication
        static let AuthenticationSessionNew = "/session"
        static let MethodType = "POST"
    }
    
    // MARK: JSONBodyKeys {
    struct JSONBodyKeys {
        static let Client = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: JSONResponseKeys
    struct JSONResponseKeys {
        static let UserSession = "session"
        static let UserAccount = "account"
        static let Registered = "registered"
        static let UserKey = "key"
        static let SessionID = "id"
        static let ExpirationDate = "expiration"
    }
}
