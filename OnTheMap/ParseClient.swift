//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Ramon Gomez on 9/15/17.
//  Copyright © 2017 Ramon's. All rights reserved.
//

import UIKit
import Foundation

class ParseClient: NSObject {

    // shared session
    var session = URLSession.shared
    
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }

    func taskForParseGetMethod(_ method: String, parameters: [String: AnyObject], completionHandlerForGet: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
        
        /* Build the URL, Configure the request */ // TODO: Use the method parameter and parameters variable
        let url = URL(string: Constants.ParseBaseURL + method)!
        print("url: \(buildURLFromParameters(parameters, withPathExtension: method))")
        
        let request = NSMutableURLRequest(url: buildURLFromParameters(parameters, withPathExtension: method))
        request.addValue(Constants.ParseApplicationID, forHTTPHeaderField: Constants.ParameterKeys.ApplicationIdString)
        request.addValue(Constants.ParseApiKey, forHTTPHeaderField: Constants.ParameterKeys.RestApiString)

        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGet(error as AnyObject, NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGet)
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }
    
    func taskForParsePostMethod(_ method: String, jsonObject: [String: AnyObject], completionHandlerForPost: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
        
        let url = URL(string: Constants.ParseBaseURL + method)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = Constants.Methods.MethodType
        request.addValue(Constants.ParseApplicationID, forHTTPHeaderField: Constants.ParameterKeys.ApplicationIdString)
        request.addValue(Constants.ParseApiKey, forHTTPHeaderField: Constants.ParameterKeys.RestApiString)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPost(error as AnyObject, NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPost)
        }
        
        task.resume()
        return task
    }
    
    func taskForParsePutMethod(_ method: String, objectId: String, jsonObject: [String: AnyObject], completionHandlerForPUT: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
        
        /* Build the URL, Configure the request */
        let url = URL(string: Constants.ParseBaseURL + Constants.Methods.StudentLocation)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = Constants.Methods.MethodParsePut
        request.addValue(Constants.ParseApplicationID, forHTTPHeaderField: Constants.ParameterKeys.ApplicationIdString)
        request.addValue(Constants.ParseApiKey, forHTTPHeaderField: Constants.ParameterKeys.RestApiString)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPUT(error as AnyObject, NSError(domain: "taskForPutMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPUT)
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }
    
    func getStudentLocationsFromParse(_ method: String, parameters: [String: AnyObject], _ completionHandlerForGet: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
        
        let url = buildURLFromParameters(parameters, withPathExtension: Constants.Methods.StudentLocation)
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = Constants.Methods.MethodParseGet
        request.addValue(Constants.ParseApplicationID, forHTTPHeaderField: Constants.ParameterKeys.ApplicationIdString)
        request.addValue(Constants.ParseApiKey, forHTTPHeaderField: Constants.ParameterKeys.RestApiString)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGet(error as AnyObject, NSError(domain: "getStudentLocations", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGet)
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }
    
    // create a URL from parameters
    // TODO: Double check the components
    
    func buildURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ParseHost
        components.path = Constants.ParsePath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        print("url: \(components.url!)")
        print("query: \(components.query!)")
        return components.url!
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
