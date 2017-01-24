//
//  Constant.swift
//  MVVMExample
//
//  Created by CYTECH on 3/2/16.
//  Copyright © 2016 vmodev.com. All rights reserved.
//

import UIKit

class Constant: NSObject {
    
    // MARK: - Service Keys

    static let serverUrlBase         = "https://rize-test.herokuapp.com/api/"
    static let serverUrlBase_prod    = "http://bixby-app.us-west-1.elasticbeanstalk.com/"
    static let googleMapAPIKey       = "AIzaSyBYTHO-g2R3ZsjbazGXM3OKgTYG90z7AZ4"
    static let youtubeThumnailsBase  = "http://img.youtube.com/vi/"

    // MARK: - NSDate

    static let kDateFormat           = "MM.dd.yyyy"
    static let kTimeFormat24         = "HH:mm:ss"
    static let kTimeFormat           = "hh:mm a"
    static let kShortTimeFormat      = "HH:mm"

    static let kDateTimeFormat       = "MM.dd.yyyy | hh aa"
    static let kDateTimeServerFormat = "yyyy-MM-dd HH:mm:ss"
    static let kDateServerFormat     = "yyyy-MM-dd"
    static let kDate                 = "E, d MMM yyyy"
    static let kMonthYearFormat      = "MMM yyyy"
	static let kDay					 = "EEEE"

    // MARK: - Notifications

    // MARK: - Language
    static let English               = "en"
    static let SimplifiedChinese     = "zh-Hans"

    // MARK: - Key User Default
    static let kIsLogin              = "kisLogin"
    static let kTorchOn              = "kTorchOn"
    
    // MARK: - Directory
    static let documentDirectoryURL  = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    // MARK: - Screen
    static let screenSize            = UIScreen.main.bounds.size
    
    // MARK: - Associated
    static var viewControllerTypeKey: UInt8    = 0
    static var leftBarButtonTypeKey: UInt8     = 1
    static var rightBarButtonTypeKey: UInt8    = 2
    static var requestsKey: UInt8              = 3
    static var bnd_prepareForReuseBagKey: UInt8   = 4

}
