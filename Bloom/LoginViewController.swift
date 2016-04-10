//
//  ViewController.swift
//  Bloom
//
//  Created by Ryoga Kitagawa on 4/9/16.
//  Copyright © 2016 Givery. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, KeyboardAvoidance {
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.startKeyboardAvoidance()
        self.view.backgroundColor = Colors.backgroundWhite
        self.loginButton.applyPrimaryTheme()
        self.companyTextField.delegate = self
        self.mailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.touchUpBackgroundView))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopKeyboardAvoidance()
    }
}

extension LoginViewController {
    func touchUpBackgroundView() {
        self.focusedView?.resignFirstResponder()
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        self.focusedView = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if self.focusedView == textField {
            self.focusedView = nil
        }
    }
}

extension LoginViewController {
    @IBAction func didTapLoginButton(sender: AnyObject) {
        //TODO: Login
        BloomAPI.signin(self.companyTextField.text!, email: self.mailTextField.text!, password: self.passwordTextField.text!)
            .success { response in
                AppDelegate.sharedDelegate().store.organization = response.organization
                AppDelegate.sharedDelegate().store.user = response.user
                
                self.performSegueWithIdentifier("loggedIn", sender: self)
            }
            .failure { (error, isCancelled) in
                let alertController = UIAlertController(title: "エラー", message: "入力が間違っています", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}