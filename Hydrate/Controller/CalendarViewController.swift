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

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalCompleteLabel: UILabel!
    
    @IBOutlet weak var goalPercent: UILabel!
    @IBOutlet weak var goalPercentProgressBar: UIProgressView!
    
    let db = Firestore.firestore()
    var dateArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calendar.delegate = self
        calendar.dataSource = self
        
        // Progress bar styling
//        goalPercentProgressBar.transform = goalPercentProgressBar.transform.scaledBy(x: 8, y: 2)
        goalPercentProgressBar.layer.cornerRadius = 8
        goalPercentProgressBar.clipsToBounds = true
        goalPercentProgressBar.layer.sublayers![1].cornerRadius = 8
        goalPercentProgressBar.subviews[1].clipsToBounds = true
        
        getDates()
    }
}

// MARK: - FSCalendar
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
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


extension CalendarViewController {
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
                    
                    if let goal = data?[K.firebase.dailyGoalField] as! Float? {
                        if let currentGoal = data? [K.firebase.currentCountField] as! Float? {
                            let percent = (currentGoal / goal)
                            DispatchQueue.main.async {
                                self.goalPercentProgressBar.setProgress(percent, animated: true)
                                self.goalPercent.text = String(format: "Goal %.0f% Complete", percent * 100) + "%"
                            }
                        }
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.goalLabel.text = "Consumption: 0 glasses"
                        self.goalCompleteLabel.text = "Goal Incomplete"
                        self.goalCompleteLabel.textColor = UIColor.red
                        
                        self.goalPercentProgressBar.setProgress(0.0, animated: true)
                        self.goalPercent.text = "Goal 0% Complete"
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
