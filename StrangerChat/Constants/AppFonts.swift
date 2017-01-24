//
//  AppFonts.swift
//  CHIP
//
//  Created by Pham Hoa on 4/21/16.
//  Copyright © 2016 vmodev.com. All rights reserved.
//

import UIKit

let SFDRegularFontname = "SFUIDisplay-Regular"
let SFDBoldFontname = "SFUIDisplay-Bold"
let SFDSemiBoldFontname = "SFUIDisplay-Semibold"

class AppFonts: NSObject {
    
    // MARK: - SF

    class func appSFD_Regular_Fonsize(_ fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: SFDRegularFontname, size: fontSize) {
            return font
        } else {
            fatalError("Error loading font: \(SFDRegularFontname)")
        }
    }
    
    class func appSFD_Bold_Fonsize(_ fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: SFDBoldFontname, size: fontSize) {
            return font
        } else {
            fatalError("Error loading font: \(SFDBoldFontname)")
        }
    }
    
    class func appSFD_Semibold_Fonsize(_ fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: SFDSemiBoldFontname, size: fontSize) {
            return font
        } else {
            fatalError("Error loading font: \(SFDSemiBoldFontname)")
        }
    }
    
    
    // MARK: - Hebbo
    
    class func heeboMedium(size fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: "Heebo-Medium", size: fontSize) {
            return font
        } else {
            fatalError("Error loading font: Heebo-Medium")
        }
    }
    
    class func heeboRegular(size fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: "Heebo-Regular", size: fontSize) {
            return font
        } else {
            fatalError("Error loading font: Heebo-Regular")
        }
    }
    
    class func heeboBold(size fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: "Heebo-Bold", size: fontSize) {
            return font
        } else {
            fatalError("Error loading font: Heebo-Bold")
        }
    }

}
