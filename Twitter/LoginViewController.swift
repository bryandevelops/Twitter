//
//  LoginViewController.swift
//  Twitter
//
//  Created by Bryan Santos on 2/19/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 25 // Programmatically changes the border-radius of the button.
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if isUserLoggedIn {
            self.performSegue(withIdentifier: "loginToHome", sender: self)  // Checks if the user is logged in. If they are, present the Home view
        }
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        let authURL = "https://api.twitter.com/oauth/request_token" // The POST path for Twitter API User Auth
        
        TwitterAPICaller.client?.login(url: authURL, success: {
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn") // Store this boolean value if the user logs in
            self.performSegue(withIdentifier: "loginToHome", sender: self)  // On Success, perform the segue we established between the LoginVC and the Nav Controller.
        }, failure: { Error in
            print("Login failed.") // On Failure, print this to the console.
        })
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
