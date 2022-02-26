//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Bryan Santos on 2/24/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetsArray = [NSDictionary]()
    var numOfTweets = 20
    let homeRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        homeRefreshControl.addTarget(self, action: #selector(getTweets), for: .valueChanged) // Fetch more tweets for table view when refreshing
        tableView.refreshControl = homeRefreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getTweets()
    }
    
    @objc func getTweets() {
        numOfTweets = 20
        let endPointURL = "https://api.twitter.com/1.1/statuses/home_timeline.json" // Endpoint URL
        let endPointParams = ["count": numOfTweets] // Additional params to be attached to the request

        TwitterAPICaller.client?.getDictionariesRequest(url: endPointURL, parameters: endPointParams, success: { (tweets: [NSDictionary]) in
            self.tweetsArray.removeAll() // Remove everything stored before storing new tweets
            for tweet in tweets {
                self.tweetsArray.append(tweet) // Append every tweet returned to us from our request
            }
            self.tableView.reloadData() // Reload table view after fetching tweets
            self.homeRefreshControl.endRefreshing() // Stop refreshing after fetching tweets
        }, failure: { Error in
            print("Could not retrieve tweets.")
            print(Error.localizedDescription)
        })
    }
    
    func getMoreTweets() {
        numOfTweets += 20
        let endPointURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let endPointParams = ["count": numOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: endPointURL, parameters: endPointParams, success: { (tweets: [NSDictionary]) in
            self.tweetsArray.removeAll() // Remove everything stored before storing new tweets
            for tweet in tweets {
                self.tweetsArray.append(tweet) // Append every tweet returned to us from our request
            }
            self.tableView.reloadData() // Reload table view after fetching tweets
        }, failure: { Error in
            print("Could not retrieve tweets.")
            print(Error.localizedDescription)
        })
    }
    
    @IBAction func onLogout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn") // Store this boolean value if the user logs out
        TwitterAPICaller.client?.logout()   // When the logout button is clicked, call the logout() function to log a user out
        self.dismiss(animated: true, completion: nil)   // Dismiss the modal view after loggin out
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetsTableViewCell
        let user = tweetsArray[indexPath.row]["user"] as! NSDictionary
        let profilePictureURL = user["profile_image_url_https"]
        
        cell.profilePicture.setImageWith(URL(string: profilePictureURL as! String)!)
        cell.profilePicture.layer.cornerRadius = 25
        cell.displayName.text = (user["name"] as! String)
        cell.userName.text = "@\(user["screen_name"] ?? "")"
        cell.tweetContent.text = (tweetsArray[indexPath.row]["text"] as! String)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetsArray.count {
            getMoreTweets()
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
