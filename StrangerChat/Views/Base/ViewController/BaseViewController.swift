//
//  BaseViewController.swift
//  MVVMExample
//
//  Created by CYTECH on 2/26/16.
//  Copyright © 2016 vmodev.com. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Vars

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        print("deinit: ", self)
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - Setups

extension UIViewController {
    func setupDefaultBackground() {
        let background = UIImageView(image: #imageLiteral(resourceName: "bg1"))
        background.frame = UIScreen.main.bounds
        background.contentMode = .scaleToFill
        view.addSubview(background)
        view.sendSubview(toBack: background)
    }
}

