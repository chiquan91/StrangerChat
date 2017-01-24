//
//  FrameOservingInputAccessoryView.swift
//  Rize
//
//  Created by Hoang Chi Quan on 11/17/16.
//  Copyright © 2016 Vmodev. All rights reserved.
//

import UIKit

class FrameOservingInputAccessoryView: UIView {
    static let frameObservingContext = UnsafeMutableRawPointer.init(bitPattern: 0)
    
    // MARK: - Vars
    
    public var keyboardDidChangeFrameClosure: ((_ isVisible: Bool, _ frame: CGRect) -> Void)?
    
    // MARK: - Privates

    
    var keyboardFrame: CGRect = CGRect.zero {
        didSet {
            let inputAccessoryViewHeight = bounds.size.height
            var frame = keyboardFrame
            frame.origin.y += inputAccessoryViewHeight
            frame.size.height -= inputAccessoryViewHeight
            keyboardFrame = frame
            keyboardDidChangeFrameClosure?(isKeyboardVisible, keyboardFrame)
        }
    }
    
    var isKeyboardVisible: Bool {
        return keyboardFrame.minY >= UIScreen.main.bounds.size.height
    }
    
    private var isObserverAdded: Bool = false
    
    // MARK: - Life cycles


    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init() {
        super.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0))
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0))
        setup()
    }
    
    // MARK: - Setups
    
    private func setup() {
        isUserInteractionEnabled = false
    }
    
    // MARK: - Overrides
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if isObserverAdded {
            superview?.removeObserver(self, forKeyPath: "frame", context: FrameOservingInputAccessoryView.frameObservingContext)
            superview?.removeObserver(self, forKeyPath: "center", context: FrameOservingInputAccessoryView.frameObservingContext)
        }
        newSuperview?.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: FrameOservingInputAccessoryView.frameObservingContext)
        newSuperview?.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.new, context: FrameOservingInputAccessoryView.frameObservingContext)
        isObserverAdded = true
        super.willMove(toSuperview: newSuperview)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        keyboardFrame = self.superview?.frame ?? CGRect.zero
    }
    
    // MARK: - Observation Handler
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let superView = object as? UIView, superView == self.superview, context == FrameOservingInputAccessoryView.frameObservingContext, (keyPath == "frame" || keyPath == "center") {
            keyboardFrame = superview?.frame ?? CGRect.zero
        }
    }
}
