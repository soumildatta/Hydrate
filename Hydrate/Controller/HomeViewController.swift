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
    
    var current: Float = 0.0
    var goal: Float = 8.0
    var percent: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // making progress bar vertical and increasing width
        waterBar.transform = waterBar.transform.rotated(by: 270 * .pi / 180)
        waterBar.transform = waterBar.transform.scaledBy(x: 1.8, y: 100)

        // iniatialize progressbar
        percent = current / goal
        waterBar.progress = percent
        percentLabel.text = String(format: "%.0f", percent * 100) + "%"

        
        // set goal and number of glasses consumed today here
        goalLabel.text = String(format: "Current Daily Goal: %.0f glasses", goal)
        currentLabel.text = String(format: "%.0f/%.0f", current, goal)
    }
    
    @IBAction func glassesStepper(_ sender: UIStepper) {
        // testing stepper
        
        // for now, do not let user drink more than goal amount (percentage purposes)
        
        if current < goal {
            // change current value based on stepper
            current = Float(sender.value)
            
            currentLabel.text = String(format: "%.0f/%.0f", current, goal)
            
            // progress bar and percent progression
            percent = current / goal
            waterBar.progress = percent
            percentLabel.text = String(format: "%.0f", percent * 100) + "%"
            
        }
        
    }
    
}
