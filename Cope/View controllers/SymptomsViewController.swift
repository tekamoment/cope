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

    @IBOutlet weak var checkInButton: UIButton!
    let userID = "tester"
    let surveyData = DatabaseConstants.surveyData
    var todayDataRef: FIRDatabaseReference?
    
    var resultsData: [String: (String, Float)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController!.title = NSLocalizedString("symptoms", comment: "Symptoms")
        
        // deconstruct device day
        let today = Date()
        let usedCalendar = Calendar(identifier: .gregorian)
        let dateComponents = (usedCalendar as NSCalendar).components([.year, .month, .day], from: today)
        
        // send over to firebase
        todayDataRef = FIRDatabase.database().reference().child("users").child(userID).child(surveyData).child(String(describing: dateComponents.year!)).child(String(describing: dateComponents.month!)).child(String(describing: dateComponents.day!))
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController!.title = NSLocalizedString("symptoms", comment: "Symptoms")
        todayDataRef!.observe(FIRDataEventType.value) { (snapshot : FIRDataSnapshot) in
            if snapshot.exists() {
                self.checkInButton.isHidden = true
            } else {
                debugPrint("This day doesn't exist.")
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
        for (category, answer) in withResults {
            todayDataRef!.child(category).setValue(answer.0)
            weightedAverage = weightedAverage + Double(answer.1)
        }
        weightedAverage = weightedAverage / Double(withResults.count)
        todayDataRef!.child("score").setValue(weightedAverage)
        // include timestamp
        
        // send over to firebase
        // set value on data ref
        

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

