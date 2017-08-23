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
            } else {
                guard let session = results?[Constants.JSONResponseKeys.UserSession] as? [String: AnyObject] else {
                    completionHandlerForSession(false, error?.localizedDescription )
                    return
                }
                
                guard let sessionID = session[Constants.JSONResponseKeys.SessionID] as? String else {
                    completionHandlerForSession(false, error?.localizedDescription)
                    return
                }
                self.sessionID = sessionID
            }
            completionHandlerForSession(true, nil)
        }

    }
    
    private func endSession(_ completionHandlerForLogout: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let _ = taskForDELETEMethod(Constants.AuthorizationURL) { (results, error) in
            
            if let error = error {
                //
                print(error)
                completionHandlerForLogout(false, "Logout Failed (End Session).")
            } else {
                completionHandlerForLogout(true, nil)
            }
        }
    }
}
