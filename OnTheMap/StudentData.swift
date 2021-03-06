//
//  StudentData.swift
//  OnTheMap
//
//  Created by Ramon Gomez on 8/15/17.
//  Copyright © 2017 Ramon's. All rights reserved.
//

import UIKit
import Foundation

class StudentData {

    class func sharedInstance() -> StudentData {
        
        struct Singleton {
            static var sharedInstance = StudentData()
        }
        return Singleton.sharedInstance
    }
    
    // The StudentInformation array
    var StudentArray: [StudentInformation] = [StudentInformation]()
    
    static func studentsFromResults(_ results: [[String: AnyObject]]) -> [StudentInformation] {
        
        var students = [StudentInformation]()
        
        for result in results {
            students.append(StudentInformation(dictionary: result))
        }
        
        return students
    }

}
