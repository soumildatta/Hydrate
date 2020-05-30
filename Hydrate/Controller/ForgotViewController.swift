//
//  ForgotViewController.swift
//  Hydrate
//
//  Created by Soumil Datta on 5/27/20.
//  Copyright © 2020 Soumil Datta. All rights reserved.
//

import UIKit
import Firebase

class ForgotViewController: UIViewController {
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        warningLabel.text = ""
    }
    
    @IBAction func returnToLogin(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        
        if emailTextField.text != "" {
            if let email = emailTextField.text {
                Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
            }
            
            let alertController = UIAlertController(title: "Password reset email sent", message: "If your email matches one in our database, we will send you the link to reset your password", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .destructive))
            
            self.present(alertController, animated: true, completion: nil)
        } else{
            warningLabel.text = "Enter an email!"
        }
        
    }
}
