//
//  Protocols.swift
//  Rize
//
//  Created by Hoang Chi Quan on 1/9/17.
//  Copyright © 2017 Vmodev. All rights reserved.
//

import UIKit

/*
Conform this protocol to make class is network handlable
*/

protocol Networking: class {
    var requests: [Request] { set get }
    func pauseAllRequest()
    func resumeAllRequest()
    func cancelAllRequest()
    func cancelRequest(request req: Request)
}

extension Networking {
    func pauseAllRequest() {
        requests.forEach({ $0.suspend() })
    }
    
    func resumeAllRequest() {
        requests.forEach { (request) in
            if request.task?.state != URLSessionTask.State.running {
                request.resume()
            }
        }
    }
    
    func cancelAllRequest() {
        requests.forEach({ $0.cancel() })
        requests.removeAll()
    }
    
    func cancelRequest(request req: Request) {
        if let index = requests.index(where: { $0.task?.taskIdentifier == req.task?.taskIdentifier }) {
            requests.remove(at: index)
        }
        req.cancel()
    }
}

enum ViewControllerType {
    case notHandle
    case none
    case root
    case child
}

enum LeftBarButtonType {
    case notHandle
    case none
    case menu
    case back
}

enum RightBarButtonType {
    case notHandle
    case none
    case menu
    case back
}

extension NSObject {
    func associatedObject<T, E>(
        base: T,
        key: UnsafePointer<UInt8>,
        initializer: () -> E)
        -> E {
            if let associated = objc_getAssociatedObject(base, key)
                as? E { return associated }
            let associated = initializer()
            objc_setAssociatedObject(base, key, associated,
                                     .OBJC_ASSOCIATION_RETAIN)
            return associated
    }
    func associateObject<T, E>(
        base: T,
        key: UnsafePointer<UInt8>,
        value: E) {
        objc_setAssociatedObject(base, key, value,
                                 .OBJC_ASSOCIATION_RETAIN)
    }
}

extension UIViewController: Networking {
    internal var requests: [Request] {
        get {
            return associatedObject(base: self, key: &Constant.requestsKey, initializer: { [] })
        }
        set {
            associateObject(base: self, key: &Constant.requestsKey, value: newValue)
        }
    }

    var viewControllerType: ViewControllerType {
        set {
            associateObject(base: self, key: &Constant.viewControllerTypeKey, value: newValue)
        }
        get {
            return associatedObject(base: self, key: &Constant.viewControllerTypeKey, initializer: { ViewControllerType.notHandle })
        }
    }
    var leftBarButtonType: LeftBarButtonType {
        set {
            associateObject(base: self, key: &Constant.leftBarButtonTypeKey, value: newValue)
        }
        get {
            return associatedObject(base: self, key: &Constant.leftBarButtonTypeKey, initializer: { LeftBarButtonType.notHandle })
        }
    }
    var rightBarButtonType: RightBarButtonType {
        set {
            associateObject(base: self, key: &Constant.rightBarButtonTypeKey, value: newValue)
        }
        get {
            return associatedObject(base: self, key: &Constant.rightBarButtonTypeKey, initializer: { RightBarButtonType.notHandle })
        }
    }
    
    // MARK: - Setups

