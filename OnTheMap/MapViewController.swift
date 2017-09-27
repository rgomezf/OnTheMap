//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Ramon Gomez on 8/15/17.
//  Copyright © 2017 Ramon's. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        clearMap()
        getLocations()
        getUserParseInformation()
    }
    // 
    func addLocations() {
        
        let studentLocations = StudentData.sharedInstance().StudentArray
        var annotations = [MKPointAnnotation]()
        
        for student in studentLocations {
            
            // create CLLocationDegree values
            let lat = CLLocationDegrees(student.latitude as Double)
            let long = CLLocationDegrees(student.longitude as Double)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let studentName = "\(student.firstName!) \(student.lastName!)"
            let mediaURL = student.mediaURL
            
            // Create the annotation and set its coordinate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = studentName
            annotation.subtitle = mediaURL
            
            // Place the annotation in an array of annotations
            annotations.append(annotation)
        }
        
        self.mapView.delegate = self
        // Annotations array is complete, add them to the map
        self.mapView.addAnnotations(annotations)
    }
    
    //
    func getLocations() {
        
        ParseClient.sharedInstance().getLocationFromParse { (results, error) in
            
            performUIUpdatesOnMain {
                if results != nil {
                
                    self.addLocations()
                    print("Success! Downloaded Student Locations")
                    
                } else {
                    
                    self.displayAlertMessage("Error!", "Could not get locations!")
            }
                
            }
        }
    }
    
    // Get User Parse Information
    func getUserParseInformation() {
        
        ParseClient.sharedInstance().getParseOjectId(uniqueKey: userInfo.uniqueKey!) { (success, error) in
            
            if error == nil {
                print("Success! Obtained objectId: \(userInfo.objectId!)")
                
            } else {
                print("Error! Could not get the information: \(error!)")
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
    
    // Clear the map annotations
    func clearMap () {
        
        for annotation: MKAnnotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
    }
    
    // MARK: Actions
    
    @IBAction func logOut( _ sender: Any) {
        
         UdacityClient.sharedInstance().logoutUser { (success, errorString) in
            performUIUpdatesOnMain {
                
                if success {
                    self.dismiss(animated: false, completion: nil)
                } else {
                    self.displayAlertMessage("Alert!", "Log Out Failed: \(errorString!)")
                }
            }
        }
    }
    
    @IBAction func reloadButton(_ sender: UIBarButtonItem) {
        
        self.clearMap()
        self.getLocations()
    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
    }
    
}

private extension MapViewController {
    
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
