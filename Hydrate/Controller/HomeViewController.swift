//
//  HomeViewController.swift
//  Hydrate
//
//  Created by Soumil Datta on 5/21/20.
//  Copyright © 2020 Soumil Datta. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var waterBar: UIProgressView!
    @IBOutlet weak var glassStepper: UIStepper!
    
    let glassManager = GlassManager()
    let db = Firestore.firestore()
    
    var current: Float = 0.0
    var percent: Float = 0.0
    // get goal from settings
    var goal: Float = GlassManager.sharedInstance.currentGoal
    
    var date = Date()
    var currentDateString: String = ""
    
    var goalComplete: Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        // reload view every time it is clicked on
        // iniatialize progressbar and stepper values with new (possibly changed) currentGoal value
        
        // setGoalItems(goal: GlassManager.sharedInstance.currentGoal, currentValue: current)
        
        // handle date
        date = Date()
        let df = DateFormatter()
        df.dateFormat = "MM-dd-yyyy"
        currentDateString = df.string(from: date)
        //print(datestring)

        loadGoalData()
        loadMainData(currentDateString)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // making progress bar vertical and increasing width
        waterBar.transform = waterBar.transform.rotated(by: 270 * .pi / 180)
        waterBar.transform = waterBar.transform.scaledBy(x: 1.8, y: 100)

    }
    
    @IBAction func glassesStepper(_ sender: UIStepper) {
        // change current value based on stepper
        current = Float(sender.value)
        
        currentLabel.text = String(format: "%.0f/%.0f", current, goal)
            
        // progress bar and percent progression
        percent = current / goal
        waterBar.setProgress(percent, animated: true)
        
        // limit percent to 999%
        if percent * 100 < 1000 {
            percentLabel.text = String(format: "%.0f", percent * 100) + "%"
        } else {
            percentLabel.text = "999%"
        }
        
        // complete daily goal
        if percent >= 1.0 {
            goalComplete = true
            storeGoalCompleteDate(forDate: currentDateString)
        } else {
            // TODO: delete storegoalcompletedate
        }
        
        sendCurrentValue(current, currentDateString, goalComplete)
    }
    
}


// MARK: - Firestore
extension HomeViewController {
    func sendCurrentValue(_ current: Float, _ date: String, _ goalComplete: Bool) {
        if let currentUser = Auth.auth().currentUser?.email {
            db.collection(K.firebase.mainDataCollection).document(currentUser).collection(date).document(K.firebase.secondDocField).setData([
                K.firebase.currentCountField: current,
                K.firebase.dateStringField: date,
                K.firebase.isGoalComplete: goalComplete
            ])
        }
    }
    
    func storeGoalCompleteDate(forDate date: String) {
        if let currentUser = Auth.auth().currentUser?.email {
            db.collection(K.firebase.mainDataCollection).document(currentUser).setData([
                "dates" : FieldValue.arrayUnion([date])
            ])
        }
    }
    
    // get goals and glass size settings
    func loadGoalData() {
        if let currentUser = Auth.auth().currentUser?.email{
            db.collection(K.firebase.settingsCollection).document(currentUser).getDocument { (documentSnapshot, error) in
                if let e = error {
                    print("\(e)")
                } else {
                    if let document = documentSnapshot {
                        let data = document.data()
                        
                        if let currentGoal = data?["goal"] as! Float?{
                            DispatchQueue.main.async {
                                self.setGoalItems(goal: currentGoal, currentValue: self.current)
                            }
                            
                            self.goal = currentGoal
                        }
                    }
                }
            }
        }
    }
    
    // load consumption values by current date
    func loadMainData(_ date: String) {
        if let currentUser = Auth.auth().currentUser?.email{
            
            db.collection(K.firebase.mainDataCollection).document(currentUser).collection(date).document(K.firebase.secondDocField).getDocument { (documentSnapshot, error) in
                if let e = error {
                    print("\(e)")
                } else {
                    if let document = documentSnapshot {
                        let data = document.data()
                        
                        if let currentValue = data?["currentCount"] as! Float? {
                            // current
                            //print(currentValue)
                            DispatchQueue.main.async {
                                self.setGoalItems(goal: self.goal, currentValue: currentValue)
                            }
                            
                            self.current = currentValue
                        }
                    }
                }
            }
        }
    }
}


// MARK: - Reusable Methods
extension HomeViewController {
    func setGoalItems(goal: Float, currentValue: Float) {
                
        percent = currentValue / goal
        waterBar.setProgress(percent, animated: true)
        glassStepper.value = Double(currentValue)
        
        if percent * 100 < 1000 {
            percentLabel.text = String(format: "%.0f", percent * 100) + "%"
        } else {
            percentLabel.text = "999%"
        }
        // set goal and number of glasses consumed today here
        goalLabel.text = String(format: "Current Daily Goal: %.0f glasses", goal)
        currentLabel.text = String(format: "%.0f/%.0f", currentValue, goal)
    }
}
