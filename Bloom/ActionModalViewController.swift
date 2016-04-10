//
//  ActionModalViewController.swift
//  Bloom
//
//  Created by Ryoga Kitagawa on 4/10/16.
//  Copyright © 2016 Givery. All rights reserved.
//

import UIKit

class ActionModalViewController: UIViewController, KeyboardAvoidance {
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.actionButton.applyPrimaryTheme()
        self.textField.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ActionModalViewController.touchUpBackgroundView))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.startKeyboardAvoidance()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopKeyboardAvoidance()
    }
}

extension ActionModalViewController {
    func touchUpBackgroundView() {
        self.focusedView?.resignFirstResponder()
    }
}

extension ActionModalViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        self.focusedView = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if self.focusedView == textField {
            self.focusedView = nil
        }
    }
}

extension ActionModalViewController {
    @IBAction func didTapActionButton(sender: AnyObject) {
        let userId = AppDelegate.sharedDelegate().store.user!.id
        let receiverId = 4
        let flowerName = "red_flower"
        let message = self.textField.text
        BloomAPI.postFlowers(userId, receiverId: receiverId, flowerName: flowerName, message: message).success { (_) in
            self.parentViewController?.dismissViewControllerAnimated(true, completion: nil)
        }.failure { (error, isCancelled) in
            //TODO: failure
//            self.parentViewController?.dismissViewControllerAnimated(true, completion: nil)
            self.performSegueWithIdentifier("unwind", sender: nil)
        }
    }
}
