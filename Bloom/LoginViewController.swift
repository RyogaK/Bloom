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
    }
}