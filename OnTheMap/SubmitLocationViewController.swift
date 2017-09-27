//
//  SubmitLocationViewController.swift
//  OnTheMap
//
//  Created by Ramon Gomez on 9/18/17.
//  Copyright © 2017 Ramon's. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class SubmitLocationViewController: UIViewController, MKMapViewDelegate {

    // Properties
    var coordinate: CLLocationCoordinate2D!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createMap()
        self.mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addAnnotation()
    }
    
    func createMap() {
    
        let latitude = CLLocationDegrees(LocationInfo.latitude as Double)
        let longitude = CLLocationDegrees(LocationInfo.longitude as Double)
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.coordinate = coordinate
        let region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(1, 1))
        mapView.setRegion(region, animated: true)
    }
    
    func addAnnotation() {
        
        let annotation = MKPointAnnotation()
        
        annotation.title = userInfo.firstName! + " " + userInfo.lastName!
        annotation.coordinate = self.coordinate
        annotation.subtitle = LocationInfo.website
        
        self.mapView.addAnnotation(annotation as MKAnnotation)
    }
    
    func postLocation(_ completionHandler: @escaping (_ success: Bool) -> Void) {
        
        self.addAnnotation()
 /*
 // Client.shared.postForParse(urlAsString: "https://parse.udacity.com/parse/classes/StudentLocation",
             httpMessageBody: "{\"uniqueKey\": \"\(Constants.Udacity.userID)\", \"firstName\": \"\(Constants.Udacity.firstName)\", \"lastName\": \"\(Constants.Udacity.lastName)\",\"mapString\": \"\(Constants.Map.enteredLocation!)\", \"mediaURL\": \"\(Constants.Map.enteredURL!)\",\"latitude\": \(Constants.Map.latitude!), \"longitude\": \(Constants.Map.longitude!)}"
 --
     let url = NSURL(string: urlAsString)
     var request = URLRequest(url: url as! URL)
     request.httpMethod = "POST"
     request.addValue(Constants.Parse.AppicationID, forHTTPHeaderField: X-Parse-Application-Id)
     request.addValue(Constants.Parse.APIKey, forHTTPHeaderField: X-Parse-REST-API-Key)
     request.addValue(Constants.Parse.contentType, forHTTPHeaderField: application/json)
     request.httpBody = httpMessageBody.data(using: String.Encoding.utf8)
 */
        // Look for the Student Location and try to get it's objectId from Parse
        if userInfo.objectId == "" {
            
            ParseClient.sharedInstance().postNewLocation(userId: userInfo.uniqueKey!, firstName: userInfo.firstName!, lastName: userInfo.lastName!, mediaUrl: LocationInfo.website, mapString: LocationInfo.location) { (success, errorString) in
                
                performUIUpdatesOnMain {
                    
                    if success {
                        
                        completionHandler(true)
                        self.completeSubmition()
                    } else {
                        
                        completionHandler(false)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        } else {
            
            ParseClient.sharedInstance().updateCurrentLocation(uniqueKey: userInfo.uniqueKey!, firstName: userInfo.firstName!, lastName: userInfo.lastName!, mediaURL: LocationInfo.website, mapString: LocationInfo.location, { (success, errorString) in
                
                if success {
                    
                    completionHandler(true)
                    self.completeSubmition()
                } else {
                    completionHandler(false)
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
        
    }
    
    func completeSubmition() {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UITabBarController
        self.present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
    
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        
        self.postLocation() { (success) in
            
            performUIUpdatesOnMain {
                
                if success {
                    
                    self.displayAlertMessage("Success!", "The Submition was completed.")
                } else {
                    
                    self.displayAlertMessage("Error!", "Connection failed! Try again.")
                }
            }
        }
    }
    
    // MARK: Map functions
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = URL(string: (view.annotation?.subtitle!)!) {
                app.open(toOpen, options: [:]){ (success) in
                    
                    if !(success) {
                        self.displayAlertMessage("Error", "Could not load the URL!")
                    }
                }
            }
        }
    }
}

private extension SubmitLocationViewController {
    
    // Custom Alert function.
    
    func displayAlertMessage(_ title: String, _ message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Dismiss", style: .destructive, handler: { (action) -> Void in })
        
        // Restyle the view of the Alert
        alert.view.backgroundColor = UIColor.blue
        alert.view.layer.cornerRadius = 25
        
        // Add action button and present the Alert
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
