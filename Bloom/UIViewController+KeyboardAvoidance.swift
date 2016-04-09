//
//  UIViewController+KeyboardAvoidance.swift
//  life-company
//
//  Created by Ryoga Kitagawa on 4/7/16.
//  Copyright © 2016 Givery. All rights reserved.
//

import UIKit

protocol KeyboardAvoidance: class {
    var focusedView: UIView? { get set }
    func startKeyboardAvoidance()
    func stopKeyboardAvoidance()
}

private var KeyboardAvoiderPropertyKey: UInt8 = 0
extension KeyboardAvoidance where Self: UIViewController {
    private var keyboardAvoider: KeyboardAvoider? {
        get {
            return objc_getAssociatedObject(self, &KeyboardAvoiderPropertyKey) as? KeyboardAvoider
        }
        set {
            objc_setAssociatedObject(self, &KeyboardAvoiderPropertyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var focusedView: UIView? {
        get {
            return keyboardAvoider?.focusedView
        }
        set {
            keyboardAvoider?.focusedView = newValue
        }
    }
    
    func startKeyboardAvoidance() {
        keyboardAvoider = KeyboardAvoider(viewController: self)
        keyboardAvoider?.registerForKeyboardNotifications()
    }
    
    func stopKeyboardAvoidance() {
        keyboardAvoider?.unregisterForKeyboardNotifications()
        keyboardAvoider = nil
    }
}

private class KeyboardAvoider {
    weak var viewController: UIViewController?
    weak var focusedView: UIView?
    
    init(viewController: UIViewController!) {
        self.viewController = viewController
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardAvoider.keyboardWasShown(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardAvoider.keyboardWasHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        guard
            let info = notification.userInfo,
            let keyboardSize = info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size
            else {
                return
        }
        
        if let focusedView = self.focusedView, let viewController = self.viewController {
            var visibleRect = viewController.view.frame
            visibleRect.size.height -= keyboardSize.height
            let focusedViewFrame = focusedView.convertRect(focusedView.bounds, toView: viewController.view)
            let focusedViewBottom = focusedViewFrame.origin.y + focusedViewFrame.height
            if !CGRectContainsPoint(visibleRect, CGPointMake(0, focusedViewBottom)) {
                let scrollPoint = CGPointMake(0, focusedViewBottom - visibleRect.size.height + 8)
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    viewController.view.frame = CGRectMake(0, -scrollPoint.y, viewController.view.frame.width, viewController.view.frame.height)
                })
            }
        }
    }
    
    @objc func keyboardWasHidden(notification: NSNotification) {
        if let viewController = self.viewController {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                viewController.view.frame = CGRectMake(0, 0, viewController.view.frame.width, viewController.view.frame.height)
            })
        }
    }
}