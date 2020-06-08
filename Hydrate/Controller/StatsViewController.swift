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
extension StatsViewController: FSCalendarDelegate {
    
    // getting the current device time and date
//    let date = Date()
//    let df = DateFormatter()
//    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
//    let dateString = df.string(from: date)
//    print(dateString)
    
}
