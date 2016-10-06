//
//  DatabaseConstants.swift
//  Cope
//
//  Created by Carlos Arcenas on 9/30/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import Foundation
import Firebase

struct DatabaseConstants {
    static let surveyData = "survey-data"
    static let medications = "medications"
    static let users = "users"
    
    static func fetchDataForMonth(userID: String, year: Int, month: Int, completion: @escaping (_: FIRDataSnapshot) -> Void) {
        FIRDatabase.database().reference().child(DatabaseConstants.users).child(userID).child(DatabaseConstants.surveyData).child(String(year)).child(String(month)).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot)
        }
    }
    
    static func fetchDataForDate(userID: String, year: Int, month: Int, day: Int, completion: @escaping (_: FIRDataSnapshot) -> Void) {
        FIRDatabase.database().reference().child(DatabaseConstants.users).child(userID).child(DatabaseConstants.surveyData).child(String(year)).child(String(month)).child(String(day)).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot)
        }
    }
    
//    static func fetchMedicineData
    static func fetchMedication(userID: String, completion: @escaping (_: FIRDataSnapshot) -> Void) {
        FIRDatabase.database().reference().child(DatabaseConstants.users).child(userID).child(DatabaseConstants.medications).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot)
        }
    }
    
}
