//
//  UIViewExtension.swift
//  TwitSplit
//
//  Created by Mettamdaica on 2/1/18.
//  Copyright © 2018 Mettamdaica. All rights reserved.
//

import UIKit

extension UIView {
    // MARK: - Keyboard
    func addDismissKeyboardGesture() {
        let tapViewGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapViewGesture.cancelsTouchesInView = true
        addGestureRecognizer(tapViewGesture)
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
}
