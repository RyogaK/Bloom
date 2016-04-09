//
//  ChangeRootViewControllerSegue.swift
//  life-company
//
//  Created by Ryoga Kitagawa on 3/8/16.
//  Copyright © 2016 Givery. All rights reserved.
//

import UIKit

class ChangeRootViewControllerSegue: UIStoryboardSegue {
    override func perform() {
        guard let window = (UIApplication.sharedApplication().delegate as? AppDelegate)?.window else {
            return
        }
//        UIView.transitionWithView(self.sourceViewController.view, duration: 0.5, options: [.TransitionFlipFromLeft, .ShowHideTransitionViews], animations: {
//            window.rootViewController = self.destinationViewController
//            }, completion: nil)
        self.switchRootViewController(window, rootViewController: self.destinationViewController, animated: true, completion: nil)
    }
    
    func switchRootViewController(window: UIWindow, rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if animated {
            UIView.transitionWithView(window, duration: 0.2, options: .TransitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled()
                UIView.setAnimationsEnabled(false)
                window.rootViewController = rootViewController
                UIView.setAnimationsEnabled(oldState)
                }, completion: { (finished: Bool) -> () in
                    if (completion != nil) {
                        completion!()
                    }
            })
        } else {
            window.rootViewController = rootViewController
        }
    }
}