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
    static let lastSurvey = "last-survey"
    static let surveyTimeLocale = "en_US_POSIX"
    static let surveyTimeStorageFormat = "yyyy-MM-dd'T'HH:mmZZZZZ"
    static let score = "score"
    
    static func userDataDatabaseReference(userID: String) -> FIRDatabaseReference {
        return FIRDatabase.database().reference().child(DatabaseConstants.users).child(userID)
    }
    
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
    
    // NEW IMPLEMENTATION
    static func fetchSurveyDataForDay(userID: String, year: Int, month: Int, day: Int, completion: @escaping (_: FIRDataSnapshot) -> Void) {
        var startComponents = DateComponents()
        startComponents.timeZone = TimeZone(abbreviation: "GMT")
        
        startComponents.year = year
        startComponents.month = month
        startComponents.day = day

        let startDate = Calendar(identifier: .gregorian).date(from: startComponents)!
        
        var endComponents = DateComponents()
        endComponents.timeZone = TimeZone(abbreviation: "GMT")
        endComponents.day = 1
        
        let endDate = Calendar(identifier: .gregorian).date(byAdding: .day, value: 1, to: startDate)!
    
        DatabaseConstants.fetchSurveyDataForTimePeriod(userID: userID, start: startDate, end: endDate, completion: completion)
    }
    
    static func fetchSurveyDataForMonth(userID: String, year: Int, month: Int, completion: @escaping(_: FIRDataSnapshot) -> Void) {
        var startComponents = DateComponents()
        startComponents.timeZone = TimeZone(abbreviation: "GMT")
        
        startComponents.year = year
        startComponents.month = month
        startComponents.day = 1
        
        let startDate = Calendar(identifier: .gregorian).date(from: startComponents)!
        
        var endComponents = DateComponents()
        endComponents.timeZone = TimeZone(abbreviation: "GMT")
        endComponents.month = 1
        endComponents.day = -1
        
        let endDate = Calendar(identifier: .gregorian).date(byAdding: endComponents, to: startDate)!
        
        DatabaseConstants.fetchSurveyDataForTimePeriod(userID: userID, start: startDate, end: endDate, completion: completion)
    }
    
    static func fetchSurveyDataForTimePeriod(userID: String, start: Date, end: Date, completion: @escaping (_: FIRDataSnapshot) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: DatabaseConstants.surveyTimeLocale)
        dateFormatter.dateFormat = DatabaseConstants.surveyTimeStorageFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        
        DatabaseConstants.userDataDatabaseReference(userID: userID).child(DatabaseConstants.surveyData).queryOrderedByKey().queryStarting(atValue: dateFormatter.string(from: start)).queryEnding(atValue: dateFormatter.string(from: end)).observe(FIRDataEventType.value) { (snapshot: FIRDataSnapshot) in
            completion(snapshot)
        }
    }
    
    
//    static func fetchMedicineData
    static func fetchMedication(userID: String, completion: @escaping (_: FIRDataSnapshot) -> Void) {
        FIRDatabase.database().reference().child(DatabaseConstants.users).child(userID).child(DatabaseConstants.medications).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot)
        }
    }
    
    static func userID() -> String {
        return "tester"
    }
    
    static func lengthOfTestIntervalInHours() -> Double {
        return 6.0
    }
}
