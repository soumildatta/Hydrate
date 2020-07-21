//
//  StatsViewController.swift
//  Hydrate
//
//  Created by Soumil Datta on 6/8/20.
//  Copyright © 2020 Soumil Datta. All rights reserved.
//

import UIKit
import FSCalendar
import Firebase

class StatsViewController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalCompleteLabel: UILabel!
    
    let db = Firestore.firestore()
    var dateArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calendar.delegate = self
        calendar.dataSource = self
        
        getDates()
    }
}

// MARK: - FSCalendar
extension StatsViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    // https://stackoverflow.com/questions/52218935/fscalendar-event-dots-not-showing
    
    // implement this later
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let datestring = formatDate(date)
                
        // currently only works after switching months
        if(dateArray.contains(datestring)) {
//            print("true")
            return 1
        } else {
//            print("false")
//            print(dateArray)
//            print(datestring)
            return 0
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectedDate = formatDate(date)
        retrieveDateData(forDate: selectedDate)
    }
}


extension StatsViewController {
    // MARK: - Firebase methods
    func retrieveDateData(forDate date: String) {
        if let currentUser = Auth.auth().currentUser?.email {
            db.collection(K.firebase.mainDataCollection).document(currentUser).collection(date).document(K.firebase.secondDocField).getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    
                    if let currentGoal = data?[K.firebase.currentCountField] as! Float? {
                        DispatchQueue.main.async {
                            self.goalLabel.text = String(format: "Consumption: %.0f glasses", currentGoal)
                        }
                    }
                    
                    if let goalComplete = data?[K.firebase.isGoalComplete] {
                        if goalComplete as! Bool {
                            DispatchQueue.main.async {
                                self.goalCompleteLabel.text = "Goal Complete!"
                                self.goalCompleteLabel.textColor = UIColor.init(red: 0.0078, green: 0.6078, blue: 0, alpha: 1)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.goalCompleteLabel.text = "Goal Incomplete"
                                self.goalCompleteLabel.textColor = UIColor.red
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.goalLabel.text = "Consumption: 0 glasses"
                        self.goalCompleteLabel.text = "Goal Incomplete"
                        self.goalCompleteLabel.textColor = UIColor.red
                    }
                }
            }
        }
    }
    
    
    // fix in the future
    func getDates() {
        if let currentUser = Auth.auth().currentUser?.email {
            db.collection(K.firebase.mainDataCollection).document(currentUser).getDocument { (documentSnapshot, error) in
                if let e = error {
                    print("\(e)")
                } else {
                    if let document = documentSnapshot {
                        let data = document.data()
                        
                        if let dates = data?["dates"] as! [String]?{
                            // print(dates)
                            self.dateArray = dates
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK: - Reusable methods
    func formatDate(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "MM-dd-yyyy"
        let datestring = df.string(from: date)
        
        return datestring
    }
}
