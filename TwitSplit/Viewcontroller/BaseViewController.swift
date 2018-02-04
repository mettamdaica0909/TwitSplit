//
//  BaseViewController.swift
//  TwitSplit
//
//  Created by Mettamdaica on 2/4/18.
//  Copyright © 2018 Mettamdaica. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register Keyboard Notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // add dismiss keyboard gesture
        self.view.addDismissKeyboardGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        //MARK: - Overridding
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //MARK: - Overridding
    }

}
