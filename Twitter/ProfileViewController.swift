//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Bryan Santos on 2/27/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    
    var currentUser = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
    }
    
    func getUser() {
        let endPointURL = "https://api.twitter.com/1.1/account/verify_credentials.json"
        let endPointParams = ["include_email": false]
        TwitterAPICaller.client?.getDictionaryRequest(url: endPointURL, parameters: endPointParams, success: { (user: NSDictionary) in
            
            let profileURL = user["profile_image_url_https"] as! String
            let backgroundURL = user["profile_banner_url"] as! String
            
            self.profileImage.setImageWith(URL(string: profileURL.replacingOccurrences(of: "_normal", with: "") )!)
            self.profileImage.layer.cornerRadius = 40
            self.profileImage.layer.borderWidth = 3
            self.profileImage.layer.borderColor = UIColor.white.cgColor
            
            self.backgroundImage.setImageWith(URL(string: backgroundURL)!)
            
            self.displayNameLabel.text = user["name"] as? String
            self.userNameLabel.text = "@\(user["screen_name"] ?? "")"
            self.descriptionLabel.text = user["description"] as? String
            
            self.tweetCountLabel.text = "\(user["statuses_count"] ?? "")"
            self.followingCountLabel.text = "\(user["friends_count"] ?? "")"
            self.followersCountLabel.text = "\(user["followers_count"] ?? "")"
            
        }, failure: { Error in
            print("Could not retrieve user.")
            print(Error.localizedDescription)
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
