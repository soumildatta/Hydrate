//
//  HomeViewController.swift
//  Hydrate
//
//  Created by Soumil Datta on 5/21/20.
//  Copyright © 2020 Soumil Datta. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var waterBar: UIProgressView!
    @IBOutlet weak var glassStepper: UIStepper!
    
    let glassManager = GlassManager()
    
    var current: Float = 80.0
    var percent: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // making progress bar vertical and increasing width
        waterBar.transform = waterBar.transform.rotated(by: 270 * .pi / 180)
        waterBar.transform = waterBar.transform.scaledBy(x: 1.8, y: 100)

        // iniatialize progressbar and stepper values
        percent = current / glassManager.currentGoal
        waterBar.setProgress(percent, animated: true)
        glassStepper.value = Double(current)
        
        if percent * 100 < 1000 {
            percentLabel.text = String(format: "%.0f", percent * 100) + "%"
        } else {
            percentLabel.text = "999%"
        }
        
        // set goal and number of glasses consumed today here
        goalLabel.text = String(format: "Current Daily Goal: %.0f glasses", glassManager.currentGoal)
        currentLabel.text = String(format: "%.0f/%.0f", current, glassManager.currentGoal)
    }
    
    @IBAction func glassesStepper(_ sender: UIStepper) {
        // change current value based on stepper
        current = Float(sender.value)
            
        currentLabel.text = String(format: "%.0f/%.0f", current, glassManager.currentGoal)
            
        // progress bar and percent progression
        percent = current / glassManager.currentGoal
        waterBar.setProgress(percent, animated: true)
        
        // limit percent to 999%
        if percent * 100 < 1000 {
            percentLabel.text = String(format: "%.0f", percent * 100) + "%"
        } else {
            percentLabel.text = "999%"
        }
        
    }
    
}
