//
//  StatsViewController.swift
//  Hydrate
//
//  Created by Soumil Datta on 6/8/20.
//  Copyright © 2020 Soumil Datta. All rights reserved.
//

import UIKit
import FSCalendar

class StatsViewController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        calendar.delegate = self
        calendar.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        let df = DateFormatter()
        df.dateFormat = "dd"
        let datestring = df.string(from: date)
        //print(datestring)
        
        
        // testing - events on even days
        if(Int(datestring)! % 2 == 0) {
            return 1
        }
        
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {

//        cell.numberOfEvents = 1
        //print(cell.numberOfEvents)
    }
}
