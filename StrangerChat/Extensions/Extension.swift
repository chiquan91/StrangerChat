//
//  Extension.swift
//  Promoter
//
//  Created by Pham Hoa on 7/11/16.
//  Copyright © 2016 vmodev.com. All rights reserved.
//

import UIKit
import MessageUI

extension UIViewController {
    func show(alert message: String?, title: String?, buttons: [String], completed:@escaping (_ index: Int) -> Void?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        if buttons.count == 1 {
            alert.addAction(UIAlertAction(title: buttons[0], style: .default, handler: { action in
                completed(0)
                alert.dismiss(animated: true, completion: nil)
            }))
        } else if buttons.count > 1 {
            alert.addAction(UIAlertAction(title: buttons[0], style: .default, handler: { action in
                completed(0)
                alert.dismiss(animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: buttons[1], style: .default, handler: { action in
                completed(1)
                alert.dismiss(animated: true, completion: nil)
            }))
        }
        present(alert, animated: true, completion: nil)
    }
}

extension UIViewController: MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    func makeCall(to number: String) {
        let formatedNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        let phoneUrl = "tel://+\(formatedNumber)"
        if let url = URL(string: phoneUrl) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("invalid url")
        }
    }
    
    func sendEmail(to email: String) {
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("invalid url")
        }
    }
    
    func openWeb(address urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("invalid url")
        }
    }
    
    func send(message text: String, to phoneNumber: String) {
        let formatedNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = text
            controller.recipients = [formatedNumber]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    // MARK: - MFMessageComposeViewControllerDelegate
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - MFMailComposeViewControllerDelegate
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

extension Date {
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(_ daysToAdd: Int) -> Date {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(_ hoursToAdd: Int) -> Date {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
    
}

extension UIView {
    func tableViewCell() -> UITableViewCell? {
        var superV = self.superview
        
        while superV?.isKind(of: UITableViewCell.self) == false && superV != nil {
            superV = superV?.superview
        }
        return superV as? UITableViewCell
    }
    
    func collectionViewCell() -> UICollectionViewCell? {
        var superV = self.superview
        while superV?.isKind(of: UICollectionViewCell.self) == false && superV != nil {
            superV = superV?.superview
        }
        return superV as? UICollectionViewCell
    }
    
    func corner(_ radius: CGFloat, borderColor: UIColor = UIColor.clear) {
        self.layer.cornerRadius = radius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
    }
    
    func shadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }
}

extension UIImage {
    func imageWithSize(_ size: CGSize) -> UIImage {
        let scale = size.width / self.size.width < size.height / self.size.height ? size.width / self.size.width : size.height / self.size.height
        let rect = CGRect.init(x: 0, y: 0, width: self.size.width * scale, height: self.size.height * scale)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
        self.draw(in: rect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}

func +(lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
    let combine = NSMutableAttributedString()
    combine.append(lhs)
    combine.append(rhs)
    return combine
}
