//
//  SymptomsViewController.swift
//  Cope
//
//  Created by Carlos Arcenas on 9/20/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit

class SymptomsViewController: UIViewController, SurveyViewControllerDelegate {

    @IBOutlet weak var checkInButton: UIButton!
    
    var resultsData: [(String, Float)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    func surveyFinished(withResults: [(String, Float)]) {
        // dismiss here.
        self.navigationController!.dismiss(animated: true, completion: nil)
        resultsData = withResults
        print(resultsData)
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

