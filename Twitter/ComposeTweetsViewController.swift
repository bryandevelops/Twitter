//
//  ComposeTweetsViewController.swift
//  Twitter
//
//  Created by Bryan Santos on 2/26/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class ComposeTweetsViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var countLabelView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.cornerRadius = 25
        textView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        textView.text = "What's happening?"
        textView.textColor = UIColor.lightGray
        textView.becomeFirstResponder()
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)

    }
    // Show the placeholder text whenever the text view is empty, even if the text view’s selected
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let strLength = textView.text.count
        let lngthToAdd = text.count
        let lengthCount = strLength + lngthToAdd
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.text = "What's happening?"
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            if (textView.textColor == UIColor.lightGray) {
                self.countLabelView.text = "\(0) / 280"
            }
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
         else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
             
            self.countLabelView.text = "\(1) / 280"
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            if (textView.textColor == UIColor.lightGray) {
                self.countLabelView.text = "\(0) / 280"
            } else {
                self.countLabelView.text = "\(lengthCount) / 280"
            }
            
            if lengthCount > 280 {
                self.countLabelView.textColor = UIColor.red
            } else {
                self.countLabelView.textColor = UIColor.black
            }
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
           return false
    }

    // Prevent the user from changing the position of the cursor while the placeholder's visible
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweet(_ sender: Any) {
        // Create an alert that will be used if the tweet is empty and can't be posted
        let emptyAlert = UIAlertController(title: "Alert", message: "Your tweet is empty.", preferredStyle: .alert)
        let tooLongAlert = UIAlertController(title: "Alert", message: "Your tweet is too long.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        
        if (!textView.text.isEmpty && textView.text.count <= 280) {
            TwitterAPICaller.client?.postTweet(tweetString: textView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { Error in
                print("Could not post tweet.")
                print(Error.localizedDescription)
                emptyAlert.addAction(OKAction)
                self.present(emptyAlert, animated: true, completion: nil) // Call the alert
            })
        } else {
            tooLongAlert.addAction(OKAction)
            self.present(tooLongAlert, animated: true, completion: nil)
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
