//
//  ViewController.swift
//  TwitSplit
//
//  Created by Mettamdaica on 1/30/18.
//  Copyright © 2018 Mettamdaica. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var inputTextView: RSKGrowingTextView!
    
    @IBOutlet weak var inputTextViewBottomConstraint: NSLayoutConstraint!
    @IBAction func btnSend(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Keyboard Notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // setup inputTextview
        inputTextView.placeholder = "Enter text here....."
        inputTextView.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        inputTextViewBottomConstraint.constant = keyboardFrame.size.height + 10
        UIView.animate(withDuration: 0.2, animations: {
          self.view.layoutIfNeeded()
        })

    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        inputTextViewBottomConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
}

