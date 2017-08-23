//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Ramon Gomez on 7/12/17.
//  Copyright © 2017 Ramon's. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var keyboardOnScreen = false
    
    // MARK: Outlets
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // get the app delegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        configureUI()
        
        // Subscribe to keyboard notifications
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    // MARK: Login
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        userDidTapView(self)
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            
            self.displayAlertMessage("Information", "The Email and Password must be provided.")
        } else {
            
            setUIEnabled(false)
            let methodParameters = [
                Constants.ParameterKeys.Username: emailTextField.text!,
                Constants.ParameterKeys.Password: passwordTextField.text!
            ]
            
            UdacityClient.sharedInstance().authenticateUser(methodParameters as [String: AnyObject]) { (success, errorString) in
                
                performUIUpdatesOnMain {
                    if success {
                        //
                        self.completeLogin()
                    } else {
                        //
                        self.displayAlertMessage("Alert", errorString!)
                    }
                }
            }
        }
    }
    
    private func completeLogin(){
        // TODO: llamar la siguiente pantalla.
            
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UITabBarController
        self.present(controller, animated: true, completion: nil)
    }
}

/*
    Follow approach from MyFavoriteMovies project
*/
// MARK: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(_ notification: Notification) {

        logoImageView.isHidden = true
    }
    
    func keyboardWillHide(_ notification: Notification) {

        logoImageView.isHidden = false
    }
    
    func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(emailTextField)
        resignIfFirstResponder(passwordTextField)
    }
}

// MARK: Configure UI

private extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        emailTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    func configureUI() {
        
        // configure background gradient
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, at: 0)
    }
}

// MARK: - LoginViewController (Notifications)

private extension LoginViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
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
