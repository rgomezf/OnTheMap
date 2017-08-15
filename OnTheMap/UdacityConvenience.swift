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
    
    private func getSessionID(_ parameters: [String: AnyObject], completionHandlerForSession: @escaping (_ success: Bool,  _ errorString: String?) -> Void) {
        
        let jsonString = "{\"\(UdacityClient.JSONBodyKeys.Client)\": {\"username\": \"\(parameters[UdacityClient.ParameterKeys.Username]!)\", \"password\": \"\(parameters[UdacityClient.ParameterKeys.Password]!)\"}}"

        let _ = taskForPOSTMethod(Constants.AuthorizationURL, parameters: jsonString) { (results, error) in
            
            if let error = error {
                print(error)
                completionHandlerForSession(false, "Login Failed (Request Session).")
            } else {
                guard let session = results?[UdacityClient.JSONResponseKeys.UserSession] as? [String: AnyObject] else {
                    completionHandlerForSession(false, error?.localizedDescription )
                    return
                }
                
                guard let sessionID = session[UdacityClient.JSONResponseKeys.SessionID] as? String else {
                    completionHandlerForSession(false, error?.localizedDescription)
                    return
                }
                self.sessionID = sessionID
            }
            completionHandlerForSession(true, nil)
        }

    }
}
