//
//  SignupViewController.swift
//  Hydrate
//
//  Created by Soumil Datta on 5/27/20.
//  Copyright © 2020 Soumil Datta. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {
    
    @IBOutlet weak var WarningLabel: UILabel!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ConfirmPasswordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        WarningLabel.text = ""
    }
    
    @IBAction func SignupPressed(_ sender: UIButton) {
    
        // move all this to a struct in models
        if let email = EmailTextField.text, let password = PasswordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.WarningLabel.text = e.localizedDescription
                } else {
                    // print("Signed up")
                    self.performSegue(withIdentifier: "SignupSegue", sender: self)
                }
            }
        }
    }
    
    @IBAction func BackButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
