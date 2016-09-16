//
//  AddMedicationFormViewController.swift
//  Cope
//
//  Created by Carlos Arcenas on 9/6/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit
import Eureka

class AddMedicationFormViewController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = super.tableView
        form = Form()
        
        form +++ Section()
            <<< TextRow() { row in
                row.title = "Medicine Name"
            }
            <<< SwitchRow() { row in
                row.title = "Reminder"
            }
            <<< IntRow() { row in
                row.title = "Dosage"
                row.placeholder = "Optional"
            }
    }
}
