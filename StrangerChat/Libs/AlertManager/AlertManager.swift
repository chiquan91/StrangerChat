//
//  AlertManager.swift
//  Rize
//
//  Created by Hoang Chi Quan on 11/18/16.
//  Copyright © 2016 Vmodev. All rights reserved.
//

import UIKit

class AlertManager: NSObject {
    class func alert(with title: String? = nil, message: String? = nil, buttons: [String], completed:((_ index: Int) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        if buttons.count == 1 {
            alert.addAction(UIAlertAction(title: buttons[0], style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
                completed?(0)
            }))
        } else if buttons.count > 1 {
            for (index, title) in buttons.enumerated() {
                alert.addAction(UIAlertAction(title: title, style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                    completed?(index)
                }))
            }
        }
        ViewControllerManager.topViewController()?.present(alert, animated: true, completion: nil)
    }

}
