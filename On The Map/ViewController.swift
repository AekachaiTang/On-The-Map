//
//  ViewController.swift
//  On The Map
//
//  Created by aekachai tungrattanavalee on 19/1/2563 BE.
//  Copyright © 2563 aekachai tungrattanavalee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
   
    let loginSegue = "LoginSegue"
    let udacitySignUpUrl = "https://www.udacity.com"
    var activeField: UITextField?
    
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func login(_ sender: Any) {
        if emailField.text!.isEmpty || passwordField.text!.isEmpty {
            return
        }
        
        UdacityClient.shared.login(email: emailField.text!, password: passwordField.text!, completion: completeLogin(_:_:))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let signUpTap = UITapGestureRecognizer(target: self, action: #selector(redirectToUdacitySignUp))
        signUpLabel.isUserInteractionEnabled = true
        signUpLabel.addGestureRecognizer(signUpTap)
        hideKeyboardWhenTappedAround()
    }
    
    @objc private func redirectToUdacitySignUp() {
        Utilities.openURL(udacitySignUpUrl)
    }
    
    private func completeLogin(_ successful: Bool, _ displayError: String?) {
        DispatchQueue.main.async {
            if (successful) {
                self.performSegue(withIdentifier: self.loginSegue, sender: nil)
            } else {
                Utilities.showErrorAlert(self, displayError)
            }
            
        }
    }
    


}

extension ViewController {
    func hideKeyboardWhenTappedAround() {
     let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(ViewController.dismissKeyboard))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
       view.endEditing(true)
    }
}
