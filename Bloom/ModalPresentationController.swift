//
//  ModalPresentationController.swift
//  life-company
//
//  Created by Ryoga Kitagawa on 3/24/16.
//  Copyright © 2016 Givery. All rights reserved.
//

import UIKit

class ModalPresentationController : UIPresentationController {
    private var overlay: UIView!
    private var closeButton: UIButton!
    
    override func presentationTransitionWillBegin() {
        let containerView = self.containerView!
        
        overlay = UIView(frame: containerView.bounds)
        overlay.gestureRecognizers = [UITapGestureRecognizer(target: self, action: #selector(overlayDidTouch(_:)))]
        overlay.backgroundColor = UIColor.blackColor()
        overlay.alpha = 0.0
        containerView.insertSubview(self.overlay, atIndex: 0)
        
        closeButton = UIButton(type: .Custom)
        closeButton.setImage(UIImage(named: "button_off"), forState: .Normal)
        closeButton.setImage(UIImage(named: "button_on"), forState: .Highlighted)
        closeButton.addTarget(self, action: #selector(ModalPresentationController.overlayDidTouch(_:)), forControlEvents: .TouchUpInside)
        containerView.insertSubview(self.closeButton, atIndex: 1)
        
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false
        let metrics = ["margin": 16]
        let views = ["closeButton": self.closeButton]
        let constraintsV = NSLayoutConstraint.constraintsWithVisualFormat("V:[closeButton]-(margin)-|", options: [], metrics: metrics, views: views)
        let constraintsH = NSLayoutConstraint.constraintsWithVisualFormat("H:[closeButton]-(margin)-|", options: [], metrics: metrics, views: views)
        containerView.addConstraints(constraintsV + constraintsH)
        
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({
            [unowned self] context in
            self.overlay.alpha = 0.5
            self.closeButton.transform = CGAffineTransformRotate(self.closeButton.transform, CGFloat(M_PI_4) * 3)
            }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator()?.animateAlongsideTransition({
            [unowned self] context in
            self.overlay.alpha = 0.0
            self.closeButton.transform = CGAffineTransformRotate(self.closeButton.transform, -CGFloat(M_PI_4) * 3)
            }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(completed: Bool) {
        if completed {
            overlay.removeFromSuperview()
            closeButton.removeFromSuperview()
        }
    }
    
    override func sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width, height: parentSize.height)
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        var presentedViewFrame = CGRectZero
        let containerBounds = containerView!.bounds
        presentedViewFrame.size = sizeForChildContentContainer(presentedViewController, withParentContainerSize: containerBounds.size)
        presentedViewFrame.origin.x = containerBounds.size.width - presentedViewFrame.size.width
        presentedViewFrame.origin.y = containerBounds.size.height - presentedViewFrame.size.height
        return presentedViewFrame
    }
    
    override func containerViewWillLayoutSubviews() {
        overlay.frame = containerView!.bounds
        presentedView()!.frame = frameOfPresentedViewInContainerView()
    }
    
    override func presentationTransitionDidEnd(completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        self.containerView?.bringSubviewToFront(self.closeButton)
    }
    
    func overlayDidTouch(sender: AnyObject) {
        self.containerView?.bringSubviewToFront(self.presentedView()!)
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
