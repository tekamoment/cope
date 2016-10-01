//
//  LoginViewController.swift
//  Cope
//
//  Created by Carlos Arcenas on 9/28/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import TwitterKit
import FirebaseAuth

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func connectWithFacebookPressed(_ sender: AnyObject) {
        let manager = FBSDKLoginManager()
        manager.logIn(withReadPermissions: ["public_profile"],
                      from: self) { (result, error) in
                        if (error != nil) {
                            let okayAction = UIAlertAction(title: NSLocalizedString("error-okay", comment: "Error for Okay string."), style: UIAlertActionStyle.default, handler: nil)
                            let alertController = UIAlertController(title: NSLocalizedString("error", comment: "Error occurred."), message: NSLocalizedString("error-facebookLoginMessage", comment: "Error message for Facebook Login"), preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(okayAction)
                            self.present(alertController, animated: true, completion: nil)
                        } else if (result?.isCancelled)! {
                            
                        } else {
                            self.signInWithCredential(credential: (FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)))
                        }
        }
    }

    @IBAction func connectWithTwitterPressed(_ sender: AnyObject) {
        Twitter.sharedInstance().logIn(with: self) { (session, error) in
            if (error != nil) {
                let okayAction = UIAlertAction(title: NSLocalizedString("error-okay", comment: "Error for Okay string."), style: UIAlertActionStyle.default, handler: nil)
                let alertController = UIAlertController(title: NSLocalizedString("error", comment: "Error occurred."), message: NSLocalizedString("error-twitterLoginMessage", comment: "Error message for Twitter Login"), preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
            if (session != nil) {
                self.signInWithCredential(credential: FIRTwitterAuthProvider.credential(withToken: session!.authToken, secret: session!.authTokenSecret))
            }
            
            // do shit here
        }
    }
    
    @IBAction func createAnAccountWithEmailPressed(_ sender: AnyObject) {
        // handoff
    }
    
    func signInWithCredential(credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            // do shit here
            // call up main storyboard here
        })
        
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
