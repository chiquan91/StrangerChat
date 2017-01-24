//
//  PlaceholderTextView.swift
//  Rize
//
//  Created by Hoang Chi Quan on 11/16/16.
//  Copyright © 2016 Vmodev. All rights reserved.
//

import UIKit

@IBDesignable class PlaceholderTextView: UITextView {
    
    private var placeholder = UILabel()
    
    // MARK: - Show or hide placeholder
    @IBInspectable var isShowPlaceholder: Bool = false {
        didSet {
            placeholder.text = "placeholder"
            placeholder.isHidden = !isShowPlaceholder
        }
    }
    
    // MARK: - Set placeholder text
    @IBInspectable var placeholderText: String = "placeholder" {
        didSet {
            placeholder.text = placeholderText
            placeholder.sizeToFit()
            placeholder.frame = CGRect.init(x: 5, y: 8, width: placeholder.frame.size.width, height: placeholder.frame.size.height)
        }
    }
    
    // MARK: - Set placeholder text color
    @IBInspectable var placeholderTextColor: UIColor = UIColor.black {
        didSet {
            placeholder.textColor = placeholderTextColor
        }
    }
    
    override var font: UIFont? {
        didSet {
            placeholder.font = font
        }
    }
    
    override var text: String! {
        didSet {
            if !isShowPlaceholder || text.characters.count > 0 {
                placeholder.isHidden = true
            } else {
                placeholder.isHidden = false
            }
            setHeight()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customView()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        customView()
    }
    
    private func customView() {
        placeholder.numberOfLines = 0
        placeholder.sizeToFit()
        placeholder.frame = CGRect.init(x: 5, y: 8, width: placeholder.frame.size.width, height: placeholder.frame.size.height)
        addSubview(placeholder)
        sendSubview(toBack: placeholder)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: Notification.Name.UITextViewTextDidChange, object: nil)
    }
    
    @objc private func textDidChange(_ noti: Notification) {
        if !isShowPlaceholder || text.characters.count > 0 {
            placeholder.isHidden = true
        } else {
            placeholder.isHidden = false
        }
        setHeight()
    }
    
    private func setHeight() {
        let height = contentSize.height
        let heightOfInputView = 30 + (height < 30 ? 30 : height)
        frame.size.height = heightOfInputView
    }
}
