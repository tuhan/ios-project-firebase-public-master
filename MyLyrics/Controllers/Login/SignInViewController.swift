//
//  SignInViewController.swift
//  MyLyrics
//
//  Created by Mudith Chathuranga on 3/18/19.
//  Copyright © 2019 chathuranga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var useremail: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        //GIDSignIn.sharedInstance().signIn()
        // Do any additional setup after loading the view.
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            print(error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                print(error)
                let alert = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            self.dismiss(animated: true, completion: nil)
            print(authResult!.user.email!)
            // User is signed in
            // ...
        }

    }
    
    @IBAction func userCustomLogin(_ sender: Any) {
        Auth.auth().signIn(withEmail: self.useremail.text!, password: self.password.text!) { [weak self] user, error in
            guard let strongSelf = self else { return }
            if error != nil {
                let alert = UIAlertController(title: "Login Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                strongSelf.present(alert, animated: true, completion: nil)
            } else {
                strongSelf.dismiss(animated: true, completion: nil)
            }

            // ...
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
