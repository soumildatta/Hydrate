//
//  ProfileViewController.swift
//  Hydrate
//
//  Created by Soumil Datta on 5/21/20.
//  Copyright © 2020 Soumil Datta. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class SettingsViewController: UIViewController {

    @IBOutlet weak var glassSizePicker: UIPickerView!
    @IBOutlet weak var setGoalLabel: UILabel!
    @IBOutlet weak var setGoalStepper: UIStepper!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    let glassManager = GlassManager()
    let db = Firestore.firestore()
    
    let center = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        glassSizePicker.dataSource = self
        glassSizePicker.delegate = self

        // initialize stepper value
        setGoalStepper.value = Double(glassManager.currentGoal)
        
        loadData()
        
        // create daily notification
        createNotification()
    }
    
    @IBAction func setGoal(_ sender: UIStepper) {
        setGoalLabel.text = "\(Int(sender.value)) glasses /day"
    }
    
    typealias AlertMethodHandler = () -> Void
    typealias AlertMethodHandlerNo = () -> Void
    // reusable alert method
    func presentAlert(title titleString:String, message messageString:String, alertYesClicked:@escaping AlertMethodHandler) {
        let alert = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: {action in
            DispatchQueue.main.async {
                self.notificationSwitch.isOn = true
            }
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            alertYesClicked()
        }))

        self.present(alert, animated: true)
    }
    
    @IBAction func notificationSwitchChanged(_ sender: UISwitch) {
        if(sender.isOn) {
            presentAlert(title: "Are you sure you want to turn on daily notifications?", message: "The app will send you a notification daily at 6pm to remind you to drink water") {
                self.authorizeNotifications()
            }
        } else {
            presentAlert(title: "Disable notifications from settings", message: "You will be taken into the system settings for this app, where you can change the notification preferences. Are you sure you want to continue?") {
                if let aString = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(aString, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    @IBAction func applyChanges(_ sender: UIButton) {
        GlassManager.sharedInstance.currentGoal = Float(setGoalStepper.value)
        
        // store changes in firebase
        storeChanges(dailyGoal: setGoalStepper.value, glassSize: glassSizePicker.selectedRow(inComponent: 0), notificationOption: notificationSwitch.isOn)
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            // pop to root, which is login view
            view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}


// MARK: - UIPickerView
extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // TODO
        // print(glassManager.glassSizes[row])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // the number of columns
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return glassManager.glassSizes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return glassManager.glassSizes[row] + "oz"
    }
    
}


// MARK: - Firebase
extension SettingsViewController {
    func loadData() {
        if let currentUser = Auth.auth().currentUser?.email {
            db.collection(K.firebase.settingsCollection).document(currentUser).getDocument { (document, error) in
                if let document = document, document.exists {
                    //set values
                    if let goalValue = document[K.firebase.dailyGoalField] {
                        DispatchQueue.main.async {
                            self.setGoalStepper.value = goalValue as! Double
                            self.setGoalLabel.text = "\(goalValue as! Int) glasses /day"
                        }
                    }
                    
                    if let glassSizeRow = document[K.firebase.glassSizeField] {
                        DispatchQueue.main.async {
                            self.glassSizePicker.selectRow(glassSizeRow as! Int, inComponent: 0, animated: true)
                        }
                    }
                    
                    if let notificationOption = document[K.firebase.notificationStatusField] {
                        DispatchQueue.main.async {
                            self.notificationSwitch.isOn = notificationOption as! Bool
                        }
                    }
                    
                } else {
                    print("Settings do not currently exist")
                }
            }
        }
    }
    
    func storeChanges(dailyGoal:Double, glassSize:Int, notificationOption:Bool) {
        if let currentUser = Auth.auth().currentUser?.email {
            db.collection(K.firebase.settingsCollection).document(currentUser).setData([
                K.firebase.dailyGoalField: dailyGoal,
                K.firebase.glassSizeField: glassSize,
                K.firebase.notificationStatusField: notificationOption,
                K.firebase.currentUserField: currentUser
            ]) { (error) in
                if let e = error {
                    print("Error saving settings, \(e)")
                } else {
                    print("Settings saved successfully")
                }
            }
        }
    }
}

// MARK: - Notification initialization
extension SettingsViewController {
    func createNotification() {
        // create notification content
        let content = UNMutableNotificationContent()
        content.title = "Daily Hydrate Reminder"
        content.body = "Don't forget to log your consumption and complete your daily goal!"
        
        // create notification trigger
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = 18
        
        // testing notifications
        //        let date = Date().addingTimeInterval(10)
        //        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // create the request
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: nil)
    }
    
    func authorizeNotifications() {
        center.requestAuthorization(options: [.alert, .sound], completionHandler: {(granted, err)  in
            // notification access granted or denied
            // present alert if denied
            if(!granted) {
                DispatchQueue.main.async {
                    let notifDenied = UIAlertController(title: "Notifications not allowed on this device", message: "If you change your mind later, you can change the notification preferences from the system settings for the app.", preferredStyle: .alert)
                    notifDenied.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                    self.present(notifDenied, animated: true)
                }
            }
        })
    }
}
