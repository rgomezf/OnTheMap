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
        
        annotation.title = userInfo.firstName! + " " + userInfo.LastName!
        annotation.coordinate = self.coordinate
        annotation.subtitle = LocationInfo.website
        
        self.mapView.addAnnotation(annotation as MKAnnotation)
    }
    
    func postLocation(_ completionHandler: @escaping (_ success: Bool) -> Void) {
        
        self.addAnnotation()
        
        print("\(userInfo)")
        ParseClient.sharedInstance().getParseOjectId(uniqueKey: userInfo.userId!) { (success, errorString) in
            
            if userInfo.objectId == "" {
                
                ParseClient.sharedInstance().postNewLocation(userId: userInfo.userId!, firstName: userInfo.firstName!, lastName: userInfo.LastName!, mediaUrl: LocationInfo.website, mapString: LocationInfo.location, { (success, errorString) in
                    
                    performUIUpdatesOnMain {
                        
                        if success {
                            
                            completionHandler(true)
                            self.completeSubmition()
                        } else {
                            
                            completionHandler(false)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                })
            } else {
                
                ParseClient.sharedInstance().updateCurrentLocation(userId: userInfo.userId!, firstName: userInfo.firstName!, lastName: userInfo.LastName!, mediaURL: LocationInfo.website, mapString: LocationInfo.location, { (success, errorString) in
                    
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
