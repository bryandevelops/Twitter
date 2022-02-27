//
//  TweetsTableViewCell.swift
//  Twitter
//
//  Created by Bryan Santos on 2/24/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetsTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    
    var favorited:Bool = false
    var retweeted:Bool = false
    var tweetID:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onFavorite(_ sender: Any) {
        if (favorited) {
            TwitterAPICaller.client?.destroyFavorite(tweetID: tweetID, success: {
                self.setFavorite(false)
            }, failure: { Error in
                print("Could not unfavorite.")
                print(Error.localizedDescription)
            })
        } else {
            TwitterAPICaller.client?.postFavorite(tweetID: tweetID, success: {
                self.setFavorite(true)
            }, failure: { Error in
                print("Could not favorite.")
                print(Error.localizedDescription)
            })
        }
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        if (retweeted) {
            TwitterAPICaller.client?.destroyRetweet(tweetID: tweetID, success: {
                self.setRetweet(false)
            }, failure: { Error in
                print("Could not unretweet.")
                print(Error.localizedDescription)
            })
        } else {
            TwitterAPICaller.client?.postRetweet(tweetID: tweetID, success: {
                self.setRetweet(true)
            }, failure: { Error in
                print("Could not retweet.")
                print(Error.localizedDescription)
            })
        }
    }
    
    func setFavorite(_ isFavorited:Bool) {
        favorited = isFavorited
        if (favorited) {
            favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
            favoriteButton.imageEdgeInsets = UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0)
        } else {
            favoriteButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
            favoriteButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 3, right: 0)
        }
    }
    
    func setRetweet(_ isRetweeted:Bool) {
        retweeted = isRetweeted
        if (retweeted) {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
        } else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
        }
    }
}
