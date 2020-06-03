//
//  ProfileViewController.swift
//  Hydrate
//
//  Created by Soumil Datta on 5/21/20.
//  Copyright © 2020 Soumil Datta. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet weak var glassSizePicker: UIPickerView!
    @IBOutlet weak var setGoalLabel: UILabel!
    @IBOutlet weak var setGoalStepper: UIStepper!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    let glassManager = GlassManager()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        glassSizePicker.dataSource = self
        glassSizePicker.delegate = self

        // initialize stepper value
        setGoalStepper.value = Double(glassManager.currentGoal)
        
        
        // in the future, make this call right when the user logs in, so that the data loads quicker
        loadData()
    }
    
    @IBAction func setGoal(_ sender: UIStepper) {
        setGoalLabel.text = "\(Int(sender.value)) glasses /day"
        GlassManager.sharedInstance.currentGoal = Float(sender.value)
    }
    
    @IBAction func notificationSwitchChanged(_ sender: UISwitch) {
        print(sender.isOn)
        // TODO: Implement notifications 
    }
    
    @IBAction func applyChanges(_ sender: UIButton) {
        let dailyGoal = setGoalStepper.value
        // TODO: picker, and notification
        if let currentUser = Auth.auth().currentUser?.email {
            db.collection(K.firebase.settingsCollection).document(currentUser).setData([
                K.firebase.dailyGoalField: dailyGoal,
                K.firebase.currentUserField: currentUser
            ]) { (error) in
                if let e = error {
                    print("Error saving settings, \(e)")
                } else {
                    print("Settings saved successfully")
                }
            }
        }
        
        // print("Here it is \(glassManager.loadGoal())")
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            // pop to root, which is login view
            view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}


// MARK: - UIPickerView
extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // TODO
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // the number of columns
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return glassManager.glassSizes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return glassManager.glassSizes[row] + "oz"
    }
    
}


// MARK: - Firebase
extension SettingsViewController {
    func loadData() {
        if let currentUser = Auth.auth().currentUser?.email {
            db.collection(K.firebase.settingsCollection).document(currentUser).getDocument { (document, error) in
                if let document = document, document.exists {
                    //set values
                    if let goalValue = document[K.firebase.dailyGoalField] {
                        self.setGoalStepper.value = goalValue as! Double
                        self.setGoalLabel.text = "\(goalValue as! Int) glasses /day"
                    }
                    
                } else {
                    print("Settings do not currently exist")
                }
            }
        }
    }
}
