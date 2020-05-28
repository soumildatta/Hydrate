//
//  LoginViewController.swift
//  Hydrate
//
//  Created by Soumil Datta on 5/27/20.
//  Copyright © 2020 Soumil Datta. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var WarningLabel: UILabel!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WarningLabel.text = ""
    }
    
    @IBAction func LoginPressed(_ sender: UIButton) {
        // TODO function to check email syntax
    }
    
}
