//
//  LoginViewController.swift
//  Hydrate
//
//  Created by Soumil Datta on 5/27/20.
//  Copyright © 2020 Soumil Datta. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var WarningLabel: UILabel!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WarningLabel.text = ""
        
        let color = UIColor.lightGray
        let emailPlaceholder = EmailTextField.placeholder ?? "" //There should be a placeholder set in storyboard or elsewhere string or pass empty
        EmailTextField.attributedPlaceholder = NSAttributedString(string: emailPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : color])
        
        let passwordPlaceholder = PasswordTextField.placeholder ?? "" //There should be a placeholder set in storyboard or elsewhere string or pass empty
        PasswordTextField.attributedPlaceholder = NSAttributedString(string: passwordPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
    
    @IBAction func LoginPressed(_ sender: UIButton) {
        // TODO function to check email syntax
        if let email = EmailTextField.text, let password = PasswordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.WarningLabel.text = e.localizedDescription
                } else {
                     self.performSegue(withIdentifier: "LoginSegue", sender: self)
                }
            }
        }
    }
    
}
