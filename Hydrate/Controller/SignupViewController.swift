//
//  SignupViewController.swift
//  Hydrate
//
//  Created by Soumil Datta on 5/27/20.
//  Copyright © 2020 Soumil Datta. All rights reserved.
//

import UIKit

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
        if EmailTextField.text == "" {
            WarningLabel.text = "Enter a valid email"
        }
    }
    
    @IBAction func BackButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
