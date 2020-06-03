//
//  GlassManager.swift
//  Hydrate
//
//  Created by Soumil Datta on 5/24/20.
//  Copyright © 2020 Soumil Datta. All rights reserved.
//

import Foundation
import Firebase

struct GlassManager {
    // use singleton
    static var sharedInstance = GlassManager()
    let db = Firestore.firestore()
    
    var currentGoal: Float = 8
    let glassSizes: [String] = ["4", "6", "8", "9", "10", "12", "14", "16"]
    
    func loadGoal() -> Float {
        var goal: Float = 8
        
        if let currentUser = Auth.auth().currentUser?.email {
            db.collection(K.firebase.settingsCollection).document(currentUser).getDocument { (document, error) in
                if let items = document {
                    if let goalValue = items[K.firebase.dailyGoalField] {
                        goal = goalValue as! Float
                    }
                }
            }
        }
        
        return goal
    }
}
