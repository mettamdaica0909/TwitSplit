//
//  StringExtension.swift
//  TwitSplit
//
//  Created by Mettamdaica on 2/2/18.
//  Copyright © 2018 Mettamdaica. All rights reserved.
//

import UIKit

extension String {
    // MARK: check input
    // If the message contains a span of non-whitespace characters longer than 50 characters return false
    func isInputMessageValid() -> Bool {
        let inputMessageArr = self.split(separator: " ")
        for word in inputMessageArr {
            if String(word).count > 50 {
                return false
            }
        }
        return true
    }
}
