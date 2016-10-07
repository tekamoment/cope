//
//  SymptomsViewController.swift
//  Cope
//
//  Created by Carlos Arcenas on 9/20/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit
import Firebase

class SymptomsViewController: UIViewController, SurveyViewControllerDelegate {

    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var checkInButton: UIButton!
    let userID = "tester"
    let surveyData = DatabaseConstants.surveyData
    var todayDataRef: FIRDatabaseReference?
    
    // NEW setup
    let surveyTimeDateFormatter = DateFormatter()
    
    var resultsData: [String: (String, Float)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController!.title = NSLocalizedString("symptoms", comment: "Symptoms")
        
        // NEW setup
        todayDataRef = DatabaseConstants.userDataDatabaseReference(userID: DatabaseConstants.userID()).child(DatabaseConstants.lastSurvey)
        
        let usedLocale = Locale(identifier: "en_US_POSIX")
        surveyTimeDateFormatter.locale = usedLocale
        surveyTimeDateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        surveyTimeDateFormatter.dateFormat = DatabaseConstants.surveyTimeStorageFormat
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController!.title = NSLocalizedString("symptoms", comment: "Symptoms")

        todayDataRef!.observe(FIRDataEventType.value) { (snapshot: FIRDataSnapshot) in
            if snapshot.exists() {
                // deduct data
                let lastTestTime = self.surveyTimeDateFormatter.date(from: snapshot.value as! String)!
                if lastTestTime.timeIntervalSinceNow > Double(-60 * 60 * DatabaseConstants.lengthOfTestIntervalInHours()) {
                    // not enough time has passed.
                    self.checkInButton.isHidden = true
                    self.greetingLabel.text = "Thanks for checking in!"
                }
            } else {
                // allow survey
                debugPrint("The user has no last-survey data point yet.")
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func checkInPressed(_ sender: AnyObject) {
        let surveyViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "surveyViewController") as! SurveyViewController
        let nav = UINavigationController(rootViewController: surveyViewController)
        surveyViewController.delegate = self
        self.navigationController!.present(nav, animated: true, completion: nil)
        
    }
    
    func surveyFinished(withResults: [String: (String, Float)]) {
        // dismiss here.
        self.navigationController!.dismiss(animated: true, completion: nil)
        resultsData = withResults
        print(resultsData)
        var weightedAverage = 0.0
        
        let surveyFinishTime = surveyTimeDateFormatter.string(from: Date())
        let surveyDataRef = DatabaseConstants.userDataDatabaseReference(userID: DatabaseConstants.userID()).child(DatabaseConstants.surveyData).child(surveyFinishTime)
        
        for (category, answer) in withResults {
            surveyDataRef.child(category).setValue(answer.0)
            weightedAverage = weightedAverage + Double(answer.1)
        }
        weightedAverage = weightedAverage / Double(withResults.count)
        surveyDataRef.child("score").setValue(weightedAverage)
        
        todayDataRef!.setValue(surveyFinishTime)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

