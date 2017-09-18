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
        
        getSessionID(parameters) { (success, errorString) in
            
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
    
    private func getSessionID(_ parameters: [String: AnyObject], completionHandlerForSession: @escaping (_ success: Bool,  _ errorString: String?) -> Void) {
        
        let jsonString = "{\"\(Constants.JSONBodyKeys.Client)\": {\"username\": \"\(parameters[Constants.ParameterKeys.Username]!)\", \"password\": \"\(parameters[Constants.ParameterKeys.Password]!)\"}}"

        let _ = taskForPOSTMethod(Constants.AuthorizationURL, parameters: jsonString) { (results, error) in
            
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
            self.udacityId = userId
            self.sessionId = sessionId
            
            completionHandlerForSession(true, nil)
        }

    }
    
    private func endSession(_ completionHandlerForLogout: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let _ = taskForDELETEMethod(Constants.AuthorizationURL) { (results, error) in
            
            if let error = error {
                print(error)
                completionHandlerForLogout(false, "Logout Failed (End Session).")
            } else {
                completionHandlerForLogout(true, nil)
            }
        }
    }
}
