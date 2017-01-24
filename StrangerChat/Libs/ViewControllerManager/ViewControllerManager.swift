//
//  ViewControllerManager.swift
//  Rize
//
//  Created by Hoang Chi Quan on 11/18/16.
//  Copyright © 2016 Vmodev. All rights reserved.
//

import UIKit

class ViewControllerManager {
    
    final class func topViewController(with root: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if root is UINavigationController {
            return topViewController(with: (root as? UINavigationController)?.visibleViewController)
        } else if root is UITabBarController {
            return topViewController(with: (root as? UITabBarController)?.selectedViewController)
        } else if let presentedViewController = root?.presentedViewController {
            return topViewController(with: presentedViewController)
        } else {
            return root
        }
    }
    
}
