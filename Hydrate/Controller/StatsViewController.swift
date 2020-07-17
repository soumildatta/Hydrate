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
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        calendar.delegate = self
        calendar.dataSource = self
    }
}

// MARK: - FSCalendar
extension StatsViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    // getting the current device time and date
//    let date = Date()
//    let df = DateFormatter()
//    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
//    let dateString = df.string(from: date)
//    print(dateString)
    
    // https://stackoverflow.com/questions/52218935/fscalendar-event-dots-not-showing
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let datestring = formatDate(date)
        
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let datestring = formatDate(date)
        
        if let currentUser = Auth.auth().currentUser?.email {
            db.collection(K.firebase.mainDataCollection).document(currentUser).collection(datestring).document("items").getDocument { (document, error) in
                if let document = document, document.exists {
                    print("yes")
                } else {
                    print("no")
                }
            }
        }
        
        // formatted conforming to stored format
        print(datestring)
    }
}

// MARK: - Reusable methods
extension StatsViewController {
    func formatDate(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "MM-dd-yyyy"
        let datestring = df.string(from: date)
        
        return datestring
    }
}
