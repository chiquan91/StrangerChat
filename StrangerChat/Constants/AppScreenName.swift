//
//  AppScreenName.swift
//  MVVMExample
//
//  Created by CYTECH on 3/1/16.
//  Copyright © 2016 vmodev.com. All rights reserved.
//

import UIKit

class AppScreenName: NSObject {

    static let storyboard     = "Main"
    static let center         = "CenterViewController"
    static let login          = "ChooseLoginViewController"
    static let selectTags     = "SelectTagsViewController"
    static let jobsSearchNavi = "JobsSearchNavigationController"
    static let activeJobNavi  = "ActiveJobsNavigationController"
    static let inboxNavi      = "InboxNavigationController"
    static let profileNavi    = "ProfileNavigationController"
    static let settingsNavi   = "SettingsNavigationController"
    static let leftMenu       = "LeftMenuViewController"
    static let dashboardNavi  = "dashboardNavigationController"
    static let registerVC     = "RegisterViewController"
    static let jobDescVc      = "JobDescriptionViewController"

    
    class func view(with identifier: String) -> UIViewController {
        return UIStoryboard.init(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    class func loginView() -> UIViewController {
        return view(with: login)
    }
    
    class func centerView() -> UIViewController {
        return view(with: center)
    }
    
    class func jobsSearchNaviView() -> UIViewController {
        let jobsSearch = view(with: jobsSearchNavi)
        jobsSearch.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "ic_job_black"), selectedImage: #imageLiteral(resourceName: "ic_Job"))
        return jobsSearch
    }
    
    class func activeJobNaviView() -> UIViewController {
        let activeJob = view(with: activeJobNavi)
        activeJob.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "ic_Interests_gray"), selectedImage: #imageLiteral(resourceName: "ic_Interests"))
        return activeJob
    }
    
    class func inboxNaviView() -> UIViewController {
        let inbox = view(with: inboxNavi)
        inbox.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "ic_chat_gray"), selectedImage: #imageLiteral(resourceName: "ic_chat"))
        return inbox
    }
    
    class func profileNaviView() -> UIViewController {
        let profile = view(with: profileNavi)
        profile.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "ic_profile_black"), selectedImage: #imageLiteral(resourceName: "ic_profile"))
        return profile
    }
    
    class func settingsNaviView() -> UIViewController {
        let settings = view(with: settingsNavi)
        settings.tabBarItem = UITabBarItem(title: "Settings", image: nil, selectedImage: nil)
        return settings
    }
    
    class func leftMenuView() -> UIViewController {
        let left = view(with: leftMenu)
        return left
    }
    
    class func dashboardNaviView() -> UIViewController {
        return view(with: dashboardNavi)
    }
    
    class func registerView() -> UIViewController {
        return view(with: registerVC)
    }
    
    class func jobDescriptionView() -> UIViewController {
        return view(with: jobDescVc)
    }
    
}
