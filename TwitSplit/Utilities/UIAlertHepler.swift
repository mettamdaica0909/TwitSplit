//
//  UIAlertHepler.swift
//  TwitSplit
//
//  Created by Mettamdaica on 2/4/18.
//  Copyright © 2018 Mettamdaica. All rights reserved.
//

import UIKit

public typealias HandleAlertAction = (_ alertAction: UIAlertAction, _ index: Int) -> Void

class UIAlertHepler {
    @discardableResult
    public static func alertController(title: String?, message: String?, cancel: String?, others: [String]?, handleAction: HandleAlertAction?) -> UIAlertController {
        
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let actionCancel = UIAlertAction.init(title: cancel, style: .cancel) { (action) in
            if(handleAction == nil) {
                return
            }
            handleAction!(action, 0)
        }
        alertVC.addAction(actionCancel)
        
        if others != nil {
            for (index, title) in others!.enumerated() {
                let action = UIAlertAction.init(title: title, style: .default, handler: { (action) in
                    
                    if handleAction == nil {
                        return
                    }
                    handleAction!(action, index + 1)
                })
                alertVC.addAction(action)
            }
        }
        return alertVC
    }
}
