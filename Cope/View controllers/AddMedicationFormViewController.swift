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
        
        form +++ Section() { section in
                section.footer = {
                    var footer = HeaderFooterView<UIView>(.callback({
                    let view = UIView()
                    return view
                    }))
                    footer.height = { 0 }
                    return footer
                }()
            }
            <<< TextRow() { row in
                row.title = "Medicine Name"
            }
            // frequency
            <<< SwitchRow() { row in
                row.title = "Reminder"
            }
            <<< IntRow() { row in
                row.title = "Dosage"
                row.placeholder = "Optional"
            }
            <<< PickerRow<String>() { row in
                row.title = "Frequency"
                row.options = ["Per Day", "Per Week", "Per Interval"]
                row.tag = "frequency"
            }
    }
}
