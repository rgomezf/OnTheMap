//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Ramon Gomez on 9/18/17.
//  Copyright © 2017 Ramon's. All rights reserved.
//
import Foundation
import MapKit
import UIKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!

    @IBOutlet weak var findLocationOutlet: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationTextField.delegate = self
        websiteTextField.delegate = self
        activityIndicator.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

   // MARK: Actions
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findButton(_ sender: UIButton) {
        
        LocationInfo.location = locationTextField.text!
        LocationInfo.website  = websiteTextField.text!
        
        if (locationTextField.text?.isEmpty)! || (websiteTextField.text?.isEmpty)! {
            
            displayAlertMessage("Error", "More information is required to continue.")
        } else {
            
            performUIUpdatesOnMain {
                
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                
                self.findLocation({ (success, errorString) in
                    
                    if success {
                        
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SubmitLocation")
                        self.present(controller!, animated: true, completion: nil)
                    } else {
                        
                        self.setUIEnabled(false)
                        self.displayAlertMessage("Error!", errorString!)
                    }
                })
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    func findLocation(_ completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationTextField.text!) { (placemark, error) in
            
            performUIUpdatesOnMain {
                
                if let error = error {
                    completionHandler(false, error.localizedDescription)
                    return
                }
                
                guard let placemark = placemark else {
                    
                    completionHandler(false, error?.localizedDescription)
                    return
                }
                guard let latitude = placemark[0].location?.coordinate.latitude else {
                    
                    completionHandler(false, error?.localizedDescription)
                    return
                }
                
                guard let longitude = placemark[0].location?.coordinate.longitude else {
                    
                    completionHandler(false, error?.localizedDescription)
                    return
                }
                
                LocationInfo.latitude = latitude
                LocationInfo.longitude = longitude
                
                print("\(LocationInfo.latitude) \(LocationInfo.longitude)")
                completionHandler(true, nil)
            }
        }
    }
}

extension AddLocationViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.locationTextField.resignFirstResponder()
        self.websiteTextField.resignFirstResponder()
        return true
    }
    
    func setUIEnabled(_ enabled: Bool) {
        locationTextField.isEnabled = enabled
        websiteTextField.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            findLocationOutlet.alpha = 1.0
        } else {
            findLocationOutlet.alpha = 0.5
        }
    }
    
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
