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
                
        if(dateArray.contains(datestring)) {
            print("true")
            return 1
        } else {
            print("false")
            print(dateArray)
            print(datestring)
            return 0
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let datestring = formatDate(date)
        
        retrieveDateData(datestring)
        
//        if(dateArray.contains(datestring)) {
//            print("true")
//        } else {
//            print("false")
//            print(dateArray)
//            print(datestring)
//        }

        // formatted conforming to stored format
//        print(datestring)
        
//        print(dateArray)
    }
}

extension StatsViewController {
    // MARK: - Firebase methods
    func retrieveDateData(_ date: String) {
        if let currentUser = Auth.auth().currentUser?.email {
            db.collection(K.firebase.mainDataCollection).document(currentUser).collection(date).document(K.firebase.secondDocField).getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    
                    if let currentGoal = data?["currentCount"] as! Float? {
                        self.goalLabel.text = String(currentGoal)
                    }
                } else {
                    self.goalLabel.text = "0"
                }
            }
        }
    }
    
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
