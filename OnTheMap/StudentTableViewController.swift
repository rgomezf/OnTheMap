//
//  StudentTableViewController.swift
//  OnTheMap
//
//  Created by Ramon Gomez on 8/15/17.
//  Copyright © 2017 Ramon's. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {

    let cellIdentifier = "StudentTableViewCell"
    var locations = [StudentInformation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locations = StudentData.sharedInstance().StudentArray
        
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // number of rows
        return locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        
        let studentLocation = locations[indexPath.row]
        
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        cell.textLabel?.text = "\(studentLocation.firstName!) \(studentLocation.lastName!)"
        cell.detailTextLabel?.text = "\(studentLocation.mediaURL!)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let media = locations[indexPath.row].mediaURL
        
        performUIUpdatesOnMain {
            
            if media?.range(of: "http") != nil {
                
                UIApplication.shared.open(URL(string: "\(media!)")!, options: [:], completionHandler: { (success) in
                    
                    if !(success) {
                        self.displayAlertMessage("Error", "Could not open the link: \(media!)")
                    }
                })
            } else {
                
                self.displayAlertMessage("Error", "Could not open the link: \(media!)")
            }
        }
        
    }
}

private extension StudentTableViewController {
    
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
