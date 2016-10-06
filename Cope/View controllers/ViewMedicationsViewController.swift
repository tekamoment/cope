//
//  ViewMedicationsViewController.swift
//  Cope
//
//  Created by Carlos Arcenas on 10/5/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit

class ViewMedicationsViewController: UIViewController {
    
    var medication: Medication!
    
    @IBOutlet weak var medicineNameLabel: UILabel!
    @IBOutlet weak var dosageLabel: UILabel!
    @IBOutlet weak var dosageTimeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
