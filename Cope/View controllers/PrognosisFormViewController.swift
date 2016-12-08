//
//  PrognosisFormViewController.swift
//  Cope
//
//  Created by Carlos Arcenas on 10/24/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit
import Eureka

class PrognosisFormViewController: FormViewController {

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
                row.title = "Name"
            }
        
            <<< TextRow() { row in
                row.title = "Sex"
            }
        
            <<< IntRow() { row in
                row.title = "Age"
            }
        
            <<< TextAreaRow() { row in
                row.title = "Current diagnosis (if any)"
            }
        
            <<< TextAreaRow() { row in
                row.title = "How long have you been diagnosed?"
            }
        
            
        
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
