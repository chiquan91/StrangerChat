//
//  AppDelegate.swift
//  StrangerChat
//
//  Created by Hoang Chi Quan on 1/24/17.
//  Copyright © 2017 SmartApps. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setup()
        return true
    }

    // MARK: - Privates
    
    private func setup() {
        setupFirebase()
    }
    
    private func setupFirebase() {
        FIRApp.configure()
    }

}

