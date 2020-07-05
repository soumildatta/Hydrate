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
        EmailTextField.delegate = self
        PasswordTextField.delegate = self
        ConfirmPasswordField.delegate = self

        WarningLabel.text = ""
        
        let color = UIColor.lightGray
        let emailPlaceholder = EmailTextField.placeholder ?? "" //There should be a placeholder set in storyboard or elsewhere string or pass empty
        EmailTextField.attributedPlaceholder = NSAttributedString(string: emailPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : color])
        
        let passwordPlaceholder = PasswordTextField.placeholder ?? "" //There should be a placeholder set in storyboard or elsewhere string or pass empty
        PasswordTextField.attributedPlaceholder = NSAttributedString(string: passwordPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : color])
        
        let confirmPasswordPlaceholder = ConfirmPasswordField.placeholder ?? "" //There should be a placeholder set in storyboard or elsewhere string or pass empty
        ConfirmPasswordField.attributedPlaceholder = NSAttributedString(string: confirmPasswordPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : color])
        
        
        // end editing when clicked outside of keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func SignupPressed(_ sender: UIButton) {
    
        if(PasswordTextField.text == ConfirmPasswordField.text) {
            if let email = EmailTextField.text, let password = PasswordTextField.text {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        DispatchQueue.main.async {
                            self.WarningLabel.text = e.localizedDescription
                        }
                    } else {
                        // print("Signed up")
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "SignupSegue", sender: self)
                        }
                    }
                }
            }
        } else {
            WarningLabel.text = "Passwords do not match"
        }
    }
    
    @IBAction func BackButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - UITextFieldDelegate
extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
