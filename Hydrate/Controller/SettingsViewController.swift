//
//  ProfileViewController.swift
//  Hydrate
//
//  Created by Soumil Datta on 5/21/20.
//  Copyright © 2020 Soumil Datta. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var glassSizePicker: UIPickerView!
    @IBOutlet weak var setGoalLabel: UILabel!
    @IBOutlet weak var setGoalStepper: UIStepper!
        
    let glassManager = GlassManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        glassSizePicker.dataSource = self
        glassSizePicker.delegate = self

        // initialize stepper value
        setGoalStepper.value = Double(glassManager.currentGoal)
        
    }
    
    @IBAction func setGoal(_ sender: UIStepper) {
        setGoalLabel.text = "\(Int(sender.value)) glasses /day"
        GlassManager.sharedInstance.currentGoal = Float(sender.value)
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
