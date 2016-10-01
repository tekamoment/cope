//
//  EmailSignupViewController.swift
//  Cope
//
//  Created by Carlos Arcenas on 9/28/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit
import Eureka

class EmailSignupViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = super.tableView
        
        form = Form()
        
        form +++ Section()
            <<< EmailRow() { row in
                row.title = "Email"
            }
            <<< PasswordRow() { row in
                row.title = "Password"
            }
            <<< PasswordRow() { row in
                row.title = "Re-type password"
            }
            <<< SwitchRow() { row in
                row.title = "Receive updates from Cope"
                // specialize this per language
                // as in emails will be set to a language-specific mailing list
            }
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
