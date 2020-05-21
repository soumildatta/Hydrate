//
//  HomeViewController.swift
//  Hydrate
//
//  Created by Soumil Datta on 5/21/20.
//  Copyright © 2020 Soumil Datta. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var currentGlasses: UILabel!
    
    var current = 0
    var goal = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set number of glasses consumed today here
        currentGlasses.text = "\(current)/\(goal)"
    }
    
    @IBAction func glassesStepper(_ sender: UIStepper) {
        // testing stepper
        
        // for now, do not let user drink more than goal amount (percentage purposes)
        if current < goal {
            currentGlasses.text = String(format: "%.0f/\(goal)", sender.value)
            current += 1
        }
        
    }
    
}