    func setNavigation() {
        guard viewControllerType != .notHandle else { return }
        if viewControllerType != .none {
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "ic_navigation").image(with: #imageLiteral(resourceName: "ic_navigation").size), for: .default)
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.shadow()
            
        } else {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    func setupNavigation(title name: String, icon: UIImage? = nil) {
        if let naviVC = navigationController {
            naviVC.setNavigationBarHidden(false, animated: true)
            
            if icon == nil {
                let label: UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
                label.textColor = UIColor.white
                label.textAlignment = NSTextAlignment.center
                label.font = AppFonts.appSFD_Regular_Fonsize(17)
                label.adjustsFontSizeToFitWidth = true
                label.text = name.uppercased()
                self.navigationController?.topViewController?.navigationItem.titleView = label
            } else {
                //
            }
        }
    }
    
    func setupLeftBarButtonItem() {
        guard leftBarButtonType != .notHandle else { return }
        var button = UIBarButtonItem()
        switch (leftBarButtonType) {
        case .menu:
            button = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_leftMenu"), style: .done, target: self, action: #selector(btnLeftTouched(_:)))
        case .back:
            button = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back"), style: UIBarButtonItemStyle.done, target: self, action: #selector(btnLeftTouched(_:)))
            button.tintColor = UIColor.white
        default:
            break
        }
        navigationController?.topViewController?.navigationItem.leftBarButtonItem = button
    }
    
    func setupRightBarButtonItem() {
        guard rightBarButtonType != .notHandle else { return }
        switch (rightBarButtonType) {
        default:
            break
        }
    }
    
    // MARK: - Actions
    
    func btnLeftTouched(_ sender: UIButton) {
        switch leftBarButtonType {
        case .menu:
            iTRAirSideMenu?.presentLeftMenuViewController()
        case .back:
            if self is JobOffersViewController
                || self is SubscriptionsViewController
                || self is InterviewsViewController
                || self is SettingsViewController
                || self is JobReportsViewController
                || self is GetPaidViewController
                || self is FAQTCViewController {
                (iTRAirSideMenu as? CenterViewController)?.gotoJobsDashboard()
            } else {
                let _ = navigationController?.popViewController(animated: true)
            }
        default:
            break
        }
    }
    
    func btnRightTouched(_ sender: UIButton) {
        //
    }
    
    // MARK: - Method Swizzling
    
    override open class func initialize() {
        super.initialize()
        guard self === UIViewController.self else { return }
        let originalViewWillAppearSelector = #selector(viewWillAppear(_:))
        let swizzledViewWillAppearSelector = #selector(swizzledViewWillAppear(_:))
        
        let originalViewWillAppearMethod = class_getInstanceMethod(self, originalViewWillAppearSelector)
        let swizzledViewWillAppearMethod = class_getInstanceMethod(self, swizzledViewWillAppearSelector)
        
        method_exchangeImplementations(originalViewWillAppearMethod, swizzledViewWillAppearMethod)
        
        let originalViewWillDisappearSelector = #selector(viewWillDisappear(_:))
        let swizzledViewWillDisappearSelector = #selector(swizzledViewWillDisappear(_:))
        
        let originalViewWillDisappearMethod = class_getInstanceMethod(self, originalViewWillDisappearSelector)
        let swizzledViewWillDisappearMethod = class_getInstanceMethod(self, swizzledViewWillDisappearSelector)
        
        method_exchangeImplementations(originalViewWillDisappearMethod, swizzledViewWillDisappearMethod)
        
    }
    
    func swizzledViewWillAppear(_ animated: Bool) {
        swizzledViewWillAppear(animated)
        setNavigation()
        setupLeftBarButtonItem()
        setupRightBarButtonItem()
        resumeAllRequest()
    }
    
    func swizzledViewWillDisappear(_ animated: Bool) {
        swizzledViewWillDisappear(animated)
        pauseAllRequest()
    }
}

extension UITableViewCell {
    var bnd_prepareForReuseBag: DisposeBag {
        get {
            return associatedObject(base: self, key: &Constant.bnd_prepareForReuseBagKey, initializer: { DisposeBag() })
        }
        set {
            associateObject(base: self, key: &Constant.bnd_prepareForReuseBagKey, value: newValue)
        }
    }
    
    func swizzledPrepareForReuse() {
        swizzledPrepareForReuse()
        bnd_prepareForReuseBag = DisposeBag()
    }
    
    override open class func initialize() {
        guard self === UITableViewCell.self else { return }
        let originalPrepareForReuseSelector = #selector(prepareForReuse)
        let swizzledPrepareForReuseSelector = #selector(swizzledPrepareForReuse)
        
        let originalPrepareForReuseMethod = class_getInstanceMethod(self, originalPrepareForReuseSelector)
        let swizzledPrepareForReuseMethod = class_getInstanceMethod(self, swizzledPrepareForReuseSelector)
        
        method_exchangeImplementations(originalPrepareForReuseMethod, swizzledPrepareForReuseMethod)
    }
}

extension UICollectionViewCell {
    var bnd_prepareForReuseBag: DisposeBag {
        get {
            return associatedObject(base: self, key: &Constant.bnd_prepareForReuseBagKey, initializer: { DisposeBag() })
        }
        set {
            associateObject(base: self, key: &Constant.bnd_prepareForReuseBagKey, value: newValue)
        }
    }
    
    func swizzledPrepareForReuse() {
        swizzledPrepareForReuse()
        bnd_prepareForReuseBag = DisposeBag()
    }
    
    override open class func initialize() {
        guard self === UICollectionViewCell.self else { return }
        let originalPrepareForReuseSelector = #selector(prepareForReuse)
        let swizzledPrepareForReuseSelector = #selector(swizzledPrepareForReuse)
        
        let originalPrepareForReuseMethod = class_getInstanceMethod(self, originalPrepareForReuseSelector)
        let swizzledPrepareForReuseMethod = class_getInstanceMethod(self, swizzledPrepareForReuseSelector)
        
        method_exchangeImplementations(originalPrepareForReuseMethod, swizzledPrepareForReuseMethod)
    }
}


