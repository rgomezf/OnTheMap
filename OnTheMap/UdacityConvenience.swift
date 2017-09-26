//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Ramon Gomez on 8/10/17.
//  Copyright © 2017 Ramon's. All rights reserved.
//

import Foundation
import UIKit

// MARK: UdacityClient (Convenient Resource Methods)

extension UdacityClient   {
    
    func authenticateUser(_ parameters: [String: AnyObject], completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        getUdacitySessionID(parameters) { (success, errorString) in
            
            if success {
                completionHandlerForAuth(true, nil)
            } else {
                completionHandlerForAuth(false, errorString!)
            }
            
        }
    }
    
    func logoutUser( completionHandlerForLogout: @escaping(_ success: Bool, _ errorString: String?) -> Void) {
        
        endSession { (success, error) in
            
            if success {
                completionHandlerForLogout(true, nil)
            } else {
                completionHandlerForLogout(false, error!)
            }
        }
    }
    
    private func getUdacitySessionID(_ parameters: [String: AnyObject], completionHandlerForSession: @escaping (_ success: Bool,  _ errorString: String?) -> Void) {
        
        let jsonString = "{\"\(Constants.JSONBodyKeys.Client)\": {\"username\": \"\(parameters[Constants.ParameterKeys.Username]!)\", \"password\": \"\(parameters[Constants.ParameterKeys.Password]!)\"}}"

        let _ = taskForUdacityPOSTMethod(Constants.AuthorizationURL, parameters: jsonString) { (results, error) in
            
            if let error = error {
                print(error)
                completionHandlerForSession(false, "Login Failed (Request Session).")
            }
            guard let userAccount = results?[Constants.JSONResponseKeys.UserAccount] as? [String: AnyObject] else {
                completionHandlerForSession(false, "Could not find key: '\(Constants.JSONResponseKeys.UserAccount)' in \(results!)")
                return
            }
            
            guard let userId = userAccount[Constants.JSONResponseKeys.UserId] as? String else {
                completionHandlerForSession(false, "Could not find key: '\(Constants.JSONResponseKeys.UserId)' in \(results!)")
                return
            }
            guard let session = results?[Constants.JSONResponseKeys.UserSession] as? [String: AnyObject] else {
                completionHandlerForSession(false, "Could not find key: '\(Constants.JSONResponseKeys.UserSession)' in \(results!)" )
                return
            }
            
            guard let sessionId = session[Constants.JSONResponseKeys.SessionID] as? String else {
                completionHandlerForSession(false, "Could not find key: '\(Constants.JSONResponseKeys.SessionID)' in \(results!)")
                return
            }
            userInfo.userId = userId
            userInfo.sessionId = sessionId
            
            self.getPublicUserData({ (success, error) in
                
                if success {
                    
                    print("Got User Data!")
                } else {
                    
                    print("Could not get User Data!")
                    completionHandlerForSession(false, error?.debugDescription)
                }
            })
            completionHandlerForSession(true, nil)
        }

    }
    func getPublicUserData(_ completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let _ = taskForUdacityGETMethod(Constants.Methods.Users, userId: userInfo.userId!) { (jsonData, error) in
            
            if let error = error {
                print("error: \(error)")
                completionHandler(false, error.localizedDescription)
            } else {
                
                guard let user = jsonData?[Constants.JSONResponseKeys.User] as? [String: AnyObject] else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.User)' in \(jsonData!)")
                    completionHandler(false, error?.localizedDescription)
                    return
                }
                
                guard let userId = user[Constants.JSONResponseKeys.UserId] as? String else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.UserId)' in \(jsonData!)")
                    completionHandler(false, error?.localizedDescription)
                    return
                }
                print("Passed GET userID: \(userId)")
                userInfo.userId = userId
                
                guard let firstName = user[Constants.JSONResponseKeys.FirstName] as? String else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.FirstName)' in \(jsonData!)")
                    completionHandler(false, error?.localizedDescription)
                    return
                }
                print("Passed GET firstName: \(firstName)")
                
                userInfo.firstName = firstName
                
                guard let lastName = user[Constants.JSONResponseKeys.LastName] as? String else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.LastName)' in \(jsonData!)")
                    completionHandler(false, error?.localizedDescription)
                    return
                }
                print("Passed GET lastName: \(lastName)")
                
                userInfo.lastName = lastName
                
                completionHandler(true, nil)
            }
        }
    }
    
    private func endSession(_ completionHandlerForLogout: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let _ = taskForUdacityDELETEMethod(Constants.AuthorizationURL) { (results, error) in
            
            if let error = error {
                print(error)
                completionHandlerForLogout(false, "Logout Failed (End Session).")
            } else {
                completionHandlerForLogout(true, nil)
            }
        }
    }
}
